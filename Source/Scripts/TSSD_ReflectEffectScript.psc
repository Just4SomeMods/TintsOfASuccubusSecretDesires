Scriptname TSSD_ReflectEffectScript extends activemagiceffect  

Quest Property tssd_StartCurse Auto
Spell Property TSSD_ReflectOn Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    tssd_StartCurse.setstage(6)
    Game.GetPlayer().RemoveSpell(TSSD_ReflectOn)
EndEvent