;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 10
Scriptname TSSD_QF_TSSD_StartCurse_070003C7 Extends Quest Hidden

;BEGIN ALIAS PROPERTY trapDoor
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_trapDoor Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CurseQuestGiver
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CurseQuestGiver Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CurseStartHouse
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_CurseStartHouse Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CursedWoman
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CursedWoman Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DangerousDoor
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_DangerousDoor Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
Alias_CursedWoman.GetActorRef().SetRelationshipRank( Game.GetPlayer() ,3)
SetObjectiveCompleted(20, true)
SetObjectiveDisplayed(30, true)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE tssd_SucieProps
Quest __temp = self as Quest
tssd_SucieProps kmyQuest = __temp as tssd_SucieProps
;END AUTOCAST
;BEGIN CODE
RegisterForSleep()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
SetStage(30)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
SetObjectiveDisplayed(5, true)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
SetObjectiveCompleted(0, true)
SetObjectiveDisplayed(10, true)

		SexLab.AddCumFxLayers( Alias_CursedWoman.GetActorRef(), 0, 4)
		SexLab.AddCumFxLayers( Alias_CursedWoman.GetActorRef(), 1, 4)
		SexLab.AddCumFxLayers( Alias_CursedWoman.GetActorRef(), 2, 4)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
SetObjectiveDisplayed(9, true)
(Alias_CursedWoman.GetReference() as TSSD_SucieDailyScript).initPania()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
SetObjectiveDisplayed(20, true)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SexLabFramework Property SexLab Auto
import tssd_utils
Spell Property TSSD_ReflectOn Auto

Event OnSleepStop(bool abInterrupted)
	UnregisterForSleep()
	Game.GetPlayer().AddSpell(TSSD_ReflectOn)
	SetStage(5)
endEvent
