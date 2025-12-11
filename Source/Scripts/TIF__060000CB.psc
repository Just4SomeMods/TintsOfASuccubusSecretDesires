;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__060000CB Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
tActions.gainSuccubusXP(1000,1000)
SuccubusDesireLevel.Mod( 100  )	
TSSD_Satiated.Cast(PlayerRef,PlayerRef)
;TSSD_HumiliationDone.SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment


GlobalVariable Property TSSD_HumiliationDone Auto

TSSD_Actions Property tActions Auto
Spell Property tssd_Satiated Auto
GlobalVariable Property SuccubusDesireLevel Auto
Actor Property PlayerRef Auto
