Scriptname TSSD_SucieDailyScript extends ObjectReference  

Faction Property TSSD_EnthralledFaction Auto
Faction Property TSSD_ThrallDominant Auto
Faction Property TSSD_ThrallSubmissive Auto
bool Property cumVisible Auto Conditional
float lastTime 
SexLabFramework Property SexLab Auto
tssd_SucieProps Property tProps Auto

import tssd_utils

Event OnInit()
    (self as Actor).SetRestrained(true)
    cumVisible = true
    RegisterForUpdateGameTime(1)
    Maintenance()
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
        SLIF_Morph.morph(self as actor, "TSSDBodyMorph", nodes[j], nodeMod/ divStep , "")
        j += 1
    endWhile
EndEvent

Event OnUpdateGameTime()
    Actor myself = self as Actor
    if lastTime +1 < Utility.GetCurrentGameTime()
        if myself.GetFactionRank(TSSD_EnthralledFaction) >= 0
            int switchie = Utility.RandomInt(1,3)
            myself.RemoveFromFaction(TSSD_ThrallDominant)
            myself.RemoveFromFaction(TSSD_ThrallSubmissive)
            if switchie == 2
                myself.SetFactionRank(TSSD_ThrallSubmissive,1)
            elseif switchie == 3
                myself.SetFactionRank(TSSD_ThrallDominant,1)
            endif
        endif
        lastTime = Utility.GetCurrentGameTime()
    endif
    
    if tProps.isCumVisible
	    SexLab.AddCumFxLayers(self as actor, 2, 1)
	    SexLab.AddCumFxLayers(self as actor, 1, 1)
	    SexLab.AddCumFxLayers(self as actor, 0, 1)
    endif
EndEvent
