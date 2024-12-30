/datum/skill/cooking
	name = "Cooking"
	title = "Chef"
	desc = "The art of cooking dishes."
	modifiers = list(
		SKILL_SPEED_MODIFIER=list(3,2.5,2,1.5,1.2,1,1,0.9,0.8,0.7,0.6),//How fast are we doing cooking related stuff
		SKILL_AMOUNT_MIN_MODIFIER=list(-1,0,0,0,1,1,1,1,2,2,3),//+This to the base min amount
		SKILL_AMOUNT_MAX_MODIFIER=list(-1,0,0,0,1,1,1,1,2,2,3),//+This to the base max amount
		SKILL_MISS_MODIFIER=list(30, 26, 24, 22, 20, 18, 16, 14, 10, 5, 0),
		SKILL_PARRY_MODIFIER=list(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		SKILL_DAMAGE_MODIFIER=list(0, 0, 1, 1, 2, 3, 4, 4, 5, 6, 7)
	)
	exp_per_attack = 1

/datum/skill/cooking/level_gained(mob/user, new_level, old_level, silent)
	. = ..()
	if(!silent)
		to_chat(user, span_green("Through better understanding of [name] I realise how to cook new recipes!"))
