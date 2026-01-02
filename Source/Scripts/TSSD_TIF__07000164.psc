;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TSSD_TIF__07000164 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
if CustomSkills.GetAPIVersion() >= 3
  CustomSkills.AdvanceSkill("SuccubusDrainSkill",  akSpeaker.GetAv("Health"))
endif
TSSD_DrainHealth.SetNthEffectMagnitude(0,  akSpeaker.GetAv("Health") + 10 )
TSSD_DrainHealth.Cast( Game.GetPlayer(), akSpeaker)

Utility.Wait(1)
akSpeaker.Kill( Game.GetPlayer() )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Spell Property TSSD_DrainHealth Auto
 
import CustomSkills
