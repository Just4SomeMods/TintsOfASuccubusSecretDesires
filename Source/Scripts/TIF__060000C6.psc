;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__060000C6 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
AzuraFadeToBlack.Apply()
tActions.gainSuccubusXP(1000,1000)
   SuccubusDesireLevel.Mod( 100  )	
Sexlab.StartSceneQuick(akActor1 = PlayerRef, akActor2 = akSpeaker , akSubmissive = PlayerRef)
        Utility.Wait(2.5)
        ImageSpaceModifier.RemoveCrossFade(3)
        GameHours.Mod(1) ; TODO
TSSD_Satiated.Cast(PlayerRef,PlayerRef)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ImageSpaceModifier Property AzuraFadeToBlack  Auto  

GlobalVariable Property GameHours  Auto   

GlobalVariable Property SuccubusDesireLevel Auto
Quest Property tssd_dealwithcurseQuest Auto
Spell Property tssd_Satiated Auto
Actor Property PlayerRef Auto
TSSD_Actions Property tActions Auto
SexLabFramework Property SexLab Auto
