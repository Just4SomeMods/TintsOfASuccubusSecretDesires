Scriptname TSSD_InflationHandler extends Quest  


import tssd_utils
String Property FILE_SLINFLATION = "sr_FillHerUp.esp" AutoReadOnly 
Actor  Property PlayerRef auto

Function onGameReload()
    RegisterForModEvent("TSSD_Inflate", "InflatePlayer")
EndFunction

Event InflatePlayer(string eventName, string strArg, float numArg, Form sender)
    bool targetArea = false
	bool allNodes = !targetArea
    String morphFolder = "../TSSD/TSSDMorphs/"
	String[] baseNodes = JsonUtil.JsonInFolder(morphFolder)
	int i = 0
	bool SLIF = Game.getModByName("SexLab Inflation Framework.esp") != 255
    float divStep = numArg/200
	while i < baseNodes.length
		if allNodes || StringUtil.Substring(baseNodes[i], 0, StringUtil.Find(baseNodes[i], ".json")) == targetArea
			int j = 0
			String morphFile = morphFolder + baseNodes[i]
			String path = ".float."
			String[] nodes = JsonUtil.PathMembers(morphFile, path)
			while j < nodes.length
				float nodeMod = JsonUtil.getFloatValue(morphFile, nodes[j])
                float additionalIn = 0.0
                if nodes[j] == "shoulderwidth"
                    additionalIn = -1.9
                endif
                if nodes[j] == "waist"
                    additionalIn = 3
                endif
                SLIF_Morph.morph(PlayerRef, "TSSDBodyMorph", nodes[j], divStep + additionalIn, "")
				j += 1
			endWhile
		endif
		i += 1
	endWhile
EndEvent