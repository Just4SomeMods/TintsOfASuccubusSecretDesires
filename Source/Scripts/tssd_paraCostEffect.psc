Scriptname tssd_paraCostEffect extends activemagiceffect  


tssd_actions Property tActions Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    tActions.RefreshEnergy(-20)
EndEvent