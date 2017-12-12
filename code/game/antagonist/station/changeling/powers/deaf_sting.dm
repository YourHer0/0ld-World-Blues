/datum/power/changeling/deaf_sting
	name = "Deaf Sting"
	desc = "We silently sting a human, completely deafening them for a short time."
	enhancedtext = "Deafness duration is extended."
	genomecost = 1
	allowduringlesserform = 1
	verbpath = /mob/living/proc/changeling_deaf_sting


/mob/living/proc/changeling_deaf_sting()
	set category = "Changeling"
	set name = "Deaf sting (5)"
	set desc="Sting target:"

	var/mob/living/carbon/T = changeling_sting(5,/mob/living/proc/changeling_deaf_sting)
	if(!T)	return 0
	var/duration = 300
	if(src.mind.changeling.recursive_enhancement)
		duration = duration + 100
		src << SPAN_NOTE("They will be unable to hear for a little longer.")
		src.mind.changeling.recursive_enhancement = 0
	T << SPAN_DANG("Your ears pop and begin ringing loudly!")
	T.sdisabilities |= DEAF
	spawn(duration)	T.sdisabilities &= ~DEAF
	return 1
