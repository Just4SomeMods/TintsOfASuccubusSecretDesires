Scriptname tssd_SuccubusBrands extends Quest  Conditional

import tssd_utils

FavorDialogueScript Property DialogueFavorGeneric  Auto  
GlobalVariable Property SkillSuccubusBaseLevel Auto
GlobalVariable Property SkillSuccubusBodyLevel Auto
GlobalVariable Property TSSD_SuccubusPerkPoints Auto
GlobalVariable Property TSSD_BrandQuestActive Auto
SexLabFramework Property SexLab Auto
Actor Property PlayerRef Auto

bool Property taskNeglected = false Auto Conditional hidden

Idle Property pa_hugA Auto
Idle Property IdleChildCryingStart Auto
Idle Property IdleChildCryingEnd Auto
Package Property DoNothing Auto

bool Property isSLSFInstalled Auto Conditional Hidden
float lastTimeActive = -1.0
float timeInSafeLocation
float lastCheckAt = -1.0
int dailyGrind = -1
int Property currentTat Auto Conditional Hidden
float Property hasToBeDoneBy = 99999.0  Auto Conditional Hidden


int Property amountOfBrands = 0  Auto Conditional Hidden
int Property brandTat = 0  Auto Hidden

faction Property sla_arousal Auto

Perk Property TSSD_AddictingBrand_Vibrancy Auto
Perk Property TSSD_AddictingBrand_CumChained Auto
Perk Property TSSD_AddictingBrand_Sway Auto
Perk Property TSSD_AddictingBrand_Task Auto

tssd_Actions Property tActions Auto
tssd_tints_variables Property tVals Auto

bool didStartUpAlready = false

Function activateStuff()
    if !didStartUpAlready
        lastTimeActive = Utility.GetCurrentGameTime() * 24
        dailyGrind = (Utility.GetCurrentGameTime() as int)
        TSSD_SuccubusPerkPoints.Mod(1)
        lastCheckAt = lastTimeActive

        int template = JMap.object()
        int matches = JArray.object()
        int tattoo = 0

        JMap.setStr(template, "section", "tssd_tats")
        JMap.setStr(template, "name", "Task")

        slavetats.query_available_tattoos(template, matches)
        
        tattoo = JArray.getObj(matches, 0)
        JMap.setInt(tattoo, "color", 16711680)
        JMap.setFlt(tattoo, "invertedAlpha", 0.0)
        JMap.setInt(tattoo, "locked", 1)
        
        slavetats.query_applied_tattoos(PlayerRef, template, matches)
        
        brandTat = slavetats.add_and_get_tattoo(PlayerRef, tattoo, -1, false, true)
        JValue.addToPool(brandTat, "tssd_tats")
        JMap.setInt(brandTat, "glow", 0)
        slavetats.synchronize_tattoos(PlayerRef, false)
        didStartUpAlready = true
        if tActions.tMenus.slsfListener.visManager
            tActions.tMenus.slsfListener.visManager.BodyTattooExcluded[JMap.GetInt(brandTat, "slot")] = true
    EndIf
    endif
    RegisterForUpdateGameTime(1)
    RegisterForMenu("Sleep/Wait Menu")
    RegisterForMenu("Dialogue Menu")
EndFunction

Event OnMenuOpen(string MenuName)
    if MenuName == "Sleep/Wait Menu" && PlayerRef.HasPerk(TSSD_AddictingBrand_CumChained) && tVals.cupidFilledUpAmount <= 0
        UI.InvokeString("HUD Menu", "_global.skse.CloseMenu", "Sleep/Wait Menu")
        T_Show("I can't rest without cum in me!", "icon.dds", aiDelay = 2.0)
    endif
EndEvent

Event OnMenuClose(string MenuName)

    if MenuName == "Dialogue Menu" && TSSD_BrandQuestActive.GetValue() >= 0
        Actor tAct = Game.GetCurrentCrossHairRef() as Actor
        float getRandom = Utility.RandomFloat() * 100 + 50
        if tAct  && PlayerRef.HasPerk(TSSD_AddictingBrand_Sway) && getRandom < tAct.GetFactionRank(sla_arousal)
            doPetting(tAct)
        endif
    endif
EndEvent

Event OnUpdateGameTime()
    bool hasVibrancy = PlayerRef.HasPerk(TSSD_AddictingBrand_Vibrancy)
    amountOfBrands =  ( (PlayerRef.HasPerk(TSSD_AddictingBrand_Task) as int) +  (hasVibrancy as int)+(PlayerRef.HasPerk(TSSD_AddictingBrand_CumChained) as int)+(PlayerRef.HasPerk(TSSD_AddictingBrand_Sway) as int))
    if hasVibrancy
        PlayerRef.SendModEvent("TSSD_Inflate", "body", (PlayerRef.GetFactionRank(sla_arousal) + SkillSuccubusBodyLevel.GetValue() - 15) / 200)
        float gT = Utility.RandomFloat() * 100
        if gT < PlayerRef.GetFactionRank(sla_arousal)
            increaseFame("Slut", 0.5)
        endif
    EndIf
    
    float timeBetween = Utility.GetCurrentGameTime() * 24 - lastCheckAt
    lastTimeActive += timeBetween
    if tActions.PlayerInSafeHaven()
        while timeBetween > 1
            timeInSafeLocation += 1
            if lastTimeActive > 24 && Utility.RandomFloat() < (timeInSafeLocation / 24) && TSSD_BrandQuestActive.GetValue() == -1
                JMap.setInt(brandTat, "glow", 16777215)
                slavetats.mark_actor(PlayerRef)
                slavetats.synchronize_tattoos(PlayerRef, false)
                lastTimeActive = 0
                timeInSafeLocation = 0
                hasToBeDoneBy = Utility.GetCurrentGameTime() + 1
                setTaskActive(-1)
            EndIf
            timeBetween -= 1
        EndWhile
        timeInSafeLocation -= timeBetween
    Else
        timeInSafeLocation = 0
    EndIf
    lastCheckAt = Utility.GetCurrentGameTime() * 24
    int nwGrind = Utility.GetCurrentGameTime() as Int
    if dailyGrind < nwGrind
        swapTat()
        dailyGrind = nwGrind
    EndIf
EndEvent

Function swapTat()
    Return
    String[] allBrands = StringUtil.Split("Task;CumDiction;Gaze;Sway", ";")
    int indexIn = 0
    int randomToday = 0
    ;/while indexIn < allBrands.Length
        slavetats.simple_remove_tattoo(PlayerRef, "tssd_tats", allBrands[indexIn], last = false, silent = true)
        if randomToday == 0
            if indexIn == 1 && PlayerRef.HasPerk(TSSD_AddictingBrand_CumChained) && Utility.RandomFloat() > 0.8
                randomToday = 1
            ElseIf indexIn == 2 && PlayerRef.HasPerk(TSSD_AddictingBrand_Vibrancy) && Utility.RandomFloat() > 0.8
                randomToday = 2
            ElseIf indexIn == 3 && PlayerRef.HasPerk(TSSD_AddictingBrand_Sway) && Utility.RandomFloat() > 0.8
                randomToday = 3
            EndIf
        EndIf
        indexIn +=1
    EndWhile/;
    slavetats.simple_add_tattoo(PlayerRef, "tssd_tats", allBrands[randomToday], last = true, silent = false, color = 0 )
    currentTat = randomToday
    
EndFunction

Function setTaskActive(int setTo = -1)
    int[] lengsOf = JArray.asIntArray(JDB.solveObj(".tssdoverviews.TasksLengths"))
    float cBaseRank = SkillSuccubusBaseLevel.GetValue()
    int maxThing = (cBaseRank / 25) as int + 1
    int multiPlier = Math.Pow(maxThing, 2) as int - 1
    float randomRoll = Utility.RandomFloat() * (multiPlier as float)
    int baseThing = 0
    if randomRoll <= 1
        baseThing = 0
    ElseIf randomRoll <= 3
        baseThing = 1
    ElseIf randomRoll <= 7
        baseThing = 2
    Else
        baseThing = 3
    EndIf
    if setTo < 1
        setTo = Utility.RandomInt(baseThing * 100 + 1, baseThing * 100 +  lengsOf[baseThing] - 1 )
    EndIf
    SetStage(1)
    TSSD_BrandQuestActive.SetValue(setTo)
    SetObjectiveCompleted(setTo, false)
    SetObjectiveDisplayed(setTo, true)
    
EndFunction

Function doPetting(Actor akTarget)
    bool[] unstrips = new bool[33]
    unstrips[7] = true
    Form[] equips = Sexlab.StripSlots(PlayerRef, unstrips, false)
    bool[] unstripsShields = new bool[33]
    unstripsShields[9] = true
    unstripsShields[32] = true
    Sexlab.StripSlots(akTarget, unstripsShields, false)
    int randI = Utility.RandomInt(2,4)
    playAnimationWithIdle(akTarget, "5a3fB_StandA_A1_S" + randI, "5a3fB_StandA_A2_S" + randI )
    
    ; playAnimationWithIdle(akTarget, "5a3fB_Beh2_A1_S1", "5a3fB_Beh2_A2_S1" )
    Sexlab.UnstripActor(PlayerRef,equips)
EndFunction

Form[] Function doSpankStrip(Actor akTarget)
    bool[] unstrips = new bool[33]
    unstrips[2] = true
    unstrips[7] = true
    unstrips[23] = true
    unstrips[19] = true
    unstrips[22] = true
    unstrips[26] = true
    Form[] equips = Sexlab.StripSlots(PlayerRef, unstrips, true)
    bool[] unstripsShields = new bool[33]
    unstripsShields[9] = true
    unstripsShields[32] = true
    Sexlab.StripSlots(akTarget, unstripsShields, false)
    return equips
EndFunction

Function TasksTold(string taskTold, Actor talkerLel)
    talkerLel.MoveTo(talkerLel)
    int cTask = StringUtil.Split(taskTold, "_")[2] as int
    if cTask == 1
        increaseFame("Nasty")
    ElseIf cTask == 2
        DialogueFavorGeneric.Brawl(talkerLel)
        Utility.Wait(10)
        increaseFame("Masochist")
    ElseIf cTask == 3
        increaseFame("Whore")
    Elseif cTask == 4
        increaseFame("Slut")
    Elseif cTask == 5
        increaseFame("Airhead")
        playAnimationWithIdle(none, "5a3fB_LayProne_A1_S1", "", 3)
    Elseif cTask == 6
        increaseFame("Airhead")
        playAnimationWithIdle(talkerLel, "5a3fB_SHeadpats1_A1_S1", "5a3fB_SHeadpats1_A2_S1")
    Elseif cTask == 7
        PlayerRef.PlayIdle(IdleChildCryingStart)
        increaseFame("Submissive")
        Utility.Wait(1)
        PlayerRef.PlayIdle(IdleChildCryingEnd)
    Elseif cTask == 8
        increaseFame("Slut")
    Elseif cTask == 9
        increaseFame("Submissive")
        playAnimationWithIdle(talkerLel, "5a3fB_LayBJDog_A1_S1", "", 3)
    Elseif cTask == 101
        increaseFame("Exhibitionist",2)
        Form[] equips = doSpankStrip(talkerLel)
        Utility.Wait(0.5)        
        Sexlab.UnstripActor(PlayerRef,equips)
    ElseIf cTask == 102
        DialogueFavorGeneric.Brawl(talkerLel)
        
        playAnimationWithIdle(none, "5a3fB_SpankStand_A1_S5", "", 15)
        Utility.Wait(15)
        increaseFame("Masochist", 2)
        
    Elseif cTask == 103
        increaseFame("Nasty")
        increaseFame("Submissive")
    Elseif cTask == 104
        increaseFame("Slut")
        increaseFame("Submissive")
    Elseif cTask == 105
        increaseFame("Slut")
        increaseFame("Airhead")
        Game.DisablePlayerControls(true, false, false, false, false, false, false)
        Utility.SetIniBool("bDisablePlayerCollision:Havok", True)        
        ActorUtil.AddPackageOverride(talkerLel as Actor, DoNothing  , 1)
        (talkerLel as Actor).EvaluatePackage()
        talkerLel.SetAnimationVariableInt("IsNPC", 1) ; disable head tracking
        talkerLel.SetAnimationVariableBool("bHumanoidFootIKDisable", True) ; disable inverse kinematics
        talkerLel.MoveTo(playerref)
        talkerLel.SetDontMove()
        PlayerRef.PlayIdleWithTarget( pa_hugA ,talkerLel)
        Utility.Wait(2)
        Utility.SetIniBool("bDisablePlayerCollision:Havok",false)
        Game.EnablePlayerControls()
        ActorUtil.RemovePackageOverride(talkerLel, DoNothing)
        talkerLel.EvaluatePackage()
        talkerLel.SetAnimationVariableInt("IsNPC", 1) ; enable head tracking
        talkerLel.SetAnimationVariableBool("bHumanoidFootIKDisable", False) ; enable inverse kinematics
        debug.sendanimationevent(PlayerRef, "idleforcedefaultstate")
        DbSkseFunctions.ToggleCollision(talkerLel)
        talkerLel.SetDontMove(false)
    Elseif cTask == 106
        increaseFame("Submissive")
        increaseFame("Airhead")
    Elseif cTask == 107
        increaseFame("Submissive", 2)
        playAnimationWithIdle(talkerLel, "5a3fB_StandFace_A1_S1", "5a3fB_StandFace_A2_S1", 1.0)
    Elseif cTask == 108
        increaseFame("Airhead",2)
        playAnimationWithIdle(talkerLel, "5a3fB_CGLay_A1_S1", "5a3fB_CGLay_A2_S1", 1.0)
    Elseif cTask == 109
        increaseFame("Slut", 2)
            Form[] plShoes = tActions.stripShoes(PlayerRef)
            Form[] tShoes = tActions.stripShoes(talkerLel)
            playAnimationWithIdle(talkerLel, "5a3fB_SKiss1_A1_S4", "5a3fB_SKiss1_A2_S4", 3)
            Sexlab.UnstripActor(PlayerRef,plShoes)
            Sexlab.UnstripActor(talkerLel,tShoes)
    Elseif cTask == 110
        increaseFame("Gentle", 2)
    Elseif cTask == 111
        increaseFame("Nasty", 2)
    Elseif cTask == 201
        Sexlab.StripActor(PlayerRef, none, true)
        increaseFame("Exhibitionist", 3)
    Elseif cTask == 202
        Sexlab.AddCumFx(PlayerRef, 2)
        increaseFame("Nasty", 3)
    Elseif cTask == 203
        increaseFame("Submissive", 3)
    Elseif cTask == 204

        bool[] unstrips = new bool[33]
        unstrips[7] = true
        Form[] equips = Sexlab.StripSlots(PlayerRef, unstrips, true)
        bool[] unstripsShields = new bool[33]
        unstripsShields[9] = true
        unstripsShields[32] = true
        Utility.Wait(0.5)
        Sexlab.UnstripActor(PlayerRef,equips)
        increaseFame("Airhead", 3)
    Elseif cTask == 205
        increaseFame("Dominant", 2)
        increaseFame("Slut", 1)
    Elseif cTask == 206
        increaseFame("Nasty", 2)
        increaseFame("Slut", 1)
    Elseif cTask == 207
        Form[] equips = Sexlab.StripActor(PlayerRef, none, true)
        increaseFame("Nasty", 2)
        increaseFame("Slut", 1)
        DialogueFavorGeneric.Brawl(talkerLel)
        Utility.Wait(15)
        PlayerRef.SetRestrained(false)
        Sexlab.UnstripActor(PlayerRef,equips)
    ElseIf cTask == 208
        increaseFame("Masochist", 2)

        Form[] equips = doSpankStrip(talkerLel)
        int randI = Utility.RandomInt(2,4)
        playAnimationWithIdle(talkerLel, "5a3fB_SpankStand_A1_S" + randI, "5a3fB_SpankStand_A2_S" + randI)
        Sexlab.UnstripActor(PlayerRef,equips)
    Elseif cTask == 301
        increaseFame("Exhibitionist", 3)
        increaseFame("Nasty", 1)

        bool[] unstrips = new bool[33]
        unstrips[2] = true
        unstrips[16] = true
        Form[] equips = Sexlab.StripSlots(PlayerRef, unstrips, false)
        bool[] unstripsShields = new bool[33]
        unstripsShields[9] = true
        unstripsShields[32] = true
        Utility.Wait(1.5)
        Sexlab.UnstripActor(PlayerRef,equips)
        playAnimationWithIdle(talkerLel, "5a3fB_Beh2_A1_S1", "5a3fB_Beh2_A2_S1" )
    Elseif cTask == 302
        increaseFame("Airhead", 2)
        increaseFame("Exhibitionist", 2)
        bool[] unstrips = new bool[33]
        unstrips[0] = true
        unstrips[7] = true
        unstrips[23] = true
        unstrips[19] = true
        unstrips[22] = true
        unstrips[26] = true
        Form[] equips = Sexlab.StripSlots(PlayerRef, unstrips, false)
        bool[] unstripsShields = new bool[33]
        unstripsShields[9] = true
        unstripsShields[32] = true
        Utility.Wait(1.5)
        Sexlab.UnstripActor(PlayerRef,equips)
    Elseif cTask == 303
        increaseFame("Exhibitionist", 4)
        Sexlab.StartSceneQuick(PlayerRef)
    Elseif cTask == 304
        increaseFame("Nasty", 2)
        increaseFame("Submissive", 2)
        Sexlab.StartSceneQuick(PlayerRef, talkerLel)
    Elseif cTask == 305
        increaseFame("Submissive", 4)
    Elseif cTask == 306
        increaseFame("Nasty", 4)
        Sexlab.AddCumFxLayers(PlayerRef, 2, 4)
    Elseif cTask == 307
        increaseFame("Masochist", 4)
        DialogueFavorGeneric.Brawl(talkerLel)
        Utility.Wait(15)
        Sexlab.StartSceneQuick(PlayerRef, talkerLel)
    Elseif cTask == 308
        increaseFame("Nasty", 2)
        increaseFame("Masochist", 2)        
        Form[] equips = doSpankStrip(talkerLel)
        int randI = Utility.RandomInt(2,4)
        playAnimationWithIdle(talkerLel, "5a3fB_SpankDog_A1_S" + randI, "5a3fB_SpankDog_A2_S" + randI)
        Sexlab.UnstripActor(PlayerRef,equips)
    endif
    SetObjectiveCompleted(cTask, true)
    SetObjectiveDisplayed(cTask, false)
    TSSD_BrandQuestActive.SetValue(-1)

    taskNeglected = false
    Game.EnablePlayerControls()
    hasToBeDoneBy = 9000000
    JMap.setInt(brandTat, "glow", 0)
    slavetats.mark_actor(PlayerRef)
    slavetats.synchronize_tattoos(PlayerRef, false)
EndFunction