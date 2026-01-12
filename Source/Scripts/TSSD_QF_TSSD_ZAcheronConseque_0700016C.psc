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
Spell Property tssd_Satiated Auto
GlobalVariable Property SuccubusDesireLevel Auto
Faction Property CurrentFollowerFaction Auto
Perk Property TSSD_Base_Explanations Auto
Actor[] nTargets

import tssd_utils


Event HookDefeatEnd(int aiThreadID, bool abHasPlayer)
    int indexIn = 0
    while indexIn < nTargets.Length
        Sexlab.GetThreadByActor(nTargets[indexIn]).Stop()
        nTargets[indexIn].Kill()
        indexIn += 1
    endWhile
	Acheron.RescueActor(PlayerRef)
    PlayerRef.DispelSpell(tssd_Satiated)
	Stop()
	Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")

	
EndEvent

Function doFakeOut()
    nTargets = PapyrusUtil.ActorArray(0)
    Actor[] pTargets = MiscUtil.ScanCellNPCs(PlayerRef, 70 * 50)
    Actor[] targets = new Actor[1]
    targets[0] = PlayerRef
    int indexIn = 0
    while indexIn < pTargets.Length && targets.Length < 4
        Actor cAct = pTargets[indexIN]
        if cAct.isHostileToActor(PlayerRef) && !cAct.isDead() && !cAct.IsDisabled()
            targets = PapyrusUtil.PushActor(targets, cAct)
        endif
        indexIN += 1
    endwhile

    RegisterForModEvent("HookAnimationEnd_TSSD_DefeatEndHook", "HookDefeatEnd")
    While Sexlab.StartScene(targets, "aggressive, -bound, -stimulation, -sextoy, -furniture", akSubmissive=PlayerRef,asHook="TSSD_DefeatEndHook" ) == none
        Ntargets = PapyrusUtil.PushActor(Ntargets, targets[-1])
        targets = PapyrusUtil.ResizeActorArray(targets, targets.Length - 1)
        if targets.Length == 1
            Acheron.RescueActor(PlayerRef)
            Stop()
            return
        endif
    endwhile
    Actor[] allFolls = PO3_SKSEFunctions.GetAllActorsInFaction(CurrentFollowerFaction)
    int indexInFol = 0
    while indexInFol < allFolls.Length
        Sexlab.StartSceneQuick(allFolls[indexInFol])
        indexInFol += 1
    endwhile
    indexInFol = 0
    while indexInFol < Ntargets.Length
        Sexlab.StartSceneQuick(Ntargets[indexInFol])
        indexInFol += 1
    endwhile
    SuccubusDesireLevel.Mod(-20 * pTargets.Length + 20)
EndFunction
