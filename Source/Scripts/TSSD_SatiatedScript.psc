Scriptname TSSD_SatiatedScript extends activemagiceffect  

import tssd_utils
MagicEffect Property TSSD_SatiatedEffect Auto
Actor Property PlayerRef Auto
Faction Property TSSD_SatiatedFaction Auto
GlobalVariable Property timescale Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	PlayerRef.AddToFaction(TSSD_SatiatedFaction)
    RegisterForSingleUpdateGameTime((getDuration() / 3600) * TimeScale.GetValue())
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Utility.Wait(1)
	if !PlayerRef.HasMagicEffect( TSSD_SatiatedEffect)
		PlayerRef.RemoveFromFaction(TSSD_SatiatedFaction)
		T_Show("I'm needy again...")
	endif
EndEvent


Event OnUpdateGameTime()
	if self
	    Dispel()
	EndIf
endEvent