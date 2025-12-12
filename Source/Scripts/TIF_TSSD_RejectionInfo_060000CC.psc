;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF_TSSD_RejectionInfo_060000CC Extends TopicInfo Hidden


;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
akSpeaker.SendModEvent("TSSD_RecejctedEvent", "", 0.0)
;END CODE
EndFunction
;END FRAGMENT


;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
SexLab.StartSceneQuick(PlayerRef, akSpeaker)
PlayerRef.AddItem( Gold001 , 60)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
akSpeaker.SetFactionRank(TSSD_ThrallAggressive,isAggressive)
akSpeaker.SetFactionRank(TSSD_ThrallDominant,isDominant)
akSpeaker.SetFactionRank(TSSD_EnthralledFaction,thrallFaction)
akSpeaker.SetFactionRank(TSSD_ThrallMain,isMain)
;END CODE
EndFunction
;END FRAGMENT



;BEGIN FRAGMENT Fragment_3
Function Fragment_3(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
AzuraFadeToBlack.Apply()
tActions.gainSuccubusXP(1000,1000)
SuccubusDesireLevel.Mod( 100  )	
Utility.Wait(2.5)
ImageSpaceModifier.RemoveCrossFade(3)
GameHour.Mod(1) ; TODO
int upTo = 100
if tssd_dealwithcurseQuest.isRunning() &&  !tssd_dealwithcurseQuest.isobjectivefailed(24)
    upTo = 19
endif
TSSD_Satiated.Cast(PlayerRef,PlayerRef)
if startsSex
    SexLab.StartSceneQuick(PlayerRef, akSpeaker, asTags=sexTags)
endif
;END CODE
EndFunction
;END FRAGMENT


;BEGIN FRAGMENT Fragment_4
Function Fragment_4(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
tActions.gainSuccubusXP(1000,1000)
SuccubusDesireLevel.Mod( 100  )	
TSSD_Satiated.Cast(PlayerRef,PlayerRef)
;END CODE
EndFunction
;END FRAGMENT



;BEGIN FRAGMENT Fragment_5
Function Fragment_5(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
SexLab.StartSceneQuick(PlayerRef, akSpeaker, asTags=sexTags)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
PlayerRef.RemoveItem(Gold001, 20)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Faction Property TSSD_ThrallAggressive Auto
Faction Property TSSD_ThrallDominant Auto
Faction Property TSSD_EnthralledFaction Auto
Faction Property  TSSD_ThrallMain Auto


ImageSpaceModifier Property AzuraFadeToBlack  Auto  

GlobalVariable Property GameHour  Auto   

GlobalVariable Property SuccubusDesireLevel Auto
Quest Property tssd_dealwithcurseQuest Auto
Spell Property tssd_Satiated Auto
Actor Property PlayerRef Auto
TSSD_Actions Property tActions Auto

SexLabFramework Property SexLab Auto


String Property sexTags Auto
int Property isAggressive Auto
int Property isDominant Auto
int Property isMain Auto
int Property thrallFaction Auto
bool Property startsSex Auto


Spell Property TSSD_DrainedMarker Auto
Spell Property TSSD_RejectionPoison Auto


MiscObject Property Gold001 Auto