Scriptname tssd_dialogue extends Quest  

import tssd_utils

Faction Property TSSD_ThrallAggressive Auto
Faction Property TSSD_ThrallDominant Auto
Faction Property TSSD_EnthralledFaction Auto
Faction Property TSSD_ThrallSubmissive Auto
Faction Property TSSD_ThrallMain Auto
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

MiscObject Property Gold001 Auto

Quest Property tssd_queststart Auto

String lastDialogue
Actor lastDialoguePartner

; Functions
Function onGameReload()
    RegisterForModEvent("TSSD_HumiliationDoneEvent","HumiDone") 
    RegisterForModEvent("TSSD_RecejctedEvent","OnSuccRejected") 
    RegisterForModEvent("TSSD_DialogueFinished","DialogueFinished") 
Endfunction

; Events

Event DialogueFinished(string eventName, string strArg, float numArg, Form sender)
    if StringUtil.Find( strArg, "TSSD_") >= 0
        lastDialogue = strArg
        lastDialoguePartner = sender as Actor
        RegisterForMenu("Dialogue Menu")
    endif
    if strArg == "TSSD_000DD"
        UnRegisterForMenu("Dialogue Menu")
        lastDialogue = ""
        lastDialoguePartner = none
    endif
EndEvent

Event OnMenuClose(String MenuName)
    if lastDialogue == ""
        UnRegisterForMenu("Dialogue Menu")
        return
    elseif lastDialogue == "TSSD_000C7"
        lastDialoguePartner.SendModEvent("TSSD_RecejctedEvent", "", 0.0)
    elseif lastDialogue == "TSSD_000C6"
        GenericRefreshPSex(lastDialoguePartner, true, "aggressive")
    elseif lastDialogue == "TSSD_000D2"
        PlayerRef.AddItem(Gold001, 50)
        GenericRefreshPSex(lastDialoguePartner, true)
    elseif lastDialogue == "TSSD_000CD"
        PlayerRef.RemoveItem(Gold001, 20)
        GenericRefreshPSex(lastDialoguePartner, true)
    elseif lastDialogue == "TSSD_000E1"
        PlayerRef.RemoveItem(Gold001, 50)
        GenericRefreshPSex(lastDialoguePartner, true)
    elseif lastDialogue == "TSSD_00096"
        GenericRefreshPSex(lastDialoguePartner, true, "love")
    elseif StringUtil.Find( "TSSD_000C4 TSSD_00096", lastDialogue) >= 0
        GenericRefreshPSex(lastDialoguePartner, true, "kissing, limitedstrip, -sex")
    elseif StringUtil.Find( "TSSD_000A6 TSSD_000B0 TSSD_000DA TSSD_000EE TSSD_000F5", lastDialogue) >= 0
        GenericRefreshPSex(lastDialoguePartner, false, "")
    elseif StringUtil.Find( "TSSD_000A1 TSSD_000A2 TSSD_000A3", lastDialogue) >= 0
        int mxAmount = 1
        if PlayerRef.HasPerk(TSSD_Base_PolyThrall3)
            mxAmount = 10
        elseif PlayerRef.HasPerk(TSSD_Base_PolyThrall2)
            mxAmount = 3
        endif
        string outMessage = ""
        while PO3_SKSEFunctions.GetAllActorsInFaction(TSSD_EnthralledFaction).Length >= mxAmount
            Actor cToDelete = PO3_SKSEFunctions.GetAllActorsInFaction(TSSD_EnthralledFaction)[0]
            cToDelete.RemoveFromFaction(TSSD_EnthralledFaction)
            cToDelete.RemoveFromFaction(TSSD_ThrallMain)
            cToDelete.RemoveFromFaction(TSSD_ThrallSubmissive)
            cToDelete.RemoveFromFaction(PlayerFaction)
            cToDelete.RemoveFromFaction(PlayerMarriedFaction)
            cToDelete.SetRelationshipRank(PlayerRef, -1)
            if outMessage == ""
                outMessage = cToDelete.GetDisplayName()
            else
                outMessage = outMessage + " and " + cToDelete.GetDisplayName()
            endif
        endwhile 
        if outMessage != ""
            T_Show("I don't think " + outMessage + " loves me anymore!", "", 0)
        endif       

        if lastDialogue == "TSSD_000A1"
            lastDialoguePartner.SetFactionRank(TSSD_EnthralledFaction, 1)
            lastDialoguePartner.SetRelationshipRank(PlayerRef, 4)
        elseif lastDialogue == "TSSD_000A2"
            lastDialoguePartner.SetFactionRank(TSSD_EnthralledFaction, 1)
            lastDialoguePartner.SetFactionRank(TSSD_ThrallMain, 1)
            lastDialoguePartner.SetRelationshipRank(PlayerRef, 4)
        elseif lastDialogue == "TSSD_000A3"
            lastDialoguePartner.SetFactionRank(TSSD_ThrallSubmissive, 1)
        endif
        lastDialoguePartner.SetFactionRank(TSSD_EnthralledFaction, 1)
        lastDialoguePartner.SetRelationshipRank(PlayerRef, 4)
        lastDialoguePartner.AddtoFaction(PlayerFaction)
        lastDialoguePartner.AddtoFaction(PlayerMarriedFaction)
        tssd_queststart.SetStage(10)
    elseif lastDialogue == "TSSD_000B2"
        GenericRefreshPSex(lastDialoguePartner, false, "")
        SexLab.AddCumFxLayers(PlayerRef, 0, 8)
        SexLab.AddCumFxLayers(PlayerRef, 1, 8)
        SexLab.AddCumFxLayers(PlayerRef, 2, 8)
    endif
    DBGTRACE(lastDialogue)
    UnRegisterForMenu("Dialogue Menu")
    lastDialogue = ""
    lastDialoguePartner = none
EndEvent

Event HumiDone(string eventName, string strArg, float numArg, Form sender)
    Utility.Wait(1)
    UI.InvokeString("HUD Menu", "_global.skse.CloseMenu", "Dialogue Menu")
    TSSD_Satiated.Cast(sender as Actor, PlayerRef)
    tActions.RefreshEnergy(100)
EndEvent


Event OnSuccRejected(string eventName, string strArg, float numArg, Form sender)
        TSSD_DrainedMarker.Cast(PlayerRef, (sender as Actor))
        TSSD_PoisonForSuccubus.Cast((sender as Actor), PlayerRef)        
        T_Show("Getting rejected hurts!"  , "icon.dds", aiDelay = 0.0)
endevent


Function GenericRefreshPSex( Actor target, bool startsSex = false, String sexTags = "" )
    Actor akSpeaker = target as Actor

    AzuraFadeToBlack.Apply()
    GameHour.Mod(1) 
    tActions.gainSuccubusXP(1000,1000)
    SuccubusDesireLevel.Mod( 100  )	
    Utility.Wait(2.5)
    ImageSpaceModifier.RemoveCrossFade(3)
    int upTo = 100
    if tssd_dealwithcurseQuest.isRunning() &&  !tssd_dealwithcurseQuest.isobjectivefailed(24)
        upTo = 19
    endif
    PlayerRef.DispelSpell(TSSD_Satiated)
    if startsSex
        SexLab.StartSceneQuick(PlayerRef, akSpeaker, asTags=sexTags)
    endif
    Utility.Wait(2.5)
    DBGTRACE(TSSD_Satiated.Cast(akSpeaker, PlayerRef))

EndFunction