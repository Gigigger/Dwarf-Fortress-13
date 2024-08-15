/obj/structure/mineral_door/material
	name = "door"
	icon_state = "material"
	materials = list(PART_STONE=/datum/material/stone, PART_INGOT=/datum/material/iron)

/obj/structure/mineral_door/material/build_material_icon(_file, state)
	if(PART_STONE in materials)
		return apply_palettes(..(), list(materials[PART_STONE], materials[PART_INGOT]))
	else
		return apply_palettes(..(), list(materials[PART_PLANKS], materials[PART_INGOT]))

/obj/structure/mineral_door/material/apply_material(list/_materials)
	. = ..()
	if(PART_STONE in materials)
		openSound = src::openSound
		closeSound = src::closeSound
	else
		openSound = 'dwarfs/sounds/structures/doors/wooden_open.ogg'
		closeSound = 'dwarfs/sounds/structures/doors/wooden_close.ogg'

/obj/structure/mineral_door/placeholder
	name = "door"
	desc = "Different door Depending on materials."
	icon_state = "placeholder"
