;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TSSD_TIF__0A000199 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
bool prevVal = (GetOwningQuest() as tssd_SucieProps).funWithMerchants
(GetOwningQuest() as tssd_SucieProps).funWithMerchants = !prevVal

if prevVal
		T_Show("She pouts a bit")
else
		T_Show("That excited smile is intoxicating")
endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

import tssd_utils
