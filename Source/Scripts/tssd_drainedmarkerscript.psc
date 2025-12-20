Scriptname tssd_drainedmarkerscript extends activemagiceffect  

import tssd_utils
GlobalVariable Property TSSD_SuccubusType Auto
Actor Property targetOf Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    float next_update = 8.0
    targetOf = akTarget
    
    RegisterForSingleUpdateGameTime(next_update)
endEvent


Event OnUpdateGameTime()
    Dispel()
endEvent