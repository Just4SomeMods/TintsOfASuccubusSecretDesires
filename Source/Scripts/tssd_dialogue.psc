Scriptname tssd_dialogue extends Quest  

import tssd_utils

tssd_PlayerEventsScript Property tPEvents Auto

Faction Property TSSD_ThrallDominant Auto
Faction Property TSSD_EnthralledFaction Auto
Faction Property TSSD_ThrallSubmissive Auto
Faction Property PlayerFaction Auto
Faction Property PlayerMarriedFaction Auto

ImageSpaceModifier Property AzuraFadeToBlack  Auto  

GlobalVariable Property GameHour  Auto   

GlobalVariable Property SuccubusDesireLevel Auto
Quest Property tssd_dealwithcurseQuest Auto
Spell Property tssd_Satiated Auto
Spell Property TSSD_PoisonForSuccubus Auto
Actor Property PlayerRef Auto
TSSD_Actions Property tActions Auto

Perk Property TSSD_Base_PolyThrall2 Auto
Perk Property TSSD_Base_PolyThrall3 Auto

SexLabFramework Property SexLab Auto

Spell Property TSSD_DrainedMarker Auto
Spell Property TSSD_CompelledSpell Auto


MiscObject Property Gold001 Auto

Quest Property tssd_queststart Auto
Quest Property tssd_tints_tracker Auto

String lastDialogue
Actor lastDialoguePartner

Faction Property TSSD_HypnoMaster Auto
Faction Property TSSD_PotentialHypnoMaster Auto

; Functions
Function onGameReload()
    RegisterForModEvent("TSSD_HumiliationDoneEvent","HumiDone") 
    RegisterForModEvent("TSSD_RecejctedEvent","OnSuccRejected") 
    RegisterForModEvent("TSSD_DialogueFinished","DialogueFinished") 
    RegisterForModEvent("TSSD_AskedForTraining","TrainingAsked")
Endfunction

; Events

Event TrainingAsked(string eventName, string strArg, float numArg, Form sender)
    RegisterForMenu("Training Menu")
endevent

Event DialogueFinished(string eventName, string strArg, float numArg, Form sender)
    if strArg == "TSSD_00155"
        return
    elseif strArg == "TSSD_000DD"
        UnRegisterForMenu("Dialogue Menu")
        lastDialogue = ""
        lastDialoguePartner = none
    elseif StringUtil.Find( strArg, "TSSD_") >= 0
        lastDialogue = strArg
        lastDialoguePartner = sender as Actor
        RegisterForMenu("Dialogue Menu")
    endif
EndEvent

Event OnMenuOpen(String MenuName)
    if MenuName == "Training Menu"
        if lastDialoguePartner
            lastDialoguePartner.SetFactionRank(TSSD_PotentialHypnoMaster, 1)
        endif
        tActions.tOrgasmLogic.incrValAndCheck(18, 1)
        UnRegisterForMenu("Training Menu")
    endif
Endevent

Event OnMenuClose(String MenuName)
    if MenuName == "Dialogue Menu"
        UnRegisterForMenu("Dialogue Menu")
        UnRegisterForMenu("Training Menu")
        if lastDialoguePartner && lastDialoguePartner.GetFactionRank(TSSD_HypnoMaster) >= 1
            tPEvents.tVals.lastHypnoSession = 0.1
        endif
        if lastDialogue == ""
            return
        else
            TSSD_DrainedMarker.Cast(PlayerRef, lastDialoguePartner)
        endif
        if lastDialogue != "TSSD_000C7" && lastDialoguePartner.GetRelationshipRank(PlayerRef) >= 1
            tActions.tOrgasmLogic.incrValAndCheck(19,1)
        endif
        if lastDialogue == "TSSD_000C7"
            lastDialoguePartner.SendModEvent("TSSD_RecejctedEvent", "", 0.0)
        elseif lastDialogue == "TSSD_000C6"
            tActions.tOrgasmLogic.incrValAndCheck(20,1)
            GenericRefreshPSex(lastDialoguePartner, true, "aggressive")
        elseif lastDialogue == "TSSD_000D2"
            PlayerRef.AddItem(Gold001, 50)
            GenericRefreshPSex(lastDialoguePartner, true)
        elseif lastDialogue == "TSSD_000CD"
            PlayerRef.RemoveItem(Gold001, 20)
            GenericRefreshPSex(lastDialoguePartner, true)
        elseif lastDialogue == "TSSD_000E1"
            PlayerRef.AddItem(Gold001, 50)
            GenericRefreshPSex(lastDialoguePartner, false)
        elseif lastDialogue == "TSSD_00098"
            tActions.tOrgasmLogic.incrValAndCheck(3,1)
            GenericRefreshPSex(lastDialoguePartner, true, "love")
        elseif StringUtil.Find( "TSSD_00096", lastDialogue) >= 0
            tActions.tOrgasmLogic.incrValAndCheck(3,1)
            GenericRefreshPSex(lastDialoguePartner, true, "kissing, -sex")
        elseif StringUtil.Find( "TSSD_000A6 TSSD_000B0 TSSD_000DA TSSD_000EE TSSD_000F5", lastDialogue) >= 0
            GenericRefreshPSex(lastDialoguePartner, false, "")
            if lastDialogue == "TSSD_000EE"
                tActions.tOrgasmLogic.incrValAndCheck(15,1)
            endif
        elseif StringUtil.Find( "TSSD_000A1 TSSD_000A2 TSSD_000A3", lastDialogue) >= 0
            int mxAmount = 1
            if PlayerRef.HasPerk(TSSD_Base_PolyThrall3)
                mxAmount = 10
            elseif PlayerRef.HasPerk(TSSD_Base_PolyThrall2)
                mxAmount = 3
            endif
            string outMessage = ""
            Actor[] allThralls = PO3_SKSEFunctions.GetAllActorsInFaction(TSSD_EnthralledFaction)
            while allThralls.Length >= mxAmount
                Actor cToDelete = allThralls[ Utility.RandomInt(0, allThralls.Length - 1) ]
                cToDelete.RemoveFromFaction(TSSD_EnthralledFaction)
                cToDelete.RemoveFromFaction(TSSD_ThrallSubmissive)
                cToDelete.RemoveFromFaction(PlayerFaction)
                cToDelete.RemoveFromFaction(PlayerMarriedFaction)
                cToDelete.SetRelationshipRank(PlayerRef, 3)
                if outMessage == ""
                    outMessage = cToDelete.GetDisplayName()
                else
                    outMessage = outMessage + " and " + cToDelete.GetDisplayName()
                endif
            endwhile 
            if outMessage != ""
                T_Show("I don't think " + outMessage + " loves me anymore!", "", 0)
            endif
            if lastDialogue == "TSSD_000A2"
                lastDialoguePartner.SetFactionRank(TSSD_ThrallDominant, 1)
                
            elseif lastDialogue == "TSSD_000A3"
                lastDialoguePartner.SetFactionRank(TSSD_ThrallSubmissive, 1)
            endif
            lastDialoguePartner.SetFactionRank(TSSD_EnthralledFaction, 1)
            lastDialoguePartner.SetRelationshipRank(PlayerRef, 4)
            tssd_tints_tracker.SetObjectiveCompleted(19, true)
            tssd_tints_tracker.SetObjectiveDisplayed(19, true)
        elseif lastDialogue == "TSSD_00109"
            lastDialoguePartner.SetFactionRank(TSSD_EnthralledFaction, -1)
        elseif lastDialogue == "TSSD_000B2"
            tActions.tOrgasmLogic.incrValAndCheck(0,1)
            GenericRefreshPSex(lastDialoguePartner, true, "aircum", true)
            if lastDialoguePartner.GetFactionRank(tPEvents.SOS_SchlongifiedFaction) >= 1
                SexLab.AddCumFxLayers(PlayerRef, 0, 1)
                SexLab.AddCumFxLayers(PlayerRef, 1, 1)
                SexLab.AddCumFxLayers(PlayerRef, 2, 1)
            endif
            if    PlayerRef.GetFactionRank(tPEvents.SOS_SchlongifiedFaction) >= 1
                SexLab.AddCumFxLayers(lastDialoguePartner, 0, 1)
                SexLab.AddCumFxLayers(lastDialoguePartner, 1, 1)
                SexLab.AddCumFxLayers(lastDialoguePartner, 2, 1)
            endif
        elseif lastDialogue == "TSSD_000F7"
            GenericRefreshPSex(lastDialoguePartner, true, "facesit")
        elseif lastDialogue == "TSSD_00111"
            tActions.tOrgasmLogic.incrValAndCheck(7,1)
            GenericRefreshPSex(lastDialoguePartner, true, "~grope, -leadIn, ~holding, ~hugging, ~cuddle, ~facesit, ~fingering, -zaz, -bound, -DeviousDevice")
        elseif lastDialogue == "TSSD_0010E"
            GenericRefreshPSex(lastDialoguePartner, false)
            Sexlab.StartSceneQuick(lastDialoguePartner)
        elseif lastDialogue == "TSSD_00133"
            lilacBeg(lastDialoguePartner)
        elseif lastDialogue == "TSSD_00139"
            GenericRefreshPSex(lastDialoguePartner, false, "")
            SexLab.StartSceneQuick(PlayerRef)
        elseif lastDialogue == "TSSD_0013D"
            if lastDialoguePartner.GetFactionRank(tPEvents.SOS_SchlongifiedFaction) >= 1
            tActions.tOrgasmLogic.incrValAndCheck(1,1)
                GenericRefreshPSex(lastDialoguePartner, true, "blowjob")
            else
                GenericRefreshPSex(lastDialoguePartner, true, "~boobsuck, ~breastfeed, ~breastfeeding")
            endif
        elseif lastDialogue == "TSSD_00142"        
            tPEvents.tVals.lastHypnoSession = 0.1
            tActions.tOrgasmLogic.incrValAndCheck(18, 10)
			TSSD_CompelledSpell.Cast(PlayerRef,PlayerRef)
            if lastDialoguePartner.GetFactionRank(TSSD_HypnoMaster) < 1
                lastDialoguePartner.SetFactionRank(TSSD_HypnoMaster, 1)
            endif
            Actor[] pos = new Actor[2]
            pos[0] = lastDialoguePartner
            pos[1] = PlayerRef
            if SexlabRegistry.LookupScenes(pos, "magic", none, 1, none).Length > 0
                GenericRefreshPSex(lastDialoguePartner, true, "magic")
            else
                GenericRefreshPSex(lastDialoguePartner, true, "aggressive", lastDialoguePartner.GetFactionRank(tPEvents.SOS_SchlongifiedFaction) < 1 )
            endif
        endif
        lastDialogue = ""
        lastDialoguePartner = none
    endif
EndEvent

Function playDefaultIfNotAvailable(Actor[] posTargets, String tagsIn, Actor akSubmissive = none, int aiFurniturePreference=0 )
    if SexlabRegistry.LookupScenes(posTargets, tagsIn, akSubmissive, aiFurniturePreference, none).Length > 0
        SexLab.StartScene(posTargets, tagsIn, akSubmissive)
    else
        Sexlab.StartScene(posTargets, "", akSubmissive)
    endif
endfunction



Function lilacBeg(Actor targetOf)
    DBGTrace("Is dog: " + targetOf.GetRace().HasKeyword(tPEvents.ActorTypeCreature))
    if targetOf.GetRace().HasKeyword(tPEvents.ActorTypeCreature)
        GenericRefreshPSex(targetOf, true, "knotted" )
    elseif targetOf.GetFactionRank(tPEvents.SOS_SchlongifiedFaction) >= 1
        GenericRefreshPSex(targetOf, true, "~doggystyle, ~doggy, -furniture, -zaz, -bound, -DeviousDevice" )
    else
        GenericRefreshPSex(targetOf, true, "dildo, aggressive", true )
    endif
EndFunction

Event HumiDone(string eventName, string strArg, float numArg, Form sender)
    Utility.Wait(1)
    UI.InvokeString("HUD Menu", "_global.skse.CloseMenu", "Dialogue Menu")
    TSSD_Satiated.Cast(sender as Actor, PlayerRef)
    tActions.gainSuccubusXP(1000)
EndEvent


Event OnSuccRejected(string eventName, string strArg, float numArg, Form sender)
    TSSD_PoisonForSuccubus.Cast((sender as Actor), PlayerRef)        
    T_Show("Getting rejected hurts!"  , "menus/tssd/HeartBreak.dds", aiDelay = 0.0)
endevent


Function GenericRefreshPSex( Actor target, bool startsSex = false, String sexTags = "", bool playerActive = false )
    Actor akSpeaker = target as Actor
    AzuraFadeToBlack.Apply()
    TSSD_Satiated.Cast(akSpeaker, PlayerRef)
    GameHour.Mod(1) 
    tActions.gainSuccubusXP(1000)
    ImageSpaceModifier.RemoveCrossFade(3)
    int upTo = 100
    ;/ if tssd_dealwithcurseQuest.isRunning() &&  !tssd_dealwithcurseQuest.isobjectivefailed(24)
        upTo = 35
    endif /;
    SuccubusDesireLevel.SetValue( min( upTo, SuccubusDesireLevel.GetValue() + 100 ) )
    if startsSex
        Actor[] Pos = new Actor[2]
        if playerActive
            Pos[0] = PlayerRef
            Pos[1] = akSpeaker
        else
            Pos[0] = akSpeaker
            Pos[1] = PlayerRef
        endif
        playDefaultIfNotAvailable(Pos, sexTags, none )
    endif
    Utility.Wait(0.1)
    TSSD_Satiated.Cast(akSpeaker, PlayerRef)
EndFunction