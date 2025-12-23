Scriptname tssd_me_toFactions extends activemagiceffect  

import b612
import tssd_utils

Event OnEffectStart(Actor akTarget, Actor akCaster)
    
    b612_TraitsMenu TraitsMenu = GetTraitsMenu()
    int jArr = JDB.solveObj(".tssdfactions")
    int index = 0
    Faction[] factionArrs = new Faction[99]
    while index < JValue.count(jArr)
        int innerJ = jArray.getObj(jArr, index)
        String nameOf = JMap.getStr(innerJ, "Name")
        int editId = JMap.Getint(innerJ, "FormKey")
        Faction tFac = Game.GetFormFromFile(editId, "TintsOfASuccubusSecretDesires.esp") as Faction
        factionArrs[index] = tFac
        if akTarget.GetFactionRank(tFac) >= 0
            TraitsMenu.AddItem( "Remove from: " + nameOf, "", "")
        else
            TraitsMenu.AddItem( "Add to: " + nameOf, "", "")
        endif
        index += 1
    endwhile

    String[] outP = TraitsMenu.show(aiMaxSelection = -1)
    index = 0
    while index < outP.Length
        Faction tFac = factionArrs[outP[index] as int]
        if akTarget.GetFactionRank(tFac) >= 0
            akTarget.SetFactionRank(tFac, -1)
        else
            akTarget.SetFactionRank(tFac, 1)
        endif
        index += 1
    endwhile
    
endEvent
