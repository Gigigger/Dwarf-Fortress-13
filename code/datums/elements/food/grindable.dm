/datum/element/grindable
	///What we get after grinding something in a quern
	var/datum/reagent/grindable_liquid_type
	///How much of this liquid do we get?
	var/liquid_amount
	///If we convert grains to flour
	var/liquid_ratio = 1
	///How much of the resulting item we get
	var/item_amount = 1
	///What type of item we get
	var/item_type

/datum/element/grindable/Attach(datum/target, grindable_liquid_type=null, liquid_amount=10, liquid_ratio=1, item_type=null, item_amount=1)
	. = ..()
	if(!grindable_liquid_type && !item_type)
		stack_trace("Grindable element added without any resulting reagent or item.")
		return COMPONENT_INCOMPATIBLE

	src.grindable_liquid_type = grindable_liquid_type
	src.liquid_amount = liquid_amount
	src.liquid_ratio = liquid_ratio
	src.item_type = item_type
	src.item_amount = item_amount

	RegisterSignal(target, COMSIG_ITEM_GRINDED, PROC_REF(grind_item))
	RegisterSignal(target, COMSIG_REAGENT_GRINDED, PROC_REF(grind_reagent))
	RegisterSignal(target, COMSIG_CAN_GRIND, PROC_REF(can_grind))

/datum/element/grindable/Detach(datum/source, ...)
	. = ..()
	UnregisterSignal(source, list(COMSIG_ITEM_GRINDED, COMSIG_REAGENT_GRINDED, COMSIG_CAN_GRIND))

/datum/element/grindable/proc/grind_item(obj/item/growable/target, obj/structure/quern/Q)
	SIGNAL_HANDLER
	if(grindable_liquid_type)
		Q.reagents.add_reagent(grindable_liquid_type, liquid_amount)
	if(item_type)
		for(var/i in 1 to item_amount)
			new item_type(get_turf(Q))
	qdel(target)

/datum/element/grindable/proc/grind_reagent(datum/reagent/target, obj/structure/quern/Q)
	SIGNAL_HANDLER
	var/vol = liquid_amount
	if(target.volume < liquid_amount)
		vol = target.volume
	Q.reagents.remove_reagent(target.type, vol)
	if(grindable_liquid_type)
		Q.reagents.add_reagent(grindable_liquid_type, vol*liquid_ratio)
	if(item_type)
		for(var/i in 1 to item_amount)
			new item_type(get_turf(Q))

/datum/element/grindable/proc/can_grind(datum/target)
	SIGNAL_HANDLER
	return TRUE
