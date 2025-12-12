Scriptname tssd_PlayerEventsScript extends ReferenceAlias

tssd_actions Property tActions Auto
Actor Property PlayerRef Auto
GlobalVariable Property TSSD_TypeMahogany Auto

import tssd_utils

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, \
    bool abBashAttack, bool abHitBlocked)
    Weapon akW = akSource as Weapon
    
    if TSSD_TypeMahogany.GetValue() == 1.0 && akW && !abHitBlocked
        tActions.gainSuccubusXP(akW.GetBaseDamage() * 20 )
    endif
    if PlayerRef.GetAV("Health") < 100
        Actor tar = tActions.getLonelyTarget()
        if tar != PlayerRef
            tActions.actDefeated(tar)
        endif
    endif
EndEvent