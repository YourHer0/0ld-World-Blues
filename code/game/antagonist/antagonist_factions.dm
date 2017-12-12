/mob/living/proc/convert_to_rev(mob/M as mob in oview(src))
	set name = "Convert Bourgeoise"
	set category = "Abilities"
	if(!M.mind)
		return
	convert_to_faction(M.mind, revs)

/mob/living/proc/convert_to_faction(var/datum/mind/player, var/datum/antagonist/faction)

	if(!player || !faction || !player.current)
		return

	if(!faction.faction_verb || !faction.faction_descriptor || !faction.faction_verb)
		return

	if(world.time < player.rev_cooldown)
		src << SPAN_DANG("You must wait five seconds between attempts.")
		return

	if(faction.is_antagonist(player))
		src << "<span class='warning'>\The [player.current] already serves the [faction.faction_descriptor].</span>"
		return

	log_mode("[key_name(src)] attempted to convert [key_name(player.current)].", player.current)
	src << SPAN_DANG("You are attempting to convert \the [player.current]...")
	player.rev_cooldown = world.time+100

	// Prevents meta-using of 'convert' verb in order to indicate antags.
	if(player_is_antag(player) || !faction.can_become_antag(player))
		player << SPAN_DANG("The [src] is trying to force you to join the [faction.faction_descriptor]! With no chance of success, actually.")
		var/choice = alert(player.current,"Asked by [src]: Do you want to join the [faction.faction_descriptor]?","Join the [faction.faction_descriptor]?","No!","Yes!(no)")
		if(choice == "No!" || choice == "Yes!(no)")
			player << SPAN_DANG("You had literally no choice!")
		src << SPAN_DANG("\The [player.current] does not support the [faction.faction_descriptor]!")
		return

	var/choice = alert(player.current,"Asked by [src]: Do you want to join the [faction.faction_descriptor]?","Join the [faction.faction_descriptor]?","No!","Yes!")
	if(choice == "Yes!" && faction.add_antagonist_mind(player, 0, faction.faction_role_text, faction.faction_welcome))
		src << SPAN_NOTE("\The [player.current] joins the [faction.faction_descriptor]!")
		return
	if(choice == "No!")
		player << SPAN_DANG("You reject this traitorous cause!")
	src << SPAN_DANG("\The [player.current] does not support the [faction.faction_descriptor]!")

/mob/living/proc/convert_to_loyalist(mob/M as mob in oview(src))
	set name = "Convert Recidivist"
	set category = "Abilities"
	if(!M.mind)
		return
	convert_to_faction(M.mind, loyalists)
