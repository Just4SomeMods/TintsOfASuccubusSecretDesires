;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__060000A6 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
AzuraFadeToBlack.Apply()

   SuccubusDesireLevel.SetValue( 100  )	
        Utility.Wait(2.5)
        ImageSpaceModifier.RemoveCrossFade(3)
        GameHours.Mod(1) ; TODO
	int upTo = 100
    if tssd_dealwithcurseQuest.isRunning() &&  !tssd_dealwithcurseQuest.isobjectivefailed(24)
        upTo = 19
    endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ImageSpaceModifier Property AzuraFadeToBlack  Auto  

GlobalVariable Property GameHours  Auto   

GlobalVariable Property SuccubusDesireLevel Auto
Quest Property tssd_dealwithcurseQuest Auto
