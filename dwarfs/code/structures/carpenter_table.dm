/obj/structure/crafter/carpenter_table
	name = "carpenter's table"
	desc = "A place to make all your wooden wonders."
	icon = 'dwarfs/icons/structures/64x32.dmi'
	icon_state = "carpenter_table"
	bound_width = 64
	density = TRUE
	anchored = TRUE
	materials = list(PART_PLANKS=/datum/material/wood/pine/treated, PART_INGOT=/datum/material/iron)
	used_recipe_type = /datum/crafter_recipe/carpenter_recipe
	craft_sound = 'dwarfs/sounds/structures/crafters/carpenter.ogg'

/obj/structure/crafter/carpenter_table/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_PLANKS], materials[PART_INGOT]))

/obj/structure/crafter/carpenter_table/update_overlays()
	. = ..()
	for(var/i in 1 to contents.len)
		var/obj/O = contents[i]
		var/mutable_appearance/item = new(O)
		item.pixel_y = -16 + 20
		item.pixel_x = -16 + 22 + (i-1) * 8
		item.transform *= 0.7
		. += item
