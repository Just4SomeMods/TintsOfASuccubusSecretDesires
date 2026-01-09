Scriptname TSSD_SatiatedScript extends activemagiceffect  

import tssd_utils
MagicEffect Property TSSD_SatiatedEffect Auto
Actor Property PlayerRef Auto
Faction Property TSSD_SatiatedFaction Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	PlayerRef.AddToFaction(TSSD_SatiatedFaction)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Utility.Wait(1)
	if !PlayerRef.HasMagicEffect( TSSD_SatiatedEffect)
		PlayerRef.RemoveFromFaction(TSSD_SatiatedFaction)
		T_Show("I'm needy again...")
	endif
EndEvent