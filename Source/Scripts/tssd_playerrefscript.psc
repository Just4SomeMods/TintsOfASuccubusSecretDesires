Scriptname tssd_playerrefscript extends ReferenceAlias  

import tssd_utils

tssd_actions Property tActions Auto
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
GlobalVariable Property TSSD_deityblessquestjhglobal Auto
Keyword Property IsMerchant Auto
Quest Property RelationshipMarriage Auto
Quest Property dunHunterQST Auto

Event OnInit()

    ; AddInventoryEventFilter(Game.GetFormFromFile(0xf,"skyrim.esm"))
    RegisterForTrackedStatsEvent()
    if RelationshipMarriage.GetStage() >= 100
        GetOwningQuest().SetObjectiveCompleted(22, true)
    else
        PO3_Events_Alias.RegisterForQuestStage(self, RelationshipMarriage)
    endif
    if dunHunterQST.IsCompleted()
        GetOwningQuest().SetObjectiveCompleted(21, true)
    else
        PO3_Events_Alias.RegisterForQuestStage(self, dunHunterQST)
    endif
	PO3_Events_Alias.RegisterForActorKilled(self)
EndEvent


Event OnQuestStageChange(Quest akQuest, Int aiNewStage)
	if aiNewStage == 100
        if akQuest == RelationshipMarriage
            GetOwningQuest().SetObjectiveCompleted(21, true)
            PO3_Events_Alias.UnregisterForQuestStage(self, RelationshipMarriage)
        elseif akQuest == dunHunterQST
            GetOwningQuest().SetObjectiveCompleted(22, true)
            PO3_Events_Alias.UnregisterForQuestStage(self, dunHunterQST)
        endif
	endif
EndEvent

;/ Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    if tssd_dealwithcurseQuest.GetStage() == 20 && !tssd_dealwithcurseQuest.isobjectivefailed(25) && aiItemCount < 1000
        int lostMoney = ((aiItemCount + 1) / 2) as int
        PlayerRef.RemoveItem(akBaseItem,  lostMoney )
        Debug.Notification("Zenithar takes half your cut!")
        if akSourceContainer as Actor && (akSourceContainer as Actor).isInFaction(DarkBrotherhoodFaction) || (akSourceContainer as Actor).isInFaction(ThievesGuildFaction)
            tssd_dealwithcurseQuest.ModObjectiveGlobal(lostMoney, TSSD_deityblessquestztglobalcor, 35, 5000)
        else
            tssd_dealwithcurseQuest.ModObjectiveGlobal(lostMoney, TSSD_deityblessquestztglobal, 25, 10000)
        endif
        advanceStageTwenty()
    endif

endEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    if tssd_dealwithcurseQuest.GetStage() == 20 && !tssd_dealwithcurseQuest.isobjectivefailed(25) && UI.IsMenuOpen("Dialogue Menu") && akDestContainer as Actor
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

endEvent /;


Event OnTrackedStatsEvent(string asStatFilter, int aiStatValue)
    if tssd_dealwithcurseQuest.GetStage() == 20
        if asStatFilter == "Dragon Souls Collected" && !tssd_dealwithcurseQuest.isobjectivefailed(25)
            tActions.increaseGlobalDeity(4,1,10)
        endif
        
        if asStatFilter == "Skill Increases" && !tssd_dealwithcurseQuest.isobjectivefailed(23)
            tActions.increaseGlobalDeity(2,1,250)
        endif
        ;/ 
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
        endif /;
    endif
    tActions.advanceStageTwenty()
endEvent


Event OnActorKilled(Actor akVictim, Actor akKiller)
;/ 	if PlayerRef.HasPerk(TSSD_DeityArkayPerk)
		tActions.RefreshEnergy(5)
	endif /;
	if PlayerRef == akKiller &&  tActions.tssd_dealwithcurseQuest.isRunning() && !tActions.tssd_dealwithcurseQuest.isobjectivefailed(24) ; Dibella
		tActions.increaseGlobalDeity(3, 50 - akVictim.GetAV("Speechcraft"),10000)
	endif
EndEvent