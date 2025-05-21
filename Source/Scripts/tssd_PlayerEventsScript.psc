Scriptname tssd_PlayerEventsScript extends ReferenceAlias

GlobalVariable Property TSSD_SuccubusType Auto
GlobalVariable Property TSSD_SuccubusLibido Auto

tssd_LibidoTrackerRefScript Property libidoTrackerScript Auto

import tssd_utils

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, \
    bool abBashAttack, bool abHitBlocked)
    Weapon akW = akSource as Weapon
    
    if TSSD_SuccubusType.GetValue() == 4 
        if akW
            if !abHitBlocked
                libidoTrackerScript.changeLibido(akW.GetBaseDamage() / 5)
            endif
        endif
    endif
  EndEvent