;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname TSSD_TIF__070003E9 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
(GetOwningQuest() as tssd_SucieProps).isCumVisible = !(GetOwningQuest() as tssd_SucieProps).isCumVisible
if (GetOwningQuest() as tssd_SucieProps).isCumVisible
    SexLab.AddCumFxLayers(akSpeaker, 2, 1)
    SexLab.AddCumFxLayers(akSpeaker, 1, 1)
    SexLab.AddCumFxLayers(akSpeaker, 0, 1)
else
    Sexlab.ClearCum(akSpeaker)
endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
import tssd_utils

SexLabFramework Property SexLab Auto
