/datum/skill/farming
	name = "Farming"
	title = "Farmer"
	desc = "Work with plants. Wild plants as well as domesticated ones at a farm plot."
	modifiers = list(
		SKILL_SPEED_MODIFIER=list(3,2.5,2,1.5,1.2,1,1,0.9,0.8,0.7,0.6),//How long something takes in seconds
		SKILL_AMOUNT_MIN_MODIFIER=list(-1,0,1,1,1,1,2,2,3,3,4),//+This to the base min amount
		SKILL_AMOUNT_MAX_MODIFIER=list(-1,0,0,0,1,1,2,2,3,4,5),//+This to the base max amount
		SKILL_MISS_MODIFIER=list(30, 26, 24, 22, 20, 18, 16, 14, 10, 5, 0),
		SKILL_PARRY_MODIFIER=list(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		SKILL_DAMAGE_MODIFIER=list(0, 0, 1, 1, 2, 3, 4, 4, 5, 6, 7)
		)
	exp_per_attack = 1
