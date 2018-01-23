/obj/structure/closet/secure_closet/medical1
	name = "medicine closet"
	desc = "Filled with medical junk."
	icon_state = "medical"
	icon_opened = "medicalopen"
	req_access = list(access_medical_equip)

	New()
		..()
		new /obj/item/storage/box/autoinjectors(src)
		new /obj/item/storage/box/pillbottles(src)
		new /obj/item/weapon/reagent_containers/glass/beaker(src)
		new /obj/item/weapon/reagent_containers/glass/beaker(src)
		new /obj/item/weapon/reagent_containers/dropper(src)
		new /obj/item/weapon/reagent_containers/glass/beaker/bottle/inaprovaline(src)
		new /obj/item/weapon/reagent_containers/glass/beaker/bottle/inaprovaline(src)
		new /obj/item/weapon/reagent_containers/glass/beaker/bottle/antitoxin(src)
		new /obj/item/weapon/reagent_containers/glass/beaker/bottle/antitoxin(src)
		new /obj/item/storage/box/syringes(src)
		return



/obj/structure/closet/secure_closet/medical2
	name = "anesthetics closet"
	desc = "Used to knock people out."
	icon_state = "medical"
	icon_opened = "medicalopen"
	req_access = list(access_surgery)

	New()
		..()
		new /obj/item/weapon/tank/anesthetic(src)
		new /obj/item/weapon/tank/anesthetic(src)
		new /obj/item/weapon/tank/anesthetic(src)
		new /obj/item/clothing/mask/breath/medical(src)
		new /obj/item/clothing/mask/breath/medical(src)
		new /obj/item/clothing/mask/breath/medical(src)
		return



/obj/structure/closet/secure_closet/medical3
	name = "medical doctor's locker"
	req_access = list(access_medical_equip)
	icon_state = "securemed"
	icon_opened = "securemedopen"

	New()
		..()
		switch(rand(4))
			if(1) new /obj/item/storage/backpack/medic(src)
			if(2) new /obj/item/storage/backpack/satchel/med(src)
			if(3) new /obj/item/storage/backpack/dufflebag/med(src)
			if(4) new /obj/item/storage/backpack/messenger/med(src)
		new /obj/item/clothing/under/rank/nursesuit (src)
		new /obj/item/clothing/head/nursehat (src)
		for(var/i in 1 to 2)
			switch(pick("blue", "green", "purple", "black", "navyblue"))
				if ("blue")
					new /obj/item/clothing/under/rank/medical/sleeveless/blue(src)
					new /obj/item/clothing/head/surgery/blue(src)
				if ("green")
					new /obj/item/clothing/under/rank/medical/sleeveless/green(src)
					new /obj/item/clothing/head/surgery/green(src)
				if ("purple")
					new /obj/item/clothing/under/rank/medical/sleeveless/purple(src)
					new /obj/item/clothing/head/surgery/purple(src)
				if ("black")
					new /obj/item/clothing/under/rank/medical/sleeveless/black(src)
					new /obj/item/clothing/head/surgery/black(src)
				if ("navyblue")
					new /obj/item/clothing/under/rank/medical/sleeveless/navyblue(src)
					new /obj/item/clothing/head/surgery/navyblue(src)
		new /obj/item/clothing/under/rank/medical(src)
		new /obj/item/clothing/under/rank/nurse(src)
		new /obj/item/clothing/under/rank/orderly(src)
		new /obj/item/clothing/suit/storage/toggle/labcoat(src)
		new /obj/item/clothing/suit/storage/toggle/fr_jacket(src)
		new /obj/item/clothing/shoes/white(src)
		new /obj/item/device/radio/headset/med(src)
		return

/obj/structure/closet/secure_closet/paramedic
	name = "paramedic locker"
	desc = "Supplies for a first responder."
	icon_state = "secureems"
	icon_opened = "secureemsopen"
	req_access = list(access_medical_equip)


	New()
		..()
		switch(rand(4))
			if(1) new /obj/item/storage/backpack/emt(src)
			if(2) new /obj/item/storage/backpack/satchel/emt(src)
			if(3) new /obj/item/storage/backpack/dufflebag/emt(src)
			if(4) new /obj/item/storage/backpack/messenger/emt(src)
		new /obj/item/storage/box/autoinjectors(src)
		new /obj/item/storage/box/syringes(src)
		new /obj/item/weapon/reagent_containers/glass/beaker/bottle/inaprovaline(src)
		new /obj/item/weapon/reagent_containers/glass/beaker/bottle/antitoxin(src)
		new /obj/item/storage/belt/medical/emt(src)
		new /obj/item/clothing/mask/gas(src)
		new /obj/item/clothing/suit/storage/toggle/fr_jacket/ems(src)
		new /obj/item/device/radio/headset/med/alt(src)
		new /obj/item/weapon/cartridge/medical(src)
		new /obj/item/device/flashlight(src)
		new /obj/item/weapon/tank/emergency_oxygen/engi(src)
		new /obj/item/clothing/glasses/hud/health(src)
		new /obj/item/device/healthanalyzer(src)
		new /obj/item/device/radio/off(src)
		new /obj/random/medical(src)
		new /obj/item/weapon/crowbar(src)
		new /obj/item/weapon/extinguisher/mini(src)
		new /obj/item/clothing/accessory/storage/white_vest(src)

		return

/obj/structure/closet/secure_closet/CMO
	name = "chief medical officer's locker"
	req_access = list(access_cmo)
	icon_state = "cmosecure"
	icon_opened = "cmosecureopen"

	New()
		..()
		switch(rand(4))
			if(1) new /obj/item/storage/backpack/medic(src)
			if(2) new /obj/item/storage/backpack/satchel/med(src)
			if(3) new /obj/item/storage/backpack/dufflebag/med(src)
			if(4) new /obj/item/storage/backpack/messenger/med(src)
		new /obj/item/clothing/suit/bio_suit/cmo(src)
		new /obj/item/clothing/head/bio_hood/cmo(src)
		new /obj/item/clothing/shoes/white(src)
		switch(pick("blue", "green", "purple", "black", "navyblue"))
			if ("blue")
				new /obj/item/clothing/under/rank/medical/sleeveless/blue(src)
				new /obj/item/clothing/head/surgery/blue(src)
			if ("green")
				new /obj/item/clothing/under/rank/medical/sleeveless/green(src)
				new /obj/item/clothing/head/surgery/green(src)
			if ("purple")
				new /obj/item/clothing/under/rank/medical/sleeveless/purple(src)
				new /obj/item/clothing/head/surgery/purple(src)
			if ("black")
				new /obj/item/clothing/under/rank/medical/sleeveless/black(src)
				new /obj/item/clothing/head/surgery/black(src)
			if ("navyblue")
				new /obj/item/clothing/under/rank/medical/sleeveless/navyblue(src)
				new /obj/item/clothing/head/surgery/navyblue(src)
		new /obj/item/clothing/under/rank/chief_medical_officer(src)
		new /obj/item/clothing/suit/storage/toggle/labcoat/cmo(src)
		new /obj/item/clothing/suit/storage/toggle/labcoat/cmoalt(src)
		new /obj/item/weapon/cartridge/cmo(src)
		new /obj/item/clothing/gloves/latex(src)
		new /obj/item/clothing/shoes/brown	(src)
		new /obj/item/device/radio/headset/heads/cmo(src)
		new /obj/item/weapon/melee/baton/shocker/loaded(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/reagent_containers/hypospray(src)
		new /obj/item/clothing/mask/gas(src)
		return



/obj/structure/closet/secure_closet/chemical
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	icon_state = "medical"
	icon_opened = "medicalopen"
	req_access = list(access_chemistry)


	New()
		..()
		new /obj/item/storage/box/pillbottles(src)
		new /obj/item/storage/box/pillbottles(src)
		return

/obj/structure/closet/secure_closet/wall/medical
	name = "first aid closet"
	desc = "It's a secure wall-mounted storage unit for first aid supplies."
	icon_state = "medical_wall_sec"
	icon_opened = "medical_wall_open"
	req_access = list(access_medical_equip)

