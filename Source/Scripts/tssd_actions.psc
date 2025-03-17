Scriptname tssd_actions extends Quest
import b612
import tssd_utils
import PapyrusUtil
import storageutil

Actor Property PlayerRef Auto

tssd_slsfrscript Property slsfListener Auto
iWant_Widgets Property  iWidgets Auto
SexLabFramework Property SexLab Auto
sslActorStats Property sslStats Auto
tssd_succubusstageendblockhook Property stageEndHook Auto
tssd_widgets Property tWidgets Auto
Faction Property sla_Arousal Auto

tssd_LibidoTrackerRefScript Property libidoTrackerScript Auto

Spell[] Property SuccubusAbilitiesSpells Auto
Perk[] Property SuccubusAbilitiesPerks  Auto
String[] Property SuccubusAbilitiesNames  Auto    

Idle property BleedOutStart auto

tssd_orgasmenergylogic Property OEnergy Auto 

Quest Property tssd_dealwithcurseQuest Auto
Quest Property tssd_libidoTrackerQuest Auto

GlobalVariable[] Property tssd_deityTrackers Auto

GlobalVariable Property TimeOfDayGlobalProperty Auto
GlobalVariable Property SkillSuccubusDrainLevel Auto
GlobalVariable Property SkillSuccubusSeductionLevel Auto
GlobalVariable Property SkillSuccubusBodyLevel Auto
GlobalVariable Property SkillSuccubusBaseLevel Auto
GlobalVariable Property TSSD_PerkPointsBought Auto
GlobalVariable Property SuccubusDesireLevel Auto
GlobalVariable Property SuccubusXpAmount Auto
GlobalVariable Property TSSD_MaxTraits Auto
GlobalVariable Property GameHours Auto
GlobalVariable Property TSSD_SuccubusType Auto
GlobalVariable Property TSSD_SuccubusLibido Auto
GlobalVariable Property TSSD_SuccubusBreakRank Auto
GlobalVariable Property TSSD_ravanousNeedLevel Auto

Perk Property TSSD_Body_Overstuffed Auto
Perk Property TSSD_Base_CapIncrease1 Auto
Perk Property TSSD_Drain_GentleDrain1 Auto
Perk Property TSSD_Drain_DrainMore1 Auto
Perk Property TSSD_Seduction_Leader Auto
Perk Property TSSD_Seduction_OfferSex Auto
Perk Property TSSD_Body_PassiveEnergy1 Auto
Perk Property TSSD_Base_IncreaseScentRange1 Auto
Perk Property TSSD_DeityArkayPerk Auto
Perk Property TSSD_DeityDibellaPerk Auto

Spell Property TSSD_SuccubusDetectJuice Auto
Spell Property TSSD_Overstuffed Auto
Spell Property TSSD_DrainHealth Auto
Spell Property TSSD_DrainedMarker Auto

bool Property deathModeActivated Auto
bool modifierKeyIsDown = false

bool [] cosmeticSettings

Actor[] Property targetsToAlert Auto
Actor[] Property cell_ac Auto

ImageSpaceModifier Property AzuraFadeToBlack  Auto  
MagicEffect Property TSSD_SuccubusDetectEnergyFF Auto


Keyword Property LocTypeInn Auto
Keyword Property LocTypePlayerHouse Auto
Keyword Property LocTypeCity Auto
Keyword Property LocTypeClearable Auto
Keyword Property LocTypeHabitation Auto
Keyword Property LocTypeHabitationHasInn Auto
Keyword Property IsCreature Auto

HeadPart PlayerEyes

int lastUsed = -1
int lastUsedSub = -1
int spellToggle
int Property numHostileActors Auto
int Property playerArousal Auto

string Property tssd_SpellDebugProp = "-1" Auto
MagicEffect Property TSSD_DraineMarkerEffect Auto  
MagicEffect Property TSSD_BeggarLibidoDecrease Auto  
MagicEffect Property TSSD_ZenitharDonationSpellEffect Auto  

float lastSmoochTimeWithThatPerson = 0.0

float last_checked
float timer_internal = 0.0
float smooching = 0.0
float _updateTimer = 0.5

String Property CUM_VAGINAL = "sr.inflater.cum.vaginal" autoreadonly hidden
String Property CUM_ANAL = "sr.inflater.cum.anal" autoreadonly Hidden
String Property CUM_ORAL = "sr.inflater.cum.oral" autoreadonly hidden
STRING PROPERTY SUCCUBUSLIBIDOINCREASE = "tssd.Libido.Rate" autoreadonly hidden

;SPECIFIC UTILITY FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Function addToSmooching(float val)
    smooching += val
Endfunction

;Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Actor Function searchForTargets()
    int radius = getScanRange()
    targetsToAlert = MiscUtil.ScanCellNPCs(PlayerRef)
    cell_ac = MiscUtil.ScanCellNPCs(PlayerRef, radius * 50)
    int ac_index = 0
    bool isFading = false
    Actor curRef
    Actor tarRef
    Bool[] isHostileArr = Utility.CreateBoolArray(cell_ac.Length, false)
    numHostileActors = 0
    float min_distance
    Actor nearestActor
    Actor[] tempArr = new Actor[1]
    while ac_index < cell_ac.Length
        curRef = cell_ac[ac_index]
        if curRef && curRef != PlayerRef && curRef.isHostileToActor(PlayerRef) && curRef.IsEnabled() && !curRef.isDead() && !curRef.HasKeyword(IsCreature)
            if !nearestActor || min_distance > PlayerRef.GetDistance(curRef)
                nearestActor = curRef
                min_distance = PlayerRef.GetDistance(curRef)
            endif
            isHostileArr[ac_index] = true
            if numHostileActors == 0
                tempArr[0] = curRef
            else
                tempArr = PapyrusUtil.PushActor(tempArr,curRef )
            endif
            numHostileActors += 1
        endif
        
        ac_index += 1
    endwhile
    cell_ac = tempArr
    if nearestActor
        isFading = true
        tarRef = nearestActor
        return nearestActor
    endif
    return none
Endfunction

Function actDefeated(actor tarRef)
    if tarRef
        PlayerRef.PlayIdle(BleedOutStart)
        AzuraFadeToBlack.Apply()
        if !deathModeActivated
            toggleDeathMode()
        endif
        GameHours.Mod(1) ; TODO
        Utility.Wait(2.5)
        tarRef.MoveTo(PlayerRef, 0, 0)
        tarRef.enable()
        Sexlab.RegisterHook( stageEndHook)
        Sexlab.StartSceneQuick(akActor1 = PlayerRef, akActor2 = tarRef, akSubmissive = PlayerRef)
        ImageSpaceModifier.RemoveCrossFade(3)
    endif
Endfunction

Function RegisterSuccubusEvents()
    RegisterForUpdateGameTime(0.4)
    RegisterForMenu("Dialogue Menu")
    RegisterForMenu("StatsMenu")
    if MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bDebugMode:Main")
        PlayerRef.AddPerk(TSSD_Seduction_OfferSex)
        TSSD_MaxTraits.SetValue(99)
    endif
    RegisterForModEvent("SexLabOrgasmSeparate", "OnSexOrgasm")
    RegisterForModEvent("PlayerTrack_Start", "PlayerSceneStart")
    RegisterForModEvent("PlayerTrack_End", "PlayerSceneEnd")
    RegisterForTrackedStatsEvent()
    tssd_libidoTrackerQuest.start()
    tssd_libidoTrackerQuest.setstage(10)
Endfunction

  
Event OnTrackedStatsEvent(string asStatFilter, int aiStatValue)
      if (asStatFilter == "Books Read") || asStatFilter == "Skill Increases" || asStatFilter == "Locations Discovered"
        Debug.Notification("Oh I gotta talk about that!")
      endif
endEvent

Function EvaluateCompleteScene(bool onStart=false)
    sslThreadController _thread =  Sexlab.GetPlayerController()
    float playerArousalNow = playerref.GetFactionRank(sla_Arousal)
    int index = 0
    int max_rel = -4
    bool max_prot = false
    int succubusType = TSSD_SuccubusType.GetValue() as int
    Actor[] ActorsIn = _thread.GetPositions()
    string output = ""
    float energyNew = 0
    float[] retVals = new float[2]
    if PlayerRef.HasPerk(TSSD_Drain_GentleDrain1)
        while index < ActorsIn.length
            Actor ActorRef = Actorsin[Index]
            int relatisonship = ActorRef.GetRelationshipRank(playerref)
            if isSuccableOverload(ActorRef) && (succubusType != 1 || relatisonship < 4)
                retVals = OEnergy.OrgasmEnergyValue(_thread, succubusType, ActorRef)
                Oenergy.nextAnnouncment = ""
                energyNew = retVals[0]
                if ActorRef
                    max_rel = max(relatisonship, max_rel) as int
                endif
            elseif ActorRef != PlayerRef
                if deathModeActivated
                    max_prot = true
                    toggleDeathMode()
                endif
                output += ActorRef.GetDisplayName() + " can't be drained!
"
            endif
            index += 1
        EndWhile
    endif
    if deathModeActivated
        energyNew += (ActorsIn.Length - 1) * 100
        output += "Someone is about to die! "
    elseif ActorsIn.Length == 1 && playerArousalNow + TSSD_SuccubusLibido.GetValue() > 75
        output += "Some great me time! "
    elseif ActorsIn.Length == 1
        output += "I'm not in the mood "
    elseif energyNew >= 30
        output += "Ooh, this will do nicely! "
    elseif energyNew >= 20
        output += "Mhhm this is good. "
    elseif energyNew >= 10
        output += "I like this. "
    elseif energyNew > 0
        output += "I can live with this. "
    else
        output += "Eugh, this is bad. "
    endif
    string newOut = Oenergy.nextAnnouncment
    newOut += "
"
    newOut += output +": " + retVals[0] as int
    GetAnnouncement().Show(newOut  , "icon.dds", aiDelay = 5.0)

    ; if ReadInCosmeticSetting()[2] == 1
    ;     OEnergy.ShowAnnounceMent(energyNew as int)
    ; endif
Endfunction

Function PlayerSceneStart(Form FormRef, int tid)
    int succubusType = TSSD_SuccubusType.GetValue() as int
    playerArousal = playerref.GetFactionRank(sla_Arousal)
    Actor[] ActorsIn = Sexlab.GetController(tid).GetPositions() 
    if SuccubusDesireLevel.GetValue() > -100.0
        PlayerRef.DispelSpell(TSSD_SuccubusDetectJuice)
    endif
    if smooching == 0.0
        EvaluateCompleteScene(true)
    else
        Actor nonPlayer = ActorsIn[0]
        if nonPlayer == PlayerRef
            nonPlayer = ActorsIn[1]
        endif
        lastSmoochTimeWithThatPerson = GetLastTimeSuccd(nonPlayer, TimeOfDayGlobalProperty)        
    endif
    if Game.GetModByName("Tullius Eyes.esp") != 255 && (succubusType == 1 || cosmeticSettings[1] ) && cosmeticSettings[0]
        HeadPart tEyes = currentEyes()
        if tEyes
            PlayerEyes = tEyes
        endif
        setHeartEyes(PlayerEyes, true)
    endif
    if tssd_dealwithcurseQuest.GetStage() == 20 && !tssd_dealwithcurseQuest.isobjectivefailed(24) ; Dibella
        int index = 0
        while index < ActorsIn.Length
            Actor WhoCums = ActorsIn[index]
            float lstTime = GetLastTimeSuccd(WhoCums, TimeOfDayGlobalProperty)
            if WhoCums != PlayerRef && (lstTime < 0 || lstTime > 7)
                increaseGlobalDeity(3, 25)
            else
                increaseGlobalDeity(3, 5)
            endif

            index+=1
        EndWhile
    endif
EndFunction

bool Function increaseGlobalDeity(int index, int byVal = 1)
    bool isCompleted = tssd_dealwithcurseQuest.ModObjectiveGlobal(byVal, tssd_deityTrackers[index], 22 + index)
    advanceStageTwenty()
    return isCompleted
Endfunction

bool Function isSuccableOverload(Actor ActorRef)
    return isSuccable(ActorRef, TSSD_DraineMarkerEffect)
Endfunction

Function PlayerSceneEnd(Form FormRef, int tid)
    int succubusType = TSSD_SuccubusType.GetValue() as int
    sslThreadController _thread =  Sexlab.GetController(tid)
    Actor[] ActorsIn = Sexlab.GetController(tid).GetPositions() 
    if Sexlab.IsHooked(stageEndHook)
        Sexlab.UnRegisterHook( stageEndHook)
    endif



    ; TSSD_DrainHealth.SetNthEffectMagnitude(1, min(ActorRef.GetActorValue("Health") - 10 ,new_drain_level))
    ; TSSD_DrainHealth.Cast(PlayerRef, ActorRef)
    int orgasmCountScene = 0
    int succAbleTargets = 0
    int index = 0
    bool playerCame = _thread.ActorAlias(PlayerRef).GetOrgasmCount() > 0
    int bonusReduction = 10

    if Actorsin.Length == 1
        if PlayerRef.HasPerk(TSSD_DeityDibellaPerk) && searchForTargets()
            bonusReduction += 10
        endif
        if playerCame && (playerArousal + TSSD_SuccubusLibido.GetValue() >= 75  || bonusReduction > 10)            
            libidoTrackerScript.changeLibido(bonusReduction * (playerArousal + TSSD_SuccubusLibido.GetValue() / 50) )
        endif
    endif
    while index < ActorsIn.Length
        Actor WhoCums = ActorsIn[index]
        if isSuccableOverload(WhoCums) && (succubusType != 1 || WhoCums.GetRelationshipRank(PlayerRef) < 4)
            orgasmCountScene += _thread.ActorAlias(WhoCums).GetOrgasmCount()
            succAbleTargets += 1
        endif
        index+=1
    EndWhile
    index = 0
    succAbleTargets = max(1, succAbleTargets) as int
    while index < ActorsIn.Length
        Actor WhoCums = ActorsIn[index]
        if WhoCums.hasmagiceffect(TSSD_DraineMarkerEffect) && (succubusType != 1 || WhoCums.GetRelationshipRank(PlayerRef) < 4) && deathModeActivated
            float succdVal = min(WhoCums.GetAV("Health"), 100 + getDrainLevel() * orgasmCountScene / succAbleTargets )
            updateSuccyNeeds( succdVal, resetAfterEnd=false, isDeathModeActivated = true   )
            TSSD_DrainHealth.SetNthEffectMagnitude(0, succdVal + 100 )
            TSSD_DrainHealth.Cast(PlayerRef, WhoCums)
            int reduction = 10
            if PlayerRef.HasPerk(TSSD_DeityArkayPerk)
                reduction += 10
            endif
            libidoTrackerScript.changeLibido(succdVal/reduction)
        endif
        index+=1
    EndWhile

    if deathModeActivated && SuccubusDesireLevel.GetValue() >= 0
        toggleDeathMode()
    endif
    if Game.GetModByName("Tullius Eyes.esp") != 255
        setHeartEyes(PlayerEyes, false)
    endif
    if targetsToAlert
        int tarIndex = 0
        while tarIndex < targetsToAlert.Length
            Actor curRef = targetsToAlert[tarIndex]
            if curRef && curRef != PlayerRef && curRef.isHostileToActor(PlayerRef) && curRef.IsEnabled() && !curRef.isDead()
                curRef.StartCombat(PlayerRef)
                curRef.PathToReference(PlayerRef, 0.9)
            endif
            tarIndex += 1
        EndWhile
    endif

    targetsToAlert = new Actor[1]
EndFunction

Function DebugForceOrgasm()
    sslThreadController _thread =  Sexlab.GetPlayerController()
    if _thread
        Actor[] ActorsIn = _thread.GetPositions()
        int index = 0
        while index < ActorsIn.Length
            Actor ActorRef = ActorsIn[index]
            if ActorRef
                _thread.ForceOrgasm(ActorRef)
            endif
            index += 1
        EndWhile
    endif
EndFunction

Function AddToStatistics(float amount_of_hours)
    int succubusType = TSSD_SuccubusType.GetValue() as int
    int sexualityPlayer = sslStats.GetSexuality(PlayerRef)
    int genderPlayer = min(Sexlab.GetSex(PlayerRef), 1) as int
    if genderPlayer == 0
        sexualityPlayer = 100 - sexualityPlayer
    endif
    int index = 0
    if succubusType != 3
        while index < (amount_of_hours as int)
            int maleSexPartner = (0.5 + Utility.RandomInt(0, sexualityPlayer) / 100) as int
            sslStats.AddSex(PlayerRef, timespent = 1.0,  withplayer = true, isaggressive = succubusType == 4, Males = 1 + 1 - genderPlayer , Females = 1 - maleSexPartner + genderPlayer, Creatures =  0)
            index += 1
        endwhile
    endif
    slsfListener.onWaitPassive(amount_of_hours)
Endfunction


; Function to adjust energy level
Function RefreshEnergy(float adjustBy, int upTo = 100, bool isDeathModeActivated = false)
    if  !tssd_dealwithcurseQuest.isobjectivefailed(24)
        upTo = 19
    endif
    float lastVal = SuccubusDesireLevel.GetValue()
    int lowerBound = -100
    if (TSSD_SuccubusType.GetValue() as int) == 3
        lowerBound = 0
    endif
    ; DBGTRace(isDeathModeActivated)
    if lastVal < upTo && (lastVal > -100 || isDeathModeActivated)
        SuccubusDesireLevel.SetValue( min(upTo, max( lowerBound,  lastVal + adjustBy) ) )
    endif
Endfunction


; Function to update Energy Level by value, which increases XP
Function updateSuccyNeeds(float value, bool resetAfterEnd = false, bool isDeathModeActivated = false)
    float succNeedVal = SuccubusDesireLevel.GetValue()
    int max_energy_level = 100
    int greed_mult = 1
    if PlayerRef.HasPerk(TSSD_Drain_DrainMore1.GetNextPerk())
        greed_mult = 3
    elseif PlayerRef.HasPerk(TSSD_Drain_DrainMore1)
        greed_mult = 2
    endif
    if PlayerRef.HasPerk(TSSD_Base_CapIncrease1.GetNextPerk().GetNextPerk())
        max_energy_level = 1000
    elseif PlayerRef.HasPerk(TSSD_Base_CapIncrease1.GetNextPerk())
        max_energy_level = 400
    elseif PlayerRef.HasPerk(TSSD_Base_CapIncrease1)
        max_energy_level = 200
    endif

    if value > 0
        SuccubusXpAmount.Mod(value * 10)
    endif
    if succNeedVal - value < 0 && (TSSD_SuccubusType.GetValue() as int) == 3
        value =   succNeedVal * - 1
    endif
    ; DBGTRace(TSSD_ravanousNeedLevel.GetValue())
    if succNeedVal > TSSD_ravanousNeedLevel.GetValue() - 1
        if succNeedVal > 0
            SuccubusDesireLevel.SetValue(Min(max_energy_level, Max(succNeedVal+ value * greed_mult, 0)))
        else
            RefreshEnergy(value, 100, isDeathModeActivated)
        endif
    endif
    succNeedVal = SuccubusDesireLevel.GetValue()
    PlayerRef.RemoveSpell(TSSD_Overstuffed)
    if succNeedVal > 100 && PlayerRef.HasPerk(TSSD_Body_Overstuffed)
        TSSD_Overstuffed.SetNthEffectMagnitude(0, succNeedVal - 100)
        TSSD_Overstuffed.SetNthEffectMagnitude(1, min(80,(succNeedVal - 100) / 10))
        PlayerRef.ADdSpell(TSSD_Overstuffed, false)
    endif
    if resetAfterEnd
        smooching = 0.0
    endif
    tWidgets.UpdateStatus()
EndFunction

Function toggleDeathMode()
    if (deathModeActivated != false) && (deathModeActivated != true)
        deathModeActivated = false
    endif
    deathModeActivated = !deathModeActivated
    if SuccubusDesireLevel.GetValue() <= TSSD_ravanousNeedLevel.GetValue()
        deathModeActivated = true
    endif
    if deathModeActivated
        GetAnnouncement().Show("SOMEONE NEEDS TO DIE NOW!", "icon.dds", aiDelay = 2.0)
    endif
    ;TSSD_KillEssentialsActive.SetValue(MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bKillEssentials:Main") as int)
EndFunction

int Function getScanRange()
    return 70 * ( 1 + PlayerRef.HasPerk(TSSD_Base_IncreaseScentRange1) as int) ; Skyrim Units to meters
Endfunction


Function toggleSpells(int newToggle = -1)
    if newToggle == -1
        newToggle = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iSpellsAdded:Main")
    endif
    int indexOfA = 1
    while indexOfA < SuccubusAbilitiesNames.length
        if PlayerRef.HasPerk(SuccubusAbilitiesPerks[indexOfA]) && newToggle > 0
            PlayerRef.AddSpell(SuccubusAbilitiesSpells[indexOfA])
        else
            PlayerRef.RemoveSpell(SuccubusAbilitiesSpells[indexOfA])
        endif
        indexOfA += 1
    endwhile
    spellToggle = newToggle
Endfunction

String Function getAllNames(Actor[] inArr)
    int index = 0
    string outString = ""
    while index < inArr.length
        outString += (inArr[index] as Actor).GetDisplayName() + ";"
        index += 1 
    endwhile
    return outString
Endfunction


;Events ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Event OnUpdate()
    sslThreadController _thread =  Sexlab.GetPlayerController()
    if _thread && PlayerRef.HasPerk(TSSD_Seduction_Leader)
        if timer_internal < 0
            timer_internal += Max(_updateTimer, 0.0)
        elseif Input.IsKeyPressed(MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iModifierHotkey:Main")) && PlayerRef.GetAV("Stamina") > 10 && timer_internal < 6
            timer_internal += _updateTimer
            PlayerRef.DamageActorValue("Stamina", 50 * _updateTimer )
        elseif timer_internal > 0
            int index = 0
            Actor[] ActorsIn = _thread.GetPositions()
            while index < ActorsIn.Length
                if ActorsIn[index] != PlayerRef
                    _thread.AdjustEnjoyment(ActorsIn[index], Min(300, _thread.GetEnjoyment(ActorsIn[index]) + 25 * timer_internal) as int)
                else
                    _thread.AdjustEnjoyment(ActorsIn[index], Min(90 - _thread.GetEnjoyment(ActorsIn[index]), _thread.GetEnjoyment(ActorsIn[index]) + 25 * timer_internal) as int)
                endif
                index += 1
            EndWhile
            timer_internal = -5
        endif
    endif
    float succNeedVal = SuccubusDesireLevel.GetValue()
    if succNeedVal <= TSSD_ravanousNeedLevel.GetValue() && succNeedVal > -101
        TSSD_SuccubusDetectJuice.Cast(PlayerRef, PlayerRef)
        if !deathModeActivated
            toggleDeathMode()
        endif
    endif
	RegisterForSingleUpdate(_updateTimer)
EndEvent


Event OnSexOrgasm(Form ActorRef_Form, Int Thread)
    int succubusType = TSSD_SuccubusType.GetValue() as int
    sslThreadController _thread =  Sexlab.GetController(Thread)
    Actor ActorRef = ActorRef_Form as Actor
    if PlayerRef.HasPerk(TSSD_Drain_GentleDrain1) && isSuccableOverload(actorRef)
        float[] retVals = OEnergy.OrgasmEnergyValue(_thread, succubusType, ActorRef)
        updateSuccyNeeds(retVals[0], true)
        libidoTrackerScript.changeLibido(retVals[2])
        GetAnnouncement().Show(Oenergy.nextAnnouncment +": " + (retVals[0] as int) , "icon.dds", aiDelay = 5.0)
        Oenergy.nextAnnouncment = ""
        if (retVals[1] as int) > 0
            RefreshEnergy(retVals[1] as int)
        endif
        if actorRef != PlayerRef
            TSSD_DrainedMarker.Cast(ActorRef, ActorRef)
        endif
    endif
    if deathModeActivated && ActorRef != PlayerRef
        int StageCount = SexLabRegistry.GetPathMax(   _Thread.getactivescene()  , "").Length
        int Stage_in = StageCount   - SexLabRegistry.GetPathMax(_Thread.getactivescene() ,_Thread.GetActiveStage()).Length + 1
        ;TSSD_DrainHealth.SetNthEffectMagnitude(1, Min( ActorRef.GetActorValue("Health") - 10, 100 + SkillSuccubusDrainLevel.GetValue() * 4 ))
        ;TSSD_DrainHealth.Cast(PlayerRef, ActorRef)
        while  Stage_in < StageCount 
            _thread.AdvanceStage()
            Stage_in = StageCount   - SexLabRegistry.GetPathMax(_Thread.getactivescene() ,_Thread.GetActiveStage()).Length + 1
        EndWhile
    elseif !deathModeActivated  && ActorRef != PlayerRef && PlayerRef.HasPerk(TSSD_Drain_GentleDrain1)
        float new_drain_level = (100 + SkillSuccubusDrainLevel.GetValue() * 4)
        if PlayerRef.HasPerk(TSSD_Drain_GentleDrain1.GetNextPerk().GetNextPerk())
            new_drain_level /= 2
        elseif PlayerRef.HasPerk(TSSD_Drain_GentleDrain1.GetNextPerk())
            new_drain_level /= 3
        elseif PlayerRef.HasPerk(TSSD_Drain_GentleDrain1)
            new_drain_level /= 5
        endif
        ;TSSD_DrainHealth.SetNthEffectMagnitude(1, min(ActorRef.GetActorValue("Health") - 10 ,new_drain_level))
        ;TSSD_DrainHealth.Cast(PlayerRef, ActorRef)
    endif
EndEvent

float Function getDrainLevel(bool isGentle = false)
    float new_drain_level = (100 + SkillSuccubusDrainLevel.GetValue() * 4)
    if !isGentle
        return new_drain_level
    endif
    if PlayerRef.HasPerk(TSSD_Drain_GentleDrain1.GetNextPerk().GetNextPerk())
        new_drain_level /= 2
    elseif PlayerRef.HasPerk(TSSD_Drain_GentleDrain1.GetNextPerk())
        new_drain_level /= 3
    elseif PlayerRef.HasPerk(TSSD_Drain_GentleDrain1)
        new_drain_level /= 5
    endif
    return new_drain_level
Endfunction


Event OnUpdateGameTime()
    int succubusType = TSSD_SuccubusType.GetValue() as int
    float timeBetween = (TimeOfDayGlobalProperty.GetValue() - last_checked) * 24
    if timeBetween > 1
        float valBefore = SuccubusDesireLevel.GetValue()
        Location curLoc = Game.GetPlayer().GetCurrentLocation()
        float chVal = 1
        if MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bEnableLibido:Libido")
            chVal = ( 1 + (TSSD_SuccubusLibido.GetValue()) / 100) * ( 1 + TSSD_SuccubusBreakRank.GetValue())
        endif
        float energy_loss = timeBetween * chVal
        if curLoc 
            if (valBefore > 0 && valBefore < 50 && PlayerRef.HasPerk(TSSD_Body_PassiveEnergy1)) && \
                (succubusType == 0 && curLoc.HasKeyword(LocTypeInn)) || (succubusType == 1 && curLoc.HasKeyword(LocTypePlayerHouse)) || (succubusType == 2 && ( curLoc.HasKeyword(LocTypeInn) ||  curLoc.HasKeyword(LocTypeHabitationHasInn)) ) || (succubusType == 4 && !curLoc.HasKeyword(LocTypeHabitation))
                if timeBetween >= 1
                    if PlayerRef.HasPerk(TSSD_Body_PassiveEnergy1.GetNextPerk().GetNextPerk())
                        RefreshEnergy(energy_loss * 20, 50)
                    elseif PlayerRef.HasPerk(TSSD_Body_PassiveEnergy1.GetNextPerk())
                        RefreshEnergy(energy_loss * 10, 50)
                    endif
                    float changeAmount = (SuccubusDesireLevel.GetValue() - valBefore) /10
                    libidoTrackerScript.changeLibido(changeAmount )
                    AddToStatistics(changeAmount)
                endif
                energy_loss = 0
            endif
        endif
        if energy_loss > 0
            energy_loss *= -1
            last_checked = TimeOfDayGlobalProperty.GetValue()
            updateSuccyNeeds(energy_loss)
        endif
    endif
    ; DBGTRace("Oral Cum: " + GetFloatValue(PlayerRef, CUM_ORAL) + "Anal Cum: " + GetFloatValue(PlayerRef, CUM_ANAL) + "Vaginal Cum: " +GetFloatValue(PlayerRef, CUM_VAGINAL))
    
endEvent

Event OnMenuOpen(String MenuName)
    if MenuName == "Dialogue Menu" && SuccubusDesireLevel.GetValue() <= TSSD_ravanousNeedLevel.GetValue() && TSSD_SuccubusType.GetValue() != -1
        UI.InvokeString("HUD Menu", "_global.skse.CloseMenu", "Dialogue Menu")
        GetAnnouncement().Show("NO TIME TO TALK!", "icon.dds", aiDelay = 2.0)
    endif
EndEvent

Event OnMenuClose(String MenuName)
    if MenuName == "StatsMenu"
        toggleSpells(-1)
    endif
EndEvent

Event OnInit()
    IntListResize(PlayerRef, SUCCUBUSLIBIDOINCREASE, 20)
	RegisterForModEvent("iWantWidgetsReset", "OniWantWidgetsReset")
	RegisterForSingleUpdate(_updateTimer)
    onGameReload()
    libidoTrackerScript.changeLibido(1)
EndEvent

Function onGameReload()
    if TSSD_SuccubusType.GetValue() > -1
        RegisterSuccubusEvents()
    endif
    Maintenance(TSSD_SuccubusType)
    cosmeticSettings = ReadInCosmeticSetting()
    tWidgets.shouldFadeOut = cosmeticSettings[5]
    tWidgets.onReloadStuff()
    updateSuccyNeeds(0)
    if IntListCount(PlayerRef, SUCCUBUSLIBIDOINCREASE) < 10
        IntListResize(PlayerRef, SUCCUBUSLIBIDOINCREASE, 20)
    endif
    if !spellToggle
        toggleSpells(MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iSpellsAdded:Main"))
    endif

    int jArr = JDB.solveObj(".tssdspellids")
    int index = 0
    while index < JValue.count(jArr)
        int innerJ = jArray.getObj(jArr, index)
        adjustSpell( jArray.Getint(innerJ, 1) as bool, jArray.GetStr(innerJ, 2), jArray.GetInt(innerJ, 3)  ,MCM.GetModSettingString("TintsOfASuccubusSecretDesires",jArray.getStr(innerJ, 0)))
        index += 1
    endwhile

    if tssd_libidoTrackerQuest.GetStage() == 100
        if MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bEnableLibido:Libido")
            TSSD_ravanousNeedLevel.SetValue(1000)
        else
            TSSD_ravanousNeedLevel.SetValue(-100)
        endif
    endif
Endfunction

Function addTSSDPerk(string perkToAdd)
    Perk toAdd = Game.GetFormFromFile(perkToAdd as int, "TintsOfASuccubusSecretDesires.esp") as Perk    
    if !PlayerRef.HasPerk(toAdd)
        PlayerRef.AddPerk(toAdd)
    else
        PlayerRef.RemovePerk(toAdd)
    endif
Endfunction

Function adjustSpell(bool isMag, string id, int index, string newValStr)
    float newVal = newValStr as float
    Spell toAdj = Game.GetFormFromFile(id as int, "TintsOfASuccubusSecretDesires.esp") as Spell
    if newVal && toAdj
        if playerref.hasspell(toAdj)
            PlayerRef.RemoveSpell(toAdj) 
            if isMag
                toAdj.SetNthEffectMagnitude(index, newVal as float)
            else
                toAdj.SetNthEffectDuration(index, newVal as int)
            endif
            PlayerRef.AddSpell(toAdj)
        endif
    endif
Endfunction

Function NotificationSpam(string Displaying)
    if MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bSpamNotifications:Main")
        Debug.Notification( "You picked: " + Displaying )
    endif
Endfunction


Function advanceStageTwenty()
    if tssd_dealwithcurseQuest.IsObjectiveCompleted(21) && tssd_dealwithcurseQuest.IsObjectiveCompleted(22) && tssd_dealwithcurseQuest.IsObjectiveCompleted(23) && tssd_dealwithcurseQuest.IsObjectiveCompleted(24) && tssd_dealwithcurseQuest.IsObjectiveCompleted(25)
        tssd_dealwithcurseQuest.setstage(40)
    endif
Endfunction
