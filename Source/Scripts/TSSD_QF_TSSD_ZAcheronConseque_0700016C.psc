;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TSSD_QF_TSSD_ZAcheronConseque_0700016C Extends Quest Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
doFakeOut()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Actor Property PlayerRef Auto
; SexLabFramework Property Sexlab Auto
SexLabFramework Property SexLab  Auto
import tssd_utils


Event HookDefeatEnd(int aiThreadID, bool abHasPlayer)
	Acheron.RescueActor(PlayerRef)
	Stop()
	Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
	
EndEvent

Function doFakeOut()
    
    Actor[] pTargets = MiscUtil.ScanCellNPCs(PlayerRef, 70 * 50)
    Actor[] targets = new Actor[1]
    targets[0] = PlayerRef
    int indexIn = 0
    while indexIn < pTargets.Length && targets.Length < 5
        Actor cAct = pTargets[indexIN]
        if cAct.isHostileToActor(PlayerRef) && !cAct.isDead() && !cAct.IsDisabled()
            targets = PapyrusUtil.PushActor(targets, cAct)
        endif
        indexIN += 1
    endwhile

    RegisterForModEvent("HookAnimationEnd_TSSD_DefeatEndHook", "HookDefeatEnd")

    if Sexlab.StartScene(targets, "aggressive, -bound, -stimulation", akSubmissive=PlayerRef,asHook="TSSD_DefeatEndHook" ) == none
        if Sexlab.StartScene(targets, "", akSubmissive=PlayerRef,asHook="TSSD_DefeatEndHook" ) == none
            Acheron.RescueActor(PlayerRef)
            Stop()
        endif
    endif
EndFunction
