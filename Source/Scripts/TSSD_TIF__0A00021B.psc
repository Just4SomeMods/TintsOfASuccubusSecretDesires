;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname TSSD_TIF__0A00021B Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
PlayerRef.SendModEvent("TSSD_ToggleDeathModeExtern", "", 1) 
    RegisterForModEvent("HookAnimationEnd_TSSD_CharmEndHook", "CharmDefeatEnd")
Sexlab.StartSceneQuick(akSpeaker, PlayerRef,asHook="TSSD_CharmEndHook" )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Spell Property TSSD_DrainHealth Auto
 
import CustomSkills

Actor Property PlayerRef Auto
SexLabFramework Property SexLab Auto
 
import CustomSkills
import tssd_utils

Event CharmDefeatEnd(int aiThreadID, bool abHasPlayer)
    DBGTrace("GETSHERE!")

    int indexIn = 0
    sslThreadController _thread =  Sexlab.GetPlayerController()
    Actor[] nTargets = _thread.GetPositions()
    while indexIn < nTargets.Length
        Actor isPlayer = nTargets[indexIn]
        if isPlayer != PlayerRef
            if CustomSkills.GetAPIVersion() >= 3
                CustomSkills.AdvanceSkill("SuccubusDrainSkill",  isPlayer.GetAv("Health"))
            endif
            TSSD_DrainHealth.SetNthEffectMagnitude(0,  isPlayer.GetAv("Health") + 10 )
            TSSD_DrainHealth.Cast( Game.GetPlayer(), isPlayer)

            Utility.Wait(1)
            isPlayer.Kill( Game.GetPlayer() )
        endif
        indexIn += 1
    endWhile
	Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState" )

    

	
EndEvent
