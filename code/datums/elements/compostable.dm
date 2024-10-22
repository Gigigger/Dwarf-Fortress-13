/datum/element/compostable
	/// How much compostable boimass we have
	var/biomass = 1

/datum/element/compostable/Attach(datum/target, biomass)
	. = ..()
	if(!isobj(target) && !isliving(target))
		return ELEMENT_INCOMPATIBLE
	src.biomass = biomass

	RegisterSignal(target, COMSIG_ATOM_COMPOSTED, PROC_REF(on_composted))
	ADD_TRAIT(target, TRAIT_COMPOSTABLE, ELEMENT_TRAIT(type))

/datum/element/compostable/Detach(datum/source, ...)
	. = ..()
	UnregisterSignal(COMSIG_ATOM_COMPOSTED)
	REMOVE_TRAIT(source, TRAIT_COMPOSTABLE, ELEMENT_TRAIT(type))

/// Handles adding biomass to compost bin. All remaining checks are in composter code.
/datum/element/compostable/proc/on_composted(obj/source, obj/target, mob/user)
	SIGNAL_HANDLER
	if(!istype(target, /obj/structure/composter))
		CRASH("Called /datum/element/compostable/on_composted with non-composter target.")
	var/obj/structure/composter/S = target
	if(S.total_volume() + biomass > S.max_volume)
		to_chat(user, span_warning("\The [S] doesn't have enough space for [source]."))
		return COMPONENT_BLOCK_COMPOSTING
	S.biomass += biomass
	qdel(source)
