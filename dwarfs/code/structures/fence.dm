/obj/structure/fence
	name = "fence"
	desc = "This is a fence."
	icon_state = "fence-0"
	base_icon_state = "fence"
	smoothing_flags = SMOOTH_BITMASK_SIMPLE
	smoothing_groups = list(SMOOTH_GROUP_FENCE)
	canSmoothWith = list(SMOOTH_GROUP_FENCE)
	anchored = TRUE
	// we want the fences to visually be aligned to north side of the turf
	pixel_z = 7

/obj/structure/fence/Initialize()
	. = ..()

	var/static/list/loc_connections = list(
		COMSIG_ATOM_EXIT = PROC_REF(on_exit),
	)

	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/fence/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/structure/fence/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER

	if((smoothing_junction & SOUTH) && (direction & WEST))
		return COMPONENT_ATOM_BLOCK_EXIT
	else if(direction & NORTH)
		return COMPONENT_ATOM_BLOCK_EXIT

	leaving.Bump(src)

/obj/structure/fence/CanPass(atom/movable/mover, border_dir)
	. = ..()
	if(!.)
		return .
	var/direction = get_dir(mover, src)
	if((smoothing_junction & SOUTH) && (direction & (EAST|WEST)))
		return FALSE
	if(direction & SOUTH)
		return FALSE

	return TRUE

/obj/structure/fence/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/flashlight/fueled/lantern))
		if(length(contents))
			return ..()
		to_chat(user, span_notice("You place [I] on \the [src]."))
		I.forceMove(src)
		update_appearance(UPDATE_OVERLAYS)
	else
		. = ..()

/obj/structure/fence/attack_hand(mob/user)
	if(length(contents))
		var/obj/item/I = contents[1]
		user.put_in_hands(I)
		update_appearance(UPDATE_OVERLAYS)

/obj/structure/fence/update_overlays()
	. = ..()
	if(length(contents))
		var/obj/item/flashlight/F = contents[1]
		var/icon/I = F.build_material_icon('dwarfs/icons/structures/fence_decoration.dmi', "[src::base_icon_state]_lamp[F.on ? "_on" : ""]")
		. += I

/obj/structure/fence/wooden
	name = "wooden fence"
	icon = 'dwarfs/icons/structures/wooden_fence.dmi'
	icon_state = "wood_fence-0"
	base_icon_state = "wood_fence"
	max_integrity = 100
	materials = /datum/material/wood/treated

/obj/structure/fence/stone
	name = "stone fence"
	icon = 'dwarfs/icons/structures/stone_fence.dmi'
	icon_state = "stone_fence-0"
	base_icon_state = "stone_fence"
	max_integrity = 150
	materials = /datum/material/stone

/obj/structure/gate
	name = "fence gate"
	desc = "A way to move in and out of a fenced area."
	icon = 'dwarfs/icons/structures/gates.dmi'
	icon_state = "gate"
	pixel_w = -16
	pixel_z = -12
	anchored = TRUE
	smoothing_groups = list(SMOOTH_GROUP_FENCE)
	var/open = FALSE
	var/obj/lower_gate
	var/soundOpen
	var/soundClose

/obj/structure/gate/Initialize()
	. = ..()

	var/static/list/loc_connections = list(
		COMSIG_ATOM_EXIT = PROC_REF(on_exit),
	)

	AddElement(/datum/element/connect_loc, loc_connections)

	lower_gate = new/obj()
	lower_gate.vis_flags = VIS_INHERIT_DIR|VIS_INHERIT_ICON|VIS_INHERIT_PLANE|VIS_INHERIT_ID
	lower_gate.layer = ABOVE_MOB_LAYER
	lower_gate.icon_state = "[src::icon_state]_l_open"

/obj/structure/gate/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER

	if(open)
		if((dir & (EAST|WEST)) && (direction & (NORTH|SOUTH)))
			return COMPONENT_ATOM_BLOCK_EXIT
		leaving.Bump(src)
		return

	if(direction & NORTH)
		return COMPONENT_ATOM_BLOCK_EXIT

	leaving.Bump(src)

/obj/structure/gate/CanPass(atom/movable/mover, border_dir)
	. = ..()
	if(!.)
		return .

	if((dir & (EAST|WEST)) && (border_dir & (NORTH|SOUTH)))
		return FALSE

	if(open)
		return TRUE

	var/direction = get_dir(mover, src)
	if((dir & (EAST|WEST)) && (direction & (EAST|WEST)))
		return FALSE
	else if((dir & (NORTH|SOUTH)) && (direction & SOUTH))
		return FALSE

	return TRUE


/// Returns TRUE if successfull. FALSE otherwise
/obj/structure/gate/proc/toggle_open()
	// block closing for west/east facing gates
	if(open && (dir & (WEST|EAST)) && is_blocked_turf(get_turf(src), FALSE))
		return FALSE
	open = !open
	icon_state = "[src::icon_state][open ? "_open" : ""]"
	playsound(src, open ? soundOpen : soundClose, 60, TRUE)
	if(open)
		vis_contents += lower_gate
	else
		vis_contents -= lower_gate
	return TRUE

/obj/structure/gate/attack_hand(mob/user)
	. = ..()
	if(!toggle_open())
		to_chat(user, span_warning("Cannot [open ? "close" : "open"] \the [src]."))
		return
	to_chat(user, span_notice("You [open ? "open" : "close"] \the [src]."))

/obj/structure/gate/wooden
	name = "wooden fence gate"
	icon_state = "wooden_gate"
	materials = /datum/material/wood/treated
	soundOpen = 'dwarfs/sounds/structures/gates/wooden_open.ogg'
	soundClose = 'dwarfs/sounds/structures/gates/wooden_close.ogg'

/obj/structure/gate/wooden/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/structure/gate/stone
	name = "stone fence gate"
	icon_state = "stone_gate"
	materials = list(PART_STONE=/datum/material/stone, PART_INGOT=/datum/material/iron)
	soundOpen = 'dwarfs/sounds/structures/gates/metal_open.ogg'
	soundClose = 'dwarfs/sounds/structures/gates/metal_close.ogg'

/obj/structure/gate/stone/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_STONE], materials[PART_INGOT]))
