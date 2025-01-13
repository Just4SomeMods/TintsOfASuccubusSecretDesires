Scriptname tssd_actions extends Quest
import b612

iWant_Widgets Property  iWidgets Auto
SexLabFramework Property SexLab Auto
sslActorStats Property sslStats Auto
tssd_succubusstageendblockhook Property stageEndHook Auto
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

Spell Property TSSD_SuccubusDetectJuice Auto
Spell Property TSSD_Overstuffed Auto
Spell Property TSSD_DrainHealth Auto

bool lookedAtExplanationsOnce = false
bool barupdates
bool deathModeActivated = false
bool registered = false
bool initial = false
bool running = False
bool modifierKeyIsDown = false
bool[] first_arr
bool [] chosenTraits
bool [] cosmeticSettings
int nextAnnouncmentLineLength = 0

Faction Property sla_Arousal Auto

Keyword Property LocTypeInn Auto
Keyword Property LocTypePlayerHouse Auto
Keyword Property LocTypeCity Auto

HeadPart PlayerEyes

int succubusType = -1
int ravanousNeedLevel = -100
int myApple
int lastUsed = -1
int lastUsedSub = -1

float lastSmoochTimeWithThatPerson = 0.0

string nextAnnouncment = "" 
string InputString = ""
String SUCCUBUSTYPESCOLORS = "Crimson;Scarlet;Pink;Sundown;Mahogany"
String SUCCUBUSTYPESCOLORSRGB  = "220.20.60;255.36.0;255.192.203;255.179.181;108.67.36"
String SUCCUBUSDESCRIPTIONS = "Your standard Succubus experience. You lose less energy from climaxing yourself. At minimum energy, you enter Predator mode, forcing yourself on the first person you talk to, draining them to death.;You are fueled by love, not lust. In the right light, your eyes appear as hears. You do not lose energy from climaxing during sex with a person that loves your, else you lose more. At minimum energy, you enter Predator mode, forcing yourself on the first person you talk to, draining them to death.;You live an exciting life! Pursuing new things is your drive. You lose no energy while climaxing with a person on your first time together, else more. At minimum energy, you enter Predator mode, forcing yourself on the first person you talk to, draining them to death.;Your transformation was not complete. You are only a half-succubus. You gain less energy and lose more. You cannot reach below 0 Energy.;Without risk, there is no fun... You do not lose energy while climaxing form being raped, you lose more otherwise. At minimum energy, you enter Predator mode, forcing yourself on the first person you talk to, draining them to death."
String SUCCUBUSTRAITS = "Razzmatazz;Cupid;Lavenderblush;Carnation;Tosca;Blush"

String SUCCUBUSTRAITSDESCRIPTIONS =  "You Gain more energy from getting cummed upon.;You gain more energy from getting cummed in.;Having sex for the first time with a person in a marriage that does not involve you increases your energy gained by a lot.;You gain more energy by having a partner orgasm whilst having romantic sex.;You gain more energy from orgasms caused by sex that involves only one gender;Your partners orgasms increase your energy gains more if they are aroused."

String SUCCUBUSTTYPESDIALOGUESTRING = ":Exhausting... ;My love! :No... I didn't mean to! ;New one! :Boring! ; : ;Exciting! :*Yawn* "
String SUCCUBUSTRAITSDIALOGUESTRING = "Cum is in the air!:I need it on my skin...;I love it sloshing down!:Argh it's being wasted!;Homewrecker!: ;Roses are in the air!:It doesn't feel romantic...;This is so GAY!:This is too straight.; needed that!: did not need that."
String[] SUCCUBUSTRAITSDIALOGUE      
int[]    SUCCUBUSTRAITSVALUESBONUS
int[]    SUCCUBUSTRAITSTARGET        

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

;GLOBAL UTILITY FUNCTIONS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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


Bool Function SafeProcess()
    If (!Utility.IsInMenuMode()) && (!UI.IsMenuOpen("Dialogue Menu")) && (!UI.IsMenuOpen("Console")) && (!UI.IsMenuOpen("Crafting Menu")) && (!UI.IsMenuOpen("MessageBoxMenu")) && (!UI.IsMenuOpen("ContainerMenu")) && (!UI.IsMenuOpen("InventoryMenu")) && (!UI.IsMenuOpen("BarterMenu")) && (!UI.IsTextInputEnabled())
    Return True
    Else
    Return False
    EndIf
EndFunction

float[] Function CopyArray(float[] arr1)
    float[] arr2 = Utility.CreateFloatArray(arr1.Length)
    int index = 0
    while index < arr2.length
        arr2[index] = arr1[index]
        index+=1
    EndWhile
    return arr2
EndFunction


;SPECIFIC UTILITY FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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

Function addToSmooching(float val)
    smooching += val
Endfunction

String [] Function GetSuccubusTraitsAll()
    return StringUtil.Split(SUCCUBUSTRAITS, ";")
Endfunction

Function setColorsOfBar()
    if SuccubusDesireLevel.GetValue() > 0
        string[] succColors = StringUtil.Split((StringUtil.Split(SUCCUBUSTYPESCOLORSRGB,";")[succubusType]), ".")
        IWidgets.setMeterRGB(myApple, succColors[0] as int, succColors[1] as int, succColors[2] as int, succColors[0] as int, succColors[1] as int, succColors[2] as int)
    else
        IWidgets.setMeterRGB(myApple, 0,0,0, 0,0,0)
    endif
EndFunction


;MENUS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function OpenGrandeMenu()
    modifierKeyIsDown = Input.IsKeyPressed( MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iModifierHotkey:Main") )
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

Function NotificationSpam(string Displaying)
    if MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bSpamNotifications:Main")
        Debug.Notification( "You picked: " + Displaying )
    endif
Endfunction


Function OpenExpansionMenu()
    if !lookedAtExplanationsOnce
        OpenExlanationMenu()
        lookedAtExplanationsOnce = true
        return
    endif

    b612_SelectList mySelectList = GetSelectList()
    String[] myItems = StringUtil.Split("Drain;Seduction;Body;Perk Points;Perk Trees;Show Explanations again",";")
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
    
    if result < 4 && result > -1
        OpenSkillTrainingsMenu(result)
        NotificationSpam(myItems[result] )
    elseif result == 4
        CustomSkills.OpenCustomSkillMenu("SuccubusBaseSkill")
    elseif result == 5
        lookedAtExplanationsOnce = false
        OpenExpansionMenu()
    endif
EndFunction

Function OpenExlanationMenu()
        
    String[] SUCCUBUSTATS = StringUtil.Split( "Perk Trees;Drain;Seduction;Body;Perk Points",";")
    String[] SUCCUBUSTATSDESCRIPTIONS =  StringUtil.Split("Opens the Perk Trees of this mod;Drain increases your drain strength;Seduction increases your [Speechcraft and gives you the ability to hypnotize people];Body [Increases your Combat Prowess];Perk Points give you perkpoint for the Trees in this mod.",";")
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
    endif
    if resultw == -1
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
        int lastType = succubusType
        succubusType = resultW[0] as int
        if SuccubusDesireLevel.GetValue() == -101
            SuccubusDesireLevel.SetValue(50)
            updateSuccyNeeds(0)
            PlayerRef.AddPerk(TSSD_Base_Explanations)
            RegisterForUpdateGameTime(0.4)
            RegisterForMenu("Dialogue Menu")
            if MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bDebugMode:Main")
                PlayerRef.AddPerk(TSSD_Seduction_OfferSex)
                TSSD_MaxTraits.SetValue(99)
            endif
            RegisterForModEvent("SexLabOrgasmSeparate", "PlayerOrgasmLel")
            RegisterForModEvent("PlayerTrack_Start", "PlayerStart")
            RegisterForModEvent("PlayerTrack_End", "PlayerSceneEnd")
        endif
        setColorsOfBar()
    endif
EndFunction

Function setHeartEyes(bool on = true)
    HeadPart HeartEyes = HeadPart.GetHeadPart("TSSD_FemaleEyesHeart2")
    if !on && PlayerEyes
        playerRef.ChangeHeadPart( PlayerEyes)
    else
        ActorBase Base = PlayerRef.GetBaseObject() as ActorBase
        int parts = Base.GetNumHeadParts()
        While parts > 0
            parts -= 1
            int Temp = Base.GetNthHeadPart(parts).GetType()
            If Temp == 2 
                if Base.GetNthHeadPart(Parts) != HeartEyes
                    PlayerEyes = Base.GetNthHeadPart(Parts)
                endif
                parts = 0
            endIf
        EndWhile
        playerRef.ChangeHeadPart( HeartEyes )
    endif
    playerRef.QueueNiNodeUpdate()
Endfunction


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


Function OpenSettingsMenu()
    String[] myItems = StringUtil.Split("Configure Bars;Evaluate Needs;Debug Climax Now;Essentials are protected;Succubus Cosmetics Menu",";")
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
    if myItems[result] == "myItems"
        ListOpenBarsOld()
    elseif myItems[result] == "Evaluate Needs"
        if Sexlab.GetPlayerController()
            EvaluateCompleteScene()
        elseif Cross
            string showboat = "I can't succ " + Cross.GetDisplayName() +"!"
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
    elseif myItems[result] == "Debug Climax Now"
        DebugForceOrgasm()
    elseif myItems[result] == "Configure Bars"
        ListOpenBarsOld()
    elseif myItems[result] == "Succubus Cosmetics Menu"
        OpenSuccubusCosmetics()
    elseif myItems[result] == "Essentials are protected" || myItems[result] ==  "Essentials can die"
        MCM.SetModSettingBool("TintsOfASuccubusSecretDesires","bKillEssentials:Main", !canEssDie)
        TSSD_KillEssentialsActive.SetValue( 0) ;(!canEssDie) as int)
    endif
EndFunction

Function OpenSuccubusCosmetics()
    String[] SUCCUBUSCOSMETICS = StringUtil.Split( "No Heart Pupils for Scarlet;Heart Pupils for all",";")
    String[] SUCCUBUSCOSMETICSDESCRIPTIONS =  StringUtil.Split("Toggle if Scarlet Succubi have heart shaped pupils during Sex;Heart shaped pupils for all!",";")
    b612_TraitsMenu TraitsMenu = GetTraitsMenu()
    if !cosmeticSettings
        cosmeticSettings = Utility.CreateBoolArray(SUCCUBUSCOSMETICS.Length, false)
    endif
    int index = 0
    while index < SUCCUBUSCOSMETICS.Length
        string text = SUCCUBUSCOSMETICS[index]
        if cosmeticSettings[index]
            text = "> " + text
        endif
        TraitsMenu.AddItem( text, SUCCUBUSCOSMETICSDESCRIPTIONS[index], "menus/tssd/"+SUCCUBUSCOSMETICSDESCRIPTIONS[index]+".dds")
        index += 1
    EndWhile


    string[] resultW = TraitsMenu.Show(aiMaxSelection = 99, aiMinSelection = 0)
    if resultW.Length > 0
        index = 0
    endif
    while index < resultw.Length
        cosmeticSettings[resultW[index] as int] = !cosmeticSettings[resultW[index] as int]
        index += 1
    EndWhile

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

bool Function isSuccable(Actor akActor)
    ActorBase ak = (akActor.GetBaseObject() as ActorBase)
    return  !(ak.IsProtected() || ak.IsEssential()) || (false && MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bKillEssentials:Main")) && !akActor.IsChild()
EndFunction


Function UpdateStatus()
    if iWidgets
        iWidgets.setTransparency(myApple,100)
        iWidgets.doTransitionByTime(myApple, max(SuccubusDesireLevel.GetValue(), SuccubusDesireLevel.GetValue() * -1) as int, 1.0, "meterpercent" ) 
        iWidgets.doTransitionByTime(myApple, 0, seconds = 2.0, targetAttribute = "alpha", easingClass = "none",  easingMethod = "none",  delay = 5.0)
        ;iWidgets.setText(myApple,"" + SuccubusDesireLevel.GetValue())
        setColorsOfBar()
    endif
EndFunction



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

Function EvaluateCompleteScene(bool onStart=false)
    nextAnnouncment = ""
    nextAnnouncmentLineLength = 0
    sslThreadController _thread =  Sexlab.GetPlayerController()
    int index = 0
    int max_rel = -4
    bool max_prot = false
    
    Actor[] ActorsIn = _thread.GetPositions()
    string output = ""
    float energyNew = 0
    while index < ActorsIn.length
        Actor ActorRef = Actorsin[Index]
        energyNew += EvaluateOrgasmEnergy(_thread, ActorRef, 2 * (1 - (onStart as int)))
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
    string output_end = ""
    if !onStart
        output_end =  nextAnnouncment + " ; " + (energyNew as int)
        nextAnnouncment = ""
    endif
    GetAnnouncement().Show(output + output_end , "icon.dds", aiDelay = 5.0)
Endfunction

float Function GetLastTimeSuccd(Actor Target)
    float lastTime = SexlabStatistics.GetLastEncounterTime(Target,PlayerRef)
    if lastTime > 0.0
        return TimeOfDayGlobalProperty.GetValue() - lastTime
    endif
    return -1.0
Endfunction

Function PlayerStart(Form FormRef, int tid)
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
        lastSmoochTimeWithThatPerson = GetLastTimeSuccd(nonPlayer)        
    endif
    if Game.GetModByName("Tullius Eyes.esp") != 255 && (succubusType == 1 || cosmeticSettings[1] ) && !cosmeticSettings[0]
        setHeartEyes(true)
    endif
EndFunction

Function PlayerSceneEnd(Form FormRef, int tid)
    sslThreadController _thread =  Sexlab.GetController(tid)
    Actor[] ActorsIn = Sexlab.GetController(tid).GetPositions() 
    ;updateSuccyNeeds(evaluateSceneEnergy(Sexlab.GetController(tid), none, false), true)
    int index = 0
    while index < ActorsIn.Length
        Actor WhoCums = ActorsIn[index]
        if WhoCums != PlayerRef && deathModeActivated && allowedToSuccToDeath(WhoCums) && _thread.ActorAlias(WhoCums).GetOrgasmCount() > 0
            WhoCums.Kill(PlayerRef)
            updateSuccyNeeds(WhoCums.GetActorValueMax("Health"))
        endif
        index+=1
    EndWhile
    if Sexlab.IsHooked(stageEndHook)
        Sexlab.UnRegisterHook( stageEndHook)
    endif
    if deathModeActivated && SuccubusDesireLevel.GetValue() >= 0
        toggleDeathMode()
    endif
    if Game.GetModByName("Tullius Eyes.esp") != 255
        setHeartEyes(false)
    endif
EndFunction

float Function EvaluateOrgasmEnergy(sslThreadController _thread, Actor WhoCums = none, int announceLogic = 0)
    ; announceLogic -- 0 no announcment -- 1 announce self -- 2 add to next announcement
    float dateCheck = TimeOfDayGlobalProperty.GetValue()
    int index = 0
    float retval = 0
    SUCCUBUSTRAITSDIALOGUE = StringUtil.Split(SUCCUBUSTRAITSDIALOGUESTRING, ";")
    SUCCUBUSTRAITSVALUESBONUS = Utility.CreateIntArray(SUCCUBUSTRAITSDIALOGUE.Length, 5)
    SUCCUBUSTRAITSVALUESBONUS[2] = 10
    SUCCUBUSTRAITSVALUESBONUS[5] =  0
    float lastMet = 1
    float energyLosses = 0
    if WhoCums && WhoCums != PlayerRef
        if !isSuccable(WhoCums)
            if announceLogic == 2
                nextAnnouncment += WhoCums.GetDisplayName() + " can't be drained!"
            elseif announceLogic == 1
                GetAnnouncement().Show(WhoCums.GetDisplayName() + " can't be drained!", "icon.dds", aiDelay = 5.0)
                nextAnnouncment = ""
            endif
            return 0
        endif
        lastMet = GetLastTimeSuccd(WhoCums)
        if lastmet  < 0.0
            lastmet = 1
        endif
        retval += 10 * lastMet * ( 1 / (_thread.ActorAlias(WhoCums).GetOrgasmCount()+1))
    Endif
    if WhoCums != PlayerRef && WhoCums
        while index < SUCCUBUSTRAITSVALUESBONUS.Length
            string[] cur_dial = StringUtil.Split(SUCCUBUSTRAITSDIALOGUE[index],":")
            if chosenTraits[index]
                bool traitYes = false
                if index == 0
                    traitYes = _thread.HasSceneTag("Aircum")
                elseif index == 1
                    traitYes =  !_thread.HasSceneTag("Aircum") && (_thread.HasSceneTag("Oral") || _thread.HasSceneTag("Anal") || _thread.HasSceneTag("Vaginal"))
                elseif index == 2
                    traitYes =  WhoCums.GetHighestRelationshiprank() == 4 && SexlabStatistics.GetTimesMet(WhoCums,PlayerRef) == 0 && _thread.ActorAlias(WhoCums).GetOrgasmCount() <= 1
                elseif index == 3
                    traitYes = (_thread.HasSceneTag("love") || _thread.HasSceneTag("loving"))
                elseif index == 4
                    traitYes = _thread.sameSexThread()
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
                if traitYes
                    float bonus_val = lastMet * SUCCUBUSTRAITSVALUESBONUS[index] * ( 1 / Max(_thread.ActorAlias(WhoCums).GetOrgasmCount(),1) / (_thread.GetPositions().Length - 1) )
                    retval += bonus_val
                endif
                if announceLogic > 0
                    nextAnnouncmentLineLength += StringUtil.GetLength((cur_dial[1 - (traitYes as int)] + " ") as string)
                    if nextAnnouncmentLineLength > 100
                        nextAnnouncment += "\n"
                        nextAnnouncmentLineLength = 0
                    endif
                    nextAnnouncment += cur_dial[1 - (traitYes as int)] + " "
                endif
            endif
            index += 1
        EndWhile
    elseif WhoCums
        string[] dial = StringUtil.SPlit( SUCCUBUSTTYPESDIALOGUESTRING, ";")
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
        float toLoseVal = 10
        bool traitYes = false
        if succubusType == 0
            toLoseVal = 5
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
            nextAnnouncment += StringUtil.Split(dial[succubusType],":")[1 - (traitYes as int)]
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

Function AddToStatistics(int amount_of_hours)
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

Function RefreshEnergy(float adjustBy)
    float lastVal = SuccubusDesireLevel.GetValue()
    if lastVal < 100
        SuccubusDesireLevel.SetValue( min(100, max( -100,  lastVal + adjustBy) ) )
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
        CustomSkills.AdvanceSkill("SuccubusBaseSkill", value * 10)
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
    UpdateStatus()
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

Event TSSD_Main_Bar_Update(string a_eventName, string a_strArg, float a_numArg, form a_sender)
    iWidgets.setTransparency(myApple, 100)
    if a_eventName == "EVM_SliderChanged_TSSD_Main_Bar_Pos_X"
        initial_Bar_Vals[0] = a_numArg
        MCM.SetModSettingInt("TintsOfASuccubusSecretDesires","iBarPosX:Main", (a_numArg + 0.5) as int)
	elseif a_eventName == "EVM_SliderChanged_TSSD_Main_Bar_Pos_Y"
        initial_Bar_Vals[1] = a_numArg
        MCM.SetModSettingInt("TintsOfASuccubusSecretDesires","iBarPosY:Main", (a_numArg + 0.5) as int)
	elseif a_eventName == "EVM_SliderChanged_TSSD_Main_Bar_Size_X"
        initial_Bar_Vals[2] = a_numArg
        MCM.SetModSettingInt("TintsOfASuccubusSecretDesires","iBarScaX:Main", (a_numArg + 0.5) as int)
	elseif a_eventName == "EVM_SliderChanged_TSSD_Main_Bar_Size_Y"
        initial_Bar_Vals[3] = a_numArg
        MCM.SetModSettingInt("TintsOfASuccubusSecretDesires","iBarScaY:Main",  (a_numArg + 0.5) as int)
	elseif a_eventName == "EVM_SliderChanged_TSSD_Main_Bar_Rotation"
        initial_Bar_Vals[4] = a_numArg
        MCM.SetModSettingInt("TintsOfASuccubusSecretDesires","iBarRota:Main", (a_numArg + 0.5) as int)
    endif
    UpdateBarPositions()
EndEvent

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
    updateSuccyNeeds(EvaluateOrgasmEnergy(_thread, ActorRef, 1), true)
    if succubusType == 1 && SuccubusDesireLevel.GetValue() < 100
        RefreshEnergy(100)
    endif
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
    float timeBetween = (TimeOfDayGlobalProperty.GetValue() - last_checked) * 24
    if ((succubusType == 0 && Game.GetPlayer().GetCurrentLocation().HasKeyword(LocTypeInn)) || \
             (succubusType == 1 && Game.GetPlayer().GetCurrentLocation().HasKeyword(LocTypePlayerHouse)) || \
             (succubusType == 2 && Game.GetPlayer().GetCurrentLocation().HasKeyword(LocTypeCity))  || \
            (succubusType == 3 && !Game.GetPlayer().GetCurrentLocation().HasKeyword(LocTypeCity)) )
        if timeBetween * 24 >= 1
            RefreshEnergy(timeBetween)
            AddToStatistics(timeBetween as int)
        endif
        timeBetween = 0
    endif
    last_checked = TimeOfDayGlobalProperty.GetValue()
    updateSuccyNeeds(timeBetween * -24)
endEvent

Event OnMenuOpen(String MenuName)
    if SuccubusDesireLevel.GetValue() <= ravanousNeedLevel
        UI.InvokeString("HUD Menu", "_global.skse.CloseMenu", "Dialogue Menu")
        GetAnnouncement().Show("NO TIME TO TALK!", "icon.dds", aiDelay = 2.0)
    endif
EndEvent

Event OnEVM_OpenBarsClosed(string a_eventName, string a_strArg, float a_numArg, form a_sender)
	int index = 0
    while index < barVals.Length
		unregisterForModEvent("EVM_SliderChanged_" + "TSSD_Main_Bar_"+barVals[index])
        index += 1
    EndWhile
    if a_numArg == 1 
        new_Bar_Vals = DbMiscFunctions.SplitAsFloat(a_strArg)
        initial_Bar_Vals = CopyArray(new_Bar_Vals)
    elseif a_numArg == 0
        initial_Bar_Vals = CopyArray(new_Bar_Vals)  
    Endif
    UpdateBarPositions()
    UpdateStatus()
EndEvent

Event OnInit()
    SUCCTRAITS      = StringUtil.Split(SUCCUBUSTRAITS, ";")
    SUCCTRAITSDESC  = StringUtil.Split(SUCCUBUSTRAITSDESCRIPTIONS, ";")
	filldirections =  StringUtil.Split("left;right;both", ";")
	RegisterForModEvent("iWantWidgetsReset", "OniWantWidgetsReset")
	RegisterForSingleUpdate(_updateTimer)
	barVals = StringUtil.Split("Pos_X;Pos_Y;Size_X;Size_Y;Rotation", ";")
    initial_Bar_Vals = New Float[5]
    initial_Bar_Vals[0] = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iBarPosX:Main") as float
    initial_Bar_Vals[1] = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iBarPosY:Main") as float
    initial_Bar_Vals[2] = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iBarScaX:Main") as float
    initial_Bar_Vals[3] = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iBarScaY:Main") as float
    initial_Bar_Vals[4] = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iBarRota:Main") as float
    new_Bar_Vals = CopyArray(initial_Bar_Vals)
EndEvent