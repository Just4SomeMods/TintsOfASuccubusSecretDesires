Scriptname tssd_menus extends Quest  


import b612
import tssd_utils

Actor Property PlayerRef Auto
Quest Property tssd_tints_tracker Auto
tssd_slsfrscript Property slsfListener Auto

SexLabFramework Property SexLab Auto
; sslActorStats Property sslStats Auto
tssd_actions Property tActions Auto
tssd_PlayerEventsScript Property tEvents Auto

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
GlobalVariable Property TSSD_SuccubusPerkPoints Auto
GlobalVariable Property SuccubusDesireLevel Auto
GlobalVariable Property SuccubusXpAmount Auto

tssd_tints_variables Property tVals Auto

Quest Property tssd_dealwithcurseQuest Auto

Perk Property TSSD_Base_Explanations Auto
;Perk Property TSSD_Drain_GentleDrain1 Auto
;Perk Property TSSD_Seduction_Kiss1 Auto
;Perk Property TSSD_Seduction_OfferSex Auto
Perk Property TSSD_Body_PlayDead1 Auto
Perk Property TSSD_Body_DefeatThem1 Auto
Perk Property TSSD_Seduction_Kiss2 Auto

Spell Property TSSD_SuccubusDetectJuice Auto
Spell Property TSSD_Satiated Auto

FormList Property TSSD_ShrinesWithQuests Auto

bool lookedAtExplanationsOnce = false
bool modifierKeyIsDown = false

bool [] cosmeticSettings

string currentVersion = "1.01.001"


; ImageSpaceModifier Property AzuraFadeToBlack  Auto 
; MagicEffect Property TSSD_SuccubusDetectEnergyFF Auto

int lastUsed  = -1
int lastUsedSub = -1
int spellToggle

int colorToAdd = -1

Quest Property tssd_enthrallDialogue Auto
Quest Property tssd_queststart Auto

; Faction Property sla_Arousal Auto
; Faction Property TSSD_ThrallDominant Auto
; Faction Property CrimeFactionWhiterun Auto


;MENUS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


bool Function toggleQuestCurses(String deityName)
    if SuccubusDesireLevel.GetValue() > -101
        if !tssd_dealwithcurseQuest.IsRunning()
            tssd_dealwithcurseQuest.Start()
            ;tssd_dealwithcurseQuest.setstage(10)
            tssd_dealwithcurseQuest.setstage(20)
            return true
        else
            int objectiveSub = 0
            if deityName == "Akatosh"
                objectiveSub = 28
            elseif deityName == "Mara"
                objectiveSub = 21
            elseif deityName == "Kynareth"
                return true
            elseif deityName == "Julianos"
                objectiveSub = 27
            elseif deityName == "Dibella"
                objectiveSub = 24
            endif
            if objectiveSub > 0   
                tssd_dealwithcurseQuest.SetObjectiveFailed(objectiveSub, !tssd_dealwithcurseQuest.isobjectivefailed(objectiveSub))
                tssd_dealwithcurseQuest.SetObjectiveDisplayed(objectiveSub)
                (tssd_dealwithcurseQuest as tssd_curequestvariables).toggleCurse(deityName)
                return true
            endif
        endif

    endif
    return false
endfunction



Function OpenGrandeMenu()
    modifierKeyIsDown = Input.IsKeyPressed( MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iModifierHotkey:Main") )
    if !SafeProcess()
        return
    endif
    if SuccubusDesireLevel.GetValue() <= -101
        int dbgSuccy = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iSkipExplanations:Main")
        ;SelectSuccubusType(dbgSuccy)
        startSuccubusLife() 
        ;ShowSuccubusTrait(19)
        CustomSkills.OpenCustomSkillMenu("SuccubusBaseSkill")


        return
    endif
    ObjectReference ref = Game.GetCurrentCrosshairRef()
    if !Sexlab.IsActorActive(PlayerRef) && tEvents.isLilac && (ref as Actor) && tActions.isDoggie(ref as Actor) && !(ref as Actor).HasMagicEffect(tActions.TSSD_DrainedDownSide)
        tActions.tDialogue.lilacBeg(ref as Actor)
        SkyInteract myBinding = SkyInteract_Util.GetSkyInteract()
        myBinding.remove("tssd_getTargetCross")
        return
    elseif TSSD_ShrinesWithQuests.HasForm(ref.GetBaseObject())
        DBGTrace(DbSkseFunctions.GetFormEditorId(ref.GetBaseObject(), "none"))
        String deityName = StringUtil.Substring(DbSkseFunctions.GetFormEditorId(ref.GetBaseObject(), "none"), 8)
        if toggleQuestCurses(deityName)
            return
        endif
    endif
    sslThreadController _thread =  Sexlab.GetPlayerController()
    b612_SelectList mySelectList = GetSelectList()
    string toSplit = "Abilities;Upgrades;Settings"
    if MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bDebugCheats:Main")
        toSplit += ";TraitsLel"
    endif
    String[] myItems = StringUtil.Split(toSplit,";")
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
    elseif myItems[result] == "TraitsLel"
        GetTraitsLel()
    endif
EndFunction 

Function OpenExpansionMenu()
    ;if MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","bSkipExplanations:Main") < 0
        lookedAtExplanationsOnce = true
    ;endif
    b612_SelectList mySelectList = GetSelectList()
    String[] myItems = StringUtil.Split("Perk Trees;Body;Drain;Seduction",";")
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
    elseif result > -1
        OpenSkillTrainingsMenu(result)
    endif
EndFunction

Function OpenSkillTrainingsMenu(int index_of)
    String[] myItems = StringUtil.Split("Base;Drain;Seduction;Body;Perk Points",";")    
    GlobalVariable[] skillLevels = new GlobalVariable[5]
    skillLevels[0] = SkillSuccubusBodyLevel
    skillLevels[1] = SkillSuccubusDrainLevel
    skillLevels[2] = SkillSuccubusSeductionLevel
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

Function startSuccubusLife()    
    SuccubusDesireLevel.SetValue(50)
    tActions.RefreshEnergy(0)
    int startLevel = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iSuccubusLevel:Main")
    if startLevel > 0
        SuccubusXpAmount.SetValue( startLevel * 10000 )
    endif
    tssd_enthrallDialogue.Start()
    PlayerRef.AddPerk(TSSD_Base_Explanations)
    tEvents.onGameReload()
    TSSD_Satiated.Cast(PlayerRef,PlayerRef)
    slsfListener.CheckFlagsSLSF()    
    int EventHandle = ModEvent.Create("SLSF_Reloaded_RegisterMod")
    ModEvent.PushString(EventHandle, "TintsOfASuccubusSecretDesires.esp")
    ModEvent.Send(EventHandle)
    tssd_tints_tracker.start()
    tssd_queststart.Start()
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
    endif
    if !tarRef.isHostileToActor(playerRef) && tActions.isSuccableOverload(tarRef) > -1
        return true
    endif
    if (playerRef.HasPerk(TSSD_Body_DefeatThem1))
        if (!playerRef.HasPerk(TSSD_Body_DefeatThem1.GetNextPerk().GetNextPerk().GetNextPerk())) && PlayerRef.GetLevel() <= tarRef.GetLevel() 
                return false
        endif
        int max_targets = 1 + playerRef.HasPerk(TSSD_Body_DefeatThem1.GetNextPerk().GetNextPerk().GetNextPerk().GetNextPerk()) as int + playerRef.HasPerk(TSSD_Body_DefeatThem1.GetNextPerk().GetNextPerk().GetNextPerk()) as int
        ;/ (tActions.numHostileActors <= max_targets) &&  /;
        if  max_targets > 1 || (tarRef.GetActorValue("Health") < PlayerRef.GetActorValue("Health")) ||  playerRef.HasPerk(TSSD_Body_DefeatThem1.GetNextPerk().GetNextPerk()) 
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
    tarRef = tActions.getCombatTarget(false)
    if PlayerRef.HasPerk(TSSD_Body_PlayDead1) && !PlayerRef.IsInCombat()
            if tarRef && tarRef != PlayerRef
                itemsAsString += ";Act defeated"
            else
                itemsAsString += ";Act defeated (no Target found)"
        endif
    endif

    itemsAsString += ";Look for Prey"
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
    
    if false ; && MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bDebugCheats:Main")
        itemsAsString += ";BimbofyWhiterun"
    endif
    itemsAsString += ";ViewAllBuffSpells"
    
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
        
    elseif myItems[result] == "Act defeated"
        tActions.actDefeated(tarRef, true)
    elseif myItems[result] == "BimbofyWhiterun"        
        int bimboIndex = 0
        Actor[] whiterRunTargets = PO3_SKSEFunctions.GetActorsByProcessingLevel(3)
        DBGTrace("In whiterun there are " + whiterRunTargets.Length + " People!")
        
        while bimboIndex < whiterRunTargets.Length
            Actor cAct = whiterRunTargets[bimboIndex]
            if !cAct.IsChild() && cAct.GetActorBase().IsUnique() && cAct.GetActorBase().GetSex() == 1 && cAct.GetRace().IsPlayable()
                DBGTrace("Corrupting " + cAct.GetDisplayName() + " now! "  + bimboIndex +"/" + whiterRunTargets.Length)
                int modActorCorruptHandle = ModEvent.Create("CC_ModActorCorruption")
                ModEvent.PushForm(modActorCorruptHandle , cAct)
                ModEvent.PushInt(modActorCorruptHandle , 105)
                ModEvent.Send(modActorCorruptHandle)
            endif
            bimboIndex += 1
        endwhile
    ;/ 
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
        endif /;
        
    elseif myItems[result] == "Steal"
        sslThreadController _thread = Sexlab.GetPlayerController()
        Actor toSteal = _thread.GetPositions()[0]
        if toSteal == PlayerRef
            toSteal = _thread.GetPositions()[1]
        endif
        toSteal.ShowGiftMenu(false, none, true, false) 
    
    elseif myItems[result] == "ViewAllBuffSpells"
        if Game.GetCurrentCrosshairRef()
            UIExtensions.OpenMenu("UIMagicMenu", Game.GetCurrentCrosshairRef(), PlayerRef)
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
    if colorToAdd >= 0
        ShowSuccubusTrait(colorToAdd)
    endif
EndEvent


Function ShowSuccubusTrait(int num)
    if tVals.canTakeBools[num] || PlayerRef.HasPerk( SuccubusTintPerks[num])
        return
    endif
    if PlayerRef.IsInCombat()
        colorToAdd = num
        RegisterForSingleUpdateGameTime(0.1)
        return
    endif

    tVals.canTakeBools[num] = true
    setNonArrBool(num)

    
    b612_TraitsMenu TraitsMenu = GetTraitsMenu()
    string[] succKinds = JArray.asStringArray(JDB.solveObj(".tssdoverviews.SuccubusTraits"))
    
    TraitsMenu.AddItem("Embrace: " + succKinds[num], JDB.solveStr(".tssdtraits." + succKinds[num] + ".description"),\
            "menus/tssd/"+succKinds[num]+".dds")
    String ResText = "Resist: "
    
    if num == 9
        ResText = "OHYESIWANTTHISTHISISWHOIAM : "
    elseif PlayerRef.HasPerk(SuccubusTintPerks[11])
        ResText = "Embrace: "
    endif

    TraitsMenu.AddItem(ResText + succKinds[num], JDB.solveStr(".tssdtraits." + succKinds[num] + ".description"),\
            "menus/tssd/"+succKinds[num]+".dds")
    ;/ int indexIn = 0
    while indexIn < succKinds.Length
        TraitsMenu.AddItem(succKinds[indexIn], JDB.solveStr(".tssdtraits." + succKinds[indexIn] + ".description"),\
            "menus/tssd/"+succKinds[indexIn]+".dds")
        indexIn += 1
    endwhile /;
    String[] resultW = TraitsMenu.Show()
    if resultW[0] == "0" || num == 9 || PlayerRef.HasPerk(SuccubusTintPerks[11])
        PlayerRef.AddPerk(SuccubusTintPerks[num])
        TSSD_SuccubusPerkPoints.Mod(1)
        tEvents.incrValAndCheck(11,1)
        tssd_tints_tracker.SetObjectiveDisplayed(num, true)
    endif


            
EndFunction

Function GetTraitsLel()
    b612_QuantitySlider qS = GetQuantitySlider()
    int outInt = qS.Show("Num", 0,  JArray.asStringArray(JDB.solveObj(".tssdoverviews.SuccubusTraits")).Length - 1)
    ShowSuccubusTrait(outInt)
EndFunction

Function setNonArrBool(int n)
    if n == 0 
        tVals.canTake00Razzmatazz = true 
    endif
    if n == 1 
        tVals.canTake01Cupid = true 
    endif
    if n == 2 
        tVals.canTake02Lavenderblush = true 
    endif
    if n == 3 
        tVals.canTake03Carnation = true 
    endif
    if n == 4 
        tVals.canTake04Tosca = true 
    endif
    if n == 5 
        tVals.canTake05Blush = true 
    endif
    if n == 6 
        tVals.canTake06Lilac = true 
    endif
    if n == 7 
        tVals.canTake07Pink = true 
    endif
    if n == 8 
        tVals.canTake08Maroon = true 
    endif
    if n == 9 
        tVals.canTake09Pink2 = true 
    endif
    if n == 10 
        tVals.canTake10Crusta = true 
    endif
    if n == 11 
        tVals.canTake11Sangria = true 
    endif
    if n == 12 
        tVals.canTake12Mystic = true 
    endif
    if n == 13 
        tVals.canTake13Geraldine = true 
    endif
    if n == 14 
        tVals.canTake14Crimson = true 
    endif
    if n == 15 
        tVals.canTake15Cerise = true 
    endif
    if n == 16 
        tVals.canTake16Plum = true 
    endif
    if n == 17 
        tVals.canTake17Pompadour = true 
    endif
    if n == 18 
        tVals.canTake18Tolopea = true 
    endif
    if n == 19 
        tVals.canTake19Scarlet = true 
    endif
    if n == 20 
        tVals.canTake20Mahogany = true 
    endif
EndFunction