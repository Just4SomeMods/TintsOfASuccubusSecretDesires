;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF_TSSD_RejectionInfo_060000CC Extends TopicInfo Hidden

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
