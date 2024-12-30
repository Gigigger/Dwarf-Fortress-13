/datum/skill/logging
	name = "Logging"
	desc = "Chop down trees."
	title = "Lumberjack"
	modifiers = list(
		SKILL_SPEED_MODIFIER=list(3,2.5,2,1.7,1.4,1.2,1.1,1,0.9,0.7,0.6),
		SKILL_MISS_MODIFIER=list(30, 26, 24, 22, 20, 18, 16, 14, 10, 5, 0),
		SKILL_PARRY_MODIFIER=list(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		SKILL_DAMAGE_MODIFIER=list(0, 0, 1, 1, 2, 3, 4, 4, 5, 6, 7)
		)
	exp_per_attack = 1
