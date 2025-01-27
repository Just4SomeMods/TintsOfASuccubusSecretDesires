Scriptname tssd_actions extends Quest
import b612
import tssd_utils

Actor Property PlayerRef Auto

tssd_slsfrscript Property slsfListener Auto
iWant_Widgets Property  iWidgets Auto
SexLabFramework Property SexLab Auto
sslActorStats Property sslStats Auto
tssd_succubusstageendblockhook Property stageEndHook Auto
tssd_widgets Property tWidgets Auto
float _updateTimer = 0.5

Spell[] Property SuccubusAbilitiesSpells Auto
Perk[] Property SuccubusAbilitiesPerks  Auto
String[] Property SuccubusAbilitiesNames  Auto    

Idle property BleedOutStart auto

tssd_orgasmenergylogic Property OEnergy Auto 

GlobalVariable Property TimeOfDayGlobalProperty Auto
GlobalVariable Property SkillSuccubusDrainLevel Auto
GlobalVariable Property SkillSuccubusSeductionLevel Auto
GlobalVariable Property SkillSuccubusBodyLevel Auto
GlobalVariable Property SkillSuccubusBaseLevel Auto
GlobalVariable Property TSSD_PerkPointsBought Auto
GlobalVariable Property SuccubusDesireLevel Auto
GlobalVariable Property SuccubusXpAmount Auto
GlobalVariable Property TSSD_KillEssentialsActive Auto
GlobalVariable Property TSSD_MaxTraits Auto
GlobalVariable Property TOSD_SuccubusPerkPoints Auto
GlobalVariable Property GameHours Auto
GlobalVariable Property TSSD_SuccubusTraits Auto
GlobalVariable Property TSSD_SuccubusType Auto

Perk Property TSSD_Base_Explanations Auto
Perk Property TSSD_Body_Overstuffed Auto
Perk Property TSSD_Base_CapIncrease1 Auto
Perk Property TSSD_Drain_GentleDrain1 Auto
Perk Property TSSD_Drain_DrainMore1 Auto
Perk Property TSSD_Seduction_Kiss1 Auto
Perk Property TSSD_Seduction_Leader Auto
Perk Property TSSD_Seduction_OfferSex Auto
Perk Property TSSD_Body_PassiveEnergy1 Auto
Perk Property TSSD_Body_PlayDead1 Auto
Perk Property TSSD_Base_IncreaseScentRange1 Auto

Spell Property TSSD_SuccubusDetectJuice Auto
Spell Property TSSD_Overstuffed Auto
Spell Property TSSD_DrainHealth Auto

bool lookedAtExplanationsOnce = false
bool deathModeActivated = false
bool modifierKeyIsDown = false

bool [] cosmeticSettings

Actor[] targetsToAlert

ImageSpaceModifier Property AzuraFadeToBlack  Auto  
MagicEffect Property TSSD_SuccubusDetectEnergyFF Auto


Keyword Property LocTypeInn Auto
Keyword Property LocTypePlayerHouse Auto
Keyword Property LocTypeCity Auto
Keyword Property LocTypeClearable Auto
Keyword Property LocTypeHabitation Auto
Keyword Property LocTypeHabitationHasInn Auto

HeadPart PlayerEyes

int ravanousNeedLevel = -100
int lastUsed = -1
int lastUsedSub = -1

float lastSmoochTimeWithThatPerson = 0.0

float last_checked
float timer_internal = 0.0
float smooching = 0.0

;SPECIFIC UTILITY FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Function addToSmooching(float val)
    smooching += val
Endfunction

;MENUS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function OpenGrandeMenu()
    modifierKeyIsDown = Input.IsKeyPressed( MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iModifierHotkey:Main") )
    if !SafeProcess()
        return
    endif
    if TSSD_SuccubusType.GetValue() == -1
        int dbgSuccy = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iSkipExplanations:Main")
        SelectSuccubusType(dbgSuccy)
        int EventHandle = ModEvent.Create("SLSF_Reloaded_RegisterMod")
        ModEvent.PushString(EventHandle, "TintsOfASuccubusSecretDesires.esp")
        ModEvent.Send(EventHandle)
        if dbgSuccy < 0
            Return
        endif
    endif
    b612_SelectList mySelectList = GetSelectList()
    sslThreadController _thread =  Sexlab.GetPlayerController()
    String[] myItems = StringUtil.Split("Abilities;Upgrades;Settings;Rechoose Type",";")
    if TSSD_MaxTraits.GetValue() > 0
        myItems = StringUtil.Split("Abilities;Upgrades;Settings;Rechoose Type;Select Traits",";")
    endif
    Int result
    if modifierKeyIsDown
        result = lastUsed
    else
        result = mySelectList.Show(myItems)
        if result == -1
            return
        endif
        lastUsedSub = -1
        lastUsed = result
    endif
    NotificationSpam(myItems[result] )
    if myItems[result] == "Abilities"
        OpenSuccubusAbilities()
    elseif myItems[result] == "Upgrades"
        OpenExpansionMenu()    
    elseif myItems[result] == "Settings"
        OpenSettingsMenu()
    elseif myItems[result] == "Rechoose Type"
        SelectSuccubusType()
    elseif myItems[result] == "Select Traits"
        OpenSuccubusTraits()
    endif
EndFunction 

Function OpenExpansionMenu()
    if MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","bSkipExplenations:Main") < 0
        lookedAtExplanationsOnce = true
    endif
    if !lookedAtExplanationsOnce
        OpenExlanationMenu()
        return
    endif
    b612_SelectList mySelectList = GetSelectList()
    String[] myItems = StringUtil.Split("Perk Trees;Base Skill;Drain;Seduction;Body;Perk Points;Show Explanations again",";")
    Int result 
    if modifierKeyIsDown && lastUsedSub > -1
        result = lastUsedSub
    else
        result  = mySelectList.Show(myItems)
        lastUsedSub = result
        if result == -1
            return
        endif
    endif
    if result == 0
        CustomSkills.OpenCustomSkillMenu("SuccubusBaseSkill")
    elseif result < 6 && result > -1
        OpenSkillTrainingsMenu(result - 1)
        NotificationSpam(myItems[result - 1] )
    elseif result == 6
        lookedAtExplanationsOnce = false
        OpenExpansionMenu()
    endif
EndFunction

Function OpenExlanationMenu()        
    String[] SUCCUBUSTATS = StringUtil.Split( "Base Skill;Drain;Seduction;Body;Perk Points",";")
    String[] SUCCUBUSTATSDESCRIPTIONS =  StringUtil.Split("Training for the Base Succubus Skill;Drain increases your drain strength;Seduction increases your [Speechcraft and gives you the ability to hypnotize people];Body [Increases your Combat Prowess];Perk Points give you perkpoint for the Trees in this mod.",";")
    b612_TraitsMenu TraitsMenu = GetTraitsMenu()
    int index = 0
    while index < SUCCUBUSTATS.Length
        TraitsMenu.AddItem( SUCCUBUSTATS[index], SUCCUBUSTATSDESCRIPTIONS[index], "menus/tssd/"+SUCCUBUSTATS[index]+".dds")
        index += 1
    EndWhile
    string[] result = TraitsMenu.Show(aiMaxSelection = 1, aiMinSelection = 0)
    int resultW = -1
    if result.Length > 0
        resultw =  result[0] as int
        OpenSkillTrainingsMenu(resultW)
    endif
Endfunction

Function OpenSkillTrainingsMenu(int index_of)
    String[] myItems = StringUtil.Split("Base;Drain;Seduction;Body;Perk Points",";")    
    GlobalVariable[] skillLevels = new GlobalVariable[5]
    skillLevels[0] = SkillSuccubusBaseLevel
    skillLevels[1] = SkillSuccubusDrainLevel
    skillLevels[2] = SkillSuccubusSeductionLevel
    skillLevels[3] = SkillSuccubusBodyLevel
    skillLevels[4] = TSSD_PerkPointsBought
    tssd_trainSuccAbilities trainingThing =  ((Quest.GetQuest("tssd_queststart")) as tssd_trainSuccAbilities)
    trainingThing.SetSkillName(mYitems[index_of])
    trainingThing.SetSkillId( "Succubus" + myItems[index_of] + "Skill")
    trainingThing.SetSkillVariable(skillLevels[index_of])
    (trainingThing).show()

Endfunction

Function OpenSuccubusTraits()
    b612_TraitsMenu TraitsMenu = GetTraitsMenu()
    int index = 0
    string[] succTraits = GetSuccubusTraitsAll()
    bool[] chosenTraits = GetSuccubusTraitsChosen(TSSD_SuccubusTraits, succTraits.Length)
    while index < succTraits.Length
        string succDesc =  JDB.solveStr(".tssdtraits." + succTraits[index] + ".description")
        if chosenTraits[index]
            TraitsMenu.AddItem( "> " + succTraits[index],  succDesc, "menus/tssd/"+succTraits[index]+".dds")
        else
            TraitsMenu.AddItem( succTraits[index], succDesc, "menus/tssd/"+succTraits[index]+".dds")   
        endif
        index += 1
    EndWhile
    String[] resultW = TraitsMenu.Show(aiMaxSelection = TSSD_MaxTraits.GetValue() as int, aiMinSelection = 0)
    if resultW.Length > 0
        chosenTraits = Utility.CreateBoolArray(succTraits.Length, false)
        index = 0
        int j = 0
        int chosenBinar = 0
        while index < resultw.Length
            int resInt = resultW[index] as int
            chosenBinar += Math.Pow(2, resInt) as int
            index += 1
        EndWhile
        TSSD_SuccubusTraits.SetValue(chosenBinar)
        slsfListener.CheckFlagsSLSF()
    endif
EndFunction

Function SelectSuccubusType(int query = -1)
    int index = 0
    if query < 0
        b612_TraitsMenu TraitsMenu = GetTraitsMenu()
        string[] succKinds = JArray.asStringArray(JDB.solveObj(".tssdoverviews.SuccubusKinds"))
        while index < succKinds.Length
            TraitsMenu.AddItem( succKinds[index], JDB.solveStr(".tssdkinds." + succKinds[index] + ".description"), "menus/tssd/"+succKinds[index]+".dds")
            index += 1
        EndWhile

        String[] resultw = TraitsMenu.Show(aiMaxSelection = 1, aiMinSelection = 0)
        index = 0        
        if resultw.Length>0
            query = resultW[0] as int
        endif
    endif
    if query >= 0
        int oldVal = TSSD_SuccubusType.GetValue() as int
        TSSD_SuccubusType.SetValue(query)
        if SuccubusDesireLevel.GetValue() == -101
            SuccubusDesireLevel.SetValue(50)
            updateSuccyNeeds(0)
            int startLevel = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iSuccubusLevel:Main")
            if startLevel > 0
                SuccubusXpAmount.SetValue( startLevel * 1000  )
                PlayerRef.AddPerk(TSSD_Drain_GentleDrain1)
                PlayerRef.AddPerk(TSSD_Seduction_Kiss1)
                PlayerRef.AddPerk(TSSD_Body_PlayDead1)
            endif
            PlayerRef.AddPerk(TSSD_Base_Explanations)
            RegisterSuccubusEvents()
        endif
        slsfListener.CheckFlagsSLSF()
    endif
        ;if succubusType == 2
            ;DBGTRace(slavetats.simple_add_tattoo(PlayerRef, "Bofs Bimbo Tats Butt", "Butt (Lower) - Sex Doll"))
            
        ;Endif
EndFunction

Function OpenSettingsMenu()
    String[] myItems = StringUtil.Split("Configure Bars;Evaluate Needs;Debug Climax Now;Essentials are protected;Succubus Cosmetics Menu (Toggles)",";")
    Int result 
    Actor Cross = Game.GetCurrentCrosshairRef() as Actor
    bool canEssDie = TSSD_KillEssentialsActive.GetValue() > 0
    if canEssDie
        myItems[3] = "Essentials can die"
    endif
    if modifierKeyIsDown && lastUsedSub > -1
        result = lastUsedSub
    else
        result = GetSelectList().Show(myItems)
        lastUsedSub = result
        if result == -1
            return
        endif
    endif   
    if result == -1
        return
    endif
    NotificationSpam(myItems[result] )
    if myItems[result] == "Evaluate Needs"
        if Sexlab.GetPlayerController()
            EvaluateCompleteScene()
        elseif Cross
            string showboat = "I can't succ " + Cross.GetDisplayName() +"!"
            if isSuccable(Cross)
                int lasttime = (GetLastTimeSuccd(Cross, TimeOfDayGlobalProperty) * 100) as int
                if lasttime > 100.0 || lasttime < 0.0 
                    showboat = "This person is full of juicy energy!"
                else
                    showboat = "This person is only " + lasttime + "% ready."
                endif
            endif
            GetAnnouncement().Show(showboat, "icon.dds", aiDelay = 2.0)
        endif
    elseif myItems[result] == "Debug Climax Now"
        DebugForceOrgasm()
    elseif myItems[result] == "Configure Bars"
        tWidgets.ListOpenBarsOld()
    elseif myItems[result] == "Succubus Cosmetics Menu (Toggles)"
        OpenSuccubusCosmetics()
    elseif myItems[result] == "Essentials are protected" || myItems[result] ==  "Essentials can die"
        MCM.SetModSettingBool("TintsOfASuccubusSecretDesires","bKillEssentials:Main", !canEssDie)
        TSSD_KillEssentialsActive.SetValue( 0) ;(!canEssDie) as int)
    endif
EndFunction

Function OpenSuccubusCosmetics()
    int jArr = JDB.solveObj(".tssdsettings")
    b612_TraitsMenu TraitsMenu = GetTraitsMenu()
    int index = 0
    cosmeticSettings = ReadInCosmeticSetting()
    while index < JValue.count(jArr)        
        string[] textArr = jArray.asStringArray(jArray.getObj(jArr,index))
        DBGTRace(textArr[0])
        string text = textArr[0]
        if cosmeticSettings[index]
            text = "> " + text
        endif
        TraitsMenu.AddItem( text, textArr[1], "menus/tssd/"+textArr[0]+".dds")
        index += 1
    EndWhile

    string[] resultW = TraitsMenu.Show(aiMaxSelection = 99, aiMinSelection = 0)
    index = 0

    string output = ""
    while index < cosmeticSettings.Length
        bool in_it = resultW.find(index as string) >= 0
        if in_it
            cosmeticSettings[index] = !cosmeticSettings[index]
        endif
        if index != 0
            output += ";"
        endif
        output += "" + (cosmeticSettings[index] as int)
        index += 1
    EndWhile
    MCM.SetModSettingString("TintsOfASuccubusSecretDesires","sCosmeticSettings:Main", output)
    cosmeticSettings = ReadInCosmeticSetting()
    tWidgets.shouldFadeOut = cosmeticSettings[5]
Endfunction


Function OpenSuccubusAbilities()    
    String itemsAsString = "Allow draining"
    if deathModeActivated
        itemsAsString = "Hold back draining"
    endif
    Actor Cross = Game.GetCurrentCrosshairRef() as Actor
    if PlayerRef.HasPerk(TSSD_Seduction_OfferSex)
        itemsAsString += ";Ask for Sex"
    endif
    if PlayerRef.HasPerk(TSSD_Body_PlayDead1) && !PlayerRef.IsInCombat()
        itemsAsString += ";Act defeated"
    endif

    itemsAsString += ";Look for Prey"
    
    int indexOfA = 1
    while indexOfA < SuccubusAbilitiesNames.length
        if PlayerRef.HasPerk(SuccubusAbilitiesPerks[indexOfA]) ||  MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iSkipExplanations:Main") >= 0
            itemsAsString += ";" + SuccubusAbilitiesNames[indexOfA]
        endif
        indexOfA += 1
    endwhile
    
    String[] myItems = StringUtil.Split(itemsAsString,";")
    Int result 
    if modifierKeyIsDown && lastUsedSub > -1
        result = lastUsedSub
    else
        result = GetSelectList().Show(myItems)
        lastUsedSub = result
        if result == -1
            return
        endif
    endif    
    NotificationSpam(myItems[result] )
    if myItems[result] == "Hold back draining" || myItems[result] == "Allow draining"
        toggleDeathMode()
    elseif myItems[result] == "Look for Prey"
        int radius = getScanRange()
        Actor[] allAround = MiscUtil.ScanCellNPCs(PlayerRef, radius * 50)
        ; DBGTRace(getAllNames(allAround))
        TSSD_SuccubusDetectJuice.SetNthEffectArea(0, radius )
        int oldDur = TSSD_SuccubusDetectJuice.GetNthEffectDuration(0)
        TSSD_SuccubusDetectJuice.SetNthEffectDuration(0, 5)
        TSSD_SuccubusDetectJuice.Cast(PlayerRef, PlayerRef)
        TSSD_SuccubusDetectJuice.SetNthEffectDuration(0, oldDur)
        ;endif
    elseif myItems[result] == "Ask for Sex" && Cross
        Sexlab.RegisterHook( stageEndHook)
        Sexlab.StartSceneQuick(akActor1 = PlayerRef, akActor2 = Cross)
    elseif myItems[result] == "Act defeated"
        int radius = getScanRange()
        PlayerRef.PlayIdle(BleedOutStart)
        targetsToAlert = MiscUtil.ScanCellNPCs(PlayerRef)
        Actor[] cell_ac = MiscUtil.ScanCellNPCs(PlayerRef, radius * 50)
        int ac_index = 0
        bool isFading = false
        Actor curRef
        Actor tarRef
        Bool[] isHostileArr = Utility.CreateBoolArray(cell_ac.Length, false)
        int numHostileActors = 0
        while ac_index < cell_ac.Length
            curRef = cell_ac[ac_index]
            if curRef && curRef != PlayerRef && curRef.isHostileToActor(PlayerRef)
                numHostileActors += 1
                if !isFading
                    AzuraFadeToBlack.Apply()
                    isFading = true
                    tarRef = curRef
                    isHostileArr[ac_index] = true
                endif
            endif
            ac_index += 1
        endwhile
        if isFading && tarRef
            if !deathModeActivated
                toggleDeathMode()
            endif
            GameHours.SetValue(GameHours.GetValue() + 1) ; TODO
            Utility.Wait(2.5)
            tarRef.MoveTo(PlayerRef, 0, 1000)
            Sexlab.RegisterHook( stageEndHook)
            Sexlab.StartSceneQuick(akActor1 = PlayerRef, akActor2 = tarRef, akSubmissive = PlayerRef)
            ImageSpaceModifier.RemoveCrossFade(3)
        endif
    elseif SuccubusDesireLevel.GetValue() > 0
        indexOfA = 1
        bool found = false
        while indexOfA < SuccubusAbilitiesNames.Length
            if myItems[result] == SuccubusAbilitiesNames[indexOfA]
                found = true
            endif
            indexOfA += 1
        endwhile
        if found
            indexOfA = 1
            while indexOfA < SuccubusAbilitiesNames.Length
                if myItems[result] == SuccubusAbilitiesNames[indexOfA]
                    SuccubusAbilitiesSpells[indexOfA].Cast(PlayerRef, PlayerRef)
                    updateSuccyNeeds(-20)
                else
                    PlayerRef.DispelSpell(SuccubusAbilitiesSpells[indexOfA])
                endif
                indexOfA += 1
            endwhile
        endif
    endif
EndFunction

int Function getScanRange()
    return 50 * ( 1 + PlayerRef.HasPerk(TSSD_Base_IncreaseScentRange1) as int)
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

;Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function RegisterSuccubusEvents()
    RegisterForUpdateGameTime(0.4)
    RegisterForMenu("Dialogue Menu")
    if MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bDebugMode:Main")
        PlayerRef.AddPerk(TSSD_Seduction_OfferSex)
        TSSD_MaxTraits.SetValue(99)
    endif
    RegisterForModEvent("SexLabOrgasmSeparate", "OnSexOrgasm")
    RegisterForModEvent("PlayerTrack_Start", "PlayerSceneStart")
    RegisterForModEvent("PlayerTrack_End", "PlayerSceneEnd")
Endfunction

Function NotificationSpam(string Displaying)
    if MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bSpamNotifications:Main")
        Debug.Notification( "You picked: " + Displaying )
    endif
Endfunction

Function EvaluateCompleteScene(bool onStart=false)
    sslThreadController _thread =  Sexlab.GetPlayerController()
    int index = 0
    int max_rel = -4
    bool max_prot = false
    int succubusType = TSSD_SuccubusType.GetValue() as int
    Actor[] ActorsIn = _thread.GetPositions()
    string output = ""
    float energyNew = 0
    if PlayerRef.HasPerk(TSSD_Drain_GentleDrain1)
        while index < ActorsIn.length
            Actor ActorRef = Actorsin[Index]
            energyNew += OEnergy.EvaluateOrgasmEnergy(_thread, ActorRef, 2 * (1 - (onStart as int)), overWriteStop = true)
            if ActorRef && PlayerRef != ActorRef
                max_rel = max(ActorRef.GetRelationshipRank(playerref), max_rel) as int
                if !isSuccable(ActorRef) && deathModeActivated
                    max_prot = true
                endif
            endif

            index += 1
        EndWhile

        if (max_rel > 3 && succubusType == 1 || max_prot) && deathModeActivated && onStart ; TODO - Logic for auto-deactivation
            output += "I can't drain them! "
            toggleDeathMode()
        endif
    endif
    if deathModeActivated
        energyNew += (ActorsIn.Length - 1) * 100
        output += "Someone is about to die! "
    elseif energyNew >= 30
        output += "Ooh, this will do nicely! "
    elseif energyNew >= 20
        output += "Mhhm this is good. "
    elseif energyNew >= 10
        output += "I like this. "
    elseif energyNew >= 0
        output += "I can live with this. "
    elseif energyNew < 0
        output += "Eugh, this is bad. "
    endif
    if cosmeticSettings[2] == 1
        OEnergy.ShowAnnounceMent(energyNew as int)
    endif
Endfunction

Function PlayerSceneStart(Form FormRef, int tid)
    int succubusType = TSSD_SuccubusType.GetValue() as int
    if SuccubusDesireLevel.GetValue() > -100.0
        PlayerRef.DispelSpell(TSSD_SuccubusDetectJuice)
    endif
    if smooching == 0.0
        EvaluateCompleteScene(true)
    else
        Actor[] ActorsIn = Sexlab.GetController(tid).GetPositions() 
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
EndFunction

Function PlayerSceneEnd(Form FormRef, int tid)
    int succubusType = TSSD_SuccubusType.GetValue() as int
    sslThreadController _thread =  Sexlab.GetController(tid)
    Actor[] ActorsIn = Sexlab.GetController(tid).GetPositions() 
    if Sexlab.IsHooked(stageEndHook)
        Sexlab.UnRegisterHook( stageEndHook)
    endif
    if deathModeActivated
        ; TSSD_DrainHealth.SetNthEffectMagnitude(1, min(ActorRef.GetActorValue("Health") - 10 ,new_drain_level))
        ; TSSD_DrainHealth.Cast(PlayerRef, ActorRef)
        int orgasmCountScene = 0
        int succAbleTargets = 0
        int index = 0
        while index < ActorsIn.Length
            Actor WhoCums = ActorsIn[index]
            if isSuccable(WhoCums) && (succubusType != 1 || WhoCums.GetRelationshipRank(PlayerRef) < 4)
                orgasmCountScene += _thread.ActorAlias(WhoCums).GetOrgasmCount()
                succAbleTargets += 1
            endif
            index+=1
        EndWhile
        index = 0
        while index < ActorsIn.Length
            Actor WhoCums = ActorsIn[index]
            if isSuccable(WhoCums) && (succubusType != 1 || WhoCums.GetRelationshipRank(PlayerRef) < 4) && _thread.ActorAlias(WhoCums).GetOrgasmCount() > 0
                updateSuccyNeeds(  min(WhoCums.GetAV("Health"), getDrainLevel() * orgasmCountScene / succAbleTargets )  )
                TSSD_DrainHealth.SetNthEffectMagnitude(0, getDrainLevel() * orgasmCountScene / succAbleTargets )
                TSSD_DrainHealth.Cast(PlayerRef, WhoCums)
            endif
            index+=1
        EndWhile
    endif
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
            if curRef && curRef != PlayerRef && curRef.isHostileToActor(PlayerRef)
                curRef.StartCombat(PlayerRef)
            endif
            tarIndex += 1
        EndWhile
    endif

    targetsToAlert = none
EndFunction

Function DebugForceOrgasm()
    sslThreadController _thread =  Sexlab.GetPlayerController()
    if _thread
        Actor[] ActorsIn = _thread.GetPositions()
        int index = 0
        while index < ActorsIn.Length
            Actor ActorRef = ActorsIn[index]
            _thread.ForceOrgasm(ActorRef)
            index += 1
        EndWhile
        
    endif
EndFunction

Function AddToStatistics(int amount_of_hours)
    int succubusType = TSSD_SuccubusType.GetValue() as int
    int sexualityPlayer = sslStats.GetSexuality(PlayerRef)
    int genderPlayer = min(Sexlab.GetSex(PlayerRef), 1) as int
    if genderPlayer == 0
        sexualityPlayer = 100 - sexualityPlayer
    endif
    int index = 0
    if succubusType != 3
        while index < amount_of_hours
            int maleSexPartner = (0.5 + Utility.RandomInt(0, sexualityPlayer) / 100) as int
            sslStats.AddSex(PlayerRef, timespent = 0,  withplayer = true, isaggressive = succubusType == 4, Males = 1 + 1 - genderPlayer , Females = 1 - maleSexPartner + genderPlayer, Creatures =  0)
            index += 1
        endwhile
    endif
    slsfListener.onWaitPassive(amount_of_hours)
Endfunction



Function RefreshEnergy(float adjustBy, int upTo = 100)
    float lastVal = SuccubusDesireLevel.GetValue()
    if lastVal < upTo && lastVal > -100
        SuccubusDesireLevel.SetValue( min(upTo, max( -100,  lastVal + adjustBy) ) )
    endif
Endfunction


Function updateSuccyNeeds(float value, bool resetAfterEnd = false)
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
        SuccubusXpAmount.SetValue(SuccubusXpAmount.GetValue() + value * 10)
    endif
    if succNeedVal != -101        
        if succNeedVal > 0
            SuccubusDesireLevel.SetValue(Min(max_energy_level, Max(succNeedVal+ value * greed_mult, 0)))
        else
            RefreshEnergy(value)
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
    deathModeActivated = !deathModeActivated
    if SuccubusDesireLevel.GetValue() <= ravanousNeedLevel
        deathModeActivated = true
    endif
    if deathModeActivated
        GetAnnouncement().Show("SOMEONE NEEDS TO DIE NOW!", "icon.dds", aiDelay = 2.0)
    endif
    ;TSSD_KillEssentialsActive.SetValue(MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bKillEssentials:Main") as int)
EndFunction

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
    if succNeedVal <= ravanousNeedLevel && succNeedVal > -101
        TSSD_SuccubusDetectJuice.Cast(PlayerRef, PlayerRef)
        if !deathModeActivated
            toggleDeathMode()
        endif
    endif
	RegisterForSingleUpdate(_updateTimer)
EndEvent


Event OnSexOrgasm(Form ActorRef_Form, Int Thread)
    sslThreadController _thread =  Sexlab.GetController(Thread)
    Actor ActorRef = ActorRef_Form as Actor
    if PlayerRef.HasPerk(TSSD_Drain_GentleDrain1)
        updateSuccyNeeds(OEnergy.EvaluateOrgasmEnergy(_thread, ActorRef, 1), true)
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
    float valBefore = SuccubusDesireLevel.GetValue()
    Location curLoc = Game.GetPlayer().GetCurrentLocation()
    if (valBefore > 50 && valBefore < 50 && PlayerRef.HasPerk(TSSD_Body_PassiveEnergy1)) && \
        (succubusType == 0 && curLoc.HasKeyword(LocTypeInn)) || (succubusType == 1 && curLoc.HasKeyword(LocTypePlayerHouse)) || (succubusType == 2 && ( curLoc.HasKeyword(LocTypeInn) ||  curLoc.HasKeyword(LocTypeHabitationHasInn)) ) || (succubusType == 4 && !curLoc.HasKeyword(LocTypeHabitation))
        if timeBetween >= 1
            if PlayerRef.HasPerk(TSSD_Body_PassiveEnergy1.GetNextPerk().GetNextPerk())
                RefreshEnergy(timeBetween * 20, 50)
            elseif PlayerRef.HasPerk(TSSD_Body_PassiveEnergy1.GetNextPerk())
                RefreshEnergy(timeBetween * 10, 50)
            endif
            AddToStatistics( ( (SuccubusDesireLevel.GetValue() - valBefore) /10 + timeBetween) as int)
        endif
        timeBetween = 0
    endif
    last_checked = TimeOfDayGlobalProperty.GetValue()
    updateSuccyNeeds(timeBetween * -1)
endEvent

Event OnMenuOpen(String MenuName)
    if SuccubusDesireLevel.GetValue() <= ravanousNeedLevel && TSSD_SuccubusType.GetValue() != -1
        UI.InvokeString("HUD Menu", "_global.skse.CloseMenu", "Dialogue Menu")
        GetAnnouncement().Show("NO TIME TO TALK!", "icon.dds", aiDelay = 2.0)
    endif
EndEvent

Event OnInit()
    Maintenance(TSSD_SuccubusType)
	RegisterForModEvent("iWantWidgetsReset", "OniWantWidgetsReset")
	RegisterForSingleUpdate(_updateTimer)
EndEvent

Function onGameReload()
    Maintenance(TSSD_SuccubusType)
    RegisterSuccubusEvents()
    cosmeticSettings = ReadInCosmeticSetting()
    tWidgets.shouldFadeOut = cosmeticSettings[5]
Endfunction