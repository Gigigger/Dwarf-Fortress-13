/datum/minigame/tailor
	var/atom/movable/screen/tailorgame/cloth/cloth

/datum/minigame/tailor/New(obj/crafter, datum/crafter_recipe/recipe)
	. = ..()
	cloth = new()
	main_window.vis_contents += cloth

/datum/minigame/tailor/on_start()
	cloth.init_points(user)

/datum/minigame/tailor/reset()
	. = ..()
	cloth.reset()

/datum/minigame/tailor/get_explanation()
	return image('dwarfs/icons/ui/minigame/bg.dmi', null, "help_tailor")

/datum/minigame/tailor/finish()
	. = ..()
	result = cloth.calculate_res_grade(user)

/atom/movable/screen/tailorgame
	icon = 'dwarfs/icons/ui/minigame/tailor.dmi'

/atom/movable/screen/tailorgame/start_btn
	icon_state = "start"

/atom/movable/screen/tailorgame/start_btn/Click(location, control, params)
	. = ..()
	var/atom/movable/screen/tailorgame/cloth/parent = vis_locs[1]
	parent.start(usr)

/atom/movable/screen/tailorgame/line
	icon = 'dwarfs/icons/ui/minigame/tailor_s.dmi'
	icon_state = "line"
	vis_flags = VIS_INHERIT_ID
	var/vector/start
	var/vector/end

/atom/movable/screen/tailorgame/line/Initialize(mapload, vector/start)
	. = ..()
	pixel_x = start.x - 1
	pixel_y = start.y - 1
	color = rgb(rand(0,255), rand(0,255), rand(0,255))
	src.start = start

/atom/movable/screen/tailorgame/line/proc/draw_to(vector/pos)
	end = pos
	var/vector/dvec = pos - start - vector(1, 1)
	var/angle = -arctan(dvec.x, dvec.y)
	var/matrix/m = matrix()

	m.Scale(dvec.size/2, 1)
	m.Turn(angle)
	m.Translate(dvec.x/2, dvec.y/2)

	transform = m

/atom/movable/screen/tailorgame/start
	icon_state = "start"
	pixel_x = 48+16+8
	pixel_y = -16

/atom/movable/screen/tailorgame/start/MouseEntered(location, control, params)
	. = ..()
	icon_state = "start_hover"

/atom/movable/screen/tailorgame/start/MouseDown(location, control, params)
	. = ..()
	icon_state = "start_click"

/atom/movable/screen/tailorgame/start/MouseExited(location, control, params)
	. = ..()
	icon_state = "start"

/atom/movable/screen/tailorgame/start/Click(location, control, params)
	. = ..()
	var/atom/movable/screen/tailorgame/cloth/parent = vis_locs[1]
	parent.start(usr)

/atom/movable/screen/tailorgame/end
	icon_state = "end"
	pixel_x = 48+16+8
	pixel_y = -16

/atom/movable/screen/tailorgame/end/MouseEntered(location, control, params)
	. = ..()
	icon_state = "end_hover"

/atom/movable/screen/tailorgame/end/MouseExited(location, control, params)
	. = ..()
	icon_state = "end"

/atom/movable/screen/tailorgame/end/MouseDown(location, control, params)
	. = ..()
	icon_state = "end_click"

/atom/movable/screen/tailorgame/end/Click(location, control, params)
	. = ..()
	var/atom/movable/screen/tailorgame/cloth/parent = vis_locs[1]
	parent.end(usr)

/atom/movable/screen/tailorgame/cloth
	icon_state = "cloth"
	pixel_x = 32
	pixel_y = 32
	var/atom/movable/screen/tailorgame/start/start = new
	var/atom/movable/screen/tailorgame/end/end = new
	var/atom/movable/screen/tailorgame/line/active_line
	var/list/lines = list()
	var/list/points = list()
	var/is_started = FALSE

/atom/movable/screen/tailorgame/cloth/Initialize(mapload)
	. = ..()
	vis_contents += start

/atom/movable/screen/tailorgame/cloth/proc/init_points(mob/user)
	var/vector/start_lb = vector(30, 20)
	var/vector/start_rt = vector(90, 76)
	var/vector/end_lb = vector(106, 20)
	var/vector/end_rt = vector(160, 76)
	var/min_lines = user.get_skill_modifier(/datum/skill/tailoring, SKILL_AMOUNT_MIN_MODIFIER)
	var/max_lines = user.get_skill_modifier(/datum/skill/tailoring, SKILL_AMOUNT_MAX_MODIFIER)
	for(var/i in 1 to rand(min_lines, max_lines))
		var/vector/start_point
		var/vector/end_point
		var/valid_line = FALSE
		do
			valid_line = TRUE
			start_point = vector(rand(start_lb.x, start_rt.x), rand(start_lb.y, start_rt.y))
			end_point = vector(rand(end_lb.x, end_rt.x), rand(end_lb.y, end_rt.y))

			for(var/vector/other_start in points)
				var/vector/other_end = points[other_start]
				var/vector/delta_start = start_point - other_start
				var/vector/delta_end = end_point - other_end

				if(delta_start.size < 8 || delta_end.size < 8)
					valid_line = FALSE
					break

				var/vector/d = other_end - other_start
				for(var/vector/point in list(start_point, end_point))
					var/vector/delta_point = point - other_start
					var/t = clamp(delta_point.Dot(d) / d.Dot(d), 0, 1)
					var/vector/closest_point = other_start.Interpolate(other_end, t)
					var/vector/delta_closest = point - closest_point

					// to_chat(world, "d: [d] t: [t]\nfound closest line to [point] at [closest_point] dist: [delta_closest.size]")

					if(delta_closest.size < 8)
						valid_line = FALSE
						break

				if(!valid_line)
					break

		while(start_point && end_point && !valid_line)
		points[start_point] = end_point

/atom/movable/screen/tailorgame/cloth/proc/start(mob/user)
	vis_contents -= start
	var/list/temp_lines = list()
	for(var/vector/start in points)
		var/vector/end = points[start]
		var/atom/movable/screen/tailorgame/line/line = new(null, start)
		line.draw_to(end)
		temp_lines += line
		vis_contents += line
	sleep(10 SECONDS)
	// for debugging
	// for(var/atom/line in temp_lines)
	// 	var/list/old_colors = ReadRGB(line.color)
	// 	line.color = rgb(old_colors[1], old_colors[2], old_colors[3], 60)
	vis_contents.RemoveAll(temp_lines)
	QDEL_LIST(temp_lines)
	vis_contents += end
	is_started = TRUE

/atom/movable/screen/tailorgame/cloth/proc/reset()
	vis_contents.Cut()
	vis_contents += start
	points.Cut()
	lines.Cut()
	active_line = null
	is_started = FALSE

/atom/movable/screen/tailorgame/cloth/proc/end(mob/user)
	var/atom/movable/screen/minigame/parent = vis_locs[1]
	parent.minigame.finish()

/atom/movable/screen/tailorgame/cloth/Click(location, control, params)
	. = ..()
	if(!is_started)
		return
	var/list/p = params2list(params)
	var/px = text2num(p["icon-x"])
	var/py = text2num(p["icon-y"])
	var/vector/current_pos = vector(px, py)
	if(active_line)
		active_line.draw_to(current_pos)
		lines += active_line
		active_line = null
		return
	active_line = new(null, current_pos)
	vis_contents += active_line

/atom/movable/screen/tailorgame/cloth/MouseMove(location, control, params)
	. = ..()
	if(!active_line)
		return
	var/list/p = params2list(params)
	var/px = text2num(p["icon-x"])
	var/py = text2num(p["icon-y"])
	var/vector/current_pos = vector(px, py)

	active_line.draw_to(current_pos)

/atom/movable/screen/tailorgame/cloth/proc/calculate_res_grade(mob/user)
	var/score = 0

	var/score_per_line = 50/LAZYLEN(points)

	var/score_count = 50 - abs(LAZYLEN(lines) - LAZYLEN(points)) * score_per_line
	score += score_count

	// start points with each having a list of all lines and their distances to them
	var/list/points_lines = list()
	for(var/vector/start in points)
		var/list/distances = list()
		for(var/atom/movable/screen/tailorgame/line/line in lines)
			var/vector/start_vec = line.start - start
			if(!distances.len)
				distances[line] = start_vec.size
				continue
			var/pos = distances.len
			while(pos > 0 && (distances[distances[pos]] - start_vec.size) > 0)
				pos--
			distances.Insert(pos+1, line)
			distances[line] = start_vec.size
		points_lines[start] = distances

	var/list/used_lines = lines.Copy()
	for(var/vector/start in points_lines)
		if(!LAZYLEN(used_lines))
			// to_chat(world, "ran out of lines, skipping\n----------------------")
			break
		var/list/distances = points_lines[start]
		var/line_index = 1
		var/atom/movable/screen/tailorgame/line/closest_line

		while(LAZYLEN(used_lines) && line_index <= LAZYLEN(distances))
			closest_line = distances[line_index]

			if(!(closest_line in used_lines))
				// to_chat(world, "skipping line [line_index], already used")
				line_index++
				continue

			var/found_closest = TRUE
			for(var/vector/other_start in (points - start))
				if(points_lines[other_start][closest_line] < distances[closest_line])
					// to_chat(world, "skipping line [line_index]")
					line_index++
					found_closest = FALSE
					break

			if(found_closest)
				// to_chat(world, "found closest line [line_index] to [start]. line start at [closest_line.start]")
				break

		if(line_index > LAZYLEN(distances))
			// to_chat(world, "no available lines found, skipping start\n----------------------")
			continue

		used_lines.Remove(closest_line)
		var/vector/end = points[start]

		// var/dist_start = (closest_line.start - start).size
		// var/dist_end = (closest_line.end - end).size

		var/score_start = get_distance_score(closest_line.start, start, score_per_line, user)
		var/score_end = get_distance_score(closest_line.end, end, score_per_line, user)

		score += score_start
		score += score_end
		// to_chat(world, "start: [start] l.start: [closest_line.start] end: [end] l.end: [closest_line.end]\nscore_start: [score_start] score_end: [score_end]\n----------------------")

	var/grade = 1

	switch(score)
		if(95 to 100)
			grade = 6
		if(85 to 95)
			grade = 5
		if(75 to 85)
			grade = 4
		if(60 to 75)
			grade = 3
		if(40 to 60)
			grade = 2
		else
			grade = 1

	// to_chat(world, "count_score: [score_count] lines: [LAZYLEN(lines)] points: [LAZYLEN(points)]")
	// to_chat(world, "total: [score] per_line: [score_per_line] res_grade: [grade]")
	return grade

/atom/movable/screen/tailorgame/cloth/proc/get_distance_score(vector/a, vector/b, score_per_line, mob/user)
	var/vector/delta = a-b
	var/max_allowed_dist = 10
	var/progress = 1 - clamp(delta.size / max_allowed_dist, 0, 1)
	var/user_level = user.get_skill_level(/datum/skill/tailoring)
	switch(user_level)
		if(11)
			// easeOutSine
			progress = sin((progress * 180) / 2)
		if(8 to 10)
			// easeInSine
			progress = 1 - cos((progress * 180) / 2)
		if(4 to 7)
			// easeInQuad
			progress = progress ** 2
		else
			// easeInCubic
			progress = progress ** 3
	var/score = progress * score_per_line
	return 0.5 * score
