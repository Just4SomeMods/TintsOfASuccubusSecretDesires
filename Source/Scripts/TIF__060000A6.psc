;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__060000A6 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
AzuraFadeToBlack.Apply()
        GameHours.Mod(1) ; TODO
        Utility.Wait(2.5)
        ImageSpaceModifier.RemoveCrossFade(3)
tdAct.RefreshEnergy(100)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ImageSpaceModifier Property AzuraFadeToBlack  Auto  

GlobalVariable Property GameHours  Auto   

tssd_actions Property tdAct  Auto  
