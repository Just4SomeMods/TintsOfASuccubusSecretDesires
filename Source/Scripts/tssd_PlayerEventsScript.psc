Scriptname tssd_PlayerEventsScript extends ReferenceAlias

GlobalVariable Property TSSD_SuccubusType Auto
tssd_actions Property tActions Auto
Actor Property PlayerRef Auto

import tssd_utils

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, \
    bool abBashAttack, bool abHitBlocked)
    Weapon akW = akSource as Weapon
    
    if TSSD_SuccubusType.GetValue() == 4 && akW && !abHitBlocked
        tActions.gainSuccubusXP(akW.GetBaseDamage() * 20 )
    endif
    if PlayerRef.GetAV("Health") < 100
        Actor tar = tActions.getLonelyTarget()
        if tar != PlayerRef
            tActions.actDefeated(tar)
        endif
    endif
EndEvent