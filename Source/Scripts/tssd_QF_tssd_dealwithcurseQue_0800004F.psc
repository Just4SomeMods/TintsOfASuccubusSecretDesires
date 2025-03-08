;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname tssd_QF_tssd_dealwithcurseQue_0800004F Extends Quest Hidden

;BEGIN ALIAS PROPERTY PlayRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayRef Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN AUTOCAST TYPE tssd_curequestvariables
Quest __temp = self as Quest
tssd_curequestvariables kmyQuest = __temp as tssd_curequestvariables
;END AUTOCAST
;BEGIN CODE
SetObjectiveCompleted(10)
SetObjectiveDisplayed(21)
SetObjectiveDisplayed(22)
SetObjectiveDisplayed(23)
SetObjectiveDisplayed(24)
SetObjectiveDisplayed(25)
kmyQuest.ArkayCurse = true
kmyQuest.DibellaCurse = true
kmyQuest.MaraCurse = true
kmyQuest.StendarrCurse = true
kmyQuest.ZenitharCurse = true
PlayerRef.Addperk(TSSD_DivineCursePerk)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Actor Property PlayerRef  Auto  

Perk Property TSSD_DivineCursePerk  Auto  
