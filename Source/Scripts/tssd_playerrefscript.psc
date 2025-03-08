Scriptname tssd_playerrefscript extends ReferenceAlias  

import tssd_utils
Form Property Gold001 auto
Actor Property PlayerRef Auto
Quest Property tssd_dealwithcurseQuest Auto
GlobalVariable Property TSSD_deityblessquestakglobal Auto
GlobalVariable Property TSSD_deityblessquestztglobal Auto
GlobalVariable Property TSSD_deityblessqueststglobal Auto
GlobalVariable Property TSSD_deityblessquestakglobalcor Auto
GlobalVariable Property TSSD_deityblessquestztglobalcor Auto
GlobalVariable Property TSSD_deityblessqueststglobalcor Auto
Keyword Property IsMerchant Auto

Event OnInit()

    AddInventoryEventFilter(Gold001)
    RegisterForTrackedStatsEvent()
    PO3_Events_Form.RegisterForQuestStage(Playerref, none)

EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    if tssd_dealwithcurseQuest.GetStage() == 20 && !tssd_dealwithcurseQuest.isobjectivefailed(25)
      int lostMoney = ((aiItemCount + 1) / 2) as int
      PlayerRef.RemoveItem(akBaseItem,  lostMoney )
      Debug.Notification("Zenithar takes half your cut!")
      tssd_dealwithcurseQuest.ModObjectiveGlobal(lostMoney, TSSD_deityblessquestztglobal, 25)
    endif

endEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    if tssd_dealwithcurseQuest.GetStage() == 20 && !tssd_dealwithcurseQuest.isobjectivefailed(25) && UI.IsMenuOpen("Dialogue Menu")
      int lostMoney = ((aiItemCount + 1) / 2) as int
      Debug.Notification("Zenithar likes your trade!")
      tssd_dealwithcurseQuest.ModObjectiveGlobal(lostMoney, TSSD_deityblessquestztglobal, 25)
    endif

endEvent


Event OnTrackedStatsEvent(string asStatFilter, int aiStatValue)
      if tssd_dealwithcurseQuest.GetStage() == 20 
        if !tssd_dealwithcurseQuest.isobjectivefailed(23) && (asStatFilter == "Undead Killed") 
            tssd_dealwithcurseQuest.ModObjectiveGlobal(1, TSSD_deityblessquestakglobal, 23)
        endif
        if !tssd_dealwithcurseQuest.isobjectivefailed(22) && ((asStatFilter == "Side Quests Completed") || (asStatFilter == "Quests Completed"))
            tssd_dealwithcurseQuest.ModObjectiveGlobal(1, TSSD_deityblessqueststglobal, 22)
        endif
        if !tssd_dealwithcurseQuest.isobjectivefailed(22) && (asStatFilter == "Thieves' Guild Quests Completed" || asStatFilter == "The Dark Brotherhood Quests Completed" || asStatFilter == "Civil War Quests Completed" || asStatFilter == "Daedric Quests Completed" || asStatFilter == "Dawnguard Quests Completed" || asStatFilter == "Dragonborn Quests Completed")
            tssd_dealwithcurseQuest.ModObjectiveGlobal(1, TSSD_deityblessqueststglobalcor, 32)
        endif




    endif

endEvent