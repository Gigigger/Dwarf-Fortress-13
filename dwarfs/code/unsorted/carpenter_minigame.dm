/datum/minigame/carpenter
	var/atom/movable/screen/woodgame/plank/plank

/datum/minigame/carpenter/New(obj/crafter, datum/crafter_recipe/recipe)
	. = ..()
	plank = new()
	main_window.vis_contents += plank

/datum/minigame/carpenter/get_explanation()
	return image('dwarfs/icons/ui/minigame/bg.dmi', null, "help_wood")

/datum/minigame/carpenter/finish()
	. = ..()
	result = plank.line.calculate_res_grade(user, plank.points)




/atom/movable/screen/woodgame
	icon = 'dwarfs/icons/ui/minigame/wood/game.dmi'

/atom/movable/screen/woodgame/start
	icon_state = "start"

/atom/movable/screen/woodgame/start/MouseEntered(location, control, params)
	. = ..()
	vis_locs[1]?:started = TRUE

/atom/movable/screen/woodgame/end
	icon_state = "end"

/atom/movable/screen/woodgame/end/MouseEntered(location, control, params)
	. = ..()
	var/atom/movable/screen/woodgame/plank/parent = vis_locs[1]
	if(!parent.started)
		return
	if(!LAZYLEN(parent.points))
		parent.started = FALSE
		return
	parent.finished = TRUE

/atom/movable/screen/woodgame/end/MouseExited(location, control, params)
	. = ..()
	var/atom/movable/screen/woodgame/plank/parent = vis_locs[1]
	if(!parent.started)
		return
	var/atom/movable/screen/minigame/window = parent.vis_locs[1]
	window.minigame.finish()

/atom/movable/screen/woodgame/plank
	icon_state = "plank"
	pixel_x = 32
	pixel_y = 32
	var/started = FALSE
	var/finished = FALSE
	var/atom/movable/screen/woodgame/line/line
	var/atom/movable/screen/woodgame/start/start
	var/atom/movable/screen/woodgame/end/end
	var/last_x = -1
	var/max_x = -1
	var/list/points = list()

/atom/movable/screen/woodgame/plank/Initialize(mapload)
	. = ..()
	line = new()
	start = new()
	end = new()
	vis_contents += list(line, start, end)

/atom/movable/screen/woodgame/plank/MouseMove(location, control, params)
	if(!started || finished)
		return
	var/list/p = params2list(params)
	var/px = text2num(p["icon-x"])
	var/py = text2num(p["icon-y"])
	last_x = px
	if(px <= max_x)
		return
	points += list(list(px, py))
	max_x = px
	line.update_progress(px)

/atom/movable/screen/woodgame/plank/MouseEntered(location, control, params)
	. = ..()
	if(!started)
		return
	var/list/p = params2list(params)
	var/px = text2num(p["icon-x"])
	if(px > 15)
		started = FALSE

/atom/movable/screen/woodgame/plank/MouseExited(location, control, params)
	. = ..()
	if(!started)
		return
	if(last_x < 175)
		started = FALSE
		points.Cut()
		line.update_progress(0)
		last_x = -1
		max_x = -1

/atom/movable/screen/woodgame/line_overlay
	icon_state = "mask"
	vis_flags = VIS_INHERIT_ID

/atom/movable/screen/woodgame/line
	vis_flags = VIS_INHERIT_ID
	appearance_flags = KEEP_TOGETHER
	var/atom/movable/screen/woodgame/line_overlay/overlay
	var/list/points = list()

/atom/movable/screen/woodgame/line/proc/calculate_res_grade(mob/user, list/inputs)
	var/avg_multiplier = user.get_skill_modifier(/datum/skill/carpentry, SKILL_AMOUNT_MIN_MODIFIER)
	var/max_multiplier = user.get_skill_modifier(/datum/skill/carpentry, SKILL_AMOUNT_MAX_MODIFIER)
	var/valid_points = 0
	var/total_dist = 0
	var/max_dist = 0
	for(var/input in inputs)
		var/x = input[1]
		var/y = input[2]
		var/target_y = points["[x]"]
		if(!target_y)
			continue
		// var/temp_dist = min(abs(44-y), abs(45-y))
		var/temp_dist = abs(target_y - y)
		// to_chat(world, "x: [x] y:[y] d:[temp_dist]")
		total_dist += temp_dist
		valid_points++
		if(temp_dist > max_dist)
			max_dist = temp_dist
	var/avg_dist = total_dist/valid_points
	var/effective_dist = (max_dist * max_multiplier + avg_dist * avg_multiplier) / (avg_multiplier + max_multiplier)
	var/resulting_grade = clamp(floor(6 - clamp(effective_dist, 0, 6)), 1, 6)
	// to_chat(world, "avg: [avg_dist];[avg_multiplier] max: [max_dist];[max_multiplier] valid samples: [valid_points] eff: [effective_dist] grade: [resulting_grade]")
	return resulting_grade

/atom/movable/screen/woodgame/line/Initialize(mapload)
	. = ..()
	icon_state = "line[rand(0,3)]"
	render_target = ref(src)
	overlay = new()
	overlay.pixel_x = -192
	filters += filter(type="alpha", icon=icon(icon, icon_state))
	vis_contents += overlay
	read_points()

/atom/movable/screen/woodgame/line/proc/read_points()
	var/icon/I = icon(icon, icon_state)
	var/w = I.Width()
	var/h = I.Height()
	for(var/x in 1 to w)
		for(var/y in 1 to h)
			var/pixel = I.GetPixel(x, y)
			if(pixel == "#c8c8c8c8")
				points["[x]"] = y

/atom/movable/screen/woodgame/line/proc/update_progress(x)
	overlay.pixel_x = -192 + x
