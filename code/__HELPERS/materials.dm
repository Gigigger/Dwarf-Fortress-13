/// Returns human-readable part name based on part id
/proc/get_part_name(part)
	switch(part)
		if(PART_ANY)
			return "anything"
		if(PART_HANDLE)
			return "handle"
		if(PART_HEAD)
			return "tool head"
		if(PART_INGOT)
			return "ingot"
		if(PART_PLANKS)
			return "any planks"
		if(PART_STONE)
			return "any stone"
		else
			return "unidentified part"

/**
 * Returns resource type or null for this material type.
 *
 * Arguments:
 * - material: Material type.
 * - refined: Whether we want a refined or raw resource type. E.g. ingot or ore.
 */
/proc/material2resource(material, refined=TRUE)
	if(!ispath(material, /datum/material))
		CRASH("Bad material argument in material2resource.")
	var/datum/material/M = get_material(material)
	return refined ? M.resource_refined : M.resource

/// Returns obj path that is default for the provided part id
/proc/get_default_part(part)
	switch(part)
		if(PART_HANDLE)
			return /obj/item/stick
		if(PART_HEAD)
			return /obj/item/partial/axe
		if(PART_INGOT)
			return /obj/item/ingot
		if(PART_PLANKS)
			return /obj/item/stack/sheet/planks
		if(PART_STONE)
			return /obj/item/stack/sheet/stone
		else
			return /obj/item/stack/sheet/stone

/proc/get_part_from_path(path)
	switch(path)
		if(/obj/item/stick, /obj/item/weapon_hilt)
			return PART_HANDLE
		if(/obj/item/ingot)
			return PART_INGOT
		if(/obj/item/stack/sheet/planks)
			return PART_PLANKS
		else
			if(ispath(path, /obj/item/partial))
				return PART_HEAD
	return PART_ANY

/// Get uniqie material types from material list. Can handle anything from single material objects to multi-part objects.
/proc/materials2mats(list/materials)
	. = list()
	//convert single material objects into list so we don't have to handle them separately
	if(!islist(materials))
		materials = list(materials)
	for(var/possible_material_type in materials)
		// multi-part object
		if(istext(possible_material_type))
			possible_material_type = materials[possible_material_type]
		var/datum/material/material = get_material(possible_material_type)
		//sanity check
		if(!material)
			continue
		if(material.mat)//if material has material type assigned, add it to the list
			.[material.mat] = material.type

/// Convert material types into corresponding debree image.
/proc/mats2debris(list/mats)
	var/image/debris = image('dwarfs/icons/technical.dmi', null, "transparent")
	if(MATERIAL_METAL in mats)
		debris.overlays += apply_palettes(icon('dwarfs/icons/structures/debris.dmi', "metal"), mats[MATERIAL_METAL])
	if(MATERIAL_STONE in mats)
		debris.overlays += apply_palettes(icon('dwarfs/icons/structures/debris.dmi', "stone"), mats[MATERIAL_STONE])
	if(MATERIAL_WOOD in mats)
		debris.overlays += apply_palettes(icon('dwarfs/icons/structures/debris.dmi', "wood"), mats[MATERIAL_WOOD])
	return debris

/// Returns a material datum based on provided type
/proc/get_material(type)
	if(islist(type))
		return
	return SSmaterials.materials[type]

/// Returns material name string based on provided type
/proc/get_material_name(type)
	var/datum/material/M = get_material(type)
	if(!M)
		return "unknown material"
	return M.name

/// Return material hex color based on provided type
/proc/get_material_color(type)
	var/datum/material/M = get_material(type)
	if(!M)
		return "#FFF"
	return M.color

/**
 * Creates an icon object with materials appplied to it.
 *
 * Arguments:
 * - type: Atom type this icon belongs to
 * - _file: Icon path to the icon
 * - state: Icon state that should be used
 * - materials: List of material datums that should be applied to the icon. Warning, order of the materials matters!
 */
/proc/create_material_icon(type, _file, state, list/materials)
	var/icon_key = MATERIAL_ICON_KEY
	if(SSmaterials.material_icons[icon_key])
		return SSmaterials.material_icons[icon_key]
	var/icon/I = apply_palettes(icon(_file, state), materials)
	SSmaterials.material_icons[icon_key] = I
	return I

/**
 * Applies materials with given palettes to an icon and returns said icon.
 *
 * Argumens:
 * - I: The icon we are working with.
 * - materials: list of material types. Place the types in the correct oder according to what templates will be used.
 */
/proc/apply_palettes(icon/I, list/materials)
	if(!I)
		CRASH("Called apply_palettes with a null icon.")
	if(!materials)
		return I
	if(!islist(materials))
		materials = list(materials)
	for(var/i in 1 to materials.len)
		var/mat_type = materials[i]
		if(istext(mat_type))
			mat_type = materials[mat_type]
		var/datum/material/M = SSmaterials.materials[mat_type]
		if(!M)
			continue
		I = M.apply2icon_default(I, i-1)
	return I
