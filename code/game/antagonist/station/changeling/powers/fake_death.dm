/datum/power/changeling/fakedeath
	name = "Regenerative Stasis"
	desc = "We become weakened to a death-like state, where we will rise again from death."
	helptext = "Can be used before or after death. Duration varies greatly."
	genomecost = 0
	allowduringlesserform = 1
	verbpath = /mob/living/proc/changeling_fakedeath

//Fake our own death and fully heal. You will appear to be dead but regenerate fully after a short delay.
/mob/living/proc/changeling_fakedeath()
	set category = "Changeling"
	set name = "Regenerative Stasis (20)"

	var/datum/changeling/changeling = changeling_power(20,1,100,DEAD)
	if(!changeling)
		return

	var/mob/living/carbon/C = src

	if(changeling.max_geneticpoints < 0) //Absorbed by another ling
		src << SPAN_DANG("We have no genomes, not even our own, and cannot regenerate.")
		return 0

	if(!C.stat && alert("Are we sure we wish to regenerate?  We will appear to be dead while doing so.","Revival","Yes","No") == "No")
		return
	C << SPAN_NOTE("We will attempt to regenerate our form.")

	C.update_canmove()
	C.remove_changeling_powers()

	if(C.suiciding)
		C.suiciding = 0

	if(C.stat != DEAD)
		C.adjustOxyLoss(C.maxHealth * 2)

	spawn(rand(800,2000))
		//The ling will now be able to choose when to revive
		src.verbs |= /mob/living/proc/changeling_revive
		src << SPAN_NOTE("<font size='5'>We are ready to rise.  Use the <b>Revive</b> verb when you are ready.</font>")

	return 1
