#define TOOLSPEED_MIN_REL_VALUE 0.3
#define MELEE_CD_MIN_REL_VALUE 0.2
#define SLOWDOWN_MIN_REL_VALUE 0.2
#define SLOWDOWN_MIN_VALUE 0

/datum/material
	/// Material name. Displayed in examine etc.
	var/name = "material"
	/// Palettes used. Used as icon_states for it's palette at 'dwarfs/icons/palettes.dmi'. Depending on amount of materials will use template palettes in increasing order.
	var/list/palettes = list("template1")
	/// What material type this is
	var/mat
	/// What default raw resource type does this material have
	var/resource
	/// What default refined resource type does this material have
	var/resource_refined
	/// What floor is made out of this material
	var/floor_type
	/// What wall is made out of this material
	var/wall_type
	/// What door is made out of this material
	var/door_type
	/// Force multipliers. Refular force mod represents material "hardness" and how well it does as a blade etc. force_mod_blunt is multiplied on top if the weapon is blunt type to simulate material mass
	/// Force multiplier
	var/force_mod = 1
	/// Force multiplier if weapon is blunt type
	var/force_mod_blunt = 1
	/// Tool speed multiplier
	var/toolspeed_mod = 1
	var/toolspeed_mod_handle = 1
	/// Health multiplier for structures
	var/integrity_mod = 1
	var/integrity_mod_handle = 1
	/// Click cd cooldown multiplier
	var/melee_cd_mod = 1
	var/melee_cd_mod_handle = 1
	/// Slowdown modifier (additive). Remember that negative values speed up
	var/slowdown_mod = 0
	var/slowdown_mod_handle = 0
	/// Mining speed and efficiecy
	var/hardness = 1

	// Armor multipliers
	var/armor_sharp_mod = 1
	var/armor_pierce_mod = 1
	var/armor_blunt_mod = 1
	var/armor_fire_mod = 1
	var/armor_acid_mod = 1
	var/armor_magic_mod = 1
	var/armor_wound_mod = 1
	// Armor penetration multipliers
	var/armorpen_sharp_mod = 1
	var/armorpen_pierce_mod = 1
	var/armorpen_blunt_mod = 1
	var/armorpen_fire_mod = 1
	var/armorpen_acid_mod = 1
	var/armorpen_magic_mod = 1

/**
 * Applies stat modifiers a given material has to an obj
 *
 * Argumens:
 * - O: The obj we are applying this material to.
 */
/datum/material/proc/apply_stats(atom/A, part_name=null)
	var/obj/O = isobj(A) ? A : null
	var/obj/item/I = isitem(A) ? A : null
	switch(part_name)
		if(PART_HANDLE)
			if(O)
				O.obj_integrity *= integrity_mod_handle
				O.max_integrity *= integrity_mod_handle
			if(I)
				I.toolspeed = max(I.toolspeed * toolspeed_mod_handle, initial(I.toolspeed) - TOOLSPEED_MIN_REL_VALUE)
				I.melee_cd = max(I.melee_cd * melee_cd_mod_handle, initial(I.melee_cd) - MELEE_CD_MIN_REL_VALUE)
				I.slowdown = max(max(I.slowdown+slowdown_mod_handle, initial(I.slowdown)-SLOWDOWN_MIN_REL_VALUE), min(initial(I.slowdown), SLOWDOWN_MIN_VALUE))
		if(PART_HEAD)
			if(O)
				O.force *= force_mod
				if(O.atck_type == BLUNT)
					O.force *= force_mod_blunt
				O.obj_integrity *= integrity_mod
				O.max_integrity *= integrity_mod
				O.hardness = hardness
			if(I)
				if(I.armor_penetration)
					I.armor_penetration.modify_rating(SHARP, armorpen_sharp_mod)
					I.armor_penetration.modify_rating(PIERCE, armorpen_pierce_mod)
					I.armor_penetration.modify_rating(BLUNT, armorpen_blunt_mod)
					I.armor_penetration.modify_rating(FIRE, armorpen_fire_mod)
					I.armor_penetration.modify_rating(ACID, armorpen_acid_mod)
					I.armor_penetration.modify_rating(MAGIC, armorpen_magic_mod)
				I.toolspeed = max(I.toolspeed * toolspeed_mod, initial(I.toolspeed) - TOOLSPEED_MIN_REL_VALUE)
				I.melee_cd = max(I.melee_cd * melee_cd_mod, initial(I.melee_cd) - MELEE_CD_MIN_REL_VALUE)
				I.slowdown = max(max(I.slowdown+slowdown_mod, initial(I.slowdown)-SLOWDOWN_MIN_REL_VALUE), min(initial(I.slowdown), SLOWDOWN_MIN_VALUE))
		else
			if(O)
				O.force *= force_mod
				if(O.atck_type == BLUNT)
					O.force *= force_mod_blunt
				O.obj_integrity *= integrity_mod
				O.max_integrity *= integrity_mod
				O.hardness = max(O.hardness, hardness)
				if(O.armor)
					O.armor = O.armor.modify_rating(armor_sharp_mod, armor_pierce_mod, armor_blunt_mod, armor_fire_mod, armor_acid_mod, armor_magic_mod, armor_wound_mod)
			if(I)
				I.toolspeed = max(I.toolspeed * toolspeed_mod, initial(I.toolspeed) - TOOLSPEED_MIN_REL_VALUE)
				I.melee_cd = max(I.melee_cd * melee_cd_mod, initial(I.melee_cd) - MELEE_CD_MIN_REL_VALUE)
				I.slowdown = max(max(I.slowdown+slowdown_mod, initial(I.slowdown)-SLOWDOWN_MIN_REL_VALUE), min(initial(I.slowdown), SLOWDOWN_MIN_VALUE))
				if(I.armor_penetration)
					I.armor_penetration.modify_rating(SHARP, armorpen_sharp_mod)
					I.armor_penetration.modify_rating(PIERCE, armorpen_pierce_mod)
					I.armor_penetration.modify_rating(BLUNT, armorpen_blunt_mod)
					I.armor_penetration.modify_rating(FIRE, armorpen_fire_mod)
					I.armor_penetration.modify_rating(ACID, armorpen_acid_mod)
					I.armor_penetration.modify_rating(MAGIC, armorpen_magic_mod)

/datum/material/proc/apply2icon_default(icon/I, _i=0)
	for(var/i in 1 to palettes.len)
		I = apply_palette(I, "template[i+_i]", palettes[i])
	return I

/**
 * Applies palette to given template for an icon
 *
 * Argumens:
 * - I: The icon we are working with.
 * - template_name: icon_state of the template we are replacing.
 * - palette_name: icon_state of the material we want to apply. This defaults to the first element of this material.
 */
/datum/material/proc/apply_palette(icon/I, template_name, palette_name=null)
	palette_name = palette_name ? palette_name : palettes[1]
	. = I
	var/icon/template_palette = SSmaterials.palettes[template_name]
	var/icon/material_palette = SSmaterials.palettes[palette_name]

	for(var/x in 1 to 9)
		var/color_old = template_palette.GetPixel(x, 1)
		var/color_new = material_palette.GetPixel(x, 1)
		I.SwapColor(color_old, color_new)

#undef TOOLSPEED_MIN_REL_VALUE
#undef MELEE_CD_MIN_REL_VALUE
#undef SLOWDOWN_MIN_REL_VALUE
#undef SLOWDOWN_MIN_VALUE
