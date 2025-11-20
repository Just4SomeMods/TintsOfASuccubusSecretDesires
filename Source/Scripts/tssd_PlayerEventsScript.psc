Scriptname tssd_PlayerEventsScript extends ReferenceAlias

GlobalVariable Property TSSD_SuccubusType Auto
tssd_actions Property tActions Auto
Actor Property PlayerRef Auto

import tssd_utils

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, \
    bool abBashAttack, bool abHitBlocked)
    Weapon akW = akSource as Weapon
    
    ;if TSSD_SuccubusType.GetValue() == 4 
    ;    if akW
    ;        if !abHitBlocked
    ;            tActions.libidoTrackerScript.changeLibido(akW.GetBaseDamage() / 5)
    ;        endif
    ;    endif
    ;endif
    ;if TSSD_SuccubusLibido.GetValue() > 10  && PlayerRef.GetAV("Health") < 50
    ;    Actor tar = tActions.getLonelyTarget()
    ;    if tar && tar != PlayerRef
    ;        tActions.actDefeated(tar)
    ;    endif
    ;endif

  EndEvent