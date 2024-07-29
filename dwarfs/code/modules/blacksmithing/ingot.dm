/obj/item/ingot
	name = "ingot"
	desc = "Can be forged into something."
	icon = 'dwarfs/icons/items/ingots.dmi'
	icon_state = "ingot"
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	force = 2
	throwforce = 5
	throw_range = 7
	materials = /datum/material/iron
	part_name = PART_INGOT
	var/datum/smithing_recipe/recipe = null
	var/durability = 6
	var/progress_current = 0
	var/progress_need = 10
	var/heattemp = 0

/obj/item/ingot/apply_material(list/_materials)
	. = ..()
	var/datum/material/M = get_material(materials)
	name = "[M.name] ingot"

/obj/item/ingot/update_stats(_grade)
	. = ..()
	var/grd = grade_name(grade)
	name = "[grd][get_material_name(materials)] ingot[grd]"

/obj/item/ingot/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/ingot/examine(mob/user)
	. = ..()
	var/ct = ""
	switch(heattemp)
		if(200 to INFINITY)
			ct = "red-hot"
		if(100 to 199)
			ct = "very hot"
		if(1 to 99)
			ct = "hot enough"
		else
			ct = "cold"

	. += "<br>The [src] is [ct]."
	if(recipe)
		. += "<br>The [src] is being smithed into <b>[recipe.name]</b>."
		if(progress_current == progress_need + 1)
			. += "<br>The [src] is ready to be quenched."

/obj/item/ingot/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/ingot/Destroy()
	STOP_PROCESSING(SSobj, src)
	recipe = null
	return ..()

/obj/item/ingot/process()
	if(!heattemp)
		return
	heattemp = max(heattemp-25, 0)
	update_appearance()
	if(isobj(loc))
		loc.update_appearance()

/obj/item/ingot/update_overlays()
	. = ..()
	var/mutable_appearance/heat = mutable_appearance('dwarfs/icons/items/ingots.dmi', "ingot_heat")
	heat.color = "#ff9900"
	heat.alpha =  255 * (heattemp / 350)
	. += heat


/obj/item/ingot/attackby(obj/item/I, mob/living/user, params)

	if(user.a_intent == INTENT_HARM)
		return ..()

	if(istype(I, /obj/item/tongs))
		if(I.contents.len)
			to_chat(user, span_warning("You are already holding something with [I]!"))
			return
		else
			src.forceMove(I)
			update_appearance()
			I.update_appearance()
			to_chat(user, span_notice("You grab \the [src] with \the [I]."))
			return

/obj/item/ingot/attack_hand(mob/user)
	if(heattemp && isliving(user))
		user.changeNext_move(CLICK_CD_MELEE)
		var/mob/living/L = user
		to_chat(user, span_warning("You try to pick up [src], but you burn your hand on it!"))
		var/obj/item/bodypart/affected = L.get_bodypart(user.active_hand_index == 1 ? BODY_ZONE_L_ARM : BODY_ZONE_R_ARM)
		affected.receive_damage(0, rand(4, 10))
		L.update_damage_overlays()
		return TRUE
	else
		. = ..()
