Scriptname tssd_SuccubusPreyMarker extends activemagiceffect  

tssd_succubusstageendblockhook Property stageEndHook Auto
GlobalVariable Property SuccubusDesireLevel Auto
Actor ThisThing
Actor Property PlayerRef Auto
SexLabFramework Property SexLab Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    ThisThing = akTarget
    tssd_actions tssd_actions_script = Quest.GetQuest("tssd_queststart") as tssd_actions
    if ThisThing.isHostileToActor(PlayerRef)
        tssd_actions_script.updateSuccyNeeds(-1)
    endif

endEvent


Event OnActivate(ObjectReference akActionRef)
    if ThisThing && akActionRef == PlayerRef && SuccubusDesireLevel.GetValue() <= -100
        Sexlab.RegisterHook( stageEndHook)
        ThisThing.SendAssaultAlarm()
        ThisThing.GetCrimeFaction().SetCrimeGoldViolent(200)
        PlayerRef.SetAttackActorOnSight(true)
        Sexlab.StartSceneQuick(akActor1 = PlayerRef, akActor2 = ThisThing, akSubmissive=ThisThing).SetConsent(false)

    endif
endEvent