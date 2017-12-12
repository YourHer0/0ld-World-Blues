/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/items.dmi'
	amount = 10
	max_amount = 10
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_range = 20
	var/heal_brute = 0
	var/heal_burn = 0

/obj/item/stack/medical/do_surgery(var/mob/living/carbon/human/target, var/mob/user)
	if(istype(target) && istype(user))
		var/obj/item/organ/external/E = target.get_organ(user.zone_sel.selecting)
		if(!E.open)
			return 0
	return ..()

/obj/item/stack/medical/attack(mob/living/carbon/M, mob/user)
	if (!istype(M))
		user << "<span class='warning'>\The [src] cannot be applied to [M]!</span>"
		return 1

	if(!user.IsAdvancedToolUser())
		user << "<span class='warning'>You don't have the dexterity to do this!</span>"
		return 1

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(!affecting)
			user << "<span class='warning'>[M] miss that body part!</span>"
			return 1

		if(affecting.organ_tag == BP_HEAD)
			if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
				user << "<span class='warning'>You can't apply [src] through [H.head]!</span>"
				return 1
		else
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
				user << "<span class='warning'>You can't apply [src] through [H.wear_suit]!</span>"
				return 1

		if(affecting.robotic >= ORGAN_ROBOT)
			user << "<span class='warning'>This isn't useful at all on a robotic limb.</span>"
			return 1

		H.UpdateDamageIcon()

	else
		M.heal_organ_damage((src.heal_brute/2), (src.heal_burn/2))
		user.visible_message(
			SPAN_NOTE("[M] has been applied with [src] by [user]."),
			SPAN_NOTE("You apply \the [src] to [M].")
		)
		use(1)
		M.updatehealth()
		return 1

/obj/item/stack/medical/bruise_pack
	name = "roll of gauze"
	singular_name = "gauze length"
	desc = "Some sterile gauze to wrap around bloody stumps."
	icon_state = "brutepack"
	origin_tech = list(TECH_BIO = 1)
	var/clean = 0

/obj/item/stack/medical/bruise_pack/advanced
	name = "advanced trauma kit"
	singular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"
	heal_brute = 12
	clean = 1

/obj/item/stack/medical/bruise_pack/attack(mob/living/carbon/human/H, mob/user)
	if(..())
		return 1

	var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

	if(affecting.open)
		user << SPAN_NOTE("The [affecting.name] is cut open, you'll need more than a bandage!")
		return 1

	if(affecting.is_bandaged() && (!clean || affecting.is_disinfected()))
		user << "<span class='warning'>The wounds on [H]'s [affecting.name] have already been treated.</span>"
		return 1
	else
		user.visible_message(
			SPAN_NOTE("\The [user] starts treating [H]'s [affecting.name]."),
			SPAN_NOTE("You start treating [H]'s [affecting.name].")
		)
		var/used = 0
		for (var/datum/wound/W in affecting.wounds)
			if (W.internal)
				continue
			if (W.bandaged && (!clean || W.disinfected))
				continue
			if(used == amount)
				break
			if(!do_mob(user, H, W.damage/5))
				user << SPAN_NOTE("You must stand still to bandage wounds.")
				break
			if (W.current_stage <= W.max_bleeding_stage)
				if(clean)
					user.visible_message(
						SPAN_NOTE("\The [user] cleans \a [W.desc] on [H]'s [affecting.name] and seals the edges with bioglue."),
						SPAN_NOTE("You clean and seal \a [W.desc] on [H]'s [affecting.name].")
					)
				else
					user.visible_message(
						SPAN_NOTE("\The [user] bandages \a [W.desc] on [H]'s [affecting.name]."),
						SPAN_NOTE("You bandage \a [W.desc] on [H]'s [affecting.name].")
					)
			else if (W.damage_type == BRUISE)
				user.visible_message(
					SPAN_NOTE("\The [user] places a medical patch over \a [W.desc] on [H]'s [affecting.name]."),
					SPAN_NOTE("You place a medical patch over \a [W.desc] on [H]'s [affecting.name].")
				)
			else
				user.visible_message(
					SPAN_NOTE("\The [user] places [singular_name] over \a [W.desc] on [H]'s [affecting.name]."),
					SPAN_NOTE("You place [singular_name] over \a [W.desc] on [H]'s [affecting.name].")
				)
			W.bandage()
			if(clean) W.disinfect()
			W.heal_damage(heal_brute)
			used++
		affecting.update_damages()
		if(used == amount)
			if(affecting.is_bandaged())
				user << "<span class='warning'>\The [src] is used up.</span>"
			else
				user << "<span class='warning'>\The [src] is used up, but there are more wounds to treat on \the [affecting.name].</span>"
		use(used)

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat those nasty burns."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 1
	origin_tech = list(TECH_BIO = 1)

/obj/item/stack/medical/ointment/advanced
	name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	singular_name = "advanced burn kit"
	icon_state = "burnkit"
	heal_burn = 12

/obj/item/stack/medical/ointment/attack(mob/living/carbon/human/H, mob/user)
	if(..())
		return 1

	var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

	if(affecting.open)
		user << SPAN_NOTE("The [affecting.name] is cut open, you'll need more than a bandage!")
		return 1

	if(affecting.is_salved())
		user << "<span class='warning'>The wounds on [H]'s [affecting.name] have already been salved.</span>"
		return 1
	else
		user.visible_message(
			SPAN_NOTE("\The [user] starts salving wounds on [H]'s [affecting.name]."),
			SPAN_NOTE("You start salving the wounds on [H]'s [affecting.name].")
		)
		if(!do_mob(user, H, 10))
			user << SPAN_NOTE("You must stand still to salve wounds.")
			return 1
		user.visible_message(
			SPAN_NOTE("[user] salved wounds on [H]'s [affecting.name] with [src]."),
			SPAN_NOTE("You salved wounds on [H]'s [affecting.name] with [src].")
		)
		affecting.heal_damage(0,heal_burn)
		use(1)
		affecting.salve()

/obj/item/stack/medical/splint
	name = "medical splints"
	singular_name = "medical splint"
	desc = "Modular splints capable of supporting and immobilizing bones in both limbs and appendages."
	icon_state = "splint"
	amount = 5
	max_amount = 5

/obj/item/stack/medical/splint/attack(mob/living/carbon/human/H, mob/user)
	if(..())
		return 1

	var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

	var/limb = affecting.name
	if(!(affecting.organ_tag in list(BP_L_ARM,BP_R_ARM,BP_L_LEG,BP_R_LEG)))
		user << SPAN_DANG("You can't apply a splint there!")
		return

	if(affecting.status & ORGAN_SPLINTED)
		user << SPAN_DANG("[H]'s [limb] is already splinted!")
		return
	if (H != user)
		user.visible_message(
			SPAN_DANG("[user] starts to apply \the [src] to [H]'s [limb]."),
			SPAN_DANG("You start to apply \the [src] to [H]'s [limb]."),
			SPAN_DANG("You hear something being wrapped.")
		)
	else
		if((!user.hand && affecting.organ_tag == BP_R_ARM) || (user.hand && affecting.organ_tag == BP_L_ARM))
			user << SPAN_DANG("You can't apply a splint to the arm you're using!")
			return
		user.visible_message(
			SPAN_DANG("[user] starts to apply \the [src] to their [limb]."),
			SPAN_DANG("You start to apply \the [src] to your [limb]."),
			SPAN_DANG("You hear something being wrapped.")
		)
	if(do_mob(user, H, 50))
		if (H != user)
			user.visible_message(
				SPAN_DANG("[user] finishes applying \the [src] to [H]'s [limb]."),
				SPAN_DANG("You finish applying \the [src] to [H]'s [limb]."),
				SPAN_DANG("You hear something being wrapped.")
			)
		else
			if(prob(25))
				user.visible_message(
					SPAN_DANG("[user] successfully applies \the [src] to their [limb]."),
					SPAN_DANG("You successfully apply \the [src] to your [limb]."),
					SPAN_DANG("You hear something being wrapped.")
				)
			else
				user.visible_message(
					SPAN_DANG("[user] fumbles \the [src]."),
					SPAN_DANG("You fumble \the [src]."),
					SPAN_DANG("You hear something being wrapped.")
				)
				return
		affecting.status |= ORGAN_SPLINTED
		use(1)
	return
