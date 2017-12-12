/datum/power/changeling/blind_sting
	name = "Blind Sting"
	desc = "We silently sting a human, completely blinding them for a short time."
	enhancedtext = "Duration is extended."
	genomecost = 2
	allowduringlesserform = 1
	verbpath = /mob/living/proc/changeling_blind_sting

/mob/living/proc/changeling_blind_sting()
	set category = "Changeling"
	set name = "Blind sting (20)"
	set desc="Sting target"

	var/mob/living/carbon/T = changeling_sting(20,/mob/living/proc/changeling_blind_sting)
	if(!T)
		return 0
	T << SPAN_DANG("Your eyes burn horrificly!")
	T.disabilities |= NEARSIGHTED
	var/duration = 300
	if(src.mind.changeling.recursive_enhancement)
		duration = duration + 150
		src << SPAN_NOTE("They will be deprived of sight for longer.")
		src.mind.changeling.recursive_enhancement = 0
	spawn(duration)
		T.disabilities &= ~NEARSIGHTED
	T.eye_blind = 10
	T.eye_blurry = 20
	return 1
