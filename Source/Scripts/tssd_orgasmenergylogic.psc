Scriptname tssd_orgasmenergylogic extends Quest  

import b612
import tssd_utils
GlobalVariable Property TimeOfDayGlobalProperty Auto
Actor Property PlayerRef Auto
SexLabFramework Property SexLab Auto
Faction Property sla_Arousal Auto
GlobalVariable Property TSSD_SuccubusTraits Auto


Function queueStringForAnnouncement(string inputStr)
    nextAnnouncement += inputStr
EndFunction


string Property nextAnnouncement Auto

float[] Function OrgasmEnergyValue(sslThreadController _thread, Actor WhoCums = none)    
    ; announceLogic -- 0 no announcement -- 1 announce self -- 2 add to next announcement
    float dateCheck = TimeOfDayGlobalProperty.GetValue()
    ; TODO
    string[] succubusTraits = GetSuccubusTraitsAll()
    int[] SUCCUBUSTRAITSVALUESBONUS = Utility.CreateIntArray(succubusTraits.Length, 20)
    SUCCUBUSTRAITSVALUESBONUS[2] = 100
    SUCCUBUSTRAITSVALUESBONUS[5] =  0
    float lastMet = 1
    bool[] cosmeticSettings = ReadInCosmeticSetting()
    bool[] chosenTraits = GetSuccubusTraitsChosen(TSSD_SuccubusTraits, succubusTraits.Length)
    float largestTime = 0
    float[] retVals = Utility.CreateFloatArray(3, 0)
    int nextAnnouncementLineLength = 0
    float energyLosses = 0
    float retval = 0
;/ 
    if isEnabledAndNotPlayer(WhoCums)
        lastMet = GetLastTimeSuccd(WhoCums, TimeOfDayGlobalProperty)
        if (lastmet  < 0.0) || (lastmet > 1.0)
            lastmet = 1
            retval += 20
        endif
        int index = 0
        while index < SUCCUBUSTRAITSVALUESBONUS.Length
            bool traitYes = false
            if chosenTraits[index]
                traitYes = traitLogic(index, _thread, WhoCums)
                if index == 5
                    nextAnnouncement += WhoCums.GetDisplayName()
                endif
                if traitYes 
                    retval += SUCCUBUSTRAITSVALUESBONUS[index]
                else
                    retVals[2] = retVals[2] + SUCCUBUSTRAITSVALUESBONUS[index] 
                endif
                string announceDial = " " + GetTypeDial(succubusTraits[index], traitYes, true)
                nextAnnouncementLineLength += StringUtil.GetLength(announceDial)
                if nextAnnouncementLineLength > 100
                    nextAnnouncement += "\n"
                    nextAnnouncementLineLength = 0
                endif
                nextAnnouncement += announceDial
            endif
            index += 1
        EndWhile
    endif
    String output = ""
    retVal += energyLosses
    if output != ""
        nextAnnouncement += output +""
    endif
    retVals[0] = retVal /;
    return retVals

Endfunction

bool Function traitLogic(int index, sslThreadController _thread, Actor WhoCums)
    float ar_norm = WhoCums.GetFactionRank(sla_Arousal) - 50

    if index == 0
        if _thread.HasSceneTag("Aircum")
            return true
        endif
    elseif index == 1
        if !_thread.HasSceneTag("Aircum")
            if _thread.HasSceneTag("Oral")
                return true
            elseif _thread.HasSceneTag("Anal")
                return true
            elseif _thread.HasSceneTag("Vaginal")
                return true
            endif
        endif
    elseif index == 2
        if !isSingle(WhoCums) && SexlabStatistics.GetTimesMet(WhoCums,PlayerRef) == 0
            return true
        endif
    elseif index == 3
        if _thread.HasSceneTag("love")
            return true
        elseif _thread.HasSceneTag("loving")
            return true
        endif
    elseif index == 4
        if _thread.sameSexThread()
            return true
        endif
    elseif index == 5
        if ar_norm > 0
            return true
        endif
    endif
    return  false
Endfunction