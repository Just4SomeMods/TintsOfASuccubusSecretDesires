Scriptname tssd_SuccubusPreyMarker extends activemagiceffect  

tssd_succubusstageendblockhook Property stageEndHook Auto
Actor ThisThing
Actor Property PlayerRef Auto
SexLabFramework Property SexLab Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
  ThisThing = akTarget
endEvent


Event OnActivate(ObjectReference akActionRef)
  if ThisThing && akActionRef == PlayerRef
    Sexlab.RegisterHook( stageEndHook)
    ThisThing.SendAssaultAlarm()
    ThisThing.GetCrimeFaction().SetCrimeGoldViolent(200)
    PlayerRef.SetAttackActorOnSight(true)
    Sexlab.StartSceneQuick(akActor1 = PlayerRef, akActor2 = ThisThing, akSubmissive=ThisThing).SetConsent(false)
    
  endif
endEvent