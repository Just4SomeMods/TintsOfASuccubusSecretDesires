Scriptname TSSD_InflationHandler extends Quest  

GlobalVariable Property SkillSuccubusBodyLevel Auto

import tssd_utils
String Property FILE_SLINFLATION = "sr_FillHerUp.esp" AutoReadOnly 
Actor  Property PlayerRef auto

Function onGameReload()
    RegisterForModEvent("TSSD_Inflate", "InflatePlayer")
EndFunction

Event InflatePlayer(string eventName, string strArg, float numArg, Form sender)
	if Game.getModByName("SexLab Inflation Framework.esp") == 255
		return
	endif
    float divStep = 2
    int j = 0
    String path = ".tssdmorphs." + strArg
    int jMa = JDB.solveObj(path)
    String[] nodes = JMap.allKeysPArray(jMa)
    while j < nodes.length
        String morphFile = nodes[j]
        float nodeMod = JMap.getFlt(jMa, nodes[j])
        SLIF_Morph.morph(sender as Actor, "TSSD_" + strArg, nodes[j], nodeMod * numArg , "")
        j += 1
    endWhile
EndEvent