Scriptname TSSD_SatiatedScript extends activemagiceffect  

import tssd_utils
MagicEffect Property TSSD_SatiatedEffect Auto

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Utility.Wait(1)
	if !Game.GetPlayer().HasMagicEffect( TSSD_SatiatedEffect)
		T_Show("I'm needy again")
	endif
EndEvent