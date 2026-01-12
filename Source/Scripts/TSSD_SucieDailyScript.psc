Scriptname TSSD_SucieDailyScript extends Actor  

Faction Property TSSD_EnthralledFaction Auto
Faction Property TSSD_ThrallDominant Auto
Faction Property TSSD_ThrallSubmissive Auto
Faction Property CurrentFollowerFaction Auto
Faction Property JobMerchantFaction Auto
float lastTime 
SexLabFramework Property SexLab Auto
tssd_SucieProps Property tProps Auto

Actor Property PlayerRef Auto
Perk Property TSSD_Together_CursedWoman Auto

Spell Property TSSD_DrainedMarker Auto
MagicEffect Property TSSD_DrainedDownSide Auto

import tssd_utils

Function onGameReload()
    RegisterForUpdateGameTime(0.5)
    RegisterForModEvent("TSSD_SeduceMerchant", "trySeduceMerchant")
EndFunction

Function initPania()
    SetRestrained(true)
    tProps.isCumVisible = true
    onGameReload()
    Utility.WaitGameTime(1)    
    bool targetArea = false
    bool allNodes = !targetArea
    bool SLIF = Game.getModByName("SexLab Inflation Framework.esp") != 255
    float divStep = 1
    int j = 0
    String path = ".tssd_morphs.sucie"
    int jMa = JDB.solveObj(path)
    String[] nodes = JMap.allKeysPArray(jMa)
    while j < nodes.length
        String morphFile = nodes[j]
        float nodeMod = JMap.getFlt(jMa, nodes[j])
        SLIF_Morph.morph(self, "TSSDBodyMorph", nodes[j], nodeMod/ divStep , "")
        j += 1
    endWhile
    DBGTrace("Pania ready!")
EndFunction

Event OnUpdateGameTime()
    Actor myself = self
    if lastTime +1 < Utility.GetCurrentGameTime()
        if GetFactionRank(TSSD_EnthralledFaction) >= 0
            int switchie = Utility.RandomInt(1,3)
            RemoveFromFaction(TSSD_ThrallDominant)
            RemoveFromFaction(TSSD_ThrallSubmissive)
            if switchie == 2
                SetFactionRank(TSSD_ThrallSubmissive,1)
            elseif switchie == 3
                SetFactionRank(TSSD_ThrallDominant,1)
            endif
        endif
        lastTime = Utility.GetCurrentGameTime()
    endif
    
    if tProps.isCumVisible
	    SexLab.AddCumFxLayers(self, 2, 1)
	    SexLab.AddCumFxLayers(self, 1, 1)
	    SexLab.AddCumFxLayers(self, 0, 1)
    endif
    RegisterForModEvent("TSSD_SeduceMerchant", "trySeduceMerchant")
EndEvent


Function trySeduceMerchant(string eventName, string strArg, float numArg, Form sender)
    if PlayerRef.HasPerk(TSSD_Together_CursedWoman)
        Actor tempActor = sender as Actor
        SexLab.StartSceneQuick(self, tempActor)
        TSSD_DrainedMarker.Cast(self,tempActor)
    endif

EndFunction
