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

int nextAnnouncmentLineLength = 0
string nextAnnouncment = "" 

float Function EvaluateOrgasmEnergy(sslThreadController _thread, Actor WhoCums = none, int announceLogic = 0, bool overWriteStop = false)
    ; announceLogic -- 0 no announcment -- 1 announce self -- 2 add to next announcement
    float dateCheck = TimeOfDayGlobalProperty.GetValue()
    int index = 0
    float retval = 0
    string[] succubusTraits = GetSuccubusTraitsAll()
    string[] succubusTypes = GetSuccubusTypesAll()
    int[] SUCCUBUSTRAITSVALUESBONUS = Utility.CreateIntArray(succubusTraits.Length, 5)
    SUCCUBUSTRAITSVALUESBONUS[2] = 100
    SUCCUBUSTRAITSVALUESBONUS[5] =  0
    float lastMet = 1
    float energyLosses = 0
    bool[] cosmeticSettings = ReadInCosmeticSetting()
    bool[] chosenTraits = GetSuccubusTraitsChosen(TSSD_SuccubusTraits, succubusTraits.Length)
    int succubusType = TSSD_SuccubusType.getvalue() as int
    string succubusTypeString = succubusTypes[succubusType]
    if cosmeticSettings[2] == 0  && !overWriteStop
        announceLogic = 0
    endif
    if WhoCums != PlayerRef && WhoCums

        if !isSuccable(WhoCums)
            if announceLogic != 1 
                nextAnnouncment += WhoCums.GetDisplayName() + " can't be drained!"
            else
                GetAnnouncement().Show(WhoCums.GetDisplayName() + " can't be drained!", "icon.dds", aiDelay = 5.0)
                nextAnnouncment = ""
            endif
            return 0
        endif
        lastMet = GetLastTimeSuccd(WhoCums, TimeOfDayGlobalProperty)
        if lastmet  < 0.0
            lastmet = 1
        endif
        retval += 20 * lastMet * ( 1 / (Max(_thread.ActorAlias(WhoCums).GetOrgasmCount(), 1)))

        bool cameOn = false
        while index < SUCCUBUSTRAITSVALUESBONUS.Length
            bool skipThis = false
            if chosenTraits[index]
                bool traitYes = false
                if index == 0
                    traitYes = _thread.HasSceneTag("Aircum")
                    if traitYes
                        cameOn = true
                    elseif chosenTraits[1]
                        skipThis = true
                    endif
                elseif index == 1
                    traitYes =  !_thread.HasSceneTag("Aircum") && (_thread.HasSceneTag("Oral") || _thread.HasSceneTag("Anal") || _thread.HasSceneTag("Vaginal")) && Sexlab.GetSex(WhoCums) != 1 && Sexlab.GetSex(WhoCums) != 4
                    if cameOn
                        skipThis = true
                    endif                    
                elseif index == 2
                    traitYes =  WhoCums.GetHighestRelationshiprank() == 4 && SexlabStatistics.GetTimesMet(WhoCums,PlayerRef) == 0 && _thread.ActorAlias(WhoCums).GetOrgasmCount() <= 1
                elseif index == 3
                    traitYes = (_thread.HasSceneTag("love") || _thread.HasSceneTag("loving"))
                elseif index == 4
                    traitYes = _thread.sameSexThread()
                    if traitYes && Sexlab.GetSex(WhoCums) == 1
                        retval += 5
                    endif
                elseif index == 5
                    float ar_norm = WhoCums.GetFactionRank(sla_Arousal) - 50
                    traitYes = ar_norm > 0
                    if traitYes
                        retval += ar_norm / 5
                    endif
                    if announceLogic > 0
                        nextAnnouncment += WhoCums.GetDisplayName()
                    endif
                endif
                if traitYes && !skipThis
                    float bonus_val = lastMet * SUCCUBUSTRAITSVALUESBONUS[index] * ( 1 / Max(_thread.ActorAlias(WhoCums).GetOrgasmCount(),1) / (_thread.GetPositions().Length - 1) )
                    retval += bonus_val
                endif
                if announceLogic > 0 && !skipThis
                    string announceDial = GetTypeDial(succubusTraits[index], traitYes, true)
                    nextAnnouncmentLineLength += StringUtil.GetLength(announceDial)
                    if nextAnnouncmentLineLength > 100
                        nextAnnouncment += "\n"
                        nextAnnouncmentLineLength = 0
                    endif
                    nextAnnouncment += announceDial
                endif
            endif
            index += 1
        EndWhile
    elseif WhoCums && !MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bDebugNoEnergyLoss:Main")
        Actor[] ActorsIn = _thread.GetPositions() 
        index = 0
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
        float toLoseVal = 2
        bool traitYes = false
        if succubusType == 0
            toLoseVal = 1
        elseif succubusType == 1
            traitYes = max_rel == 4
        elseif succubusType == 2 
            traitYes = SexlabStatistics.GetTimesMet(WhoCums,PlayerRef) == 0 && max_met == 0
        elseif succubusType == 3
            toLoseVal = 0
        elseif succubusType == 4
            traitYes = _thread.GetSubmissive(PlayerRef)
        endif

        if !traitYes
            energyLosses = toLoseVal * -1
        endif
        if announceLogic > 0
            string announceDial = GetTypeDial(succubusTypeString, traitYes)
            nextAnnouncment += announceDial
        endif
    endif
    String output = ""
    if (!WhoCums || (announceLogic == 0 && WhoCums != PLayerRef)) && smooching > 0.0
        retval = smooching * lastMet
        output += "Smooch!\n"
    endif
    if retval > 0
        if succubusType == 3
            retval /= 2
        endif
    endif
    retVal += energyLosses
    if output != ""
        nextAnnouncment += output +"\n"
    endif
    if announceLogic == 1
        GetAnnouncement().Show(nextAnnouncment + " ; " + (retval as int), "icon.dds", aiDelay = 5.0)
        nextAnnouncment = ""
    endif
    return retval
Endfunction


Function ShowAnnounceMent(int energy)
    if (TSSD_SuccubusType.getvalue() as int) > -1
        GetAnnouncement().Show(nextAnnouncment +": " + energy , "icon.dds", aiDelay = 5.0)
    endif
    nextAnnouncment = ""
Endfunction
