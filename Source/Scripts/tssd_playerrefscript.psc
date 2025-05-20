Scriptname tssd_playerrefscript extends ReferenceAlias  

import tssd_utils

Int Property undeadKilled Auto
Form Property Gold001 Auto
Faction Property ThievesGuildFaction Auto
Faction Property DarkBrotherhoodFaction Auto
Actor Property PlayerRef Auto
Quest Property tssd_dealwithcurseQuest Auto
GlobalVariable Property TSSD_deityblessquestakglobal Auto
GlobalVariable Property TSSD_deityblessquestmaglobal Auto
GlobalVariable Property TSSD_deityblessquestztglobal Auto
GlobalVariable Property TSSD_deityblessqueststglobal Auto
GlobalVariable Property TSSD_deityblessquestakglobalcor Auto
GlobalVariable Property TSSD_deityblessquestztglobalcor Auto
GlobalVariable Property TSSD_deityblessqueststglobalcor Auto
GlobalVariable Property TSSD_deityblessquestmaglobalcor Auto
Keyword Property IsMerchant Auto
Quest Property RelationshipMarriage Auto

Event OnInit()

    AddInventoryEventFilter(Gold001)
    RegisterForTrackedStatsEvent()
    if RelationshipMarriage.GetStage() >= 100
		GetOwningQuest().ModObjectiveGlobal(1, TSSD_deityblessquestmaglobal, 21, 1)
    else
        PO3_Events_Alias.RegisterForQuestStage(self, RelationshipMarriage)
    endif
EndEvent


Event OnQuestStageChange(Quest akQuest, Int aiNewStage)
	if aiNewStage == 100
		GetOwningQuest().ModObjectiveGlobal(1, TSSD_deityblessquestmaglobal, 21, 1)
        PO3_Events_Alias.UnregisterForQuestStage(self, RelationshipMarriage)
	endif
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    if tssd_dealwithcurseQuest.GetStage() == 20 && !tssd_dealwithcurseQuest.isobjectivefailed(25)
      int lostMoney = ((aiItemCount + 1) / 2) as int
      PlayerRef.RemoveItem(akBaseItem,  lostMoney )
      Debug.Notification("Zenithar takes half your cut!")
      DBGTRace(ThievesGuildFaction)
        if (akSourceContainer as Actor).isInFaction(DarkBrotherhoodFaction) || (akSourceContainer as Actor).isInFaction(ThievesGuildFaction)
            tssd_dealwithcurseQuest.ModObjectiveGlobal(lostMoney, TSSD_deityblessquestztglobalcor, 35, 5000)
        else
            tssd_dealwithcurseQuest.ModObjectiveGlobal(lostMoney, TSSD_deityblessquestztglobal, 25, 10000)
        endif
        advanceStageTwenty()
    endif

endEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    if tssd_dealwithcurseQuest.GetStage() == 20 && !tssd_dealwithcurseQuest.isobjectivefailed(25) && UI.IsMenuOpen("Dialogue Menu")
        int lostMoney = ((aiItemCount + 1) / 2) as int
        if (akDestContainer as Actor).IsInFaction(ThievesGuildFaction)
            tssd_dealwithcurseQuest.ModObjectiveGlobal(lostMoney, TSSD_deityblessquestztglobalcor, 35, 5000)
            Debug.Notification("Zenithar tolerates your trade.")
        else
            Debug.Notification("Zenithar likes your trade!")
            tssd_dealwithcurseQuest.ModObjectiveGlobal(lostMoney, TSSD_deityblessquestztglobal, 25, 10000)
        endif
        advanceStageTwenty()
    endif

endEvent


Event OnTrackedStatsEvent(string asStatFilter, int aiStatValue)
    if tssd_dealwithcurseQuest.GetStage() == 20
        int unKD = Game.QueryStat("Undead Killed") - undeadKilled
        if !tssd_dealwithcurseQuest.isobjectivefailed(23) && unKD > 0
            tssd_dealwithcurseQuest.ModObjectiveGlobal(unKD, TSSD_deityblessquestakglobal, 23, 100)
        endif
        undeadKilled += unKD
        if !tssd_dealwithcurseQuest.isobjectivefailed(22) && ((asStatFilter == "Side Quests Completed") || (asStatFilter == "Quests Completed"))
            tssd_dealwithcurseQuest.ModObjectiveGlobal(1, TSSD_deityblessqueststglobal, 22, 10)
        endif
        if !tssd_dealwithcurseQuest.isobjectivefailed(22) && (asStatFilter == "Thieves' Guild Quests Completed" || asStatFilter == "The Dark Brotherhood Quests Completed" || asStatFilter == "Civil War Quests Completed" || asStatFilter == "Daedric Quests Completed" || asStatFilter == "Dawnguard Quests Completed" || asStatFilter == "Dragonborn Quests Completed")
            tssd_dealwithcurseQuest.ModObjectiveGlobal(1, TSSD_deityblessqueststglobalcor, 32, 5)
        endif
    endif
    advanceStageTwenty()
endEvent

Function advanceStageTwenty()
    int index = 0
    while index < 5
        if tssd_dealwithcurseQuest.IsObjectiveCompleted(31 + index)
            tssd_dealwithcurseQuest.SetObjectiveFailed(21 + index)
        endif
        index += 1
    EndWhile
    index = 0
    bool isCompleted = true
    while index < 5
        if !tssd_dealwithcurseQuest.IsObjectiveCompleted(21 + index) ||  !tssd_dealwithcurseQuest.IsObjectiveCompleted(31 + index)
            isCompleted = false
        endif
        index += 1
    EndWhile
    if isCompleted
        tssd_dealwithcurseQuest.setstage(40)
    endif
Endfunction
