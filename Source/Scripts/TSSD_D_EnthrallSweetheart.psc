;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname TSSD_D_EnthrallSweetheart Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
slaUtil.SetActorExposure(akSpeaker, 99)
akSpeaker.AddToFaction(sla_Arousal_Locked)
Debug.MessageBox(akSpeaker.GetDisplayName())
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

slaFrameworkScr Property slaUtil  Auto
Faction Property sla_Arousal_Locked  Auto
Faction Property TSSD_EnthralledFaction Auto
