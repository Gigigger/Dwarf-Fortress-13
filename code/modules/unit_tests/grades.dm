/datum/unit_test/grades/Run()
	var/list/items_to_check = list(
		// tools
		/obj/item/pickaxe,
		/obj/item/axe,
		/obj/item/shovel,
		/obj/item/smithing_hammer,
		/obj/item/chisel,
		/obj/item/tongs,
		/obj/item/hoe,
		// weapons
		/obj/item/sword,
		/obj/item/dagger,
		/obj/item/battleaxe,
		/obj/item/zwei,
		/obj/item/flail,
		/obj/item/spear,
		/obj/item/warhammer,
		/obj/item/halberd,
		/obj/item/club,
		/obj/item/shield,
		// armor
		/obj/item/clothing/suit/light_plate,
		/obj/item/clothing/suit/heavy_plate,
		/obj/item/clothing/under/chainmail,
		/obj/item/clothing/head/heavy_plate,
		/obj/item/clothing/head/light_plate,
		/obj/item/clothing/gloves/plate_gloves,
		/obj/item/clothing/shoes/plate_boots,
		/obj/item/clothing/shoes/leather_boots,
		/obj/item/clothing/gloves/leather,
		/obj/item/clothing/suit/leather_vest,
		/obj/item/clothing/head/leather_helmet,
	)

	for(var/type in items_to_check)
		var/obj/item/item1 = allocate(type)
		var/obj/item/item2 = allocate(type)

		item1.grade_parts = shuffle(item1.grade_parts)
		item2.grade_parts = shuffle(item2.grade_parts)

		item1.update_stats()
		item2.update_stats()

		TEST_ASSERT_EQUAL(item1.force, item2.force, "[item1::name] force should be equal.")
		TEST_ASSERT_EQUAL(item1.melee_cd, item2.melee_cd, "[item1::name] melee_cd should be equal.")
		TEST_ASSERT_EQUAL(item1.toolspeed, item2.toolspeed, "[item1::name] toolspeed should be equal.")
		TEST_ASSERT_EQUAL(item1.slowdown, item2.slowdown, "[item1::name] slowdown should be equal.")
		TEST_ASSERT_EQUAL(item1.block_chance, item2.block_chance, "[item1::name] block_chance should be equal.")
		TEST_ASSERT_EQUAL(item1.hardness, item2.hardness, "[item1::name] hardness should be equal.")
		TEST_ASSERT_EQUAL(item1.armor_penetration.tag, item2.armor_penetration.tag, "[item1::name] armor penetration rating should be equal.")
		TEST_ASSERT_EQUAL(item1.armor.tag, item2.armor.tag, "[item1::name] armor rating should be equal.")

		TEST_ASSERT_EQUAL(item1.obj_integrity, item2.obj_integrity, "[item1::name] integrity should be equal.")
		TEST_ASSERT_EQUAL(item1.max_integrity, item2.max_integrity, "[item1::name] max_integrity should be equal.")
