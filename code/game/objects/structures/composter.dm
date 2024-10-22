/obj/structure/composter
	name = "compost bin"
	desc = "Converts leftover organics into useful fertilizer and soil."
	icon = 'dwarfs/icons/structures/workshops.dmi'
	icon_state = "composter"
	anchored = TRUE
	density = TRUE
	materials = /datum/material/wood/treated
	/// Amount of biomass this has
	var/biomass = 0
	/// Amount of fertilizer this has
	var/fertilizer = 0
	/// Amount of soil this has
	var/soil = 0
	/// Max volume of biomass, fertilizer and soil
	var/max_volume = 100
	/// How much of stuff gets converted per second (biomass -> fertilizer -> soil)
	var/converted_per_second = 0.1
	/// Whether the compost has water to speed up the process
	var/has_water = FALSE
	/// Whether the compost was mixed recently to make soil out of fertilizer
	var/is_mixed = FALSE
	/// timers
	var/water_timerid
	var/mixed_timerid
	var/compost_timerid
	/// Front layer overlay obj sitting in vis_contents
	var/obj/front_overlay
	/// Whether we are composting
	var/is_composting = FALSE
	/// How long to wait before starting to compost
	var/composting_delay = 30 SECONDS
	/// How much of stuff (fertilizer/soil) is needed per item
	var/consumed_per_item = 10

/obj/structure/composter/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/structure/composter/Initialize(mapload)
	. = ..()
	front_overlay = new()
	front_overlay.vis_flags = VIS_INHERIT_ICON | VIS_INHERIT_PLANE | VIS_INHERIT_ID
	front_overlay.icon_state = "composter_front"
	vis_contents += front_overlay

/obj/structure/composter/Destroy()
	vis_contents.Cut()
	qdel(front_overlay)
	deltimer(water_timerid)
	deltimer(mixed_timerid)
	deltimer(compost_timerid)
	. = ..()

/obj/structure/composter/examine(mob/user)
	. = ..()
	if(is_empty())
		. += "<br>It's empty."
		return
	if(soil)
		. += "<br>There's soil inside."
	if(fertilizer)
		. += "<br>There's fertilizer inside."
	if(biomass)
		. += "<br>There's biomass inside."
	. += "<br>It's [has_water ? "moist" : "dry"]."
	. += "<br>It [is_mixed ? "has been mixed recently" : "hasn't been mixed for a while"]."

/obj/structure/composter/attackby(obj/item/I, mob/user, params)
	. = TRUE
	if(HAS_TRAIT(I, TRAIT_COMPOSTABLE))
		if(SEND_SIGNAL(I, COMSIG_ATOM_COMPOSTED, src, user) == COMPONENT_BLOCK_COMPOSTING)
			return FALSE
		to_chat(user, span_notice("You add [I] to [src]."))
		update_appearance(UPDATE_OVERLAYS)
		if(!compost_timerid && !is_composting)
			compost_timerid = addtimer(CALLBACK(src, PROC_REF(start_composting)), composting_delay, TIMER_STOPPABLE)
	else if(I.is_refillable())
		if(is_empty())
			to_chat(user, span_warning("\The [src] is empty."))
			return
		if(has_water)
			to_chat(user, span_warning("\The [src] is already moist."))
			return
		if(!I.reagents.remove_reagent(/datum/reagent/water, 15))
			to_chat(user, span_warning("\The [I] doesn't have enough water."))
			return
		to_chat(user, span_notice("You water \the [src]."))
		playsound(src, 'sound/effects/slosh.ogg', 25, TRUE)
		has_water = TRUE
		water_timerid = addtimer(CALLBACK(src, PROC_REF(refresh_water)), rand(2 MINUTES, 10 MINUTES), TIMER_STOPPABLE)
		update_appearance(UPDATE_OVERLAYS)
	else if(I.tool_behaviour == TOOL_SHOVEL)
		if(is_empty())
			to_chat(user, span_warning("\The [src] is empty."))
			return
		if(is_mixed)
			to_chat(user, span_warning("\The [src] is already mixed."))
			return
		to_chat(user, span_notice("You start mixing \the [src]'s contents..."))
		if(I.use_tool(src, user, 3 SECONDS, volume=50, used_skill=/datum/skill/farming))
			to_chat(user, span_notice("You mix \the [src]'s contents."))
			is_mixed = TRUE
			mixed_timerid = addtimer(CALLBACK(src, PROC_REF(refresh_mixed)), rand(2 MINUTES, 10 MINUTES), TIMER_STOPPABLE)
	else
		. = ..()

/obj/structure/composter/attack_hand(mob/user)
	. = TRUE
	if(is_empty())
		to_chat(user, span_warning("\The [src] is empty."))
		return
	else if(soil < consumed_per_item && fertilizer < consumed_per_item)
		to_chat(user, span_warning("There's too little to take out."))
	if(soil > consumed_per_item)
		soil -= consumed_per_item
		var/obj/S = new/obj/item/stack/dirt()
		user.put_in_hands(S)
		to_chat(user, span_notice("You take some soil out of [src]."))
		update_appearance(UPDATE_OVERLAYS)
		return
	else if(fertilizer > consumed_per_item)
		fertilizer -= consumed_per_item
		var/obj/S = new/obj/item/stack/fertilizer()
		user.put_in_hands(S)
		to_chat(user, span_notice("You take some fertilizer out of [src]."))
		update_appearance(UPDATE_OVERLAYS)
		return
	. = ..()

/obj/structure/composter/MouseDrop_T(atom/dropping, mob/living/user)
	if(!isliving(dropping))
		return ..()
	var/mob/living/L = dropping
	if(!HAS_TRAIT(L, TRAIT_COMPOSTABLE))
		return ..()
	if(L.stat != DEAD)
		return ..()
	to_chat(user, span_notice("You start moving [L] into [src]..."))
	if(do_after(user, 5 SECONDS, L))
		if(SEND_SIGNAL(L, COMSIG_ATOM_COMPOSTED, src, user) == COMPONENT_BLOCK_COMPOSTING)
			return
		L.unequip_everything()
		to_chat(user, span_notice("You move [L] into [src]."))
		update_appearance(UPDATE_OVERLAYS)
		if(!compost_timerid && !is_composting)
			compost_timerid = addtimer(CALLBACK(src, PROC_REF(start_composting)), composting_delay, TIMER_STOPPABLE)

/obj/structure/composter/proc/refresh_water()
	has_water = FALSE
	water_timerid = 0
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/composter/proc/refresh_mixed()
	is_mixed = FALSE
	mixed_timerid = 0

/obj/structure/composter/proc/start_composting()
	is_composting = TRUE
	compost_timerid = 0
	START_PROCESSING(SSprocessing, src)

/// Returns TRUE if it's empty, FALSE otherwise
/obj/structure/composter/proc/is_empty()
	return (total_volume() == 0)

/// Returns total amount of biomass, fertilizer and soil inside
/obj/structure/composter/proc/total_volume()
	return biomass + fertilizer + soil

/obj/structure/composter/update_overlays()
	. = ..()
	if(is_empty())
		return
	var/icon/mask_icon = icon(src::icon, "composter_mask")
	var/mutable_appearance/water_overlay
	if(has_water)
		water_overlay = mutable_appearance(src::icon, "composter_water")
		water_overlay.blend_mode = BLEND_MULTIPLY
	if(soil)
		var/mutable_appearance/SA = mutable_appearance(src::icon, "composter_soil", FLOAT_LAYER-2)
		if(has_water)
			SA.overlays += water_overlay
		var/s_offset = -15 + 15 * (biomass+fertilizer+soil) / max_volume
		SA.pixel_z = s_offset
		SA.filters += filter(type="alpha", icon=mask_icon, y=-s_offset-30, flags=MASK_INVERSE)
		. += SA
	if(fertilizer)
		var/mutable_appearance/FA = mutable_appearance(src::icon, "composter_fertilizer", FLOAT_LAYER-1)
		if(has_water)
			FA.overlays += water_overlay
		var/f_offset = -15 + 15 * (biomass+fertilizer) / max_volume
		FA.pixel_z = f_offset
		FA.filters += filter(type="alpha", icon=mask_icon, y=-f_offset-30, flags=MASK_INVERSE)
		if(soil)
			FA.filters += filter(type="alpha", icon=mask_icon, y=16, flags=MASK_INVERSE)
		. += FA
	if(biomass)
		var/mutable_appearance/BA = mutable_appearance(src::icon, "composter_biomass", FLOAT_LAYER)
		if(has_water)
			BA.overlays += water_overlay
		var/b_offset = -15 + 15 * biomass / max_volume
		BA.pixel_z = b_offset
		BA.filters += filter(type="alpha", icon=mask_icon, y=-b_offset-30, flags=MASK_INVERSE)
		if(soil || fertilizer)
			BA.filters += filter(type="alpha", icon=mask_icon, y=16, flags=MASK_INVERSE)
		. += BA

/obj/structure/composter/process(delta_time)
	if(is_empty())
		is_composting = FALSE
		return PROCESS_KILL
	if(!is_composting)
		return PROCESS_KILL
	var/needs_update = FALSE
	var/converted = converted_per_second * delta_time
	if(has_water)
		converted *= 1.25

	if(biomass)
		converted = clamp(converted, 0, biomass)
		fertilizer += converted
		biomass -= converted
		needs_update = TRUE
	// make dirt only if mixed -> players decide what to make
	else if(fertilizer && is_mixed)
		converted = clamp(converted, 0, soil)
		soil += converted
		fertilizer -= converted
		needs_update = TRUE
	else
		is_composting = FALSE
		if(needs_update)
			update_appearance(UPDATE_OVERLAYS)
		return PROCESS_KILL

	if(needs_update)
		update_appearance(UPDATE_OVERLAYS)
