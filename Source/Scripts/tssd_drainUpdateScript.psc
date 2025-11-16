Scriptname tssd_drainUpdateScript extends ActiveMagicEffect
import tssd_utils

tssd_actions tssd_actions_script
Spell Property TSSD_DrainHealthAsSpell auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    ; DBGTrace(TSSD_DrainHealthAsSpell.GetEffectiveMagickaCost(akCaster)) TODO Spelleffectivness Destruction
    tssd_actions_script = Quest.GetQuest("tssd_queststart") as tssd_actions
    RegisterForSingleUpdate(0.1)
EndEvent

Event OnUpdate()
    tssd_actions_script.updateSuccyNeeds(-1)
    RegisterForSingleUpdate(0.1)
endEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    UnregisterForUpdate()
EndEvent