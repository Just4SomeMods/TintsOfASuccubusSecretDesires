Scriptname tssd_actions extends Quest
import b612

iWant_Widgets Property  iWidgets Auto
SexLabFramework Property SexLab Auto
Actor Property PlayerRef Auto

Quest Property  b612Quest Auto

GlobalVariable Property TimeOfDayGlobalProperty Auto
GlobalVariable Property SkillSuccubusDrainLevel Auto
GlobalVariable Property SkillSuccubusSeductionLevel Auto
GlobalVariable Property SkillSuccubusBodyLevel Auto
GlobalVariable Property TSSD_PerkPointsBought Auto
GlobalVariable Property SuccubusDesireLevel Auto
GlobalVariable Property SuccubusXpAmount Auto
GlobalVariable Property TSSD_KillEssentialsActive Auto
GlobalVariable Property TSSD_MaxTraits Auto

Perk Property TOSD_Base_Explanations Auto
Perk Property TSSD_Body_Overstuffed Auto
Perk Property TSSD_Base_CapIncrease1 Auto
Perk Property TSSD_Base_CapIncrease2 Auto
Perk Property TSSD_Base_CapIncrease3 Auto
Perk Property TOSD_Drain_GentleDrain1 Auto
Perk Property TOSD_Drain_GentleDrain2 Auto
Perk Property TOSD_Drain_GentleDrain3 Auto
Perk Property TOSD_Drain_GentleDrain4 Auto
Perk Property TOSD_Drain_DrainMore1 Auto
Perk Property TOSD_Drain_DrainMore2 Auto
Perk Property TSSD_Seduction_Kiss1 Auto
Perk Property TOSD_Seduction_Leader Auto

Spell Property TSSD_SuccubusDetectJuice Auto
Spell Property TSSD_SuccubusBaseChanges Auto
Spell Property TSSD_Overstuffed Auto
Spell Property TOSD_DrainHealth Auto

bool lookedAtExplanationsOnce = false
bool barupdates
bool deathModeActivated = false
bool registered = false
bool initial = false
bool running = False
bool[] first_arr
bool [] chosenTraits

Faction Property sla_Arousal Auto

int succubusType = -1
int ravanousNeedLevel = -100
int myApple
int lastUsed = -1
int bar_pos_x
int bar_pos_y
int scale_pos_x
int scale_pos_y
int bar_rotation
float lastSmoochTimeWithThatPerson = 0.0

string nextAnnouncment = "" 
string InputString = ""
String SUCCUBUSTYPESCOLORS = "Crimson;Scarlet;Pink;Sundown"
String SUCCUBUSTYPESCOLORSRGB  = "220.20.60;255.36.0;255.192.203;255.179.181"
String SUCCUBUSDESCRIPTIONS = "Your standard Succubus experience.\nAt minimum energy, you enter Predator mode, forcing yourself on the first person you talk to. You lose less energy from climaxing yourself.;You are fueled by love, not lust.\n You lose more energy from climaxing with a person that does not love you.\nAt minimum energy, you enter Predator mode, forcing yourself on the first person you talk to.;You live an exciting life! Pursuing new things is your drive.\nYou gain more energy from climaxing partners that climax with you for the first time.\nYou lose more energy from climaxing with a partner you have been with before.\nAt minimum energy, you enter Predator mode, forcing yourself on the first person you talk to.;Your transformation was not complete. You are only a half-succubus.\nYou gain less energy and lose more.\nYou cannot reach below 0 Energy."
String SUCCUBUSTRAITS = "Lavenderblush;Cupid;Razzmatazz;Carnation;Tosca;Blush;Mahogany"
String SUCCUBUSTRAITSDESCRIPTIONS =  "SuccubusTraitsDescriptions Getting cummed on increases your energy even more.;Getting cummed in increases your energy even more.;Having sex for the first time with a person in a marriage that does not involve you increases your energy by a lot.;You gain more energy by having a partner orgasm whilst having romantic sex.;You gain more energy from sex that involves only one gender;You and your partners orgasms increase your energy more if they are aroused, else less.;You do not lose energy while climaxing form being raped, you lose more otherwise."
string[] filldirections
string[] barVals
string[] string_first_arr
string[] SUCCTRAITS
string[] SUCCTRAITSDESC
String[] succKinds
String[] succDesc

float last_checked
float timer_internal = 0.0
float[] initial_Bar_Vals
float[] new_Bar_Vals
float _updateTimer = 0.5
float smooching = 0.0

Function addToSmooching(float val)
    smooching += val
Endfunction

Bool Function SafeProcess()
    If (!Utility.IsInMenuMode()) && (!UI.IsMenuOpen("Dialogue Menu")) && (!UI.IsMenuOpen("Console")) && (!UI.IsMenuOpen("Crafting Menu")) && (!UI.IsMenuOpen("MessageBoxMenu")) && (!UI.IsMenuOpen("ContainerMenu")) && (!UI.IsMenuOpen("InventoryMenu")) && (!UI.IsMenuOpen("BarterMenu")) && (!UI.IsTextInputEnabled())
    Return True
    Else
    Return False
    EndIf
EndFunction

String [] Function GetSuccubusTraitsAll()
    return StringUtil.Split(SUCCUBUSTRAITS, ";")
Endfunction

Event TSSD_Main_Bar_Update(string a_eventName, string a_strArg, float a_numArg, form a_sender)
    iWidgets.setTransparency(myApple, 100)
    if a_eventName == "EVM_SliderChanged_TSSD_Main_Bar_Pos_X"
        bar_pos_x = (a_numArg + 0.5) as int
        initial_Bar_Vals[0] = a_numArg
        MCM.SetModSettingInt("TintsOfASuccubusSecretDesires","iBarPosX:Main", bar_pos_x)
	elseif a_eventName == "EVM_SliderChanged_TSSD_Main_Bar_Pos_Y"
        bar_pos_y = (a_numArg + 0.5) as int
        initial_Bar_Vals[1] = a_numArg
        MCM.SetModSettingInt("TintsOfASuccubusSecretDesires","iBarPosY:Main", bar_pos_y)
	elseif a_eventName == "EVM_SliderChanged_TSSD_Main_Bar_Size_X"
        scale_pos_x = (a_numArg + 0.5) as int
        initial_Bar_Vals[2] = a_numArg
        MCM.SetModSettingInt("TintsOfASuccubusSecretDesires","iBarScaX:Main", scale_pos_x)
	elseif a_eventName == "EVM_SliderChanged_TSSD_Main_Bar_Size_Y"
        scale_pos_y = (a_numArg + 0.5) as int
        initial_Bar_Vals[3] = a_numArg
        MCM.SetModSettingInt("TintsOfASuccubusSecretDesires","iBarScaY:Main", scale_pos_y)
	elseif a_eventName == "EVM_SliderChanged_TSSD_Main_Bar_Rotation"
        bar_rotation = (a_numArg + 0.5) as int
        initial_Bar_Vals[4] = a_numArg
        MCM.SetModSettingInt("TintsOfASuccubusSecretDesires","iBarRota:Main", bar_rotation)
    endif
    UpdateBarPositions()
EndEvent

Event TSSD_Main_Bar_Pos_X_Event(string a_eventName, string a_strArg, float a_numArg, form a_sender)
    TSSD_Main_Bar_Update(a_eventName, a_strArg, a_numArg, a_sender)
EndEvent
Event TSSD_Main_Bar_Pos_Y_Event(string a_eventName, string a_strArg, float a_numArg, form a_sender)
    TSSD_Main_Bar_Update(a_eventName, a_strArg, a_numArg, a_sender)
EndEvent
Event TSSD_Main_Bar_Size_X_Event(string a_eventName, string a_strArg, float a_numArg, form a_sender)
    TSSD_Main_Bar_Update(a_eventName, a_strArg, a_numArg, a_sender)
EndEvent
Event TSSD_Main_Bar_Size_Y_Event(string a_eventName, string a_strArg, float a_numArg, form a_sender)
    TSSD_Main_Bar_Update(a_eventName, a_strArg, a_numArg, a_sender)
EndEvent
Event TSSD_Main_Bar_Rotation_Event(string a_eventName, string a_strArg, float a_numArg, form a_sender)
    TSSD_Main_Bar_Update(a_eventName, a_strArg, a_numArg, a_sender)
EndEvent

Function UpdateBarPositions()
    IWidgets.setMeterFillDirection(myApple, filldirections[(initial_Bar_Vals[4] > 1) as int])
    if (initial_Bar_Vals[4] == 0 || initial_Bar_Vals[4] == 2)
        IWidgets.setRotation(myApple,0 )
    else
        IWidgets.setRotation(myApple,90 )
    endif
    IWidgets.setZoom(myApple, initial_Bar_Vals[2] as int, initial_Bar_Vals[3] as int)
    iWidgets.setpos(myApple, initial_Bar_Vals[0] as int, initial_Bar_Vals[1] as int)
EndFunction

Event OniWantWidgetsReset(String eventName, String strArg, Float numArg, Form sender)
	If eventName == "iWantWidgetsReset"
        iWidgets = sender As iWant_Widgets
        myApple = iWidgets.loadMeter(1, 1, false)
        UpdateBarPositions()
        iWidgets.setTransparency(myApple,0)
        IWidgets.setVisible(myApple)
	EndIf
    UpdateBarPositions()
	RegisterForSingleUpdate(_updateTimer)
EndEvent

Event OnUpdate()
    sslThreadController _thread =  Sexlab.GetPlayerController()
    if _thread && PlayerRef.HasPerk(TOSD_Seduction_Leader)
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

Function UpdateStatus()
    if iWidgets
        iWidgets.setTransparency(myApple,100)
        iWidgets.doTransitionByTime(myApple, max(SuccubusDesireLevel.GetValue(), SuccubusDesireLevel.GetValue() * -1) as int, 1.0, "meterpercent" ) 
        iWidgets.doTransitionByTime(myApple, 0, seconds = 2.0, targetAttribute = "alpha", easingClass = "none",  easingMethod = "none",  delay = 5.0)
        ;iWidgets.setText(myApple,"" + SuccubusDesireLevel.GetValue())
        setColorsOfBar()
    endif
EndFunction


bool Function isSuccable(Actor akActor)
    ActorBase ak = (akActor.GetBaseObject() as ActorBase)
    return  !(ak.IsProtected() || ak.IsEssential()) || (false && MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bKillEssentials:Main")) && !akActor.IsChild()
EndFunction


Event PlayerOrgasmLel(Form ActorRef_Form, Int Thread)
    sslThreadController _thread =  Sexlab.GetController(Thread)
    Actor ActorRef = ActorRef_Form as Actor
    
    if SuccubusDesireLevel.GetValue() > -101
        updateSuccyNeeds(evaluateSceneEnergy(_thread, ActorRef))
    endif
    
    if deathModeActivated && ActorRef != PlayerRef && _thread.GetPositions().Length == 2
        
        int StageCount = SexLabRegistry.GetPathMax(   _Thread.getactivescene()  , "").Length
        int Stage_in = StageCount   - SexLabRegistry.GetPathMax(_Thread.getactivescene() ,_Thread.GetActiveStage()).Length + 1
        TOSD_DrainHealth.SetNthEffectMagnitude(1, 100 + SkillSuccubusDrainLevel.GetValue() * 4 )
        TOSD_DrainHealth.Cast(PlayerRef, ActorRef)
        while  Stage_in < StageCount 
            _thread.AdvanceStage()
            Stage_in = StageCount   - SexLabRegistry.GetPathMax(_Thread.getactivescene() ,_Thread.GetActiveStage()).Length + 1
        EndWhile
    elseif !deathModeActivated  && ActorRef != PlayerRef && PlayerRef.HasPerk(TOSD_Drain_GentleDrain1)
        float new_drain_level = (100 + SkillSuccubusDrainLevel.GetValue() * 4)
        if PlayerRef.HasPerk(TOSD_Drain_GentleDrain4)
            TOSD_DrainHealth.SetNthEffectMagnitude(1,  new_drain_level)
        elseif PlayerRef.HasPerk(TOSD_Drain_GentleDrain3)
            TOSD_DrainHealth.SetNthEffectMagnitude(1,  new_drain_level / 2)
        elseif PlayerRef.HasPerk(TOSD_Drain_GentleDrain2)
            TOSD_DrainHealth.SetNthEffectMagnitude(1,  new_drain_level / 3)
        elseif PlayerRef.HasPerk(TOSD_Drain_GentleDrain1)
            TOSD_DrainHealth.SetNthEffectMagnitude(1,  new_drain_level / 5)
        endif
    endif

EndEvent


Function EvaluateCompleteScene(bool onStart=false)
    nextAnnouncment = ""
    sslThreadController _thread =  Sexlab.GetPlayerController()
    int index = 0
    int max_rel = -4
    bool max_prot = false
    Actor[] ActorsIn = _thread.GetPositions()
    string output = ""
    float energyNew = 0
    while index < ActorsIn.length
        Actor ActorRef = Actorsin[Index]
        energyNew += evaluateSceneEnergy(_thread, ActorRef, false)
        if PlayerRef != ActorRef
            max_rel = max(ActorRef.GetRelationshipRank(playerref), max_rel) as int
            if !isSuccable(ActorRef) && deathModeActivated
                max_prot = true
            endif
        endif

        index += 1
    EndWhile

    if energyNew >= 30
        output += "Ooh, this will do nicely! "
    elseif energyNew >= 20
        output += "Mhhm this is good. "
    elseif energyNew >= 10
        output += "I like this."
    elseif energyNew < 0
        output += "Eugh, this is bad. "
    endif

    if (max_rel > 3 && succubusType == 1 || max_prot) && deathModeActivated && onStart ; TODO - Logic for auto-deactivation
        output += "I can't drain them! "
        toggleDeathMode()
    endif

    GetAnnouncement().Show(output + "\n" + nextAnnouncment + "Projected Energy gain: " + (energyNew as int), "icon.dds", aiDelay = 2.0)
Endfunction

float Function GetLastTimeSuccd(Actor Target)
    float lastTime = SexlabStatistics.GetLastEncounterTime(Target,PlayerRef)
    if lastTime > 0.0
        return TimeOfDayGlobalProperty.GetValue() - lastTime
    endif
    return -1.0
Endfunction

Function PlayerStart(Form FormRef, int tid)
    if smooching == 0.0
        EvaluateCompleteScene(true)
    else
        Actor[] ActorsIn = Sexlab.GetController(tid).GetPositions() 
        Actor nonPlayer = ActorsIn[0]
        if nonPlayer == PlayerRef
            nonPlayer = ActorsIn[1]
        endif
        lastSmoochTimeWithThatPerson = GetLastTimeSuccd(nonPlayer)
        
    endif

EndFunction

Function PlayerSceneEnd(Form FormRef, int tid)
    sslThreadController _thread =  Sexlab.GetController(tid)
    Actor[] ActorsIn = Sexlab.GetController(tid).GetPositions() 
    if SuccubusDesireLevel.GetValue() > -101
        updateSuccyNeeds(evaluateSceneEnergy(Sexlab.GetController(tid), none, false), true)
    endif
    int index = 0
    while index < ActorsIn.Length
        Actor WhoCums = ActorsIn[index] 
        if WhoCums != PlayerRef && deathModeActivated && allowedToSuccToDeath(WhoCums) && _thread.ActorAlias(WhoCums).GetOrgasmCount() > 0
            WhoCums.Kill(PlayerRef)
            updateSuccyNeeds(WhoCums.GetActorValueMax("Health"))
        endif
        index+=1
    EndWhile
EndFunction

float Function evaluateSceneEnergy(sslThreadController _thread, Actor WhoCums = none, bool anounceMent = true)
    float dateCheck = TimeOfDayGlobalProperty.GetValue() 
    float retVal = 0
    String output = ""
    float energyLosses = 0
    Actor[] ActorsIn = _thread.GetPositions()
    if WhoCums
        int idx = _thread.GetPositionIdx(WhoCums)
        int orgCount = _thread.ActorAlias(WhoCums).GetOrgasmCount()
        if WhoCums != PlayerRef && isSuccable(WhoCums)
            if Sexlab.GetSex(WhoCums) == 0 || Sexlab.GetSex(WhoCums) == 2 || Sexlab.GetSex(WhoCums) == 3
                if chosenTraits[0] && _thread.HasSceneTag("Aircum")
                    retVal += 5
                    output += "Cum is in the air! "
                elseif chosenTraits[1] && !_thread.HasSceneTag("Aircum") && (_thread.HasSceneTag("Oral") || _thread.HasSceneTag("Anal") || _thread.HasSceneTag("Vaginal") )
                    retVal += 5
                    output += "Cum enters you! "
                endif
            endif
            if chosenTraits[2] && (_thread.HasSceneTag("love") || _thread.HasSceneTag("loving"))
                retVal += 5
                output += "This is romantic! "
            endif
            if chosenTraits[5]
                float ar_norm = (WhoCums.GetFactionRank(sla_Arousal) - 50)
                retval += ar_norm / 5
                if ar_norm > 0
                    output += "This is a great release for " + WhoCums.GetDisplayName() + "! "
                else
                    output += "I don't think " + WhoCums.GetDisplayName() +" needed that... " 
                endif
            endif
            if orgCount == 1
                retVal += 10
                if chosenTraits[3] && WhoCums.GetHighestRelationshiprank() == 4 && SexlabStatistics.GetTimesMet(WhoCums,PlayerRef) == 0
                    retVal += 5
                    output += "Homewrecker!\n"
                endif
            elseif orgCount > 1
                retVal /= (orgCount+1)
            endif
            if SexlabStatistics.GetTimesMet(WhoCums,PlayerRef) == 0 && succubusType == 2
                retVal += 5
                output += "New One!\n"
            elseif WhoCums.GetRelationshipRank(PlayerRef) > 0 && succubusType == 1
                retVal += 5
                output += "My love!\n"
            endif
        endif
        if WhoCums == PlayerRef || isSuccable(WhoCums)
            if chosenTraits[4]
                if _thread.sameSexThread()
                    retVal += 5
                    output += "This is so GAY! "
                elseif WhoCums == PlayerRef
                    energyLosses -= 5
                    output += "This is too straight! "
                endif
            endif
            if chosenTraits[5] && PlayerRef == WhoCums
                float ar_norm = (WhoCums.GetFactionRank(sla_Arousal) - 50)
                if ar_norm > 0
                    retval += ar_norm / 5
                    output += "This is a great release for me! "
                else
                    energyLosses += ar_norm / 5
                    output += "I don't think I needed that... " 
                endif

            endif
            if chosenTraits[6]
                if _thread.GetSubmissive(PlayerRef)
                    retVal += 5
                    output += "Thrilling! "
                elseif WhoCums == PlayerRef
                    energyLosses -= 5
                    output += "Way too safe. "
                endif
            endif
        endif
    endif
    if WhoCums == PlayerRef
        int index = 0
        bool sameSex = true
        int max_relationship = 0
        int min_times = 0
        while index < ActorsIn.Length
            Actor ActorRef = ActorsIn[index]
            if ActorRef!= PlayerRef
                max_relationship = max(ActorRef.GetRelationshipRank(PlayerRef), max_relationship) as int
                min_times = min(SexlabStatistics.GetTimesMet(ActorRef,PlayerRef), min_times) as int
            endif
            index += 1
        EndWhile
        if succubusType == 1 && max_relationship < 4 
            energyLosses = -5
            output += "No... I didn't mean to! "
        elseif succubusType == 2 && min_times >= 1
            energyLosses = -5
            output += "Boring! "
        endif
        if succubusType < 3
            energyLosses -= -5
        endif
    endif

    int nonPlayerCount = ActorsIn.Length - 1
    if WhoCums && PlayerRef != WhoCums
        retVal = retVal / nonPlayerCount
    endif
    if (!WhoCums || (!anounceMent && WhoCums != PLayerRef)) && smooching > 0.0
        retval = smooching
        output += "Smooch!\n"
    endif
    if retval > 0
        if succubusType == 3
            retval /= 2
        endif
    endif
    if smooching > 0.0
        float lastMet = lastSmoochTimeWithThatPerson
        if lastMet>=0.0
            retVal *= min(lastMet, 1)
        endif

    endif
    if WhoCums && WhoCums != PlayerRef
        float lastMet = GetLastTimeSuccd(WhoCums)
        if lastMet>0.0
            retVal *= min(lastMet, 1)
        endif
    endif
    retVal += energyLosses
    if output != ""
        nextAnnouncment += output +"\n"
    endif
    if anounceMent
        GetAnnouncement().Show(output + (retval as int), "icon.dds", aiDelay = 5.0)
    endif
    return retVal
EndFunction

bool Function allowedToSuccToDeath(Actor ActorRef)
    bool endResult = isSuccable(ActorRef)
    if succubusType == 1 && ActorRef.GetRelationshipRank(PlayerRef) > 3 ; You cannot kill your sweethearts.
        endResult = false
    endif
    return endResult
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

Function OpenGrandeMenu()
    if !SafeProcess()
        return
    endif
    if succubusType == -1
        SelectSuccubusType()
        return
    endif
    last_checked = TimeOfDayGlobalProperty.GetValue()
    b612_SelectList mySelectList = GetSelectList()
    sslThreadController _thread =  Sexlab.GetPlayerController()
    String[] myItems = StringUtil.Split("Abilities;Upgrades;Settings;Rechoose Type",";")
    if TSSD_MaxTraits.GetValue() > 0
        myItems = StringUtil.Split("Abilities;Upgrades;Settings;Rechoose Type;Select Traits",";")
    endif
    Int result
    if Input.IsKeyPressed( MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iModifierHotkey:Main") )
        result = lastUsed
    else
        result = mySelectList.Show(myItems)
        if result > -1
            lastUsed = result
        endif
    endif

    int valToCheck = 0

    if result == valToCheck
        OpenSuccubusAbilities()
    endif
    valToCheck += 1

    if result == valToCheck
        OpenExpansionMenu()
    endif
    valToCheck += 1

    if result == valToCheck
        OpenSettingsMenu()
    endif
    valToCheck += 1

    if result == valToCheck
        SelectSuccubusType()
    endif
    valToCheck += 1
    
    if result == valToCheck
        OpenSuccubusTraits()
    endif
    valToCheck += 1

EndFunction

Event OnUpdateGameTime()
    float energyLoss = TimeOfDayGlobalProperty.GetValue() - last_checked
    last_checked = TimeOfDayGlobalProperty.GetValue()
    updateSuccyNeeds(energyLoss * -24)
endEvent

Function updateSuccyNeeds(float value, bool resetAfterEnd = false)
    float succNeedVal = SuccubusDesireLevel.GetValue()
    int max_energy_level = 100
    int greed_mult = 1
    if PlayerRef.HasPerk(TOSD_Drain_DrainMore2)
        greed_mult = 3
    elseif PlayerRef.HasPerk(TOSD_Drain_DrainMore1)
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
        CustomSkills.AdvanceSkill("SuccubusBaseSkill", value * 10)
    endif
    
    if succNeedVal != -101
        
        if succNeedVal > 0
            SuccubusDesireLevel.SetValue(Min(max_energy_level, Max(succNeedVal+ value * greed_mult, 0)))
        else
            SuccubusDesireLevel.SetValue(Min(100, Max(succNeedVal+ value, -100)))
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
    UpdateStatus()
EndFunction

float Function Max(float a, float b)
    if a > b 
        return a
    endif
    return b
EndFunction

float Function Min(float a, float b)
    if b > a 
        return a
    endif
    return b
EndFunction

Function OpenExpansionMenu()
    if !lookedAtExplanationsOnce
        OpenExlanationMenu()
        lookedAtExplanationsOnce = true
        return
    endif

    b612_SelectList mySelectList = GetSelectList()
    String[] myItems = StringUtil.Split("Drain;Seduction;Body;Perk Points;Perk Trees;Show Explanations again",";")
    Int result  = mySelectList.Show(myItems)
    if result < 4 && result > -1
        OpenSkillTrainingsMenu(result)
    elseif result == 4
        CustomSkills.OpenCustomSkillMenu("SuccubusBaseSkill")
    elseif result == 5
        lookedAtExplanationsOnce = false
        OpenExpansionMenu()
    endif
EndFunction

Function OpenExlanationMenu()
        
    String[] SUCCUBUSTATS = StringUtil.Split( "Perk Trees;Drain;Seduction;Body;Perk Points",";")
    String[] SUCCUBUSTATSDESCRIPTIONS =  StringUtil.Split("Opens the Perk Trees of this mod;Drain increases your drain strength;Seduction increases your <Speechcraft and gives you the ability to hypnotize people>;Body <Increases your Combat Prowess>;Perk Points give you perkpoint for the Trees in this mod.",";")
    b612_TraitsMenu TraitsMenu = GetTraitsMenu()

    int index = 0
    while index < SUCCUBUSTATS.Length
        TraitsMenu.AddItem( SUCCUBUSTATS[index], SUCCUBUSTATSDESCRIPTIONS[index], "menus/tssd/"+SUCCUBUSTATS[index]+".dds")
        index += 1
    EndWhile
    string[] result = TraitsMenu.Show(aiMaxSelection = 1, aiMinSelection = 0)
    int resultw = result[0] as int
    if result.length == 0
        Return
    endif
    if resultW == 0
        CustomSkills.OpenCustomSkillMenu("SuccubusBaseSkill")
    elseif resultw >= 0
        OpenSkillTrainingsMenu(resultW - 1)
    endif

Endfunction

Function OpenSkillTrainingsMenu(int index_of)
    String[] myItems = StringUtil.Split("Drain;Seduction;Body;Perk Points;Perk Trees;Read Explanations again",";")
    String[] skillNames = new String[4]
    skillNames[0] = "SuccubusDrainSkill"
    skillNames[1] = "SuccubusSeductionSkill"
    skillNames[2] = "SuccubusBodySkill"
    skillNames[3] = "SuccubusPerkPoints"

    tssd_trainSuccAbilities trainingThing =  ((Quest.GetQuest("tssd_queststart")) as tssd_trainSuccAbilities)
    trainingThing.SetSkillName(mYitems[index_of])
    trainingThing.SetSkillVariable(skillNames[index_of])
    (trainingThing).show()

Endfunction

Function OpenSuccubusTraits()

    b612_TraitsMenu TraitsMenu = GetTraitsMenu()
    int index = 0
    while index < succTraits.Length
        if chosenTraits[index]
            TraitsMenu.AddItem( "> " + succTraits[index], succTraitsDesc[index], "menus/tssd/"+succTraits[index]+".dds")
        else
            TraitsMenu.AddItem( succTraits[index], succTraitsDesc[index], "menus/tssd/"+succTraits[index]+".dds")   
        endif
        index += 1
    EndWhile
    
    String[] resultW = TraitsMenu.Show(aiMaxSelection = TSSD_MaxTraits.GetValue() as int, aiMinSelection = 0)
    if resultW.Length > 0
        chosenTraits = Utility.CreateBoolArray(succTraits.Length, false)
        index = 0
    endif
    while index < resultw.Length
        chosenTraits[resultW[index] as int] = true
        index += 1
    EndWhile
EndFunction

Function SelectSuccubusType()
    b612_TraitsMenu TraitsMenu = GetTraitsMenu()
    succKinds = StringUtil.Split(SUCCUBUSTYPESCOLORS, ";")
    succDesc  = StringUtil.Split(SUCCUBUSDESCRIPTIONS, ";")

    int index = 0
    while index < succKinds.Length
        TraitsMenu.AddItem( succKinds[index], succDesc[index], "menus/tssd/"+succKinds[index]+".dds")
        index += 1
    EndWhile

    String[] resultw = TraitsMenu.Show(aiMaxSelection = 1, aiMinSelection = 0)
    index = 0
    if resultw.Length>0
        if SuccubusDesireLevel.GetValue() == -101
            SuccubusDesireLevel.SetValue(50)
            updateSuccyNeeds(0)
            PlayerRef.AddPerk(TOSD_Base_Explanations)
            RegisterForUpdateGameTime(0.4)
            RegisterForMenu("Dialogue Menu")
        endif
        succubusType = resultW[0] as int
        setColorsOfBar()
    endif
EndFunction

Function setColorsOfBar()
    if SuccubusDesireLevel.GetValue() > 0
        string[] succColors = StringUtil.Split((StringUtil.Split(SUCCUBUSTYPESCOLORSRGB,";")[succubusType]), ".")
        IWidgets.setMeterRGB(myApple, succColors[0] as int, succColors[1] as int, succColors[2] as int, succColors[0] as int, succColors[1] as int, succColors[2] as int)
    else
        IWidgets.setMeterRGB(myApple, 0,0,0, 0,0,0)
    endif


EndFunction

Event OnMenuOpen(String MenuName)
    if SuccubusDesireLevel.GetValue() <= ravanousNeedLevel
        UI.InvokeString("HUD Menu", "_global.skse.CloseMenu", "Dialogue Menu")
        GetAnnouncement().Show("NO TIME TO TALK!", "icon.dds", aiDelay = 2.0)
    endif
EndEvent

Function ListOpenBarsOld()
    int listLength = barVals.length
	String[] BarSliders = Utility.CreateStringArray(ListLength)
    int taken_num = 0
	int index = 0
    while index < listLength
        int max_now = 2
        int step_size = 1
        if index<2
            max_now = 1500
        elseif index<4
            max_now = 200
        else
            max_now = 3
        endif
        BarSliders[index] = ExtendedVanillaMenus.SliderParamsToString("TSSD_Main_Bar_"+barVals[index], barVals[index],"",0,max_now,step_size,0)
        index += 1
    EndWhile

    ;event recieved when Slider Menu is closed. a_strArg == slider values seperated by ||. If accepted, a_numArg == 1. If Cancelled a_numArg == 0.
    registerForModEvent("EVM_SliderMenuClosed", "OnEVM_OpenBarsClosed")
    
    ExtendedVanillaMenus.SliderMenuMult(SliderParams = BarSliders, InitialValues = initial_Bar_Vals, TitleText = "My Sliders", AcceptText = "Alright", CancelText = "No Way", WaitForResult = False)

    index = 0
    while index < listLength
		registerForModEvent("EVM_SliderChanged_" + "TSSD_Main_Bar_"+barVals[index],  "TSSD_Main_Bar_"+barVals[index]+"_Event")
        index += 1
	EndWhile
    
EndFunction


Event OnEVM_OpenBarsClosed(string a_eventName, string a_strArg, float a_numArg, form a_sender)
	int index = 0
    while index < barVals.Length
		unregisterForModEvent("EVM_SliderChanged_" + "TSSD_Main_Bar_"+barVals[index])
        index += 1
    EndWhile
    if a_numArg == 1 ;user accepted 
        new_Bar_Vals = DbMiscFunctions.SplitAsFloat(a_strArg) ;split string result into float array
        initial_Bar_Vals = CopyArray(new_Bar_Vals)
    elseif a_numArg == 0
        initial_Bar_Vals = CopyArray(new_Bar_Vals)  
    Endif
    UpdateBarPositions()
    UpdateStatus()
EndEvent

Function OpenSuccubusAbilities()
    
    String itemsAsString = "Activate Death Mode"

    itemsAsString += ";Enable Predator Mode (Debug)" ;; Keep Last

    String[] myItems = StringUtil.Split(itemsAsString,";")
    Int result 
    if deathModeActivated
        myItems[0] = "Deactivate Death Mode"
    endif

    Actor targetRef = Game.GetCurrentCrosshairRef() as Actor
    int index = 0    

    result = GetSelectList().Show(myItems)
    if result == -1
        return
    endif

    if myItems[result] == "Activate Death Mode" || myItems[result] == "Deactivate Death Mode"
        toggleDeathMode()
    elseif myItems[result] == "Enable Predator Mode (Debug)"
        SuccubusDesireLevel.SetValue(-100)
    endif   

EndFunction

Function OpenSettingsMenu()
    String[] myItems = StringUtil.Split("Configure Bars;Evaluate Needs;Debug Climax Now;Essentials are protected",";")
    Int result 
    Actor Cross = Game.GetCurrentCrosshairRef() as Actor
    bool canEssDie = TSSD_KillEssentialsActive.GetValue() > 0
    if canEssDie
        myItems[3] = "Essentials can die."
    endif
    
    result = GetSelectList().Show(myItems)
    int valToCheck = 0    

    if result == valToCheck
        ListOpenBarsOld()
    endif
    valToCheck += 1

    if result == valToCheck
        if Sexlab.GetPlayerController()
            EvaluateCompleteScene()
        elseif Cross
            string showboat = "I can't succ them!"
            if isSuccable(Cross)
                int lasttime = (GetLastTimeSuccd(Cross) * 100) as int
                if lasttime > 100.0 || lasttime < 0.0 
                    showboat = "This person is full of juicy energy!"
                else
                    showboat = "This person is only " + lasttime + "% ready."
                endif
            endif
            GetAnnouncement().Show(showboat, "icon.dds", aiDelay = 2.0)
        endif
                
    endif
    valToCheck += 1

    if result == valToCheck
        DebugForceOrgasm()
    endif
    valToCheck += 1
    if result == valToCheck
        MCM.SetModSettingBool("TintsOfASuccubusSecretDesires","bKillEssentials:Main", !canEssDie)
        TSSD_KillEssentialsActive.SetValue( (!canEssDie) as int)
    endif
    valToCheck += 1
EndFunction

Function toggleDeathMode()
    if SuccubusDesireLevel.GetValue() > ravanousNeedLevel
        deathModeActivated = !deathModeActivated
    else 
        deathModeActivated = true
    endif
    if deathModeActivated
        GetAnnouncement().Show("SOMEONE NEEDS TO DIE NOW!", "icon.dds", aiDelay = 2.0)
    endif
    TSSD_KillEssentialsActive.SetValue(MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bKillEssentials:Main") as int)
EndFunction


Event OnInit()
    SUCCTRAITS      = StringUtil.Split(SUCCUBUSTRAITS, ";")
    SUCCTRAITSDESC  = StringUtil.Split(SUCCUBUSTRAITSDESCRIPTIONS, ";")
    chosenTraits = Utility.CreateBoolArray(succTraits.Length, false)
	filldirections =  StringUtil.Split("left;right;both", ";")
	RegisterForModEvent("iWantWidgetsReset", "OniWantWidgetsReset")
	RegisterForSingleUpdate(_updateTimer)
    RegisterForModEvent("SexLabOrgasmSeparate", "PlayerOrgasmLel")
	RegisterForModEvent("PlayerTrack_Start", "PlayerStart")
    RegisterForModEvent("PlayerTrack_End", "PlayerSceneEnd")
	barVals = StringUtil.Split("Pos_X;Pos_Y;Size_X;Size_Y;Rotation", ";")

    ;RegisterForModEvent("ExtendedVanillaMenus_Debug", "OmExtendedVanillaMenus_Debug")
    
    initial_Bar_Vals = New Float[5]
    initial_Bar_Vals[0] = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iBarPosX:Main") as float
    initial_Bar_Vals[1] = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iBarPosY:Main") as float
    initial_Bar_Vals[2] = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iBarScaX:Main") as float
    initial_Bar_Vals[3] = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iBarScaY:Main") as float
    initial_Bar_Vals[4] = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iBarRota:Main") as float
    bar_pos_x =    initial_Bar_Vals[0] as int
    bar_pos_y =    initial_Bar_Vals[1] as int
    scale_pos_x =  initial_Bar_Vals[2] as int
    scale_pos_y =  initial_Bar_Vals[3] as int
    bar_rotation = initial_Bar_Vals[4] as int
    
    new_Bar_Vals = CopyArray(initial_Bar_Vals)
    
EndEvent 

float[] Function CopyArray(float[] arr1)
    float[] arr2 = Utility.CreateFloatArray(arr1.Length)
    int index = 0
    while index < arr2.length
        arr2[index] = arr1[index]
        index+=1
    EndWhile
    return arr2
EndFunction

