SUBSYSTEM_DEF(loadouts)
	name = "Lobby Loadouts"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_LOADOUTS

	/// Tracks how much of each loadout type is selected
	var/list/loadout_counter = list()
	/// Stores loadout types and their corresponding display names
	var/list/loadout_names = list()
	/// Currently used maptext info
	var/used_maptext = ""


/datum/controller/subsystem/loadouts/Initialize(start_timeofday)
	// init our lists
	var/list/choices = GLOB.crafting_loadout_choices + GLOB.combat_loadout_choices
	for(var/loadout_name in choices)
		var/loadout_type = choices[loadout_name]
		loadout_names[loadout_type] = loadout_name
		loadout_counter[loadout_type] = 0

	// count existing clients
	for(var/mob/M in GLOB.new_player_list)
		loadout_counter[M.client.prefs.loadout]++

	update_maptext_string()

	update_panel(TRUE)

	. = ..()

/datum/controller/subsystem/loadouts/proc/update_panel(forced=FALSE)
	if(!initialized && !forced)
		return

	update_maptext_string()
	for(var/mob/M in GLOB.new_player_list)
		update_new_player(M)

/datum/controller/subsystem/loadouts/proc/update_client(client/C)
	if(!isnewplayer(C.mob))
		return
	update_new_player(C.mob)

/datum/controller/subsystem/loadouts/proc/update_new_player(mob/dead/new_player/user)
	var/datum/hud/new_player/hud = user.hud_used
	hud.set_loadout_info(used_maptext)

/datum/controller/subsystem/loadouts/proc/update_counter(old_loadout, new_loadout)
	if(!initialized)
		return

	var/needs_update = FALSE

	if(old_loadout)
		loadout_counter[old_loadout]--
		needs_update = TRUE
	if(new_loadout)
		loadout_counter[new_loadout]++
		needs_update = TRUE

	if(needs_update)
		update_maptext_string()

/datum/controller/subsystem/loadouts/proc/update_maptext_string()
	. = "<font face=lilgard size=3><span style='line-height:1.8; color:#bc8435'>"
	for(var/loadout_type in loadout_counter)
		var/count = loadout_counter[loadout_type]
		var/name = loadout_names[loadout_type]
		. += "[count] [name][count != 1 ? "s" : ""]\n"
	. += "</span></font>"

	used_maptext = .
