Scriptname tssd_PlayerEventsScript extends ReferenceAlias

GlobalVariable Property TSSD_SuccubusType Auto
GlobalVariable Property TSSD_SuccubusLibido Auto
import tssd_utils

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, \
    bool abBashAttack, bool abHitBlocked)
    Weapon akW = akSource as Weapon
    
    if TSSD_SuccubusType.GetValue() == 4 
        if akW
            if !abHitBlocked
                TSSD_SuccubusLibido.Mod(akW.GetBaseDamage()/10)
            endif
        endif
    endif
  EndEvent