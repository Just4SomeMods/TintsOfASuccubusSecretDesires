Scriptname tssd_actions extends Quest

import tssd_utils
import PapyrusUtil
import storageutil
import CustomSkills

Actor Property PlayerRef Auto
tssd_slsfrscript Property slsfListener Auto
tssd_dialogue Property tDialogue Auto
tssd_menus Property tMenus Auto
SexLabFramework Property SexLab Auto
sslActorStats Property sslStats Auto
tssd_PlayerEventsScript Property tEvents Auto

Faction Property sla_Arousal Auto
Faction Property TSSD_EnthralledFaction Auto
Faction Property TSSD_MarkedForDeathFaction Auto

Actor HotDemonTarget

int prevRelRankHotDemon = 0

Spell[] Property SuccubusAbilitiesSpells Auto
Perk[] Property SuccubusAbilitiesPerks  Auto
String[] Property SuccubusAbilitiesNames  Auto    

Idle property BleedOutStart auto

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
GlobalVariable Property GameHours Auto
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
Perk Property TSSD_Drain_ExtractSemen Auto
Perk Property TSSD_Drain_GentleDrain4 Auto
Perk Property TSSD_Seduction_HotDemon1 Auto
Perk Property TSSD_Drain_CollaredEvil1 Auto
Perk Property TSSD_Base_PowerGrowing Auto
Perk Property TSSD_Drain_RefreshHealth Auto

Spell Property TSSD_SuccubusDetectJuice Auto
Spell Property TSSD_Overstuffed Auto
Spell Property TSSD_DrainHealth Auto
Spell Property TSSD_DrainedMarker Auto
Spell Property TSSD_Satiated Auto
Spell Property TSSD_RejectionPoison Auto
Spell Property TSSD_FuckingInvincible Auto

bool Property deathModeActivated Auto Hidden
bool modifierKeyIsDown = false
bool hasAbsorbedCum = false

bool [] cosmeticSettings

Actor[] Property cell_ac auto Hidden

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

HeadPart PlayerEyes
HeadPart ThrallEyes

int lastUsed = -1
int lastUsedSub = -1
int spellToggle
int numHostileActors
int lastPerc = -1

string tssd_SpellDebugProp = "-1"
MagicEffect Property TSSD_DrainedDownSide Auto
MagicEffect Property TSSD_ZenitharDonationSpellEffect Auto  


float last_checked
float timer_internal = 0.0
float _updateTimer = 0.5

String Property CUM_VAGINAL = "sr.inflater.cum.vaginal" autoreadonly hidden
String Property CUM_ANAL = "sr.inflater.cum.anal" autoreadonly Hidden
String Property CUM_ORAL = "sr.inflater.cum.oral" autoreadonly 


;SPECIFIC UTILITY FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Function to adjust energy level
Function RefreshEnergy(float adjustBy, int upTo = 100, bool isDeathModeActivated = false)
    if  tssd_dealwithcurseQuest.IsRunning() && !tssd_dealwithcurseQuest.isobjectivefailed(24)
        upTo = 19
    endif
    float lastVal = SuccubusDesireLevel.GetValue()
    int lowerBound = -100
    ;/ 
    if (TSSD_TypeSundown.GetValue() as int) == 1
        lowerBound = 0
    endif /;
    if playerRef.HasPerk(TSSD_Drain_RefreshHealth) && adjustBy > 0
        PlayerRef.RestoreActorValue("Health", adjustBy)
    endif
    if (lastVal > -100 || isDeathModeActivated)
        SuccubusDesireLevel.SetValue( min(upTo, max( lowerBound,  lastVal + adjustBy) ) )
    endif
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
    if playerInSafeHaven()
        energyLoss = 0
        RefreshEnergy(byValue/10)
        SuccubusXpAmount.Mod(byValue)
    elseif (succNeedVal + 10) > energyLoss * -1
        RefreshEnergy( energyLoss )
        int multI = 1
        if PlayerRef.HasPerk(tMenus.SuccubusTintPerks[11])
            multI *= 2
        endif
        if PlayerRef.HasPerk(TSSD_Base_PowerGrowing)
            multI *= 2
        endif
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
        if curRef && curRef != PlayerRef && curRef.isHostileToActor(PlayerRef) && curRef.IsEnabled()
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
    if nearestActor &&  numHostileActors == 1 
        isFading = true
        tarRef = nearestActor
        return nearestActor
    endif
    return PlayerRef
EndFunction

Actor Function searchForTargets()
    int radius = getScanRange()
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
            if (!nearestActor || min_distance > PlayerRef.GetDistance(curRef) )
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

bool Function playerInSafeHaven()
        Location curLoc = Game.GetPlayer().GetCurrentLocation()
        if !curLoc return false endif
        bool safeHaven = (curLoc.HasKeyword(LocTypePlayerHouse)) || curLoc.HasKeyword(LocTypeInn) \
        || curLoc.HasKeyword(LocTypeHabitationHasInn)
        return safeHaven
EndFunction


Function actDefeated(actor tarRef, bool changeGameTime = true)
    
    ;TSSD_FuckingInvincible.Cast(PlayerRef)
    if tarRef
        AzuraFadeToBlack.Apply()
        if changeGameTime
            PlayerRef.PlayIdle(BleedOutStart)
            GameHours.Mod(1) ; TODO
            Utility.Wait(2.5)
            tarRef.MoveTo(PlayerRef, 0, 0)
            tarRef.enable()
        endif
        ImageSpaceModifier.RemoveCrossFade(3)
        Sexlab.StartSceneQuick(akActor1 = PlayerRef, akActor2 = tarRef, akSubmissive = PlayerRef)
    endif
Endfunction

Function RegisterSuccubusEvents()
    RegisterForUpdateGameTime(0.4)
    RegisterForMenu("Dialogue Menu")
    RegisterForMenu("StatsMenu")
    if MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bDebugMode:Main")
        ; PlayerRef.AddPerk(TSSD_Seduction_OfferSex)
    endif
    RegisterForTrackedStatsEvent()
    RegisterForModEvent("SexLabClearCum", "CumAbsorb")
    RegisterForModEvent("PlayerTrack_Start", "PlayerSceneStart")
    RegisterForModEvent("PlayerTrack_End", "PlayerSceneEnd")
    
Endfunction

Event CumAbsorb(form akTarget, int aiType)
    if !PlayerRef.IsSwimming() && (akTarget as Actor) == PlayerRef
        tEvents.incrValAndCheck(0, 1)
        if PlayerRef.HasPerk(TSSD_Drain_ExtractSemen)
            hasAbsorbedCum = true
        endif
    endif
EndEvent

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
    while index < (amount_of_hours as int)
        int maleSexPartner = (0.5 + Utility.RandomInt(0, sexualityPlayer) / 100) as int
        sslStats.AddSex(PlayerRef, timespent = 1.0,  withplayer = true, \
    isaggressive = PlayerRef.HasPerk(tMenus.SuccubusTintPerks[20]), Males = 1 + 1 - genderPlayer , Females = 1 - maleSexPartner + genderPlayer, Creatures =  0)
        index += 1
    endwhile
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

Function gainAllPerks()
    
    int index = 0
    string[] succTraits = GetSuccubusStartPerksAll()
    while index < succTraits.Length
        int PerkID =  JDB.solveInt(".tssdperks." + succTraits[index] + ".id")
        PlayerRef.AddPerk(Game.GetFormFromFile(PerkID, "TintsOfASuccubusSecretDesires.esp") as Perk)
        index += 1
    EndWhile

EndFunction

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
                (PlayerRef.HasPerk(tMenus.SuccubusTintPerks[19]) && curLoc.HasKeyword(LocTypePlayerHouse)) ||\
                (PlayerRef.HasPerk(tMenus.SuccubusTintPerks[19]) && curLoc.HasKeyword(LocTypeInn) || curLoc.HasKeyword(LocTypeHabitationHasInn)) ||\
                (PlayerRef.HasPerk(tMenus.SuccubusTintPerks[20]) >= 1 && !curLoc.HasKeyword(LocTypeHabitation))    )
            
EndFunction

Function onGameReload()
    if SuccubusDesireLevel.GetValue() > -101
        RegisterSuccubusEvents()
    endif
    ; RegisterForCrosshairRef()
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

    tEvents.onGameReload()
    tDialogue.onGameReload()
    HotDemonTarget = PlayerRef
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
    if  PlayerRef.HasPerk(tMenus.SuccubusTintPerks[19]) && ((asStatFilter == "Books Read") || asStatFilter == "Skill Increases" || asStatFilter == "Locations Discovered")
        int toIncrease = 2
        Actor[] myThralls = PO3_SKSEFunctions.GetAllActorsInFaction(TSSD_EnthralledFaction)
        if myThralls.Length >= 1
            T_Show("Oh I gotta talk with " + myThralls[Utility.RandomInt(0, myThralls.Length -1)].GetDisplayName() +  " about that!", "menus/tssd/small/scarlet.dds")
        else
            T_Show("I am so alone!")
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
        if PlayerRef.HasPerk(TSSD_Drain_CollaredEvil1)
            energy_loss *= 0.5
        endif
        if curLoc && valBefore > 0 && valBefore < 50  && GetHabitationCorrect(curLoc) && timeBetween >= 1
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
    if succNeedVal <= TSSD_ravanousNeedLevel.GetValue() && succNeedVal > -101 && PlayerRef.HasPerk(TSSD_Base_PowerGrowing)
        TSSD_SuccubusDetectJuice.Cast(PlayerRef, PlayerRef)
        if !deathModeActivated
            toggleDeathMode()
        endif
    endif
    if hasAbsorbedCum
        T_Show("I love the feeling of cum being absorbed through my skin!", "", 0)

        RefreshEnergy(10)
    endif
    DBGTRACE(PlayerRef.HasPerk(tMenus.SuccubusTintPerks[0]))
    if PlayerRef.HasPerk(tMenus.SuccubusTintPerks[0]) && !PlayerRef.HasMagicEffect(TSSD_SatiatedEffect)
        
        int eid = ModEvent.Create("slaUpdateExposure")
        ModEvent.PushForm(eid, PlayerRef)
        ModEvent.PushFloat(eid, 99)
        ModEvent.Send(eid)
    endif
endEvent

Event OnMenuOpen(String MenuName)
    if MenuName == "Dialogue Menu"
        
        Actor tempActor = SPE_Actor.GetPlayerSpeechTarget()
        if SuccubusDesireLevel.GetValue() <= TSSD_ravanousNeedLevel.GetValue() && PlayerRef.HasPerk(TSSD_Base_PowerGrowing)
            UI.InvokeString("HUD Menu", "_global.skse.CloseMenu", "Dialogue Menu")
            T_Show("NO TIME TO TALK!", "icon.dds", aiDelay = 2.0)
        elseif PlayerRef.HasPerk(TSSD_Seduction_HotDemon1)
            if !tempActor.IsChild() && HotDemonTarget == PlayerRef 
                DBGTRACE(tempActor.GetDisplayName())
                HotDemonTarget = tempActor
                int eid = ModEvent.Create("slaUpdateExposure")
                ModEvent.PushForm(eid, HotDemonTarget)
                float arousalPush = 10.0
                if PlayerRef.HasPerk(TSSD_Seduction_HotDemon1.GetNextPerk())
                    arousalPush = 99.0
                endif
                ModEvent.PushFloat(eid, arousalPush)
                ModEvent.Send(eid)
                if PlayerRef.HasPerk(TSSD_Seduction_HotDemon1.GetNextPerk().GetNextPerk())
                    prevRelRankHotDemon = HotDemonTarget.GetRelationshipRank(PlayerRef)
                    HotDemonTarget.SetRelationShipRank(PlayerRef, 1)
                endif
            endif
        endif
    endif
EndEvent

Event OnMenuClose(String MenuName)
    if MenuName == "StatsMenu"
        toggleSpells(-1)
    elseif MenuName == "Dialogue Menu" && HotDemonTarget != PlayerRef
        int eid = ModEvent.Create("slaUpdateExposure")
        ModEvent.PushForm(eid, HotDemonTarget)
        ModEvent.PushFloat(eid, -100)
        ModEvent.Send(eid)
        HotDemonTarget = PlayerRef
    endif    
EndEvent



Event PlayerSceneStart(Form FormRef, int tid)
    DBGTRACE("PLAYERSCENESTARTBEGIN")
    TSSD_FuckingInvincible.Cast(PlayerRef)
    sslThreadController _thread =  Sexlab.GetController(tid)
    Actor[] ActorsIn = Sexlab.GetController(tid).GetPositions()
    int indexIn = 0
    if !deathModeActivated && _thread.GetSubmissive(PlayerRef)
        bool aggressiveY = false
        while indexIn < ActorsIn.length
            Actor consentingActor = ActorsIn[indexIn]
            if consentingActor != PlayerRef 
                if consentingActor.IsHostileToActor(PlayerRef) && !_thread.GetSubmissive(consentingActor)
                    aggressiveY = true
                endif
                if PlayerRef.HasPerk(tMenus.SuccubusTintPerks[19])  && consentingActor.GetFactionRank(TSSD_EnthralledFaction) == 1
                    T_Show("My sweeheart " + consentingActor.GetDisplayName() , "menus/TSSD/ScarletHearts.dds", aiDelay = 2.0)
                endif                
                TSSD_DrainedMarker.Cast(PlayerRef, consentingActor)
            endif
            indexIn += 1
        endwhile
        if aggressiveY
            toggleDeathMode(true)
        endif
    endif
    if SuccubusDesireLevel.GetValue() > -100.0
        PlayerRef.DispelSpell(TSSD_SuccubusDetectJuice)
    endif
    
    if Game.GetModByName("Tullius Eyes.esp") != 255 && (PlayerRef.HasPerk(tMenus.SuccubusTintPerks[19]) || cosmeticSettings[1] ) && cosmeticSettings[0]
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
    endif
    DBGTRACE("PLAYERSCENESTARTFIN")
EndEvent

Event PlayerSceneEnd(Form FormRef, int tid)
    DBGTRACE("PLAYERSCENEENDBEGIN")
    PlayerRef.DispelSpell(TSSD_FuckingInvincible)
    if Game.GetModByName("Tullius Eyes.esp") != 255
        setHeartEyes(PlayerEyes, false)
    endif

    sslThreadController _thread =   Sexlab.GetController(tid)
    Actor[] ActorsIn = _thread.GetPositions()
    int indexIn = 0
    while indexIn < ActorsIn.length
        Actor consentingActor = ActorsIn[indexIn]
        if consentingActor.GetFactionRank(TSSD_MarkedForDeathFaction) >= 1
            consentingActor.Kill(PlayerRef)
        endif
        indexIn += 1
    endwhile   
    if deathModeActivated && SuccubusDesireLevel.GetValue() >= -99
        toggleDeathMode(true)
    endif
    DBGTRACE("PLAYERSCENEENDFIN")
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

