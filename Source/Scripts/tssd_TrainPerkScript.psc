Scriptname tssd_TrainPerkScript extends activemagiceffect

Perk Property TOSD_Base_TraitGain Auto
Actor Property PlayerRef Auto
GlobalVariable Property TSSD_MaxTraits Auto

import tssd_utils

Event OnEffectStart(Actor akTarget, Actor akCaster)
	int max_num_traits = GetSuccubusTraitsAll().Length
		if max_num_traits > TSSD_MaxTraits.GetValue()
			PlayerRef.RemovePerk(TOSD_Base_TraitGain)
		endif
		TSSD_MaxTraits.setvalue(TSSD_MaxTraits.GetValue() + 1 )
		Debug.Messagebox("You can now select " + TSSD_MaxTraits.GetValue() + " out of " + max_num_traits + " Traits!")
endevent