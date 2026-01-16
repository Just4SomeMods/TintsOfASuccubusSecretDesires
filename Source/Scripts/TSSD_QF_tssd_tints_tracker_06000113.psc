;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 31
Scriptname TSSD_QF_tssd_tints_tracker_06000113 Extends Quest Hidden

;BEGIN ALIAS PROPERTY PlayerAlias
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerAlias Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_27
Function Fragment_27()
;BEGIN CODE
Game.TeachWord(TSSD_WordSuck)
PlayerRef.AddShout(TSSD_DragonRendShout)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_14
Function Fragment_14()
;BEGIN CODE
SetObjectiveDisplayed(7, true)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_24
Function Fragment_24()
;BEGIN CODE
SetObjectiveDisplayed(21, true)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
TSSD_SuccubusPerkPoints.Mod(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN AUTOCAST TYPE tssd_tints_variables
Quest __temp = self as Quest
tssd_tints_variables kmyQuest = __temp as tssd_tints_variables
;END AUTOCAST
;BEGIN CODE
tEvents.addToLilac()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_30
Function Fragment_30()
;BEGIN CODE
Game.GetPlayer().SendModEvent("TSSD_Inflate", "carmine",  1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
PlayerRef.SetFactionRank(sla_arousal, 99)
PlayerRef.SetFactionRank(sla_arousal_locked, 1)
SetObjectiveCompleted(5, true)
SetObjectiveDisplayed(5, true)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Faction Property sla_Arousal_Locked Auto
Faction Property sla_Arousal Auto
Actor Property PlayerRef Auto

tssd_PlayerEventsScript Property tEvents  Auto  

GlobalVariable Property TSSD_SuccubusPerkPoints  Auto  
WordOfPower Property TSSD_WordSuck Auto
Shout Property TSSD_DragonRendShout Auto
