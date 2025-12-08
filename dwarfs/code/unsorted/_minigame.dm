/datum/minigame
	var/obj/structure/crafter/crafter
	var/datum/crafter_recipe/recipe
	var/mob/user
	var/datum/weakref/last_user
	var/atom/user_loc
	var/atom/crafter_loc
	var/is_finished = FALSE
	var/result
	var/is_resetting = FALSE
	var/atom/movable/screen/minigame/main_window

/datum/minigame/New(obj/crafter, datum/crafter_recipe/recipe)
	. = ..()
	src.crafter = crafter
	src.recipe = recipe
	main_window = new /atom/movable/screen/minigame(null, src)

/datum/minigame/Destroy(force, ...)
	. = ..()
	if(user)
		UnregisterSignal(user, COMSIG_PARENT_QDELETING)
	if(crafter)
		UnregisterSignal(crafter, COMSIG_PARENT_QDELETING)

	QDEL_NULL(main_window)
	close()
	last_user = null
	user = null
	crafter = null
	user_loc = null
	crafter_loc = null
	recipe = null

/datum/minigame/proc/start(mob/user)
	src.user = user
	user_loc = user.loc
	crafter_loc = crafter.loc
	RegisterSignal(user, COMSIG_PARENT_QDELETING, PROC_REF(on_user_delete))

	show()
	on_start()
	while(!is_finished)
		stoplag(1)
		if(check_interrupt())
			reset()
			return FALSE
	last_user = WEAKREF(user)
	close()
	return get_result()

/datum/minigame/proc/on_start()
	return

/datum/minigame/proc/show()
	if(!user.client)
		return
	user.client.screen += main_window

/datum/minigame/proc/close()
	user_loc = null
	crafter_loc = null
	if(!user || !user.client)
		return
	user.client.screen -= main_window

	UnregisterSignal(user, COMSIG_PARENT_QDELETING)
	user = null

/datum/minigame/proc/on_user_delete()
	SIGNAL_HANDLER
	is_resetting = TRUE

/datum/minigame/proc/on_crafter_delete()
	SIGNAL_HANDLER
	is_resetting = TRUE
	qdel(src)

/datum/minigame/proc/reset()
	close()
	result = null
	is_finished = FALSE
	is_resetting = FALSE
	last_user = null

/datum/minigame/proc/check_interrupt()
	if(is_resetting)
		return TRUE

	if(QDELETED(src))
		return TRUE

	if(
	QDELETED(user) \
	|| (user.loc != user_loc) \
	|| (HAS_TRAIT(user, TRAIT_INCAPACITATED)) \
	)
		return TRUE

	if(
	!QDELETED(crafter_loc) \
	&& (QDELETED(crafter) || crafter_loc != crafter.loc) \
	&& ((user_loc != crafter_loc || crafter_loc != user)) \
	)
		return TRUE
	return FALSE

/datum/minigame/proc/finish()
	is_finished = TRUE

/datum/minigame/proc/get_result()
	return result

/datum/minigame/proc/get_explanation()
	return

/atom/movable/screen/minigame
	name = "minigame"
	icon = 'dwarfs/icons/ui/minigame/bg.dmi'
	icon_state = "bg"
	screen_loc = "CENTER-2,CENTER-1"
	var/atom/movable/screen/exit_btn/exit_btn
	var/atom/movable/screen/help_btn/help_btn
	var/datum/minigame/minigame

/atom/movable/screen/minigame/Initialize(mapload, datum/minigame/minigame)
	. = ..()
	exit_btn = new(src)
	help_btn = new(src)
	vis_contents += exit_btn
	vis_contents += help_btn
	src.minigame = minigame

/atom/movable/screen/minigame/Destroy()
	. = ..()
	minigame = null
	vis_contents.Cut()
	QDEL_NULL(exit_btn)
	QDEL_NULL(help_btn)

/atom/movable/screen/help_btn
	icon = 'dwarfs/icons/ui/minigame/bg.dmi'
	icon_state = "?"
	name = "help"
	var/enabled = FALSE

/atom/movable/screen/help_btn/Click(location, control, params)
	. = ..()
	enabled = !enabled
	if(enabled)
		var/image/img = (vis_locs[1])?:minigame?:get_explanation()
		img.plane = HUD_PLANE + 1
		add_overlay(img)
	else
		cut_overlays()

/atom/movable/screen/exit_btn
	icon = 'dwarfs/icons/ui/minigame/bg.dmi'
	icon_state = "x"
	name = "close"

/atom/movable/screen/exit_btn/Click(location, control, params)
	. = ..()
	(vis_locs[1])?:minigame?:is_resetting = TRUE
