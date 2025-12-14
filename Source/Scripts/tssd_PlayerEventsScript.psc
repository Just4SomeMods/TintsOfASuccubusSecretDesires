Scriptname tssd_PlayerEventsScript extends ReferenceAlias

tssd_actions Property tActions Auto
Actor Property PlayerRef Auto
GlobalVariable Property TSSD_TypeMahogany Auto
Spell Property tssd_Satiated Auto
MagicEffect Property TSSD_SatiatedEffect Auto
GlobalVariable Property SkillSuccubusDrainLevel Auto

import tssd_utils

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, \
    bool abBashAttack, bool abHitBlocked)
    Weapon akW = akSource as Weapon
    
    if TSSD_TypeMahogany.GetValue() == 1.0 && akW && !abHitBlocked
        tActions.gainSuccubusXP(akW.GetBaseDamage() * 20 )
    endif
    if PlayerRef.GetAV("Health") < 100 && !PlayerRef.HasMagicEffect(TSSD_SatiatedEffect) && (akAggressor as Actor) && \
        (akAggressor as Actor).GetAv("Health") < SkillSuccubusDrainLevel.GetValue()
        Actor tar = tActions.getLonelyTarget()
        if tar && tar != PlayerRef
            tActions.actDefeated(tar)
        endif
    endif
EndEvent