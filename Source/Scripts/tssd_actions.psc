Scriptname tssd_actions extends Quest
import b612
import tssd_utils

iWant_Widgets Property  iWidgets Auto
SexLabFramework Property SexLab Auto
sslActorStats Property sslStats Auto
tssd_succubusstageendblockhook Property stageEndHook Auto
tssd_widgets Property tWidgets Auto
Actor Property PlayerRef Auto
float _updateTimer = 0.5

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

GlobalVariable Property TSSD_SuccubusTraits Auto
GlobalVariable Property TSSD_SuccubusType Auto

Perk Property TSSD_Base_Explanations Auto
Perk Property TSSD_Body_Overstuffed Auto
Perk Property TSSD_Base_CapIncrease1 Auto
Perk Property TSSD_Base_CapIncrease2 Auto
Perk Property TSSD_Base_CapIncrease3 Auto
Perk Property TSSD_Drain_GentleDrain1 Auto
Perk Property TSSD_Drain_GentleDrain2 Auto
Perk Property TSSD_Drain_GentleDrain3 Auto
Perk Property TSSD_Drain_GentleDrain4 Auto
Perk Property TSSD_Drain_DrainMore1 Auto
Perk Property TSSD_Drain_DrainMore2 Auto
Perk Property TSSD_Seduction_Kiss1 Auto
Perk Property TSSD_Seduction_Leader Auto
Perk Property TSSD_Seduction_OfferSex Auto
Perk Property TSSD_Body_PassiveEnergy1 Auto

Spell Property TSSD_SuccubusDetectJuice Auto
Spell Property TSSD_Overstuffed Auto
Spell Property TSSD_DrainHealth Auto

bool lookedAtExplanationsOnce = false
bool deathModeActivated = false
bool modifierKeyIsDown = false

bool [] cosmeticSettings

Keyword Property LocTypeInn Auto
Keyword Property LocTypePlayerHouse Auto
Keyword Property LocTypeCity Auto

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
        SelectSuccubusType()
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
    if !lookedAtExplanationsOnce
        OpenExlanationMenu()
        lookedAtExplanationsOnce = true
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
    elseif result < 5 && result > -1
        OpenSkillTrainingsMenu(result - 1)
        NotificationSpam(myItems[result - 1] )
    elseif result == 5
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
    endif
EndFunction

Function SelectSuccubusType()
    b612_TraitsMenu TraitsMenu = GetTraitsMenu()
    string[] succKinds = JArray.asStringArray(JDB.solveObj(".tssdoverviews.SuccubusKinds"))
    int index = 0
    while index < succKinds.Length
        TraitsMenu.AddItem( succKinds[index], JDB.solveStr(".tssdkinds." + succKinds[index] + ".description"), "menus/tssd/"+succKinds[index]+".dds")
        index += 1
    EndWhile

    String[] resultw = TraitsMenu.Show(aiMaxSelection = 1, aiMinSelection = 0)
    index = 0
    if resultw.Length>0
        TSSD_SuccubusType.SetValue(resultW[0] as int)
        if SuccubusDesireLevel.GetValue() == -101
            SuccubusDesireLevel.SetValue(50)
            updateSuccyNeeds(0)
            int startLevel = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iSuccubusLevel:Main")
            if startLevel > 0
                SuccubusXpAmount.SetValue( startLevel * 1000  )
                PlayerRef.AddPerk(TSSD_Drain_GentleDrain1)
                PlayerRef.AddPerk(TSSD_Seduction_Kiss1)
                PlayerRef.AddPerk(TSSD_Body_PassiveEnergy1)
            endif
            PlayerRef.AddPerk(TSSD_Base_Explanations)
            RegisterSuccubusEvents()
        endif
        ;if succubusType == 2
            ;DBGTRace(slavetats.simple_add_tattoo(PlayerRef, "Bofs Bimbo Tats Butt", "Butt (Lower) - Sex Doll"))
            
        ;Endif
    endif
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
    while index < JValue.count(jArr) 
        string[] textArr = jArray.asStringArray(jArray.getObj(jArr,index))
        string text = textArr[0]
        if cosmeticSettings[index]
            text = "> " + text
        endif
        TraitsMenu.AddItem( text, textArr[1], "menus/tssd/"+textArr[index]+".dds")
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

Endfunction


Function OpenSuccubusAbilities()
    
    String itemsAsString = "Activate Death Mode"
    if PlayerRef.HasPerk(TSSD_Seduction_OfferSex)
        itemsAsString += ";Ask for Sex."
    endif
    Actor Cross = Game.GetCurrentCrosshairRef() as Actor

    itemsAsString += ";Look for Prey" ;; Keep Last
    String[] myItems = StringUtil.Split(itemsAsString,";")
    if deathModeActivated
        myItems[0] = "Deactivate Death Mode"
    endif
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
    if myItems[result] == "Activate Death Mode" || myItems[result] == "Deactivate Death Mode"
        toggleDeathMode()
    elseif myItems[result] == "Look for Prey"
        ;if !PlayerRef.DispelSpell(TSSD_SuccubusDetectJuice)
        int old_dur = TSSD_SuccubusDetectJuice.GetNthEffectDuration(0)
        TSSD_SuccubusDetectJuice.SetNthEffectDuration(0, 5)
        TSSD_SuccubusDetectJuice.Cast(PlayerRef, PlayerRef)
        TSSD_SuccubusDetectJuice.SetNthEffectDuration(0, old_dur)
        ;endif
    elseif myItems[result] == "Ask for Sex." && Cross
        Sexlab.RegisterHook( stageEndHook)
        Sexlab.StartSceneQuick(akActor1 = PlayerRef, akActor2 = Cross)        
    endif
EndFunction


;Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function RegisterSuccubusEvents()
    RegisterForUpdateGameTime(0.4)
    RegisterForMenu("Dialogue Menu")
    if MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bDebugMode:Main")
        PlayerRef.AddPerk(TSSD_Seduction_OfferSex)
        TSSD_MaxTraits.SetValue(99)
    endif
    RegisterForModEvent("SexLabOrgasmSeparate", "PlayerOrgasmLel")
    RegisterForModEvent("PlayerTrack_Start", "PlayerStart")
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
    while index < ActorsIn.length
        Actor ActorRef = Actorsin[Index]
        energyNew += OEnergy.EvaluateOrgasmEnergy(_thread, ActorRef, 2 * (1 - (onStart as int)), overWriteStop = true)
        if PlayerRef != ActorRef
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

Function PlayerStart(Form FormRef, int tid)
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
    int index = 0
    while index < ActorsIn.Length
        Actor WhoCums = ActorsIn[index]
        if deathModeActivated &&  _thread.ActorAlias(WhoCums).GetOrgasmCount() > 0 && isSuccable(WhoCums) && (succubusType == 1 || WhoCums.GetRelationshipRank(PlayerRef) < 4)
            WhoCums.Kill(PlayerRef)
            updateSuccyNeeds(WhoCums.GetActorValueMax("Health"))
        endif
        index+=1
    EndWhile
    if deathModeActivated && SuccubusDesireLevel.GetValue() >= 0
        toggleDeathMode()
    endif
    if Game.GetModByName("Tullius Eyes.esp") != 255
        setHeartEyes(PlayerEyes, false)
    endif
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
Endfunction

Function RefreshEnergy(float adjustBy, int upTo = 100)
    float lastVal = SuccubusDesireLevel.GetValue()
    if lastVal < upTo
        SuccubusDesireLevel.SetValue( min(upTo, max( -100,  lastVal + adjustBy) ) )
    endif
Endfunction


Function updateSuccyNeeds(float value, bool resetAfterEnd = false)
    float succNeedVal = SuccubusDesireLevel.GetValue()
    int max_energy_level = 100
    int greed_mult = 1
    if PlayerRef.HasPerk(TSSD_Drain_DrainMore2)
        greed_mult = 3
    elseif PlayerRef.HasPerk(TSSD_Drain_DrainMore1)
        greed_mult = 2
    endif
    if PlayerRef.HasPerk(TSSD_Base_CapIncrease3)
        max_energy_level = 1000
    elseif PlayerRef.HasPerk(TSSD_Base_CapIncrease2)
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


Event PlayerOrgasmLel(Form ActorRef_Form, Int Thread)
    sslThreadController _thread =  Sexlab.GetController(Thread)
    Actor ActorRef = ActorRef_Form as Actor
    updateSuccyNeeds(OEnergy.EvaluateOrgasmEnergy(_thread, ActorRef, 1), true)
    if deathModeActivated && ActorRef != PlayerRef
        int StageCount = SexLabRegistry.GetPathMax(   _Thread.getactivescene()  , "").Length
        int Stage_in = StageCount   - SexLabRegistry.GetPathMax(_Thread.getactivescene() ,_Thread.GetActiveStage()).Length + 1
        TSSD_DrainHealth.SetNthEffectMagnitude(1, Min( ActorRef.GetActorValue("Health") - 10, 100 + SkillSuccubusDrainLevel.GetValue() * 4 ))
        TSSD_DrainHealth.Cast(PlayerRef, ActorRef)
        while  Stage_in < StageCount 
            _thread.AdvanceStage()
            Stage_in = StageCount   - SexLabRegistry.GetPathMax(_Thread.getactivescene() ,_Thread.GetActiveStage()).Length + 1
        EndWhile
    elseif !deathModeActivated  && ActorRef != PlayerRef && PlayerRef.HasPerk(TSSD_Drain_GentleDrain1)
        float new_drain_level = (100 + SkillSuccubusDrainLevel.GetValue() * 4)
        if PlayerRef.HasPerk(TSSD_Drain_GentleDrain3)
            new_drain_level /= 2
        elseif PlayerRef.HasPerk(TSSD_Drain_GentleDrain2)
            new_drain_level /= 3
        elseif PlayerRef.HasPerk(TSSD_Drain_GentleDrain1)
            new_drain_level /= 5
        endif
        TSSD_DrainHealth.SetNthEffectMagnitude(1, min(ActorRef.GetActorValue("Health") - 10 ,new_drain_level))
        TSSD_DrainHealth.Cast(PlayerRef, ActorRef)
    endif
EndEvent

Event OnUpdateGameTime()
    int succubusType = TSSD_SuccubusType.GetValue() as int
    float timeBetween = (TimeOfDayGlobalProperty.GetValue() - last_checked) * 24
    if SuccubusDesireLevel.GetValue() < -10 && ((succubusType == 0 && Game.GetPlayer().GetCurrentLocation().HasKeyword(LocTypeInn)) || \
             (succubusType == 1 && Game.GetPlayer().GetCurrentLocation().HasKeyword(LocTypePlayerHouse)) || \
             (succubusType == 2 && Game.GetPlayer().GetCurrentLocation().HasKeyword(LocTypeCity))  || \
            (succubusType == 4 && !Game.GetPlayer().GetCurrentLocation().HasKeyword(LocTypeCity)) )
        if timeBetween * 24 >= 1
            RefreshEnergy(timeBetween, 50)
            AddToStatistics(timeBetween as int)
        endif
        timeBetween = 0
    endif
    last_checked = TimeOfDayGlobalProperty.GetValue()
    updateSuccyNeeds(timeBetween * -1)
endEvent

Event OnMenuOpen(String MenuName)
    if SuccubusDesireLevel.GetValue() <= ravanousNeedLevel
        UI.InvokeString("HUD Menu", "_global.skse.CloseMenu", "Dialogue Menu")
        GetAnnouncement().Show("NO TIME TO TALK!", "icon.dds", aiDelay = 2.0)
    endif
EndEvent

Event OnInit()
    Maintenance(TSSD_SuccubusType)
	RegisterForModEvent("iWantWidgetsReset", "OniWantWidgetsReset")
	RegisterForSingleUpdate(_updateTimer)
EndEvent