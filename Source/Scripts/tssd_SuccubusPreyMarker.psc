Scriptname tssd_SuccubusPreyMarker extends activemagiceffect  


import tssd_utils
GlobalVariable Property SuccubusDesireLevel Auto
Actor ThisThing
Actor Property PlayerRef Auto
SexLabFramework Property SexLab Auto
GlobalVariable Property TSSD_ravanousNeedLevel Auto

Perk Property TSSD_Base_PowerGrowing Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    ThisThing = akTarget
    tssd_actions tssd_actions_script = Quest.GetQuest("tssd_queststart") as tssd_actions
    if ThisThing.isHostileToActor(PlayerRef)
        tssd_actions_script.RefreshEnergy(-1)
    endif
endEvent


Event OnActivate(ObjectReference akActionRef)
    if ThisThing && akActionRef == PlayerRef && SuccubusDesireLevel.GetValue() <= TSSD_ravanousNeedLevel.GetValue() && PlayerRef.HasPerk(TSSD_Base_PowerGrowing)
        ThisThing.SendAssaultAlarm()
        Faction CrimeFaction = ThisThing.GetCrimeFaction()
        if CrimeFaction
            CrimeFaction.SetCrimeGoldViolent(200)
        endif
        PlayerRef.SetAttackActorOnSight(true)
        Sexlab.StartSceneQuick(akActor1 = PlayerRef, akActor2 = ThisThing, akSubmissive=ThisThing).SetConsent(false)

    endif
endEvent