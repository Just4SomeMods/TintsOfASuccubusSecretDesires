Scriptname tssd_actions extends Quest

import tssd_utils
import PapyrusUtil
import storageutil
import CustomSkills

Actor Property PlayerRef Auto


tssd_slsfrscript Property slsfListener Auto
tssd_dialogue Property tDialogue Auto
SexLabFramework Property SexLab Auto
sslActorStats Property sslStats Auto
tssd_succubusstageendblockhook Property stageEndHook Auto

Faction Property sla_Arousal Auto
Faction Property TSSD_EnthralledFaction Auto

Actor Property MySweetHeart Auto
Actor Property HoveredPrey Auto

Spell[] Property SuccubusAbilitiesSpells Auto
Perk[] Property SuccubusAbilitiesPerks  Auto
String[] Property SuccubusAbilitiesNames  Auto    

Idle property BleedOutStart auto

tssd_orgasmenergylogic Property OEnergy Auto 

Quest Property tssd_dealwithcurseQuest Auto
Quest Property TSSD_EvilSuccubusQuest Auto

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
GlobalVariable Property TSSD_TypeScarlet Auto
GlobalVariable Property TSSD_TypeSundown Auto
GlobalVariable Property TSSD_TypeMahogany Auto
GlobalVariable Property TSSD_SuccubusBreakRank Auto
GlobalVariable Property TSSD_ravanousNeedLevel Auto
GlobalVariable Property TSSD_InnocentsSlain Auto

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
Spell Property TSSD_Satiated Auto
Spell Property TSSD_RejectionPoison Auto
Spell Property TSSD_FuckingInvincible Auto

bool Property deathModeActivated Auto
bool modifierKeyIsDown = false
bool Property isHoveringPrey Auto

bool [] cosmeticSettings

Actor[] Property targetsToAlert Auto
Actor[] Property cell_ac Auto
Actor[] Property mySweethearts Auto
  
ImageSpaceModifier Property AzuraFadeToBlack  Auto
ImageSpaceModifier Property BerserkerMainImod  Auto  

MagicEffect Property TSSD_SuccubusDetectEnergyFF Auto
MagicEffect Property TSSD_SatiatedEffect Auto

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
int lastPerc = -1

string Property tssd_SpellDebugProp = "-1" Auto
MagicEffect Property TSSD_DrainedDownSide Auto
MagicEffect Property TSSD_ZenitharDonationSpellEffect Auto  

float lastSmoochTimeWithThatPerson = 0.0

float last_checked
float timer_internal = 0.0
float smooching = 0.0
float _updateTimer = 0.5

String Property CUM_VAGINAL = "sr.inflater.cum.vaginal" autoreadonly hidden
String Property CUM_ANAL = "sr.inflater.cum.anal" autoreadonly Hidden
String Property CUM_ORAL = "sr.inflater.cum.oral" autoreadonly hidden


;SPECIFIC UTILITY FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function addToSmooching(float val)
    smooching += val
Endfunction

;Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function queueStringForAnnouncement(string inputStr)
    OEnergy.queueStringForAnnouncement(inputStr)
EndFunction



; Function to adjust energy level
Function RefreshEnergy(float adjustBy, int upTo = 100, bool isDeathModeActivated = false)
    if  tssd_dealwithcurseQuest.IsRunning() && !tssd_dealwithcurseQuest.isobjectivefailed(24)
        upTo = 19
    endif
    float lastVal = SuccubusDesireLevel.GetValue()
    int lowerBound = -100
    if (TSSD_TypeSundown.GetValue() as int) == 1
        lowerBound = 0
    endif
    if (lastVal > -100 || isDeathModeActivated)
        SuccubusDesireLevel.SetValue( min(upTo, max( lowerBound,  lastVal + adjustBy) ) )
    endif
    DBGTRACE(min(upTo, max( lowerBound,  lastVal + adjustBy) ))
    int nxtPerc = Min(5, ((SuccubusDesireLevel.GetValue() / 20  ) + 0.5) as int) as int
    if nxtPerc != lastPerc
        T_Show("", "menus/TSSD/" + nxtPerc + "H.dds" )
        lastPerc = nxtPerc
    endif
Endfunction

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



Function toggleDeathMode(bool makeAnnouncement = true)
    if (deathModeActivated != false) && (deathModeActivated != true)
        deathModeActivated = false
    endif
    deathModeActivated = !deathModeActivated
    if SuccubusDesireLevel.GetValue() <= TSSD_ravanousNeedLevel.GetValue()
        deathModeActivated = true
    endif
    if deathModeActivated
        BerserkerMainImod.ApplyCrossFade(1)
        if makeAnnouncement
            T_Show("SOMEONE NEEDS TO DIE NOW!", "icon.dds", aiDelay = 2.0)
        endif
    else
        BerserkerMainImod.Remove()
    endif
    ;TSSD_KillEssentialsActive.SetValue(MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bKillEssentials:Main") as int)
EndFunction



; Function to update Energy Level by value, which increases XP
Function gainSuccubusXP(float byValue, float enegryLossReduction = 0.0)
    float succNeedVal = SuccubusDesireLevel.GetValue()
    int max_energy_level = 100
    int greed_mult = 1
    float energyLoss = Max (0,byValue - enegryLossReduction) / -10
    if (succNeedVal + 10) > energyLoss * -1
        RefreshEnergy( energyLoss )
        SuccubusXpAmount.Mod(byValue)
    else
        SuccubusXpAmount.Mod(succNeedVal * -1)
        RefreshEnergy( succNeedVal * -1 )
    endif
    if CustomSkills.GetAPIVersion() >= 3
        CustomSkills.AdvanceSkill("SuccubusBaseSkill",byValue)
    endif
EndFunction


int Function getScanRange()
    return 70 * ( 1 + PlayerRef.HasPerk(TSSD_Base_IncreaseScentRange1) as int) ; Skyrim Units to meters
Endfunction

Function advanceStageTwenty()
    int index = 0
    while index < 5
        if tssd_dealwithcurseQuest.IsObjectiveCompleted(31 + index)
            tssd_dealwithcurseQuest.SetObjectiveFailed(21 + index)
        endif
        index += 1
    EndWhile
    index = 0
    bool isCompleted = true
    while index < 5
        if !tssd_dealwithcurseQuest.IsObjectiveCompleted(21 + index) ||  !tssd_dealwithcurseQuest.IsObjectiveCompleted(31 + index)
            isCompleted = false
        endif
        index += 1
    EndWhile
    if isCompleted
        tssd_dealwithcurseQuest.setstage(40)
    endif
Endfunction

Actor Function getLonelyTarget()
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
        if curRef && curRef != PlayerRef && curRef.isHostileToActor(PlayerRef) && curRef.IsEnabled() && !curRef.isDead() 
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
    if nearestActor && !nearestActor.HasKeyword(IsCreature) && numHostileActors == 1 
        isFading = true
        tarRef = nearestActor
        return nearestActor
    endif
    return PlayerRef
EndFunction

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
        if curRef && curRef != PlayerRef && curRef.isHostileToActor(PlayerRef) && curRef.IsEnabled() && !curRef.isDead()
            if (!nearestActor || min_distance > PlayerRef.GetDistance(curRef) ) && !curRef.HasKeyword(IsCreature)
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
    return PlayerRef
Endfunction

Function actDefeated(actor tarRef)
    
    TSSD_FuckingInvincible.Cast(PlayerRef)
    if tarRef
        PlayerRef.PlayIdle(BleedOutStart)
        AzuraFadeToBlack.Apply()
        GameHours.Mod(1) ; TODO
        Utility.Wait(2.5)
        tarRef.MoveTo(PlayerRef, 0, 0)
        tarRef.enable()
        ImageSpaceModifier.RemoveCrossFade(3)
        Sexlab.StartSceneQuick(akActor1 = PlayerRef, akActor2 = tarRef, akSubmissive = PlayerRef)
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
    RegisterForModEvent("PlayerTrack_Start", "PlayerSceneStart")
    RegisterForModEvent("PlayerTrack_End", "PlayerSceneEnd")
    RegisterForTrackedStatsEvent()
    RegisterForModEvent("SexLabClearCum", "CumAbsorb")
    ; RegisterForModEvent("SexLabOrgasmSeparate", "OnSexOrgasm")
Endfunction

Event CumAbsorb(form akTarget, int aiType)

    if PlayerRef.IsSwimming() || (akTarget as Actor) != PlayerRef
        return
    endif
    T_Show("I love the feeling of cum being absorbed through my skin!", "", 0)
EndEvent

int Function EvaluateCompleteScene(int inPutScene = -1)
    sslThreadController _thread
    if inPutScene >= 0
        _thread = Sexlab.GetController(inPutScene)
    else
        _thread =  Sexlab.GetPlayerController()
    endif
    if !_thread
        DBGTrace("No active Scene!")
    endif
    float playerArousalNow = playerref.GetFactionRank(sla_Arousal)
    int index = 0
    int max_rel = -4
    bool max_prot = false
    Actor[] ActorsIn = _thread.GetPositions()
    string output = ""
    float energyNew = 0
    float[] retVals = new float[2]
    Oenergy.nextAnnouncment = ""
    while index < ActorsIn.length
        Actor ActorRef = Actorsin[Index]
        int relatisonship = ActorRef.GetRelationshipRank(playerref)
        int isSucc = isSuccableOverload(ActorRef)
        if isSucc >= 0
            retVals = OEnergy.OrgasmEnergyValue(_thread, ActorRef)
            energyNew = retVals[0]
            if ActorRef
                max_rel = max(relatisonship, max_rel) as int
            endif
        elseif ActorRef != PlayerRef
            if deathModeActivated
                max_prot = true
                toggleDeathMode(true)
            endif
            string nextOutput = ActorRef.GetDisplayName() + " can't be drained"
            if ActorRef.HasMagicEffect(TSSD_DrainedDownSide) && isSucc > -1
                nextOutput += " yet"
            endif
            nextOutput += "!"
            queueStringForAnnouncement(nextOutput)
        endif
        index += 1
    EndWhile
    int max_relRank = -4
    index = 0
    while index < ActorsIn.length
        Actor ActorRef = Actorsin[Index]
        int relatisonship = ActorRef.GetRelationshipRank(playerref)
        if isEnabledAndNotPlayer(ActorRef)
            max_relRank = max(relatisonship, max_relRank) as int
        endif
        if max_relRank > 3 && deathModeActivated
            toggleDeathMode(true)
        endif
        index += 1
    EndWhile
    bool energyOutPut = true
    if deathModeActivated
        energyNew += (ActorsIn.Length - 1) * 100
        output += "Someone is about to die! "
    elseif (TSSD_TypeScarlet.GetValue() as int) == 1 && max_relRank == 4
        output += GetTypeDial("Scarlet", true)
        energyOutPut = false
    elseif ActorsIn.Length == 1 && playerArousalNow > 75
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
        energyOutPut = false
    endif
    string newOut = Oenergy.nextAnnouncment
    newOut += "\n" + output
    if energyOutPut
        newOut = "Energy gained: " + energyNew as int + "\n" + newOut
    endif
    T_Show(newOut  , "icon.dds", aiDelay = 0.0)
    
    return energyNew as int
Endfunction

bool Function increaseGlobalDeity(int index, int byVal = 1, int targetVal = -1)
    int additional = 0
    if index >= 5
        additional = 5
    endif
    bool isCompleted = tssd_dealwithcurseQuest.ModObjectiveGlobal(byVal, tssd_deityTrackers[index], 21 + index + additional, targetVal)
    advanceStageTwenty()
    return isCompleted
Endfunction

int Function isSuccableOverload(Actor ActorRef, bool ignoreMarker = false, bool afterSceneEnd = true)
    return isSuccable(ActorRef, TSSD_DrainedDownSide, playerref, ignoreMarker, afterSceneEnd)
Endfunction

bool Function isDeathSuccableOverload(Actor ActorRef, bool ignoreMarker = false, bool afterSceneEnd = true)
    return isDeathSuccable(ActorRef, TSSD_DrainedDownSide, playerref, ignoreMarker, afterSceneEnd)
EndFunction

Function PlayerSceneStart(Form FormRef, int tid)
    TSSD_FuckingInvincible.Cast(PlayerRef)
    playerArousal = playerref.GetFactionRank(sla_Arousal)
    sslThreadController _thread =  Sexlab.GetController(tid)
    Actor[] ActorsIn = Sexlab.GetController(tid).GetPositions()
    int indexIn = 0
    if !deathModeActivated && _thread.GetSubmissive(PlayerRef)
        bool aggressiveY = false
        while indexIn < ActorsIn.length
            Actor consentingActor = ActorsIn[indexIn]
            if consentingActor != PlayerRef && consentingActor.IsHostileToActor(PlayerRef) && !_thread.GetSubmissive(consentingActor)
                aggressiveY = true
            endif
            indexIn += 1
        endwhile
        if aggressiveY
            toggleDeathMode(true)
        endif
    endif
    indexIn = 0
    if TSSD_TypeScarlet.GetValue() == 1 
        while indexIn < ActorsIn.length
            Actor consentingActor = ActorsIn[indexIn]
            if consentingActor.GetRelationshipRank(PlayerRef) == 4 
                T_Show("My sweeheart " + consentingActor.GetDisplayName() , "menus/TSSD/ScarletHearts.dds", aiDelay = 2.0)
                MySweetHeart = consentingActor
                indexIn = 99
            endif
            indexIn += 1
        endwhile
    endif
    if SuccubusDesireLevel.GetValue() > -100.0
        PlayerRef.DispelSpell(TSSD_SuccubusDetectJuice)
    endif
    
    if Game.GetModByName("Tullius Eyes.esp") != 255 && (TSSD_TypeScarlet.GetValue() == 1 || cosmeticSettings[1] ) && cosmeticSettings[0]
        HeadPart tEyes = currentEyes()
        if tEyes
            PlayerEyes = tEyes
        endif
        setHeartEyes(PlayerEyes, true)
    endif
    if tssd_dealwithcurseQuest.GetStage() == 20
        int outerIndex = 0
        bool conSent = true
        actor consentingActor
        while outerIndex < ActorsIn.Length
            consentingActor = ActorsIn[outerIndex]
            if _thread.GetSubmissive(consentingActor)
                conSent = false
            endif
            outerIndex += 1
        endwhile
        if !tssd_dealwithcurseQuest.isobjectivefailed(24) ; Dibella
            int index = 0
            int val_to_increase = 0
            int deityNum = 3
            int toVal = 1000
            if !conSent
                deityNum = 8
                toVal = 500
            endif
            while index < ActorsIn.Length
                Actor WhoCums = ActorsIn[index]
                float lstTime = GetLastTimeSuccd(WhoCums, TimeOfDayGlobalProperty)
                if WhoCums != PlayerRef && (lstTime < 0 || lstTime > 7)
                    val_to_increase += 25
                elseif WhoCums != PlayerRef
                    val_to_increase += 5
                endif
                index+=1
            EndWhile
            increaseGlobalDeity(deityNum, val_to_increase, toVal)
        endif
        if !tssd_dealwithcurseQuest.isobjectivefailed(21) ; Mara
            int index = 0
            while index < ActorsIn.length
                Actor WhoCums = ActorsIn[index]
                float lstTime = GetLastTimeSuccd(WhoCums, TimeOfDayGlobalProperty)
                if WhoCums.GetHighestRelationshiprank() >= 3 && lstTime < 0
                    increaseGlobalDeity(5, 1, 5)
                endif
                index+=1
            EndWhile
        endif
    endif
    if deathModeActivated
        BerserkerMainImod.ApplyCrossFade(1)
    else        
        gainSuccubusXP(EvaluateCompleteScene(tid))
    endif
EndFunction

Function PlayerSceneEnd(Form FormRef, int tid)
    PlayerRef.DispelSpell(TSSD_FuckingInvincible)
    sslThreadController _thread =  Sexlab.GetController(tid)
    Actor[] ActorsIn = Sexlab.GetController(tid).GetPositions() 
    int index = 0
    int bonusReduction = 10
    while index < ActorsIn.Length
        Actor WhoCums = ActorsIn[index]
        if deathModeActivated
            WhoCums.PlayIdle(BleedOutStart)
        endif
        if  ((TSSD_TypeScarlet.GetValue() == 0 &&  WhoCums.GetRelationshipRank(PlayerRef) < 1) || \
            (TSSD_TypeScarlet.GetValue() == 1 &&  WhoCums.GetRelationshipRank(PlayerRef) >= 1)) && !PlayerRef.HasMagicEffect(TSSD_SatiatedEffect)
            gainSuccubusXP(1000,1000)
            RefreshEnergy(100)
        endif
        index+=1
    EndWhile
    ; gainSuccubusXP(EvaluateCompleteScene(tid))
    ; TSSD_DrainHealth.SetNthEffectMagnitude(1, min(ActorRef.GetActorValue("Health") - 10 ,new_drain_level))
    ; TSSD_DrainHealth.Cst(PlayerRef, ActorRef)
    if Actorsin.Length == 1 && PlayerRef.HasPerk(TSSD_DeityDibellaPerk) && searchForTargets() != PlayerRef
        bonusReduction += 10
    endif
    index = 0
    while index < ActorsIn.Length
        Actor WhoCums = ActorsIn[index]
        if WhoCums != PlayerRef
            if (TSSD_TypeScarlet.GetValue() != 1.0 || WhoCums.GetRelationshipRank(PlayerRef) < 4) && deathModeActivated && isDeathSuccableOverload(WhoCums)
                float succdVal = min(WhoCums.GetAV("Health"), getDrainLevel() )
                ; updateSuccyNeeds( succdVal, resetAfterEnd=false, isDeathModeActivated = true   ) TODO change to only if evil?
                TSSD_DrainHealth.SetNthEffectMagnitude(0, succdVal )
                TSSD_DrainHealth.Cast(PlayerRef, WhoCums)
                int reduction = 10
                if WhoCums.GetRelationshipRank(playerref) >= 0 && succdVal >= WhoCums.GetAV("Health") && !WhoCums.isHostileToActor(PlayerRef)
                    TSSD_EvilSuccubusQuest.ModObjectiveGlobal(1, TSSD_InnocentsSlain)
                    if !TSSD_EvilSuccubusQuest.IsRunning()
                        TSSD_EvilSuccubusQuest.Start()
                        TSSD_EvilSuccubusQuest.SetCurrentStageID(10)
                    endif
                elseif PlayerRef.HasPerk(TSSD_DeityArkayPerk)
                    reduction += 10
                endif
                gainSuccubusXP(succdVal, reduction + TSSD_TypeMahogany.GetValue() * succdVal)
                if TSSD_TypeMahogany.GetValue() == 1
                    RefreshEnergy(succdVal)
                endif
            endif
            TSSD_DrainedMarker.Cast(PlayerRef, WhoCums)
        endif
        index+=1
    EndWhile
    if Game.GetModByName("Tullius Eyes.esp") != 255
        setHeartEyes(PlayerEyes, false)
    endif
    if deathModeActivated && SuccubusDesireLevel.GetValue() >= -99
        toggleDeathMode(true)
    endif
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
    int sexualityPlayer = sslStats.GetSexuality(PlayerRef)
    int genderPlayer = min(Sexlab.GetSex(PlayerRef), 1) as int
    if genderPlayer == 0
        sexualityPlayer = 100 - sexualityPlayer
    endif
    int index = 0
    if TSSD_TypeSundown.GetValue() != 1.0
        while index < (amount_of_hours as int)
            int maleSexPartner = (0.5 + Utility.RandomInt(0, sexualityPlayer) / 100) as int
            sslStats.AddSex(PlayerRef, timespent = 1.0,  withplayer = true, \
        isaggressive = TSSD_TypeMahogany.GetValue() == 1.0, Males = 1 + 1 - genderPlayer , Females = 1 - maleSexPartner + genderPlayer, Creatures =  0)
            index += 1
        endwhile
    endif
    slsfListener.onWaitPassive(amount_of_hours)
Endfunction




Function toggleSpells(int newToggle = -1)
    if newToggle == -1
        newToggle = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iSpellsAdded:Main")
    endif
    int indexOfA = 1
    while indexOfA < SuccubusAbilitiesNames.length
        if PlayerRef.HasPerk(SuccubusAbilitiesPerks[indexOfA]) && newToggle > 0
            PlayerRef.AddSpell(SuccubusAbilitiesSpells[indexOfA], false)
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



bool Function GetHabitationCorrect(Location curLoc) 
    return (\
                (TSSD_TypeScarlet.GetValue() >= 1 && curLoc.HasKeyword(LocTypePlayerHouse)) ||\
                (TSSD_TypeScarlet.GetValue() <= 0 && curLoc.HasKeyword(LocTypeInn) || curLoc.HasKeyword(LocTypeHabitationHasInn)) ||\
                (TSSD_TypeMahogany.GetValue() >= 1 && !curLoc.HasKeyword(LocTypeHabitation))    )
            
EndFunction

Function onGameReload()
    if SuccubusDesireLevel.GetValue() > -101
        RegisterSuccubusEvents()
    endif
    ; RegisterForCrosshairRef()
    isHoveringPrey = false
    Maintenance()
    cosmeticSettings = ReadInCosmeticSetting()
    gainSuccubusXP(0)
    if !spellToggle
        toggleSpells(MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iSpellsAdded:Main"))
    endif

    int jArr = JDB.solveObj(".tssdspellids")
    int index = 0
    while index < JValue.count(jArr)
        int innerJ = jArray.getObj(jArr, index)
        adjustSpell( jArray.Getint(innerJ, 1) as bool, jArray.GetStr(innerJ, 2), jArray.GetInt(innerJ, 3)  ,\
        MCM.GetModSettingString("TintsOfASuccubusSecretDesires",jArray.getStr(innerJ, 0)))
        index += 1
    endwhile

    tDialogue.onGameReload()

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
            PlayerRef.AddSpell(toAdj, false)
        endif
    endif
Endfunction

Function NotificationSpam(string Displaying)
    if MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bSpamNotifications:Main")
        Debug.Notification( "You picked: " + Displaying )
    endif
Endfunction

;Events ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



  
Event OnTrackedStatsEvent(string asStatFilter, int aiStatValue)
    if  (TSSD_TypeScarlet.GetValue() as int) == 1 && ((asStatFilter == "Books Read") || asStatFilter == "Skill Increases" || asStatFilter == "Locations Discovered")
        int toIncrease = 2
        if MySweetHeart
            Debug.Notification("Oh I gotta talk with " + MySweetHeart.GetDisplayName() +  " about that!")
        else
            Debug.Notification("I am so alone!")
            toIncrease += 2
        endif
        SuccubusXpAmount.Mod(10)
    endif
endEvent



Event OnUpdateGameTime()
    float timeBetween = (TimeOfDayGlobalProperty.GetValue() - last_checked) * 100
    if timeBetween > 1
        float valBefore = SuccubusDesireLevel.GetValue()
        Location curLoc = Game.GetPlayer().GetCurrentLocation()
        float chVal = 1
        float energy_loss = timeBetween * chVal
        if PlayerRef.HasMagicEffect(TSSD_SatiatedEffect)
            energy_loss *= 0.1
        endif
        if curLoc && valBefore > 0 && valBefore < 50 && PlayerRef.HasPerk(TSSD_Body_PassiveEnergy1) && GetHabitationCorrect(curLoc) && timeBetween >= 1
            if PlayerRef.HasPerk(TSSD_Body_PassiveEnergy1.GetNextPerk().GetNextPerk())
                RefreshEnergy(energy_loss * 20, 50)
            elseif PlayerRef.HasPerk(TSSD_Body_PassiveEnergy1.GetNextPerk())
                RefreshEnergy(energy_loss * 10, 50)
            endif
            float changeAmount = (SuccubusDesireLevel.GetValue() - valBefore) /10
            AddToStatistics(changeAmount)
            energy_loss = 0
        endif
        if energy_loss > 0
            energy_loss *= -1
            last_checked = TimeOfDayGlobalProperty.GetValue()
            RefreshEnergy(energy_loss)
        endif
    endif
    float succNeedVal = SuccubusDesireLevel.GetValue()
    if succNeedVal <= TSSD_ravanousNeedLevel.GetValue() && succNeedVal > -101
        TSSD_SuccubusDetectJuice.Cast(PlayerRef, PlayerRef)
        if !deathModeActivated
            toggleDeathMode()
        endif
    endif
endEvent

Event OnMenuOpen(String MenuName)
    if MenuName == "Dialogue Menu" && SuccubusDesireLevel.GetValue() <= TSSD_ravanousNeedLevel.GetValue()
        UI.InvokeString("HUD Menu", "_global.skse.CloseMenu", "Dialogue Menu")
        T_Show("NO TIME TO TALK!", "icon.dds", aiDelay = 2.0)
    endif 
    isHoveringPrey = false
EndEvent

Event OnMenuClose(String MenuName)
    if MenuName == "StatsMenu"
        toggleSpells(-1)
    endif
EndEvent

Event OnInit()
	RegisterForModEvent("iWantWidgetsReset", "OniWantWidgetsReset")
    onGameReload()
EndEvent

 ;/ 
Event OnCrosshairRefChange(ObjectReference ref)
    SkyInteract myBinding = SkyInteract_Util.GetSkyInteract()
    Actor Aref = ref as Actor

    if Aref && Aref.GetFactionRank(TSSD_EnthralledFaction) >= 1
        myBinding.Add("tssd_getTargetCross", "Thrall Actions", 47)
        HoveredPrey = Aref
    else
        HoveredPrey = PlayerRef
    endif

	If Aref && isSuccableOverload(Aref) > 0 && !Aref.isDead()
        myBinding.Add("tssd_getTargetCross", "Succubus Actions " + isSuccableOverload(Aref), 47)
        int lasttime = (GetLastTimeSuccd(Aref, TimeOfDayGlobalProperty) * 300) as int
        if lasttime > 100.0 || lasttime < 0.0
            lasttime = 100
        endif
        if lasttime > 50
            myBinding.Add("tssd_getTargetPct", lasttime + "%",-1)
            isHoveringPrey = true
        endif
        RegisterForSingleUpdate(1)
    else
        myBinding.Remove("tssd_getTargetCross")
        myBinding.Remove("tssd_getTargetPct")
        isHoveringPrey = false
	EndIf
EndEvent

Event OnUpdate()
    if  Game.GetCurrentCrosshairRef() && Game.GetCurrentCrosshairRef() == HoveredPrey
        RegisterForSingleUpdate(1)
    else
        SkyInteract myBinding = SkyInteract_Util.GetSkyInteract()
        myBinding.Remove("tssd_getTargetCross")
        myBinding.Remove("tssd_getTargetPct")
        isHoveringPrey = false
        HoveredPrey = PlayerRef
    endif
EndEvent
 /;