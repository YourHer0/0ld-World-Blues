
/obj/item/weapon/grab/proc/inspect_organ(mob/living/carbon/human/H, mob/user, var/target_zone)

	var/obj/item/organ/external/E = H.get_organ(target_zone)

	if(!E || E.is_stump())
		user << SPAN_NOTE("[H] is missing that bodypart.")
		return

	user.visible_message(SPAN_NOTE("[user] starts inspecting [affecting]'s [E.name] carefully."))
	if(!do_mob(user,H, 10))
		user << SPAN_NOTE("You must stand still to inspect [E] for wounds.")
	else if(E.wounds.len)
		user << "<span class='warning'>You find [E.get_wounds_desc()]</span>"
	else
		user << SPAN_NOTE("You find no visible wounds.")

	user << SPAN_NOTE("Checking bones now...")
	if(!do_mob(user, H, 20))
		user << SPAN_NOTE("You must stand still to feel [E] for fractures.")
	else if(E.status & ORGAN_BROKEN)
		user << "<span class='warning'>The [E.encased ? E.encased : "bone in the [E.name]"] moves slightly when you poke it!</span>"
		H.custom_pain("Your [E.name] hurts where it's poked.")
	else
		user << SPAN_NOTE("The [E.encased ? E.encased : "bones in the [E.name]"] seem to be fine.")

	user << SPAN_NOTE("Checking skin now...")
	if(!do_mob(user, H, 10))
		user << SPAN_NOTE("You must stand still to check [H]'s skin for abnormalities.")
	else
		var/bad = 0
		if(H.getToxLoss() >= 40)
			user << "<span class='warning'>[H] has an unhealthy skin discoloration.</span>"
			bad = 1
		if(H.getOxyLoss() >= 20)
			user << "<span class='warning'>[H]'s skin is unusaly pale.</span>"
			bad = 1
		if(E.status & ORGAN_DEAD)
			user << "<span class='warning'>[E] is decaying!</span>"
			bad = 1
		if(!bad)
			user << SPAN_NOTE("[H]'s skin is normal.")

/obj/item/weapon/grab/proc/jointlock(mob/living/carbon/human/target, mob/attacker, var/target_zone)
	if(state < GRAB_AGGRESSIVE)
		attacker << "<span class='warning'>You require a better grab to do this.</span>"
		return

	var/obj/item/organ/external/organ = target.get_organ(check_zone(target_zone))
	if(!organ || organ.dislocated == -1)
		return

	attacker.visible_message(SPAN_DANG("[attacker] [pick("bent", "twisted")] [target]'s [organ.name] into a jointlock!"))
	var/armor = target.run_armor_check(target, "melee")
	if(armor < 2)
		target << SPAN_DANG("You feel extreme pain!")
		affecting.adjustHalLoss(Clamp(0, 60-affecting.halloss, 30)) //up to 60 halloss

/obj/item/weapon/grab/proc/attack_eye(mob/living/carbon/human/target, mob/living/carbon/human/attacker)
	if(!istype(attacker))
		return

	var/datum/unarmed_attack/attack = attacker.get_unarmed_attack(target, O_EYES)

	if(!attack)
		return
	if(state < GRAB_NECK)
		attacker << "<span class='warning'>You require a better grab to do this.</span>"
		return
	for(var/obj/item/protection in list(target.head, target.wear_mask, target.glasses))
		if(protection && (protection.body_parts_covered & EYES))
			attacker << SPAN_DANG("You're going to need to remove the eye covering first.")
			return
	if(!target.has_eyes())
		attacker << SPAN_DANG("You cannot locate any eyes on [target]!")
		return

	admin_attack_log(attacker, target,
		"Attacked [key_name(target)]'s eyes using grab",
		"Had eyes attacked by [key_name(attacker)]'s grab",
		"attacked [key_name(target)]'s eyes using a grab action."
	)

	attack.handle_eye_attack(attacker, target)

/obj/item/weapon/grab/proc/headbut(mob/living/carbon/human/target, mob/living/carbon/human/attacker)
	if(!istype(attacker))
		return
	if(target.lying)
		return
	attacker.visible_message(SPAN_DANG("[attacker] thrusts \his head into [target]'s skull!"))

	var/damage = 20
	var/obj/item/clothing/hat = attacker.head
	if(istype(hat))
		damage += hat.force * 10

	var/armor = target.run_armor_check(BP_HEAD, "melee")
	target.apply_damage(damage*rand(90, 110)/100, BRUTE, BP_HEAD, armor)
	attacker.apply_damage(10*rand(90, 110)/100, BRUTE, BP_HEAD, attacker.run_armor_check(BP_HEAD, "melee"))

	if(!armor && prob(damage))
		target.apply_effect(20, PARALYZE)
		target.visible_message(SPAN_DANG("[target] [target.get_knockout_message()]"))

	playsound(attacker.loc, "swing_hit", 25, 1, -1)
	admin_attack_log(attacker, target,
		"Headbutted [key_name(target)]",
		"Headbutted by [key_name(attacker)]",
		"has headbutted"
	)

	attacker.drop_from_inventory(src)
	src.loc = null
	qdel(src)
	return

/obj/item/weapon/grab/proc/dislocate(mob/living/carbon/human/target, mob/living/attacker, var/target_zone)
	if(state < GRAB_NECK)
		attacker << "<span class='warning'>You require a better grab to do this.</span>"
		return
	if(target.grab_joint(attacker, target_zone))
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		return

/obj/item/weapon/grab/proc/pin_down(mob/target, mob/attacker)
	if(state < GRAB_AGGRESSIVE)
		attacker << "<span class='warning'>You require a better grab to do this.</span>"
		return
	if(force_down)
		attacker << "<span class='warning'>You are already pinning [target] to the ground.</span>"

	attacker.visible_message(SPAN_DANG("[attacker] starts forcing [target] to the ground!"))
	if(do_after(attacker, 20) && target)
		last_action = world.time
		attacker.visible_message(SPAN_DANG("[attacker] forces [target] to the ground!"))
		apply_pinning(target, attacker)

/obj/item/weapon/grab/proc/apply_pinning(mob/target, mob/attacker)
	force_down = 1
	target.Weaken(3)
	target.lying = 1
	step_to(attacker, target)
	attacker.set_dir(EAST) //face the victim
	target.set_dir(SOUTH) //face up

/obj/item/weapon/grab/proc/devour(mob/target, mob/user)
	var/can_eat
	var/mob/living/carbon/human/H = user
	if(istype(H) && H.species.gluttonous)
		if(H.species.gluttonous == 2)
			can_eat = 2
		else if(!ishuman(target) && !issmall(target) && (target.small || iscarbon(target)))
			can_eat = 1

	if(can_eat)
		var/mob/living/carbon/attacker = user
		user.visible_message(SPAN_DANG("[user] is attempting to devour [target]!"))
		if(can_eat == 2)
			if(!do_mob(user, target, 30)) return
		else
			if(!do_mob(user, target, 100)) return
		user.visible_message(SPAN_DANG("[user] devours [target]!"))
		target.loc = user
		attacker.stomach_contents.Add(target)
		qdel(src)