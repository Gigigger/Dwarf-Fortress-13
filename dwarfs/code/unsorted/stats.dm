/atom/proc/update_stats(grade_override=null)
	reset_stats()
	if(!SSatoms.initialized)
		return
	apply_material_stats()

/obj/update_stats(grade_override)
	reset_stats()

	if(!SSatoms.initialized)
		return

	var/part_amount = LAZYLEN(grade_parts)

	if(grade_override)
		if(!grade_parts)
			src.grade = grade_override
		else
			for(var/part_type in grade_parts)
				grade_parts[part_type] = grade_override

	if(part_amount)
		var/grd = 0
		var/real_parts = 0
		for(var/part_type in grade_parts)
			grd += grade_parts[part_type]
			real_parts++
		src.grade = floor(grd/real_parts)

	if(part_amount)
		apply_grade_from_parts()
	else
		apply_grade(grade_override)

	apply_grade_extra(grade_override)

	// don't visually show that we use grades even if we actually use them. Maybe later on I will make it make more sense
	if(!(obj_flags & IGNORES_GRADES))
		obj_flags |= USES_GRADES
		apply_grade_name()

	apply_material_stats()

/obj/item/update_stats(grade_override)
	. = ..()
	// two-handed weapons when unwielded should usually have low force
	// 5 is just what is used most of the time for force_unwielded
	if(HAS_TRAIT(src, TRAIT_CAN_WIELD) && !HAS_TRAIT(src, TRAIT_WIELDED) && !HAS_TRAIT(src, TRAIT_NEEDS_TWO_HANDS))
		force = 5

/atom/proc/reset_stats()
	return

/obj/reset_stats()
	. = ..()
	obj_integrity = initial(max_integrity)
	max_integrity = initial(max_integrity)

/obj/item/reset_stats()
	. = ..()
	if(LAZYLEN(grade_parts))
		slowdown = 0
		melee_cd = CLICK_CD_MELEE
		toolspeed = 1
		force = 0
		block_chance = 0
	else
		slowdown = initial(slowdown)
		melee_cd = initial(melee_cd)

/obj/proc/apply_grade(grade_override=null)
	return

/obj/proc/apply_grade_extra(grade_override=null)
	return

/obj/proc/apply_grade_name()
	var/symbol = grade_symbol(grade)
	name = "[symbol][initial(name)][symbol]"

/obj/proc/apply_grade_from_parts()
	for(var/part_type in grade_parts)
		var/part_grade = grade_parts[part_type]
		var/obj/part = SSmaterials.get_part(part_type)
		part.apply_part_grade(part_grade, src)

/// Called by individual parts to apply stats to parent
/obj/proc/apply_part_grade(grade, obj/parent)
	return

/obj/item/apply_part_grade(grade, obj/item/parent)
	return

/proc/grade_symbol(grade)
	var/list/grades = list("-", "+", "*", "≡", "☼", "☼☼")
	return grades[min(6, grade)]

/*******************************************************************************************************************/


/obj/item/zwei/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 20
            throwforce = 10
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=8, pierce=4, blunt=2, fire=0, magic=0)
        if(2)
            force = 27
            throwforce = 18
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=8, pierce=4, blunt=4, fire=0, magic=0)
        if(3)
            force = 33
            throwforce = 25
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=9, pierce=5, blunt=5, fire=0, magic=0)
        if(4)
            force = 38
            throwforce = 30
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=11,pierce=6, blunt=5, fire=0, magic=0)
        if(5)
            force = 42
            throwforce = 36
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=13,pierce=7, blunt=6, fire=0, magic=0)
        if(6)
            force = 45
            throwforce = 40
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=15,pierce=8, blunt=8, fire=0, magic=0)

/obj/item/partial/zwei/apply_part_grade(grade, obj/item/parent)
	. = ..()
	parent.melee_cd += 12
	APPLY_GRADES(parent.force, 20, 27, 33, 38, 42, 45)
	APPLY_GRADES(parent.throwforce, 10, 18, 25, 30, 36, 40)
	APPLY_GRADES_RATING( \
		parent.armor_penetration.setRating(sharp=8, pierce=4, blunt=2, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=8, pierce=4, blunt=4, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=9, pierce=5, blunt=5, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=11,pierce=6, blunt=5, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=13,pierce=7, blunt=6, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=15,pierce=8, blunt=8, fire=0, magic=0))

/obj/item/flail/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 9
            throwforce = 8
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=2, blunt=2, fire=0, magic=0)
        if(2)
            force = 12
            throwforce = 10
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=3, blunt=4, fire=0, magic=0)
        if(3)
            force = 16
            throwforce = 14
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=1, pierce=3, blunt=6, fire=0, magic=0)
        if(4)
            force = 21
            throwforce = 18
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=2, pierce=5, blunt=8, fire=0, magic=0)
        if(5)
            force = 25
            throwforce = 22
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=3, pierce=5, blunt=9, fire=0, magic=0)
        if(6)
            force = 30
            throwforce = 25
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=4, pierce=6, blunt=10,fire=0, magic=0)

/obj/item/partial/flail/apply_part_grade(grade, obj/item/parent)
	. = ..()
	parent.melee_cd += 2
	APPLY_GRADES(parent.force, 9, 12, 16, 21, 25, 30)
	APPLY_GRADES(parent.throwforce, 8, 10, 14, 18, 22, 25)
	APPLY_GRADES_RATING( \
		parent.armor_penetration.setRating(sharp=0, pierce=2, blunt=2, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=0, pierce=3, blunt=4, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=1, pierce=3, blunt=6, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=2, pierce=5, blunt=8, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=3, pierce=5, blunt=9, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=4, pierce=6, blunt=10,fire=0, magic=0))

/obj/item/dagger/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 4
            throwforce = 4
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=4, pierce=5, blunt=0, fire=0, magic=0)
        if(2)
            force = 6
            throwforce = 6
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=5, pierce=7, blunt=0, fire=0, magic=0)
        if(3)
            force = 9
            throwforce = 9
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=7, pierce=8, blunt=0, fire=0, magic=0)
        if(4)
            force = 12
            throwforce = 12
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=8, pierce=9, blunt=1, fire=0, magic=0)
        if(5)
            force = 15
            throwforce = 15
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=9, pierce=11,blunt=2, fire=0, magic=0)
        if(6)
            force = 18
            throwforce = 18
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=10,pierce=13,blunt=3, fire=0, magic=0)

/obj/item/partial/dagger/apply_part_grade(grade, obj/item/parent)
	. = ..()
	parent.melee_cd -= 4
	APPLY_GRADES(parent.force, 4, 6, 9, 12, 15, 18)
	APPLY_GRADES(parent.throwforce, 4, 6, 9, 12, 15, 18)
	APPLY_GRADES_RATING( \
		parent.armor_penetration.setRating(sharp=4, pierce=5, blunt=0, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=5, pierce=7, blunt=0, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=7, pierce=8, blunt=0, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=8, pierce=9, blunt=1, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=9, pierce=11,blunt=2, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=10,pierce=13,blunt=3, fire=0, magic=0))

/obj/item/sword/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 10
            throwforce = 8
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=5, pierce=3, blunt=0, fire=0, magic=0)
        if(2)
            force = 15
            throwforce = 12
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=7, pierce=3, blunt=1, fire=0, magic=0)
        if(3)
            force = 20
            throwforce = 15
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=9, pierce=5, blunt=2, fire=0, magic=0)
        if(4)
            force = 23
            throwforce = 18
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=11,pierce=6, blunt=3, fire=0, magic=0)
        if(5)
            force = 26
            throwforce = 21
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=12,pierce=7, blunt=4, fire=0, magic=0)
        if(6)
            force = 31
            throwforce = 25
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=14,pierce=8, blunt=5, fire=0, magic=0)

/obj/item/partial/sword/apply_part_grade(grade, obj/item/parent)
	parent.melee_cd += 2
	APPLY_GRADES(parent.force, 10, 15, 20, 23, 26, 31)
	APPLY_GRADES(parent.throwforce, 8, 12, 15, 18, 21, 25)
	APPLY_GRADES_RATING( \
		parent.armor_penetration.setRating(sharp=5, pierce=3, blunt=0, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=7, pierce=3, blunt=1, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=9, pierce=5, blunt=2, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=11,pierce=6, blunt=3, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=12,pierce=7, blunt=4, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=14,pierce=8, blunt=5, fire=0, magic=0))

/obj/item/spear/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 12
            throwforce = 12
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=2, pierce=7, blunt=2, fire=0, magic=0)
        if(2)
            force = 16
            throwforce = 16
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=3, pierce=7, blunt=2, fire=0, magic=0)
        if(3)
            force = 23
            throwforce = 20
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=5, pierce=9, blunt=3, fire=0, magic=0)
        if(4)
            force = 26
            throwforce = 25
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=5, pierce=11,blunt=5, fire=0, magic=0)
        if(5)
            force = 30
            throwforce = 28
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=7, pierce=13,blunt=6, fire=0, magic=0)
        if(6)
            force = 34
            throwforce = 30
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=8, pierce=14,blunt=7, fire=0, magic=0)

/obj/item/partial/spear/apply_part_grade(grade, obj/item/parent)
	. = ..()
	parent.melee_cd += 4
	APPLY_GRADES(parent.force, 12, 16, 23, 26, 30, 34)
	APPLY_GRADES(parent.throwforce, 12, 16, 23, 26, 30, 34)
	APPLY_GRADES_RATING( \
		armor_penetration.setRating(sharp=2, pierce=7, blunt=2, fire=0, magic=0), \
		armor_penetration.setRating(sharp=3, pierce=7, blunt=2, fire=0, magic=0), \
		armor_penetration.setRating(sharp=5, pierce=9, blunt=3, fire=0, magic=0), \
		armor_penetration.setRating(sharp=5, pierce=11,blunt=5, fire=0, magic=0), \
		armor_penetration.setRating(sharp=7, pierce=13,blunt=6, fire=0, magic=0), \
		armor_penetration.setRating(sharp=8, pierce=14,blunt=7, fire=0, magic=0))

/obj/item/warhammer/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 15
            throwforce = 15
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=5, fire=0, magic=0)
        if(2)
            force = 19
            throwforce = 17
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=1, pierce=2, blunt=7, fire=0, magic=0)
        if(3)
            force = 23
            throwforce = 24
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=2, pierce=3, blunt=9, fire=0, magic=0)
        if(4)
            force = 28
            throwforce = 29
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=3, pierce=5, blunt=11,fire=0, magic=0)
        if(5)
            force = 32
            throwforce = 35
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=3, pierce=5, blunt=12,fire=0, magic=0)
        if(6)
            force = 36
            throwforce = 45
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=4, pierce=6, blunt=13,fire=0, magic=0)

/obj/item/partial/warhammer/apply_part_grade(grade, obj/item/parent)
	. = ..()
	parent.melee_cd += 6
	APPLY_GRADES(parent.force, 15, 19, 23, 28, 32, 36)
	APPLY_GRADES(parent.throwforce, 15, 19, 23, 28, 32, 36)
	APPLY_GRADES_RATING( \
		parent.armor_penetration.setRating(sharp=0, pierce=0, blunt=5, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=1, pierce=2, blunt=7, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=2, pierce=3, blunt=9, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=3, pierce=5, blunt=11,fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=3, pierce=5, blunt=12,fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=4, pierce=6, blunt=13,fire=0, magic=0))

/obj/item/halberd/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 15
            throwforce = 8
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=3, pierce=4, blunt=0, fire=0, magic=0)
        if(2)
            force = 17
            throwforce = 10
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=5, pierce=5, blunt=0, fire=0, magic=0)
        if(3)
            force = 18
            throwforce = 13
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=7, pierce=8, blunt=0, fire=0, magic=0)
        if(4)
            force = 20
            throwforce = 15
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=10,pierce=12,blunt=0, fire=0, magic=0)
        if(5)
            force = 24
            throwforce = 18
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=15,pierce=14,blunt=0, fire=0, magic=0)
        if(6)
            force = 28
            throwforce = 22
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=18,pierce=18,blunt=0, fire=0, magic=0)

/obj/item/partial/halberd/apply_part_grade(grade, obj/item/parent)
	. = ..()
	parent.melee_cd += 4
	APPLY_GRADES(parent.force, 15, 17, 18, 20, 24, 28)
	APPLY_GRADES(parent.throwforce, 8, 10, 13, 15, 18, 22)
	APPLY_GRADES_RATING( \
		parent.armor_penetration.setRating(sharp=3, pierce=4, blunt=0, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=5, pierce=5, blunt=0, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=7, pierce=8, blunt=0, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=10,pierce=12,blunt=0, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=15,pierce=14,blunt=0, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=18,pierce=18,blunt=0, fire=0, magic=0))

/obj/item/battleaxe/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 15
            throwforce = 15
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=5, fire=0, magic=0)
        if(2)
            force = 19
            throwforce = 17
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=1, pierce=2, blunt=7, fire=0, magic=0)
        if(3)
            force = 23
            throwforce = 24
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=2, pierce=3, blunt=9, fire=0, magic=0)
        if(4)
            force = 28
            throwforce = 29
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=3, pierce=5, blunt=11,fire=0, magic=0)
        if(5)
            force = 32
            throwforce = 35
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=3, pierce=5, blunt=12,fire=0, magic=0)
        if(6)
            force = 36
            throwforce = 45
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=4, pierce=6, blunt=13,fire=0, magic=0)

/obj/item/partial/battleaxe/apply_part_grade(grade, obj/item/parent)
	. = ..()
	parent.melee_cd += 4
	APPLY_GRADES(parent.force, 15, 19, 23, 28, 32, 36)
	APPLY_GRADES(parent.throwforce, 15, 19, 23, 28, 32, 36)
	APPLY_GRADES_RATING( \
		parent.armor_penetration.setRating(sharp=0, pierce=0, blunt=5, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=1, pierce=2, blunt=7, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=2, pierce=3, blunt=9, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=3, pierce=5, blunt=11,fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=3, pierce=5, blunt=12,fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=4, pierce=6, blunt=13,fire=0, magic=0))

/obj/item/scepter/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 4
            throwforce = 4
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=1, fire=0, magic=0)
        if(3)
            force = 6
            throwforce = 6
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=2, fire=0, magic=0)
        if(4)
            force = 7
            throwforce = 7
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=4, fire=0, magic=0)
        if(5)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=5, fire=0, magic=0)
        if(6)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=6, fire=0, magic=0)

/obj/item/partial/scepter_part/apply_part_grade(grade, obj/item/parent)
	. = ..()
	APPLY_GRADES(parent.force, 4, 5, 6, 7, 8, 8)
	APPLY_GRADES(parent.throwforce, 4, 5, 6, 7, 8, 8)
	APPLY_GRADES_RATING( \
		parent.armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=0, pierce=0, blunt=1, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=0, pierce=0, blunt=2, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=0, pierce=0, blunt=4, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=0, pierce=0, blunt=5, fire=0, magic=0), \
		parent.armor_penetration.setRating(sharp=0, pierce=0, blunt=6, fire=0, magic=0))

/obj/item/pickaxe/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 3
            throwforce = 3
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 7
            throwforce = 7
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 10
            throwforce = 10
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 13
            throwforce = 13
            block_chance = 0
            toolspeed = 0.8
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 15
            throwforce = 15
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/partial/pickaxe/apply_part_grade(grade, obj/item/parent)
	. = ..()
	parent.block_chance = 0
	parent.armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
	APPLY_GRADES(parent.force, 3, 5, 7, 10, 13, 15)
	APPLY_GRADES(parent.throwforce, 3, 5, 7, 10, 13, 15)

/obj/item/axe/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 10
            throwforce = 10
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 13
            throwforce = 13
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 15
            throwforce = 15
            block_chance = 0
            toolspeed = 0.7
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 15
            throwforce = 17
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/partial/axe/apply_part_grade(grade, obj/item/parent)
	. = ..()
	parent.armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
	APPLY_GRADES(parent.force, 5, 8, 10, 13, 15, 16)
	APPLY_GRADES(parent.throwforce, 5, 8, 10, 13, 15, 16)

/obj/item/hoe/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 3
            throwforce = 2
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 5
            throwforce = 4
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 6
            throwforce = 7
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 7
            throwforce = 11
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 8
            throwforce = 14
            block_chance = 0
            toolspeed = 0.7
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 10
            throwforce = 16
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/partial/hoe/apply_part_grade(grade, obj/item/parent)
	. = ..()
	parent.armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
	APPLY_GRADES(parent.force, 3, 5, 6, 7, 8, 10)
	APPLY_GRADES(parent.throwforce, 3, 5, 6, 7, 8, 10)

/obj/item/shovel/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 3
            throwforce = 3
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 5
            throwforce = 6
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 6
            throwforce = 9
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 7
            throwforce = 12
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 8
            throwforce = 15
            block_chance = 0
            toolspeed = 0.7
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 10
            throwforce = 18
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/partial/shovel/apply_part_grade(grade, obj/item/parent)
	. = ..()
	parent.armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
	APPLY_GRADES(parent.force, 3, 5, 6, 7, 8, 10)
	APPLY_GRADES(parent.throwforce, 3, 5, 6, 7, 8, 10)

/obj/item/chisel/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 1
            throwforce = 1
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 2
            throwforce = 4
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 4
            throwforce = 8
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 5
            throwforce = 10
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 7
            throwforce = 12
            block_chance = 0
            toolspeed = 0.7
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 8
            throwforce = 15
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/partial/chisel/apply_part_grade(grade, obj/item/parent)
	. = ..()
	parent.armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
	APPLY_GRADES(parent.force, 2, 3, 4, 5, 6, 8)
	APPLY_GRADES(parent.throwforce, 2, 3, 4, 5, 6, 8)

/obj/item/builder_hammer/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 2
            throwforce = 2
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 4
            throwforce = 4
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 6
            throwforce = 6
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 10
            throwforce = 10
            block_chance = 0
            toolspeed = 0.7
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 12
            throwforce = 14
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/partial/builder_hammer/apply_part_grade(grade, obj/item/parent)
	. = ..()
	parent.armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
	APPLY_GRADES(parent.force, 2, 4, 6, 8, 10, 12)
	APPLY_GRADES(parent.throwforce, 2, 4, 6, 8, 10, 12)

/obj/item/smithing_hammer/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 3
            throwforce = 3
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 6
            throwforce = 6
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 7
            throwforce = 7
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 0.7
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 10
            throwforce = 10
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/partial/smithing_hammer/apply_part_grade(grade, obj/item/parent)
	. = ..()
	parent.armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
	APPLY_GRADES(parent.force, 3, 5, 6, 7, 8, 10)
	APPLY_GRADES(parent.throwforce, 3, 5, 6, 7, 8, 10)

/obj/item/tongs/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 3
            throwforce = 3
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 6
            throwforce = 6
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 7
            throwforce = 7
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 0.7
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 10
            throwforce = 10
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/trowel/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 1
            throwforce = 1
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 2
            throwforce = 2
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 4
            throwforce = 4
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 7
            throwforce = 7
            block_chance = 0
            toolspeed = 0.7
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/kitchen/knife/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            force = 4
            throwforce = 4
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 6
            throwforce = 6
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 7
            throwforce = 7
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 0.7
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 10
            throwforce = 10
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/partial/kitchen_knife/apply_part_grade(grade, obj/item/parent)
	. = ..()
	parent.armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
	APPLY_GRADES(parent.force, 4, 5, 6, 7, 8, 10)
	APPLY_GRADES(parent.throwforce, 4, 5, 6, 7, 8, 10)

/obj/item/shield/apply_grade(grade_override)
	..()
	switch(grade)
		if(1)
			force = 1
			throwforce = 4
			block_chance = 15
			toolspeed = 1
			armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
		if(2)
			force = 2
			throwforce = 5
			block_chance = 20
			toolspeed = 1
			armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
		if(3)
			force = 3
			throwforce = 6
			block_chance = 25
			toolspeed = 1
			armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
		if(4)
			force = 3
			throwforce = 7
			block_chance = 30
			toolspeed = 1
			armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
		if(5)
			force = 4
			throwforce = 8
			block_chance = 35
			toolspeed = 1
			armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
		if(6)
			force = 5
			throwforce = 10
			block_chance = 40
			toolspeed = 1
			armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

// since both shields use the same primary component (shield parts)
/obj/item/shield/large/reset_stats()
	. = ..()
	block_chance = 10

/obj/item/shield/large/reset_stats()
	. = ..()
	block_chance = 20

/obj/item/partial/shield/apply_part_grade(grade, obj/item/parent)
	. = ..()
	parent.armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
	APPLY_GRADES_ADD(parent.block_chance, 5, 10, 15, 20, 25, 30)
	APPLY_GRADES(parent.force, 1, 2, 3, 4, 5, 6)
	APPLY_GRADES(parent.throwforce, 2, 3, 5, 6, 7, 8)

/obj/item/shield/large/apply_grade(grade_override)
	..()
	switch(grade)
		if(1)
			force = 1
			throwforce = 4
			block_chance = 25
			toolspeed = 1
			armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
		if(2)
			force = 2
			throwforce = 5
			block_chance = 30
			toolspeed = 1
			armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
		if(3)
			force = 3
			throwforce = 6
			block_chance = 35
			toolspeed = 1
			armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
		if(4)
			force = 3
			throwforce = 7
			block_chance = 40
			toolspeed = 1
			armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
		if(5)
			force = 4
			throwforce = 8
			block_chance = 45
			toolspeed = 1
			armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
		if(6)
			force = 5
			throwforce = 10
			block_chance = 50
			toolspeed = 1
			armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/*******************************************************************************************************************/

/obj/item/clothing/suit/light_plate/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            armor = armor.setRating(sharp=6, pierce=2, blunt=4, fire=4, wound=15)
        if(2)
            armor = armor.setRating(sharp=9, pierce=4, blunt=5, fire=5, wound=20)
        if(3)
            armor = armor.setRating(sharp=12,pierce=8, blunt=7, fire=6, wound=25)
        if(4)
            armor = armor.setRating(sharp=16,pierce=10,blunt=10, fire=7, wound=30)
        if(5)
            armor = armor.setRating(sharp=19,pierce=12,blunt=16, fire=8, wound=35)
        if(6)
            armor = armor.setRating(sharp=23,pierce=15,blunt=20,fire=9, wound=40)

/obj/item/clothing/suit/heavy_plate/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            armor = armor.setRating(sharp=9, pierce=4, blunt=6, fire=6, wound=20)
        if(2)
            armor = armor.setRating(sharp=12,pierce=6, blunt=9, fire=7, wound=25)
        if(3)
            armor = armor.setRating(sharp=15,pierce=10, blunt=12, fire=8, wound=30)
        if(4)
            armor = armor.setRating(sharp=18,pierce=15,blunt=17,fire=9, wound=40)
        if(5)
            armor = armor.setRating(sharp=24,pierce=21,blunt=20,fire=10,wound=45)
        if(6)
            armor = armor.setRating(sharp=30,pierce=25,blunt=27,fire=11,wound=50)

/obj/item/clothing/under/chainmail/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            armor = armor.setRating(sharp=5, pierce=0, blunt=2, fire=5, wound=10)
        if(2)
            armor = armor.setRating(sharp=8, pierce=3, blunt=5, fire=6, wound=15)
        if(3)
            armor = armor.setRating(sharp=11,pierce=6, blunt=7, fire=7, wound=20)
        if(4)
            armor = armor.setRating(sharp=14,pierce=9, blunt=10,fire=8, wound=25)
        if(5)
            armor = armor.setRating(sharp=17,pierce=12,blunt=12,fire=9, wound=30)
        if(6)
            armor = armor.setRating(sharp=20,pierce=14,blunt=15,fire=10,wound=35)

/obj/item/clothing/head/heavy_plate/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            armor = armor.setRating(sharp=9, pierce=10, blunt=8, fire=5, wound=15)
        if(2)
            armor = armor.setRating(sharp=14, pierce=14, blunt=13, fire=6, wound=20)
        if(3)
            armor = armor.setRating(sharp=18,pierce=20, blunt=16, fire=7, wound=25)
        if(4)
            armor = armor.setRating(sharp=23,pierce=25,blunt=22, fire=8, wound=30)
        if(5)
            armor = armor.setRating(sharp=28,pierce=30,blunt=27,fire=9, wound=35)
        if(6)
            armor = armor.setRating(sharp=35,pierce=40,blunt=35,fire=10,wound=40)

/obj/item/clothing/gloves/plate_gloves/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            armor = armor.setRating(sharp=5, pierce=5, blunt=5, fire=5, wound=15)
        if(2)
            armor = armor.setRating(sharp=9, pierce=7, blunt=7, fire=6, wound=20)
        if(3)
            armor = armor.setRating(sharp=13,pierce=10, blunt=10, fire=7, wound=25)
        if(4)
            armor = armor.setRating(sharp=17,pierce=14,blunt=17, fire=8, wound=30)
        if(5)
            armor = armor.setRating(sharp=20,pierce=19,blunt=22,fire=9, wound=35)
        if(6)
            armor = armor.setRating(sharp=23,pierce=24,blunt=28,fire=10,wound=40)

/obj/item/clothing/shoes/plate_boots/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            armor = armor.setRating(sharp=5, pierce=5, blunt=7, fire=5, wound=15)
        if(2)
            armor = armor.setRating(sharp=9, pierce=8, blunt=10, fire=6, wound=20)
        if(3)
            armor = armor.setRating(sharp=13,pierce=11, blunt=16, fire=7, wound=25)
        if(4)
            armor = armor.setRating(sharp=17,pierce=16,blunt=20, fire=8, wound=30)
        if(5)
            armor = armor.setRating(sharp=20,pierce=20,blunt=25,fire=9, wound=35)
        if(6)
            armor = armor.setRating(sharp=23,pierce=25,blunt=30,fire=10,wound=40)

/obj/item/clothing/head/crown/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            armor = armor.setRating(sharp=2, pierce=0, blunt=0, fire=5, wound=0)
        if(2)
            armor = armor.setRating(sharp=4, pierce=0, blunt=0, fire=0, wound=0)
        if(3)
            armor = armor.setRating(sharp=6, pierce=0, blunt=0, fire=0, wound=0)
        if(4)
            armor = armor.setRating(sharp=8, pierce=0, blunt=0, fire=0, wound=0)
        if(5)
            armor = armor.setRating(sharp=9, pierce=0, blunt=0, fire=0, wound=0)
        if(6)
            armor = armor.setRating(sharp=10,pierce=0, blunt=0, fire=0, wound=0)

/obj/item/clothing/shoes/boots/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            armor = armor.setRating(sharp=1, pierce=0, blunt=0, fire=5, wound=0)
        if(2)
            armor = armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)
        if(3)
            armor = armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)
        if(4)
            armor = armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)
        if(5)
            armor = armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)
        if(6)
            armor = armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)

/obj/item/clothing/under/tunic/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            armor = armor.setRating(sharp=1, pierce=0, blunt=0, fire=5, wound=0)
        if(2)
            armor = armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)
        if(3)
            armor = armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)
        if(4)
            armor = armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)
        if(5)
            armor = armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)
        if(6)
            armor = armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)

/obj/item/clothing/head/light_plate/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            armor = armor.setRating(sharp=5, pierce=4, blunt=7, fire=4, wound=10)
        if(2)
            armor = armor.setRating(sharp=8, pierce=6, blunt=9, fire=5, wound=15)
        if(3)
            armor = armor.setRating(sharp=12, pierce=11, blunt=13, fire=6, wound=20)
        if(4)
            armor = armor.setRating(sharp=17,pierce=16, blunt=18, fire=7, wound=25)
        if(5)
            armor = armor.setRating(sharp=21,pierce=20,blunt=23, fire=8, wound=30)
        if(6)
            armor = armor.setRating(sharp=25,pierce=23,blunt=27,fire=9, wound=35)

/obj/item/clothing/head/leather_helmet/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            armor = armor.setRating(sharp=3, pierce=2, blunt=2, fire=4, wound=10)
        if(2)
            armor = armor.setRating(sharp=5, pierce=4, blunt=3, fire=5, wound=15)
        if(3)
            armor = armor.setRating(sharp=8, pierce=7, blunt=5, fire=6, wound=20)
        if(4)
            armor = armor.setRating(sharp=11,pierce=9, blunt=7, fire=7, wound=25)
        if(5)
            armor = armor.setRating(sharp=14,pierce=12,blunt=9, fire=8, wound=30)
        if(6)
            armor = armor.setRating(sharp=18,pierce=14,blunt=12,fire=9, wound=35)

/obj/item/clothing/suit/leather_vest/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            armor = armor.setRating(sharp=2, pierce=2, blunt=0, fire=0, wound=10)
        if(2)
            armor = armor.setRating(sharp=5, pierce=4, blunt=3, fire=2, wound=15)
        if(3)
            armor = armor.setRating(sharp=8, pierce=7, blunt=5, fire=4, wound=20)
        if(4)
            armor = armor.setRating(sharp=14,pierce=10,blunt=7, fire=6, wound=25)
        if(5)
            armor = armor.setRating(sharp=17,pierce=12,blunt=9, fire=8, wound=30)
        if(6)
            armor = armor.setRating(sharp=20,pierce=15,blunt=14,fire=9, wound=35)

/obj/item/clothing/gloves/leather/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            armor = armor.setRating(sharp=2, pierce=3, blunt=2, fire=1, wound=5)
        if(2)
            armor = armor.setRating(sharp=4, pierce=5, blunt=4, fire=3, wound=10)
        if(3)
            armor = armor.setRating(sharp=7,pierce=8, blunt=7, fire=5, wound=15)
        if(4)
            armor = armor.setRating(sharp=10,pierce=10,blunt=9, fire=8, wound=20)
        if(5)
            armor = armor.setRating(sharp=12,pierce=12,blunt=12,fire=10, wound=25)
        if(6)
            armor = armor.setRating(sharp=16,pierce=15,blunt=15,fire=11,wound=30)

/obj/item/clothing/shoes/leather_boots/apply_grade(grade_override)
    ..()
    switch(grade)
        if(1)
            armor = armor.setRating(sharp=2, pierce=3, blunt=2, fire=1, wound=5)
        if(2)
            armor = armor.setRating(sharp=4, pierce=5, blunt=4, fire=3, wound=10)
        if(3)
            armor = armor.setRating(sharp=8,pierce=7, blunt=7, fire=5, wound=15)
        if(4)
            armor = armor.setRating(sharp=11,pierce=10,blunt=9, fire=8, wound=20)
        if(5)
            armor = armor.setRating(sharp=15,pierce=13,blunt=12,fire=9, wound=25)
        if(6)
            armor = armor.setRating(sharp=17,pierce=15,blunt=15,fire=11,wound=30)
