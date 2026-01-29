Scriptname TSSD_SeductionCharmForFollow extends activemagiceffect  

Faction Property MagicAllegianceFaction Auto


Actor Property PlayerRef Auto
tssd_actions Property tActions Auto

Event OnCombatStateChanged(Actor akTarget, Int aeCombatState)
    Dispel()
EndEvent


Event OnEffectStart(Actor akTarget, Actor akCaster)
    tActions.SetSeduced(akTarget)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    if tActions.currentSeduced == akTarget
        tActions.SetSeduced(PlayerRef)
    EndIf
EndEvent