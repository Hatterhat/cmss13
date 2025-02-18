/datum/chem_property/negative
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_TOXICANT
	value = -2

/datum/chem_property/negative/process(mob/living/M, var/potency = 1, delta_time)
	M.last_damage_data = create_cause_data("Harmful substance", holder.last_source_mob?.resolve())

/datum/chem_property/negative/hypoxemic
	name = PROPERTY_HYPOXEMIC
	code = "HPX"
	description = "Reacts with hemoglobin in red blood cells preventing oxygen from being absorbed, resulting in hypoxemia."
	rarity = PROPERTY_COMMON
	value = -1

/datum/chem_property/negative/hypoxemic/process(mob/living/M, var/potency = 1, delta_time)
	..()
	M.apply_damage(potency * delta_time, OXY)
	if(prob(5 * delta_time))
		M.emote("gasp")

/datum/chem_property/negative/hypoxemic/process_overdose(mob/living/M, var/potency = 1, delta_time)
	M.apply_damages(0.5 * potency * delta_time, 0, potency)
	M.apply_damage(2.5 * potency * delta_time, OXY)

/datum/chem_property/negative/hypoxemic/process_critical(mob/living/M, var/potency = 1, delta_time)
	M.apply_damages(2.5 * potency * delta_time, 0, potency * delta_time)

/datum/chem_property/negative/toxic
	name = PROPERTY_TOXIC
	code = "TXC"
	description = "Poisonous substance which causes harm on contact with or through absorption by organic tissues, resulting in bad health or severe illness."
	rarity = PROPERTY_COMMON
	starter = TRUE
	value = -1

/datum/chem_property/negative/toxic/process(mob/living/M, var/potency = 1, delta_time)
	..()
	M.apply_damage(0.5 * potency * delta_time, TOX)

/datum/chem_property/negative/toxic/process_overdose(mob/living/M, var/potency = 1, delta_time)
	M.apply_damage(potency * delta_time, TOX)

/datum/chem_property/negative/toxic/process_critical(mob/living/M, var/potency = 1, delta_time)
	M.apply_damage(2 * potency * delta_time, TOX)

/datum/chem_property/negative/corrosive
	name = PROPERTY_CORROSIVE
	code = "CRS"
	description = "Damages or destroys other substances on contact through a chemical reaction. Causes chemical burns on contact with living tissue."
	rarity = PROPERTY_COMMON
	starter = TRUE
	value = -1

/datum/chem_property/negative/corrosive/process(mob/living/M, var/potency = 1, delta_time)
	..()
	M.take_limb_damage(0, 0.5 * potency * delta_time)

/datum/chem_property/negative/corrosive/process_overdose(mob/living/M, var/potency = 1, delta_time)
	M.take_limb_damage(0, potency * delta_time)

/datum/chem_property/negative/corrosive/process_critical(mob/living/M, var/potency = 1, delta_time)
	M.take_limb_damage(0, 2 * potency * delta_time)

/datum/chem_property/negative/biocidic
	name = PROPERTY_BIOCIDIC
	code = "BCD"
	description = "Ruptures cell membranes on contact, destroying most types of organic tissue."
	rarity = PROPERTY_COMMON
	starter = TRUE
	value = -1

/datum/chem_property/negative/biocidic/process(mob/living/M, var/potency = 1, delta_time)
	..()
	M.take_limb_damage(0.5 * potency * delta_time)

/datum/chem_property/negative/biocidic/process_overdose(mob/living/M, var/potency = 1, delta_time)
	M.take_limb_damage(potency * delta_time)

/datum/chem_property/negative/biocidic/process_critical(mob/living/M, var/potency = 1, delta_time)
	M.take_limb_damage(2 * potency * delta_time)

/datum/chem_property/negative/paining
	name = PROPERTY_PAINING
	code = "PNG"
	description = "Activates the somatosensory system causing neuropathic pain all over the body. Unlike nociceptive pain, this is not caused to any tissue damage and is solely perceptive."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_STIMULANT
	value = -1

/datum/chem_property/negative/paining/on_delete(mob/living/M)
	..()

	M.pain.recalculate_pain()

/datum/chem_property/negative/paining/process(mob/living/M, var/potency = 1, delta_time)
	if(!(..()))
		return

	M.pain.apply_pain(PROPERTY_PAINING_PAIN * potency)

/datum/chem_property/negative/paining/process_overdose(mob/living/M, var/potency = 1, delta_time)
	if(!(..()))
		return

	M.pain.apply_pain(PROPERTY_PAINING_PAIN_OD * potency)
	M.take_limb_damage(0.5 * potency * delta_time)

/datum/chem_property/negative/paining/process_critical(mob/living/M, var/potency = 1, delta_time)
	M.take_limb_damage(potency * delta_time)

/datum/chem_property/negative/hemolytic
	name = PROPERTY_HEMOLYTIC
	code = "HML"
	description = "Causes intravascular hemolysis, resulting in the destruction of erythrocytes (red blood cells) in the bloodstream. This can result in Hemoglobinemia, where a high concentration of hemoglobin is released into the blood plasma."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/negative/hemolytic/process(mob/living/M, var/potency = 1, delta_time)
	if(!iscarbon(M))
		return
	var/mob/living/carbon/C = M
	..()
	C.blood_volume = max(C.blood_volume - 2 * potency * delta_time, 0)

/datum/chem_property/negative/hemolytic/process_overdose(mob/living/M, var/potency = 1, delta_time)
	if(!iscarbon(M))
		return
	var/mob/living/carbon/C = M
	C.blood_volume = max(C.blood_volume - 4 * potency *  delta_time, 0)
	M.drowsyness = min(M.drowsyness + 0.5 * potency * delta_time, 15 * potency)
	M.reagent_move_delay_modifier += potency
	M.recalculate_move_delay = TRUE
	if(prob(5 * delta_time))
		M.emote(pick("yawn","gasp"))

/datum/chem_property/negative/hemolytic/process_critical(mob/living/M, var/potency = 1, delta_time)
	M.apply_damage(2 * potency * delta_time, OXY)

/datum/chem_property/negative/hemorrhaging
	name = PROPERTY_HEMORRAGING
	code = "HMR"
	description = "Ruptures endothelial cells making up bloodvessels, causing blood to escape from the circulatory system."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/negative/hemorrhaging/process(mob/living/M, var/potency = 1, delta_time)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	var/obj/limb/L = pick(H.limbs)
	if(!L || L.status & LIMB_ROBOT|LIMB_SYNTHSKIN)
		return
	..()
	if(prob(2.5 * potency * delta_time))
		var/datum/wound/internal_bleeding/I = new (0)
		L.add_bleeding(I, TRUE)
		L.wounds += I
	if(prob(2.5 * potency * delta_time))
		spawn L.owner.emote("me", 1, "coughs up blood!")
		L.owner.drip(10)

/datum/chem_property/negative/hemorrhaging/process_overdose(mob/living/M, var/potency = 1, delta_time)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	var/obj/limb/L = pick(H.limbs)
	if(L.internal_organs)
		var/datum/internal_organ/O = pick(L.internal_organs)//Organs can't bleed, so we just damage them
		O.damage += 0.25 * potency * delta_time

/datum/chem_property/negative/hemorrhaging/process_critical(mob/living/M, var/potency = 1, delta_time)
	if(prob(10 * potency * delta_time) && ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/limb/L = pick(H.limbs)
		var/datum/wound/internal_bleeding/I = new (0)
		L.add_bleeding(I, TRUE)
		L.wounds += I

/datum/chem_property/negative/carcinogenic
	name = PROPERTY_CARCINOGENIC
	code = "CRG"
	description = "Penetrates the cell nucleus causing direct damage to the deoxyribonucleic acid in cells resulting in cancer and abnormal cell proliferation. In extreme cases causing hyperactive apoptosis and potentially atrophy."
	rarity = PROPERTY_COMMON

/datum/chem_property/negative/carcinogenic/process(mob/living/M, var/potency = 1, delta_time)
	..()
	M.adjustCloneLoss(0.25 * potency * delta_time)

/datum/chem_property/negative/carcinogenic/process_overdose(mob/living/M, var/potency = 1, delta_time)
	M.adjustCloneLoss(potency * delta_time)

/datum/chem_property/negative/carcinogenic/process_critical(mob/living/M, var/potency = 1, delta_time)
	M.take_limb_damage(potency * delta_time) //Hyperactive apoptosis

/datum/chem_property/negative/hepatotoxic
	name = PROPERTY_HEPATOTOXIC
	code = "HPT"
	description = "Damages hepatocytes in the liver, resulting in liver deterioration and eventually liver failure."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/negative/hepatotoxic/process(mob/living/M, var/potency = 1, delta_time)
	if(!ishuman(M))
		return
	..()
	M.apply_internal_damage(0.375 * potency * delta_time, "liver")

/datum/chem_property/negative/hepatotoxic/process_overdose(mob/living/M, var/potency = 1, delta_time)
	M.apply_damage(potency * delta_time, TOX)

/datum/chem_property/negative/hepatotoxic/process_critical(mob/living/M, var/potency = 1, delta_time)
	M.apply_damage(2.5 * potency * delta_time, TOX)

/datum/chem_property/negative/nephrotoxic
	name = PROPERTY_NEPHROTOXIC
	code = "NPT"
	description = "Causes deterioration and damage to podocytes in the kidney resulting in potential kidney failure."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/negative/nephrotoxic/process(mob/living/M, var/potency = 1, delta_time)
	if(!ishuman(M))
		return
	..()
	M.apply_internal_damage(0.375 * potency * delta_time, "kidneys")

/datum/chem_property/negative/nephrotoxic/process_overdose(mob/living/M, var/potency = 1, delta_time)
	M.apply_damage(potency * delta_time, TOX)

/datum/chem_property/negative/nephrotoxic/process_critical(mob/living/M, var/potency = 1, delta_time)
	M.apply_damage(2.5 * potency * delta_time, TOX)

/datum/chem_property/negative/pneumotoxic
	name = PROPERTY_PNEUMOTOXIC
	code = "PNT"
	description = "Toxic substance which causes damage to connective tissue that forms the support structure (the interstitium) of the alveoli in the lungs."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/negative/pneumotoxic/process(mob/living/M, var/potency = 1, delta_time)
	if(!ishuman(M))
		return
	..()
	M.apply_internal_damage(0.375 * potency * delta_time, "lungs")

/datum/chem_property/negative/pneumotoxic/process_overdose(mob/living/M, var/potency = 1, delta_time)
	M.apply_damage(potency * delta_time, OXY)

/datum/chem_property/negative/pneumotoxic/process_critical(mob/living/M, var/potency = 1, delta_time)
	M.apply_damage(2.5 * potency * delta_time, OXY)

/datum/chem_property/negative/oculotoxic
	name = PROPERTY_OCULOTOXIC
	code = "OCT"
	description = "Damages the photoreceptive cells in the eyes impairing neural transmissions to the brain, resulting in loss of sight or blindness."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/negative/oculotoxic/process(mob/living/M, var/potency = 1, delta_time)
	if(!ishuman(M))
		return
	..()
	var/mob/living/carbon/human/H = M
	var/datum/internal_organ/eyes/L = H.internal_organs_by_name["eyes"]
	if(L)
		L.damage += 0.375 * potency * delta_time

/datum/chem_property/negative/oculotoxic/process_overdose(mob/living/M, var/potency = 1, delta_time)
	M.sdisabilities |= DISABILITY_BLIND

/datum/chem_property/negative/oculotoxic/process_critical(mob/living/M, var/potency = 1, delta_time)
	M.apply_damage(0.25 * potency * delta_time, BRAIN)

/datum/chem_property/negative/cardiotoxic
	name = PROPERTY_CARDIOTOXIC
	code = "CDT"
	description = "Attacks cardiomyocytes when passing through the heart in the bloodstream. This disrupts the cardiac cycle and can lead to cardiac arrest."
	rarity = PROPERTY_COMMON

/datum/chem_property/negative/cardiotoxic/process(mob/living/M, var/potency = 1, delta_time)
	if(!ishuman(M))
		return
	..()
	M.apply_internal_damage(0.375 * potency * delta_time, "heart")

/datum/chem_property/negative/cardiotoxic/process_overdose(mob/living/M, var/potency = 1, delta_time)
	M.apply_damage(potency * delta_time, OXY)

/datum/chem_property/negative/cardiotoxic/process_critical(mob/living/M, var/potency = 1, delta_time)
	M.apply_damage(2.5 * potency * delta_time, OXY)

/datum/chem_property/negative/neurotoxic
	name = PROPERTY_NEUROTOXIC
	code = "NRT"
	description = "Breaks down neurons causing widespread damage to the central nervous system and brain functions."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_TOXICANT|PROPERTY_TYPE_STIMULANT

/datum/chem_property/negative/neurotoxic/process(mob/living/M, var/potency = 1, delta_time)
	M.apply_damage(potency * delta_time, BRAIN)

/datum/chem_property/negative/neurotoxic/process_overdose(mob/living/M, var/potency = 1, delta_time)
	M.apply_damage(1.5 * potency * delta_time, BRAIN)
	M.jitteriness = min(M.jitteriness + 0.5 * potency * delta_time, 3 * potency)
	if(prob(25 * delta_time))
		M.drowsyness = min(M.drowsyness + 0.5 * potency * delta_time, 3 * potency)
	if(prob(5 * delta_time))
		M.emote("drool")

/datum/chem_property/negative/neurotoxic/process_critical(mob/living/M, var/potency = 1, delta_time)
	if(prob(7.5 * potency * delta_time))
		apply_neuro(M, potency * delta_time, FALSE)

/datum/chem_property/negative/hypermetabolic
	name = PROPERTY_HYPERMETABOLIC
	code = "EMB"
	description = "Takes less time for this chemical to metabolize, resulting in it being in the bloodstream for less time per unit."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_METABOLITE

/datum/chem_property/negative/hypermetabolic/reset_reagent()
	holder.custom_metabolism = initial(holder.custom_metabolism)
	..()

/datum/chem_property/negative/hypermetabolic/update_reagent()
	holder.custom_metabolism = holder.custom_metabolism * (1 + 0.25 * level)
	..()

/datum/chem_property/negative/addictive
	name = PROPERTY_ADDICTIVE
	code = "ADT"
	description = "Causes addiction. Higher potency results in a higher chance of causing an addiction when metabolized."
	rarity = PROPERTY_RARE
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/negative/addictive/process(mob/living/M, var/potency = 1, delta_time)
	var/has_addiction
	for(var/datum/disease/addiction/D in M.viruses)
		if(D.chemical_id == holder.id)
			D.handle_chem()
			has_addiction = TRUE
			break
	if(!has_addiction)
		var/datum/disease/addiction/D = new /datum/disease/addiction(holder.id, potency)
		M.contract_disease(D, TRUE)

/datum/chem_property/negative/addictive/process_overdose(mob/living/M, var/potency = 1, delta_time)
	M.apply_damage(0.5 * potency * delta_time, BRAIN)

/datum/chem_property/negative/addictive/process_critical(mob/living/M, var/potency = 1, delta_time)
	M.disabilities |= NERVOUS

//PROPERTY_DISABLED (in generation)
/datum/chem_property/negative/hemositic
	name = PROPERTY_HEMOSITIC
	code = "HST"
	description = "The chemical shows parasitic behavior towards live erythrocytes (red blood cells) in order to produce more of itself."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_REACTANT|PROPERTY_TYPE_ANOMALOUS
	value = 1

/datum/chem_property/negative/hemositic/pre_process(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.flags & IS_SYNTHETIC)
			return list(REAGENT_CANCEL = TRUE)

/datum/chem_property/negative/hemositic/process(mob/living/M, var/potency = 1, delta_time)
	if(!iscarbon(M))
		return
	..()
	var/mob/living/carbon/C = M
	C.blood_volume = max(C.blood_volume - 2.5 * potency * delta_time, 0)
	holder.volume += 0.5 * potency * delta_time

/datum/chem_property/negative/hemositic/process_overdose(mob/living/M, var/potency = 1, delta_time)
	if(!iscarbon(M))
		return
	var/mob/living/carbon/C = M
	C.blood_volume = max(C.blood_volume - 5 * potency * delta_time, 0)
	holder.volume += potency * delta_time

/datum/chem_property/negative/hemositic/process_critical(mob/living/M, var/potency = 1, delta_time)
	M.disabilities |= NERVOUS
