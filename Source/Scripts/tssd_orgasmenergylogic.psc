Scriptname tssd_orgasmenergylogic extends Quest  

import b612
import tssd_utils
GlobalVariable Property TimeOfDayGlobalProperty Auto
Actor Property PlayerRef Auto
SexLabFramework Property SexLab Auto
Faction Property sla_Arousal Auto
GlobalVariable Property TSSD_SuccubusType Auto
GlobalVariable Property TSSD_SuccubusTraits Auto
int smooching

string Property nextAnnouncment Auto

float[] Function OrgasmEnergyValue(sslThreadController _thread, int succubusType , Actor WhoCums = none)    
    ; announceLogic -- 0 no announcment -- 1 announce self -- 2 add to next announcement
    float dateCheck = TimeOfDayGlobalProperty.GetValue()
    string succubusTypeString = GetSuccubusTypesAll()[succubusType]
    
    string[] succubusTraits = GetSuccubusTraitsAll()
    int[] SUCCUBUSTRAITSVALUESBONUS = Utility.CreateIntArray(succubusTraits.Length, 20)
    SUCCUBUSTRAITSVALUESBONUS[2] = 100
    SUCCUBUSTRAITSVALUESBONUS[5] =  0
    float lastMet = 1
    bool[] cosmeticSettings = ReadInCosmeticSetting()
    bool[] chosenTraits = GetSuccubusTraitsChosen(TSSD_SuccubusTraits, succubusTraits.Length)
    float largestTime = 0
    float[] retVals = Utility.CreateFloatArray(3, 0)
    int nextAnnouncmentLineLength = 0
    float energyLosses = 0
    float retval = 0

    if WhoCums && WhoCums != PlayerRef
        lastMet = GetLastTimeSuccd(WhoCums, TimeOfDayGlobalProperty)
        if (lastmet  < 0.0) || (lastmet > 1.0)
            lastmet = 1
        else
            return retVals
        endif
        int index = 0
        retval += 20
        while index < SUCCUBUSTRAITSVALUESBONUS.Length
            bool traitYes = false
            if chosenTraits[index]
                traitYes = traitLogic(index, _thread, WhoCums)
                if traitYes 
                    retval += SUCCUBUSTRAITSVALUESBONUS[index]
                    if index == 5
                        nextAnnouncment += WhoCums.GetDisplayName()
                    endif
                else
                    retVals[2] += SUCCUBUSTRAITSVALUESBONUS[index]
                endif
                string announceDial = " " + GetTypeDial(succubusTraits[index], traitYes, true)
                nextAnnouncmentLineLength += StringUtil.GetLength(announceDial)
                if nextAnnouncmentLineLength > 100
                    nextAnnouncment += "\n"
                    nextAnnouncmentLineLength = 0
                endif
                nextAnnouncment += announceDial
            endif
            index += 1
        EndWhile
    elseif WhoCums && !MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bDebugNoEnergyLoss:Main")
        Actor[] ActorsIn = _thread.GetPositions() 
        int index = 0
        int max_rel = 0
        int max_prot = 0
        int max_met = 0
        while index < ActorsIn.length
            Actor ActorRef = Actorsin[Index]            
            if PlayerRef != ActorRef
                max_rel = max(ActorRef.GetRelationshipRank(playerref), max_rel) as int
                max_met = max(SexlabStatistics.GetTimesMet(ActorRef,PlayerRef), max_met) as int
            endif
    
            index += 1
        EndWhile
        float toLoseVal = 20
        bool traitYes = false
        if succubusTypeString == "Crimson"
            toLoseVal /= 2
        elseif succubusTypeString == "Scarlet"
            traitYes = max_rel == 4
            retVals[1] = 1000
        elseif succubusTypeString == "Pink"
            traitYes = (largestTime > 3) || (max_met == 0)
        elseif succubusTypeString == "Sundown"
            toLoseVal = 0
        elseif succubusTypeString == "Mahogany"
            traitYes = _thread.GetSubmissive(PlayerRef)
        endif
        if !traitYes
            toLoseVal /= -10
        endif
        energyLosses = toLoseVal
        nextAnnouncment += GetTypeDial(succubusTypeString, traitYes)
    endif
    String output = ""
    if (!WhoCums || WhoCums != PLayerRef) && smooching > 0.0
        retval = smooching * lastMet
        output += "Smooch!\n"
    endif
    if retval > 0
        if succubusTypeString == "Sundown"
            retval /= 2
        endif
    endif
    retVal += energyLosses
    if output != ""
        nextAnnouncment += output +"\n"
    endif
    retVals[0] = retVal
    return retVals

Endfunction

bool Function traitLogic(int index, sslThreadController _thread, Actor WhoCums)
    float ar_norm = WhoCums.GetFactionRank(sla_Arousal) - 50

    return  ((index == 0 && _thread.HasSceneTag("Aircum")) ||\
    ((index == 1) && (!_thread.HasSceneTag("Aircum") && (_thread.HasSceneTag("Oral") || _thread.HasSceneTag("Anal") || _thread.HasSceneTag("Vaginal")) && Sexlab.GetSex(WhoCums) != 1 && Sexlab.GetSex(WhoCums) != 4)) ||\
    ((index == 2) && WhoCums.GetHighestRelationshiprank() == 4 && SexlabStatistics.GetTimesMet(WhoCums,PlayerRef) == 0 && _thread.ActorAlias(WhoCums).GetOrgasmCount() <= 1) ||\
    ((index == 3) && (_thread.HasSceneTag("love") || _thread.HasSceneTag("loving"))) ||\
    ((index == 4) && _thread.sameSexThread()) ||\
    ((index == 5) && (ar_norm > 0) ))
Endfunction