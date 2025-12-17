Scriptname tssd_menus extends Quest  


import b612
import tssd_utils

Actor Property PlayerRef Auto
Quest Property tssd_tints_tracker Auto
tssd_slsfrscript Property slsfListener Auto

SexLabFramework Property SexLab Auto
sslActorStats Property sslStats Auto
tssd_actions Property tActions Auto

Spell[] Property SuccubusAbilitiesSpells Auto
Perk[] Property SuccubusAbilitiesPerks  Auto
Perk[] Property SuccubusTintPerks  Auto
String[] Property SuccubusAbilitiesNames  Auto    

GlobalVariable Property TimeOfDayGlobalProperty Auto
GlobalVariable Property SkillSuccubusDrainLevel Auto
GlobalVariable Property SkillSuccubusSeductionLevel Auto
GlobalVariable Property SkillSuccubusBodyLevel Auto
GlobalVariable Property SkillSuccubusBaseLevel Auto
GlobalVariable Property TSSD_PerkPointsBought Auto
GlobalVariable Property SuccubusDesireLevel Auto
GlobalVariable Property SuccubusXpAmount Auto
GlobalVariable Property TSSD_MaxTraits Auto
GlobalVariable Property TSSD_SuccubusTraits Auto

GlobalVariable Property TSSD_SuccubusBreakRank Auto
GlobalVariable[] Property TSSD_SuccubusTypes Auto

GlobalVariable Property TSSD_TypeScarlet Auto
GlobalVariable Property TSSD_TypeSundown Auto
GlobalVariable Property TSSD_TypeMahogany Auto

Perk Property TSSD_Base_Explanations Auto
Perk Property TSSD_Drain_GentleDrain1 Auto
Perk Property TSSD_Seduction_Kiss1 Auto
Perk Property TSSD_Seduction_OfferSex Auto
Perk Property TSSD_Body_PlayDead1 Auto
Perk Property TSSD_Body_DefeatThem1 Auto
Perk Property TSSD_Base_PolyThrall1 Auto
Perk Property TSSD_Seduction_Kiss2 Auto

Spell Property TSSD_SuccubusDetectJuice Auto
Spell Property TSSD_Satiated Auto

bool lookedAtExplanationsOnce = false
bool modifierKeyIsDown = false

bool [] cosmeticSettings

string currentVersion = "0.03.03"


ImageSpaceModifier Property AzuraFadeToBlack  Auto 
MagicEffect Property TSSD_SuccubusDetectEnergyFF Auto

int lastUsed  = -1
int lastUsedSub = -1
int spellToggle

int colorToAdd

Quest Property tssd_enthrallDialogue Auto
Quest Property tssd_queststart Auto

Faction Property sla_Arousal Auto
Faction Property TSSD_ThrallDominant Auto
Faction Property TSSD_ThrallAggressive Auto


;MENUS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function OpenThrallMenu(Actor targetRef)
    b612_SelectList mySelectList = GetSelectList()
    String[] myItems = StringUtil.Split("Intimacy;Inventory;Release",";")
    int result = mySelectList.Show(myItems)
    if result == 0
        OpenIntmacyMenu(targetRef)
    endif

EndFunction

Function OpenIntmacyMenu(Actor targetRef)
    b612_SelectList mySelectList = GetSelectList()
    String[] myItems = StringUtil.Split("> Thrall passive;> Thrall non-aggressive;Kiss;Vaginal",";")
    if targetRef.GetFactionRank(TSSD_ThrallDominant) == 1
        myItems[0] = "> Thrall Active"
    endif
    if targetRef.GetFactionRank(TSSD_ThrallAggressive) == 1
        myItems[1] = "> Thrall aggressive"
    endif
    int result = mySelectList.Show(myItems)
    if result <= 2 && result > -1
        if result == 0
            targetRef.SetFactionRank(TSSD_ThrallDominant, 1-targetRef.GetFactionRank(TSSD_ThrallDominant))
        else
            targetRef.SetFactionRank(TSSD_ThrallAggressive, 1-targetRef.GetFactionRank(TSSD_ThrallAggressive))
        endif
        OpenIntmacyMenu(targetRef)
    elseif result == 2
        SexLab.StartSceneQuick(PlayerRef, targetRef, asTags="kissing, limitedstrip, -sex")
    elseif result == 3
        string tagsIn = "vaginal"
        if targetRef.GetFactionRank(TSSD_ThrallAggressive) > 0
            tagsIn += ",aggressive"
        endif
        if targetRef.GetFactionRank(TSSD_ThrallDominant) > 0
            SexLab.StartSceneQuick(PlayerRef, targetRef, asTags=tagsIn) 
        else
            SexLab.StartSceneQuick(targetRef, PlayerRef, asTags=tagsIn) 
        endif
    Endif
EndFunction

Function OpenGrandeMenu()
    modifierKeyIsDown = Input.IsKeyPressed( MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iModifierHotkey:Main") )
    if !SafeProcess()
        return
    endif
    if SuccubusDesireLevel.GetValue() <= -101
        int dbgSuccy = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iSkipExplanations:Main")
        SelectSuccubusType(dbgSuccy)
        int EventHandle = ModEvent.Create("SLSF_Reloaded_RegisterMod")
        ModEvent.PushString(EventHandle, "TintsOfASuccubusSecretDesires.esp")
        ModEvent.Send(EventHandle)
        if dbgSuccy < 0
            return
        endif
    endif
    sslThreadController _thread =  Sexlab.GetPlayerController()
    b612_SelectList mySelectList = GetSelectList()
    String[] myItems = StringUtil.Split("Abilities;Upgrades;Settings;Rechoose Type;TraitsLel",";")
    
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
    tActions.NotificationSpam(myItems[result] )
    if myItems[result] == "Abilities"
        OpenSuccubusAbilities()
    elseif myItems[result] == "Upgrades"
        OpenExpansionMenu()    
    elseif myItems[result] == "Settings"
        OpenSuccubusCosmetics()
    elseif myItems[result] == "Rechoose Type"
        SelectSuccubusType()
    elseif myItems[result] == "TraitsLel"
        GetTraitsLel()
    endif
EndFunction 

Function OpenExpansionMenu()
    ;if MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","bSkipExplanations:Main") < 0
        lookedAtExplanationsOnce = true
    ;endif
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
            tActions.NotificationSpam(myItems[result - 1] )
    elseif result == 6
        lookedAtExplanationsOnce = false
        OpenExpansionMenu()
    endif
EndFunction

Function OpenExplanationMenu()        
    String[] SUCCUBUSTATS = StringUtil.Split( "Base Skill;Drain;Seduction;Body;Perk Points",";")
    String[] SUCCUBUSTATSDESCRIPTIONS =  StringUtil.Split("Training for the Base Succubus Skill;Drain increases your drain strength;\
    Seduction increases your [Speechcraft and gives you the ability to hypnotize people];Body [Increases your Combat Prowess];\
    Perk Points give you perkpoint for the Trees in this mod.",";")
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

Function GainFreePerk()
    b612_TraitsMenu TraitsMenu = GetTraitsMenu()
    int index = 0
    string[] succTraits = GetSuccubusStartPerksAll()
    while index < succTraits.Length
        string succDesc =  JDB.solveStr(".tssdperks." + succTraits[index] + ".Desc")
        string succName =   JDB.solveStr(".tssdperks." + succTraits[index] + ".Name")
        TraitsMenu.AddItem( "Free Perk: " + succName, succDesc, "");"menus/tssd/"+succTraits[index]+".dds")
        index += 1
    EndWhile
    String[] resultW = TraitsMenu.Show(aiMaxSelection = 1, aiMinSelection = 1)
    if resultW.Length > 0
        int PerkID =  JDB.solveInt(".tssdperks." + succTraits[resultW[0] as int] + ".id")
        PlayerRef.AddPerk(Game.GetFormFromFile(PerkID, "TintsOfASuccubusSecretDesires.esp") as Perk)
    endif
EndFunction

Function SelectSuccubusType(int query = -1)
    int index = 0
    if query < 0
        b612_TraitsMenu TraitsMenu = GetTraitsMenu()
        string[] succKinds = JArray.asStringArray(JDB.solveObj(".tssdoverviews.SuccubusKinds"))
        while index < succKinds.Length
            TraitsMenu.AddItem( succKinds[index], JDB.solveStr(".tssdkinds." + succKinds[index] + ".description"),\
             "menus/tssd/"+succKinds[index]+".dds")
            index += 1
        EndWhile

        String[] resultw = TraitsMenu.Show(aiMaxSelection = 3, aiMinSelection = 0)
        index = 0
        TSSD_SuccubusTypes[0].SetValue(0.0)
        TSSD_SuccubusTypes[1].SetValue(0.0)
        TSSD_SuccubusTypes[2].SetValue(0.0)
        PlayerRef.RemovePerk(TSSD_Base_PolyThrall1)
        while index < resultW.Length
            TSSD_SuccubusTypes[resultW[index] as int].SetValue(1.0)
            index += 1
            query = 1
        endwhile
        if TSSD_TypeScarlet.GetValue() == 1
            PlayerRef.Addperk(TSSD_Base_PolyThrall1)
            tssd_queststart.SetStage(1)
        endif
    endif
    if query >= 0 && SuccubusDesireLevel.GetValue() == -101
        SuccubusDesireLevel.SetValue(50)
        TSSD_SuccubusBreakRank.SetValue(0)
        tActions.RefreshEnergy(0)
        int startLevel = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iSuccubusLevel:Main")
        if startLevel > 0
            SuccubusXpAmount.SetValue( startLevel * 10000 )
            PlayerRef.AddPerk(TSSD_Drain_GentleDrain1)
            PlayerRef.AddPerk(TSSD_Seduction_Kiss1)
            PlayerRef.AddPerk(TSSD_Body_PlayDead1)
        endif
        tssd_enthrallDialogue.Start()
        PlayerRef.AddPerk(TSSD_Base_Explanations)
        tActions.RegisterSuccubusEvents()
        GainFreePerk()
        TSSD_Satiated.Cast(PlayerRef,PlayerRef)
    endif
    slsfListener.CheckFlagsSLSF()
    ;if succubusType == 2
        ;DBGTrace(slavetats.simple_add_tattoo(PlayerRef, "Bofs Bimbo Tats Butt", "Butt (Lower) - Sex Doll"))        
    ;Endif
EndFunction

Function OpenSuccubusCosmetics()
    int jArr = JDB.solveObj(".tssdsettings")
    b612_TraitsMenu TraitsMenu = GetTraitsMenu()
    int index = 0
    cosmeticSettings = ReadInCosmeticSetting()
    while index < JValue.count(jArr)        
        string[] textArr = jArray.asStringArray(jArray.getObj(jArr,index))
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
Endfunction


bool Function checkAbilityDefeatThem(Actor tarRef)
    if tarRef == playerRef
        tarRef = Game.GetCurrentCrosshairRef() as Actor
        tactions.cell_ac[0] = tarRef
    endif
    if !tarRef.isHostileToActor(playerRef) && tActions.isSuccableOverload(tarRef) > -1
        return true
    endif
    if (playerRef.HasPerk(TSSD_Body_DefeatThem1))
        if (!playerRef.HasPerk(TSSD_Body_DefeatThem1.GetNextPerk().GetNextPerk().GetNextPerk())) && PlayerRef.GetLevel() <= tarRef.GetLevel() 
                return false
        endif
        int max_targets = 1 + playerRef.HasPerk(TSSD_Body_DefeatThem1.GetNextPerk().GetNextPerk().GetNextPerk().GetNextPerk()) as int +\
                              playerRef.HasPerk(TSSD_Body_DefeatThem1.GetNextPerk().GetNextPerk().GetNextPerk()) as int
        if (tActions.numHostileActors <= max_targets) && \
        max_targets > 1 || (tarRef.GetActorValue("Health") < PlayerRef.GetActorValue("Health")) || \
        playerRef.HasPerk(TSSD_Body_DefeatThem1.GetNextPerk().GetNextPerk()) 
            return true
        endif
    endif
    return false
Endfunction


Function OpenSuccubusAbilities()
    String itemsAsString = "Allow draining"
    Actor tarRef = PlayerRef
    if tactions.deathModeActivated
        itemsAsString = "Hold back draining"
    endif
    Actor Cross
    if Game.GetCurrentCrosshairRef() as Actor
        Cross = Game.GetCurrentCrosshairRef() as Actor
    endif
    tarRef = tActions.searchForTargets()
    if PlayerRef.HasPerk(TSSD_Body_PlayDead1) && !PlayerRef.IsInCombat()
            if tarRef && tarRef != PlayerRef
                itemsAsString += ";Act defeated"
            else
                itemsAsString += ";Act defeated (no Target found)"
        endif
    endif

    itemsAsString += ";Look for Prey;Cum now!"
    int indexOfA = 1
    if (PlayerRef.HasPerk(TSSD_Seduction_Kiss2) || true) && Sexlab.GetPlayerController()
        itemsAsString += ";Steal"
    endif
    while indexOfA < SuccubusAbilitiesNames.length
        if PlayerRef.HasPerk(SuccubusAbilitiesPerks[indexOfA]) && spellToggle < 2
                itemsAsString += ";" + SuccubusAbilitiesNames[indexOfA]
        endif
        indexOfA += 1
    endwhile
    if checkAbilityDefeatThem(tarRef)
        itemsAsString += ";Rape them!"
    endif
    
    String[] myItems = StringUtil.Split(itemsAsString,";")
    Int result = -1
    if modifierKeyIsDown
        if lastUsedSub >= 0
            result = lastUsedSub
        else
            result = GetSelectList().Show(myItems)
            lastUsedSub = result
            if result == -1
                return
            endif
        endif
    endif
    if result == -1
        result = GetSelectList().Show(myItems)
        if result == -1
            return
        endif
    endif
    tActions.NotificationSpam(myItems[result] )
    if myItems[result] == "Hold back draining" || myItems[result] == "Allow draining"
        tActions.toggleDeathMode(true)
    elseif myItems[result] == "Look for Prey"
        int radius = tActions.getScanRange()
        Actor[] allAround = MiscUtil.ScanCellNPCs(PlayerRef, radius * 50)
        TSSD_SuccubusDetectJuice.SetNthEffectArea(0, radius )
        int oldDur = TSSD_SuccubusDetectJuice.GetNthEffectDuration(0)
        TSSD_SuccubusDetectJuice.SetNthEffectDuration(0, 5)
        TSSD_SuccubusDetectJuice.Cast(PlayerRef, PlayerRef)
        TSSD_SuccubusDetectJuice.SetNthEffectDuration(0, oldDur)
    elseif myItems[result] == "Ask for Sex" && Cross
            Sexlab.StartSceneQuick(akActor1 = PlayerRef, akActor2 = Cross)
    elseif myItems[result] == "Act defeated"
        tActions.actDefeated(tarRef, true)
    elseif myItems[result] == "Rape them!"
        if !tactions.deathModeActivated
            tactions.toggleDeathMode(true)
        endif
        if !Sexlab.StartSceneA(akPositions = PapyrusUtil.PushActor(tactions.cell_ac, PlayerRef), asTags = "", akSubmissives = tactions.cell_ac)
            if !Sexlab.StartScene(akPositions = PapyrusUtil.PushActor(tactions.cell_ac, PlayerRef), asTags = "")
                int tarIndex = 0
                while tarIndex < tactions.cell_ac.Length
                    Actor curT = tactions.cell_ac[tarIndex]
                    if curT && !curT.isDead()
                            tactions.gainSuccubusXP(  min(curT.GetAV("Health"), 100 + tactions.getDrainLevel() )  )
                            tactions.TSSD_DrainHealth.SetNthEffectMagnitude(0, 100 + tactions.getDrainLevel() )
                            tactions.TSSD_DrainHealth.Cast(PlayerRef, curT)
                    endif
                    tarIndex += 1
                EndWhile
            endif
        endif
    elseif myItems[result] == "Cum Now!"
        Game.ShakeCamera(none, 0.1, 0.1 + 1.0)
        Sexlab.GetPlayerController().ActorAlias(PlayerRef)
		int eid = ModEvent.Create("SexLabOrgasm")
		ModEvent.PushForm(eid, PlayerRef)
		ModEvent.PushInt(eid, 100)
		ModEvent.PushInt(eid, 1)
		ModEvent.Send(eid)
		Int handle = ModEvent.Create("SexlabOrgasmSeparate")
		ModEvent.PushForm(handle, PlayerRef)
		ModEvent.PushInt(handle, 0)
		ModEvent.Send(handle)
    elseif myItems[result] == "Steal"
        sslThreadController _thread = Sexlab.GetPlayerController()
        Actor toSteal = _thread.GetPositions()[0]
        if toSteal == PlayerRef
            toSteal = _thread.GetPositions()[1]
        endif
        toSteal.ShowGiftMenu(false, none, true, false) 



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
                    tActions.RefreshEnergy(-20)
                else
                    PlayerRef.DispelSpell(SuccubusAbilitiesSpells[indexOfA])
                endif
                indexOfA += 1
            endwhile
        endif
    endif
EndFunction


Event OnUpdateGameTime()
    UnregisterForUpdateGameTime()
    ShowSuccubusTrait(colorToAdd)
EndEvent


Function ShowSuccubusTrait(int num)

    if PlayerRef.IsInCombat()
        colorToAdd = num
        RegisterForSingleUpdateGameTime(0.1)
        return
    endif


    
    b612_TraitsMenu TraitsMenu = GetTraitsMenu()
    string[] succKinds = JArray.asStringArray(JDB.solveObj(".tssdoverviews.SuccubusTraits"))
    
    TraitsMenu.AddItem("Embrace: " + succKinds[num], JDB.solveStr(".tssdtraits." + succKinds[num] + ".description"),\
            "menus/tssd/"+succKinds[num]+".dds")
    String ResText = "Resist: "
    if num == 9
        ResText = "OHYESIWANTTHISTHISISWHOIAM : "
    endif
    int indexIN = 0
    while indexIN < succKinds.Length
        DBGTRACE(indexIN +" " +succKinds[indexIN])
        indexIN += 1
    endwhile

    TraitsMenu.AddItem(ResText + succKinds[num], JDB.solveStr(".tssdtraits." + succKinds[num] + ".description"),\
            "menus/tssd/"+succKinds[num]+".dds")
    String[] resultW = TraitsMenu.Show()
    tssd_tints_tracker.SetObjectiveDisplayed(num, true)
    if resultW[0] == "0"
        PlayerRef.AddPerk(SuccubusTintPerks[num])
		tssd_tints_tracker.SetObjectiveCompleted(num, true)
        tssd_tints_tracker.SetObjectiveFailed(num, false)
    else
        tssd_tints_tracker.SetObjectiveFailed(num, true)
    endif

            
EndFunction

Function GetTraitsLel()
    b612_QuantitySlider qS = GetQuantitySlider()
    int outInt = qS.Show("Num", 0,  JArray.asStringArray(JDB.solveObj(".tssdoverviews.SuccubusTraits")).Length -1)
    ShowSuccubusTrait(outInt)
EndFunction
