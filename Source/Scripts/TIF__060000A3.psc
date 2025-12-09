;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__060000A3 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
akSpeaker.SetFactionRank(TSSD_EnthralledFaction,3)
akSpeaker.SetFactionRank(TSSD_ThrallAggressive,0)
akSpeaker.SetFactionRank(TSSD_ThrallDominant,0)
akSpeaker.SetFactionRank(TSSD_ThrallSubmissive,1)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment


Faction Property TSSD_ThrallAggressive Auto
Faction Property TSSD_ThrallDominant Auto
Faction Property  TSSD_EnthralledFaction Auto
Faction Property  TSSD_ThrallSubmissive Auto
