Scriptname tssd_actions extends Quest

import tssd_utils
import PapyrusUtil
import storageutil
import CustomSkills


Actor Property PlayerRef Auto


;Actor[] Property cell_ac Auto


Faction Property TSSD_EnthralledFaction Auto
;Faction Property TSSD_MarkedForDeathFaction Auto
;Faction Property sla_Arousal Auto


GlobalVariable Property GameHours Auto
GlobalVariable Property SkillSuccubusBaseLevel Auto
;GlobalVariable Property SkillSuccubusBodyLevel Auto
GlobalVariable Property SkillSuccubusDrainLevel Auto
GlobalVariable Property TSSD_PerkPointsBought Auto
GlobalVariable Property TSSD_SuccubusPerkPoints Auto
;GlobalVariable Property SkillSuccubusSeductionLevel Auto
GlobalVariable Property SuccubusDesireLevel Auto
GlobalVariable Property SuccubusXpAmount Auto
GlobalVariable Property TSSD_DebugMode Auto
;GlobalVariable Property TSSD_InnocentsSlain Auto
GlobalVariable Property TSSD_ravanousNeedLevel Auto


GlobalVariable[] Property tssd_deityTrackers Auto


Idle Property BleedOutStart Auto


ImageSpaceModifier Property AzuraFadeToBlack Auto
ImageSpaceModifier Property BerserkerMainImod Auto


;Keyword Property LocTypeCity Auto
;Keyword Property LocTypeClearable Auto
Keyword Property LocTypeHabitation Auto
Keyword Property LocTypeHabitationHasInn Auto
Keyword Property LocTypeInn Auto
Keyword Property LocTypePlayerHouse Auto
Keyword Property LocTypeGuild Auto
Keyword Property LocTypeStore Auto
Keyword Property LocTypeHouse Auto
Keyword Property LocTypeDwelling Auto


MagicEffect Property TSSD_DrainedDownSide Auto
MagicEffect Property TSSD_SatiatedEffect Auto
MagicEffect Property TSSD_SuccubusDetectEnergyFF Auto
;MagicEffect Property TSSD_ZenitharDonationSpellEffect Auto


Perk Property TSSD_Base_CapIncrease1 Auto
Perk Property TSSD_Base_IncreaseScentRange1 Auto
Perk Property TSSD_Base_PowerGrowing Auto
;Perk Property TSSD_Body_Overstuffed Auto
Perk Property TSSD_Body_PassiveEnergy1 Auto
Perk Property TSSD_DeityAllPerk Auto
;Perk Property TSSD_DeityArkayPerk Auto
;Perk Property TSSD_DeityDibellaPerk Auto
Perk Property TSSD_Drain_CollaredEvil1 Auto
;Perk Property TSSD_Drain_DrainMore1 Auto
Perk Property TSSD_Drain_ExtractSemen Auto
Perk Property TSSD_Drain_GentleDrain1 Auto
;Perk Property TSSD_Drain_GentleDrain4 Auto
Perk Property TSSD_Drain_RefreshHealth Auto
Perk Property TSSD_Seduction_HotDemon1 Auto
;Perk Property TSSD_Seduction_Leader Auto
Perk Property TSSD_Seduction_OfferSex Auto
Perk Property TSSD_Base_ChangesPerk Auto



;Quest Property TSSD_EvilSuccubusQuest Auto
Quest Property tssd_dealwithcurseQuest Auto


Spell Property TSSD_DebugToFaction Auto
;Spell Property TSSD_DrainHealth Auto
;Spell Property TSSD_DrainedMarker Auto
Spell Property TSSD_FuckingInvincible Auto
;Spell Property TSSD_Overstuffed Auto
Spell Property TSSD_RejectionPoison Auto
Spell Property TSSD_Satiated Auto
Spell Property TSSD_SuccubusDetectJuice Auto

;String Property CUM_ANAL Auto
;String Property CUM_ORAL Auto
;String Property CUM_VAGINAL Auto


bool Property deathModeActivated Auto Hidden


SexLabFramework Property SexLab Auto
sslActorStats Property sslStats Auto
tssd_PlayerEventsScript Property tEvents Auto
tssd_dialogue Property tDialogue Auto
tssd_menus Property tMenus Auto
tssd_orgasmenergylogic Property tOrgasmLogic Auto
tssd_slsfrscript Property slsfListener Auto
TSSD_InflationHandler Property tInflation Auto
tssd_curequestvariables Property tCVals Auto
TSSD_SucieDailyScript Property tSucieThings Auto
tssd_SuccubusBrands Property tBrand Auto 

FormList Property TSSD_ShrinesWithQuests Auto

bool ade

Actor HotDemonTarget
Actor Property TSSD_CursedWoman Auto

int prevRelRankHotDemon = 0

bool modifierKeyIsDown = false
bool hasAbsorbedCum = false
bool isStartingDefeated = false

HeadPart PlayerEyes
HeadPart ThrallEyes

int lastUsed = -1
int lastUsedSub = -1
int spellToggle
int numHostileActors
int lastPerc = -1
int Property allInOneKey Auto Hidden

string tssd_SpellDebugProp = "-1"

float last_checked
float timer_internal = 0.0
float _updateTimer = 0.5
float lastScarletTalk = 999.0

;String Property CUM_VAGINAL = "sr.inflater.cum.vaginal" autoreadonly hidden
;String Property CUM_ANAL = "sr.inflater.cum.anal" autoreadonly Hidden
;String Property CUM_ORAL = "sr.inflater.cum.oral" autoreadonly 


Race Property WolfRace Auto
Race Property WereWolfBeastRace Auto
Faction Property CompanionsCirclePlusKodlak Auto
Faction Property WereWolfFaction Auto
Faction Property WolfFaction Auto
Faction Property DogFaction Auto

SkyInteract myBinding

;SPECIFIC UTILITY FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Function to adjust energy level
Function RefreshEnergy(float adjustBy, int upTo = 100, bool isDeathModeActivated = false)
    float lastVal = SuccubusDesireLevel.GetValue()
    int lowerBound = -100
    if PlayerRef.HasPerk(TSSD_DeityAllPerk)
        lowerBound = 0
    endif
    if playerRef.HasPerk(TSSD_Drain_RefreshHealth) && adjustBy > 0
        PlayerRef.RestoreActorValue("Health", adjustBy)
    endif
    If PlayerRef.HasPerk(TSSD_Base_CapIncrease1)
        upTo += 100
    endif
    If PlayerRef.HasPerk(TSSD_Base_CapIncrease1.GetNextPerk())
        upTo += 200
    endif
    If PlayerRef.HasPerk(TSSD_Base_CapIncrease1.GetNextPerk().GetNextPerk())
        upTo += 600
    endif
    if (lastVal > -100 || isDeathModeActivated)
        SuccubusDesireLevel.SetValue( min(upTo, max( lowerBound,  lastVal + adjustBy) ) )
    endif
    updateHeartMeter()
Endfunction

Function updateHeartMeter(bool forceShow = false)
    
    int lastVal = SuccubusDesireLevel.GetValue() as int
    int nxtPerc = Min(5, ((SuccubusDesireLevel.GetValue() / 20  ) + 0.5) as int) as int
    if ((nxtPerc != lastPerc) || forceShow) && !Sexlab.IsActorActive(PlayerRef)
        T_Show(lastVal, "menus/TSSD/" + nxtPerc + "H.dds" )
        lastPerc = nxtPerc
    endif
EndFunction

float Function getDrainLevel(bool isGentle = false)
    float new_drain_level = (100 + SkillSuccubusDrainLevel.GetValue() * 4)

        return new_drain_level
Endfunction



Function toggleDeathMode(bool makeAnnouncement = true, bool overWriteOn = false)
    if (deathModeActivated != false) && (deathModeActivated != true)
        deathModeActivated = false
    endif
    if overWriteOn
        deathModeActivated = true
    else
        deathModeActivated = !deathModeActivated
    endif
    if deathModeActivated
        BerserkerMainImod.ApplyCrossFade(1)
        if makeAnnouncement
            T_Show("SOMEONE NEEDS TO DIE NOW!", "icon.dds", aiDelay = 2.0)
        endif
        
        if tMenus.cosmeticSettings[4]
            int jjM = JDB.solveObj(".tssdtints")
            
            int indexIn = 0
            int numOfTints = 1
            int mashedCol = 16711680
            while indexIn < JMap.Count(jjM)
                int toAdd = 0
                int innerJJ = JMap.getObj(jjM, "" + indexIN)

                if PlayerRef.HasPerk(getPerkNumber(indexIn))
                    numOfTints += 1
                    mashedCol += DbMiscFunctions.ConvertHexToInt(JMap.GetStr(innerJJ, "colorHex"))
                endif
                indexIn += 1
            endwhile
            ColorForm nwForm = DbSkseFunctions.CreateColorForm( (mashedCol / numOfTints) as int )
            PO3_SKSEFunctions.SetSkinColor(PlayerRef, nwForm)
        EndIf
        Utility.Wait(3)
        BerserkerMainImod.Remove()
    else
        BerserkerMainImod.Remove()
        PO3_SKSEFunctions.ResetActor3D(PlayerRef, "PO3_TINT")
    endif
    slavetats.mark_actor(PlayerRef)
	slavetats.synchronize_tattoos(PlayerRef, false)
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
        if PlayerRef.HasPerk(getPerkNumber(11))
            multI *= 2
        endif
        if PlayerRef.HasPerk(TSSD_Base_PowerGrowing)
            multI *= 2
        endif
        if PlayerRef.HasPerk(getPerkNumber(19))
            multI *= 5
        endif
        SuccubusXpAmount.Mod(byValue)
    else
        SuccubusXpAmount.Mod(succNeedVal * -1)
        RefreshEnergy( succNeedVal * -1 )
    endif
    if CustomSkills.GetAPIVersion() >= 3
        byValue *= 1 + ( (tBrand.amountOfBrands - 1) / 3.0)
        CustomSkills.AdvanceSkill("SuccubusBaseSkill",byValue)
    endif
EndFunction


int Function getScanRange()
    return 70 * ( 1 + PlayerRef.HasPerk(TSSD_Base_IncreaseScentRange1) as int) ; Skyrim Units to meters
Endfunction

Function advanceStageTwenty()
    if !tssd_dealwithcurseQuest.isRunning()
        return
    endif
    int index = 0
    while index < 5
        if tssd_dealwithcurseQuest.IsObjectiveCompleted(31 + index)
            tssd_dealwithcurseQuest.SetObjectiveFailed(21 + index)
            toggleCActions(index)
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

Actor Function getCombatTarget(bool onlyLonely = false)

    Actor[] cT = PO3_SKSEFunctions.GetCombatTargets(PlayerRef)
    if ct.length == 0
        return playerRef
    endif
    if cT.Length == 1 || !onlyLonely
        return cT[0]
    endif
    return PlayerRef
EndFunction


bool Function playerInSafeHaven()
        Location curLoc = Game.GetPlayer().GetCurrentLocation()
        if !curLoc
            return false
        endif
        bool safeHaven = (curLoc.HasKeyword(LocTypePlayerHouse)) || curLoc.HasKeyword(LocTypeInn) || curLoc.HasKeyword(LocTypeDwelling) || curLoc.HasKeyword(LocTypeHabitation) || curLoc.HasKeyword(LocTypeGuild) || curLoc.HasKeyword(LocTypeHouse) || curLoc.HasKeyword(LocTypeStore)
        return safeHaven
EndFunction


bool Function actDefeated(actor tarRef, bool changeGameTime = true)
    
    ;TSSD_FuckingInvincible.Cast(PlayerRef)
    if tarRef && !isStartingDefeated
        isStartingDefeated = true
        AzuraFadeToBlack.Apply()
        if changeGameTime
            PlayerRef.PlayIdle(BleedOutStart)
            GameHours.Mod(1) ; TODO
            Utility.Wait(2.5)
            tarRef.MoveTo(PlayerRef, 0, 0)
            tarRef.enable()
        endif
        ImageSpaceModifier.RemoveCrossFade(3)
        if (Sexlab.StartSceneQuick(akActor1 = tarRef, akActor2 = PlayerRef,  akSubmissive = PlayerRef, astags = "-love, -bed, -furniture, rape")) == none
            if Sexlab.StartSceneQuick(tarRef, PlayerRef, akSubmissive = PlayerRef) == none
                Utility.Wait(3)
                isStartingDefeated = false
                return false
            endif
        endif
        Utility.Wait(3)
        isStartingDefeated = false
        return true
    endif
    Utility.Wait(3)
    isStartingDefeated = false
    return false
Endfunction

Function RegisterSuccubusEvents()
    RegisterForSingleUpdateGameTime(0.4)
    RegisterForMenu("Dialogue Menu")
    RegisterForMenu("BarterMenu")
    RegisterForMenu("Training Menu")
    RegisterForMenu("StatsMenu")
    if MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bDebugMode:Main")
        ; PlayerRef.AddPerk(TSSD_Seduction_OfferSex)
    endif
    RegisterForTrackedStatsEvent()
    RegisterForModEvent("SexLabClearCum", "CumAbsorb")    
Endfunction

Event CumAbsorb(form akTarget, int aiType)
    if !PlayerRef.IsSwimming() && (akTarget as Actor) == PlayerRef
        tOrgasmLogic.incrValAndCheck(0, 1)
        if PlayerRef.HasPerk(TSSD_Drain_ExtractSemen)
            hasAbsorbedCum = true
        endif
    endif
EndEvent

Function toggleCActions(int index)
    
        if index == 0
            tCVals.toggleCurse("Mara")
        elseif index == 2
            tCVals.toggleCurse("Julianos")
        elseif index == 3
            tCVals.toggleCurse("Dibella")
        elseif index == 4
            tCVals.toggleCurse("Akatosh")
        endif

EndFunction

bool Function increaseGlobalDeity(int index, float byVal = 1, int targetVal = -1)
    if !tssd_dealwithcurseQuest.GetStage() >= 20
        return
    endif
    int additional = 0
    if index >= 5
        additional = 5
    endif
    float valBefore = tssd_deityTrackers[index].GetValue()
    int percDone = (valBefore / targetVal * 5) as int
    bool shouldDisplay = (percDone < (((byVal + valBefore) / targetVal * 5) as int)) || valBefore == 0

    bool isCompleted = tssd_dealwithcurseQuest.ModObjectiveGlobal(byVal, tssd_deityTrackers[index], 21 + index + additional, targetVal, true, true, shouldDisplay)
    advanceStageTwenty()
    if isCompleted
        toggleCActions(index)
        tCVals.completeQuest(index)
    endif
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
    isaggressive = PlayerRef.HasPerk(getPerkNumber(20)), Males = 1 + 1 - genderPlayer , Females = 1 - maleSexPartner + genderPlayer, Creatures =  0)
        index += 1
    endwhile
    ; slsfListener.onWaitPassive(amount_of_hours)
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
    if PlayerRef.HasPerk(getPerkNumber(19)) && curLoc.HasKeyword(LocTypePlayerHouse) 
        return true
    endif
    if PlayerRef.HasPerk(getPerkNumber(19)) && curLoc.HasKeyword(LocTypeInn)
        return true
    endif
    if curLoc.HasKeyword(LocTypeHabitationHasInn)
        return true
    endif
    return PlayerRef.HasPerk(getPerkNumber(20)) && !curLoc.HasKeyword(LocTypeHabitation)            
EndFunction

Function trySeduceMerchant(Actor tempActor)
    
    tempActor.SendModEvent("TSSD_SeduceMerchant", "", 0.0 )
EndFunction

Function onGameReload()
    if SuccubusDesireLevel.GetValue() > -101
        RegisterSuccubusEvents()
    endif
    
    myBinding = SkyInteract_Util.GetSkyInteract()
    tMenus.cosmeticSettings = ReadInCosmeticSetting()
    gainSuccubusXP(0)
    setAllInOneKeyAction(MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iAllInOneKey:Main"))

    int jArr = JDB.solveObj(".tssdspellids")
    int index = 0
    while index < JValue.count(jArr)
        int innerJ = jArray.getObj(jArr, index)
        adjustSpell( jArray.Getint(innerJ, 1) as bool, jArray.GetStr(innerJ, 2), jArray.GetInt(innerJ, 3)  ,\
        MCM.GetModSettingString("TintsOfASuccubusSecretDesires",jArray.getStr(innerJ, 0)))
        index += 1
    endwhile
    
    tDialogue.onGameReload()
    HotDemonTarget = PlayerRef
    last_checked = Utility.GetCurrentGameTime() * 24
    tOrgasmLogic.onGameReload()
    tInflation.onGameReload()
    updateHeartMeter(true)
    (TSSD_CursedWoman as TSSD_SucieDailyScript).onGameReload()
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
    ;/
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
    endif /;
Endfunction

Function NotificationSpam(string Displaying)
    if MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bSpamNotifications:Main")
        Debug.Notification( "You picked: " + Displaying )
    endif
Endfunction

;Events ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnTrackedStatsEvent(string asStatFilter, int aiStatValue)
    if !PlayerRef.isInCombat() && PlayerRef.HasPerk(getPerkNumber(19)) && lastScarletTalk > 24 && ((asStatFilter == "Books Read") || asStatFilter == "Skill Increases" || asStatFilter == "Locations Discovered")
        int toIncrease = 2
        Actor[] myThralls = PO3_SKSEFunctions.GetAllActorsInFaction(TSSD_EnthralledFaction)
        if myThralls.Length >= 1
            T_Show("Oh I gotta talk with " + myThralls[Utility.RandomInt(0, myThralls.Length - 1)].GetDisplayName() +  " about that!", "menus/tssd/small/scarlet.dds")
        else
            T_Show("I am so alone!")
            toIncrease += 2
        endif
        SuccubusXpAmount.Mod(10)
        lastScarletTalk = 0.1
    endif
    if asStatFilter == "Dragon Souls Collected"
        tOrgasmLogic.incrValAndCheck(23, 1)
        if PlayerRef.HasPerk(getPerkNumber(23))
            tMenus.TSSD_Satiated.SetNthEffectDuration(0, 3600 * 7 * 2)
        endif
        tMenus.TSSD_Satiated.Cast(PlayerRef,PlayerRef)
        tMenus.TSSD_Satiated.SetNthEffectDuration(0, 3600)
    endif
endEvent



Event OnUpdateGameTime()
    float timeBetween = (Utility.GetCurrentGameTime() * 24 - last_checked)
    lastScarletTalk += timeBetween
    float valBefore = SuccubusDesireLevel.GetValue()
    Location curLoc = Game.GetPlayer().GetCurrentLocation()
    float chVal = 1
    float energy_loss = timeBetween * chVal
    if PlayerRef.HasMagicEffect(TSSD_SatiatedEffect)
        energy_loss *= 0.1
    endif
    if PlayerRef.HasPerk(TSSD_Drain_CollaredEvil1) && PlayerRef.GetFactionRank(tEvents.TSSD_Collared) >= 1
        energy_loss *= 0.5
    endif
    energy_loss *= -1
    last_checked = Utility.GetCurrentGameTime() * 24
    RefreshEnergy(energy_loss)

    float succNeedVal = SuccubusDesireLevel.GetValue()
    if succNeedVal <= TSSD_ravanousNeedLevel.GetValue() && succNeedVal > -101 && PlayerRef.HasPerk(TSSD_Base_PowerGrowing) && !Sexlab.IsActorActive(PlayerRef)
        TSSD_SuccubusDetectJuice.Cast(PlayerRef, PlayerRef)
        if !deathModeActivated
            toggleDeathMode()
        endif
    endif
    if hasAbsorbedCum
        T_Show("I love the feeling of cum being absorbed through my skin!", "", 0)

        RefreshEnergy(10)
    endif
    PlayerRef.RemovePerk(TSSD_Base_ChangesPerk)
    Utility.Wait(0.1)
    PlayerRef.AddPerk(TSSD_Base_ChangesPerk)
    updateHeartMeter(timeBetween > 6)
    

    RegisterForSingleUpdateGameTime(0.4)

endEvent



Event OnMenuOpen(String MenuName)
    if MenuName == "Dialogue Menu"
        
        Actor tempActor = SPE_Actor.GetPlayerSpeechTarget()
        Actor RefA = tempActor
        if RefA && RefA.HasMagicEffect(TSSD_DrainedDownSide)
            RefA.SendModEvent("TSSD_DrainedTargetHovered", "", 0.0)
        endif

        if SuccubusDesireLevel.GetValue() <= TSSD_ravanousNeedLevel.GetValue() && PlayerRef.HasPerk(TSSD_Base_PowerGrowing)
            UI.InvokeString("HUD Menu", "_global.skse.CloseMenu", "Dialogue Menu")
            T_Show("NO TIME TO TALK!", "icon.dds", aiDelay = 2.0)
        elseif PlayerRef.HasPerk(TSSD_Seduction_HotDemon1) && tempActor != none
            if !tempActor.IsChild() && HotDemonTarget == PlayerRef
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
    else
        myBinding.Remove("tssd_getTargetCross")
    endif
EndEvent

Event OnMenuClose(String MenuName)
    if MenuName == "Dialogue Menu" && HotDemonTarget != PlayerRef
        int eid = ModEvent.Create("slaUpdateExposure")
        ModEvent.PushForm(eid, HotDemonTarget)
        ModEvent.PushFloat(eid, -100)
        ModEvent.Send(eid)
        HotDemonTarget = PlayerRef
    endif
    myBinding.Remove("tssd_getTargetCross")
EndEvent

Function setAllInOneKeyAction(int a)
    allInOneKey = a
EndFunction


bool Function isDoggie(Actor cA)
    return cA.GetFactionRank(CompanionsCirclePlusKodlak) >=0 || cA.GetFactionRank(WereWolfFaction) > 0 || 				cA.GetFactionRank(WolfFaction) > 0 || cA.GetRace() == WolfRace || cA.GetRace() == WereWolfBeastRace  || cA.IsInFaction(DogFaction)
endfunction
    
Event OnCrosshairRefChange(ObjectReference ref)
    if myBinding == none        
        myBinding = SkyInteract_Util.GetSkyInteract()
    endif

    if ref &&  TSSD_ShrinesWithQuests.HasForm(ref.GetBaseObject())
        String deityName = StringUtil.Substring(DbSkseFunctions.GetFormEditorId(ref.GetBaseObject(), "none"), 8)
        String oldName = JDB.solveStr(".oldNorseGods."+ deityName)

        myBinding.Remove("tssd_getTargetCross")
        myBinding.Add("tssd_getTargetCross",  oldName, allInOneKey)
    Elseif !(ref as Actor)
        
        myBinding.Remove("tssd_getTargetCross")
    Elseif ref && tEvents.isLilac && playerInSafeHaven() && !Sexlab.IsActorActive(PlayerRef) &&  (ref as Actor) && isDoggie(ref as Actor) && !(Ref as Actor).HasMagicEffect(TSSD_DrainedDownSide)
        myBinding.Add("tssd_getTargetCross", "Beg", allInOneKey)

    EndIf

EndEvent


Function toggleDebug(bool turnOn)
    TSSD_DebugMode.SetValue(MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bDebugCheats:Main") as int)
Endfunction

Function toggleDebugFaction(bool turnOn)
    if PlayerRef.HasSpell(TSSD_DebugToFaction)
        PlayerRef.RemoveSpell(TSSD_DebugToFaction)
    else
        PlayerRef.AddSpell(TSSD_DebugToFaction)
    endif
EndFunction