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
tssd_orgasmenergylogic Property tOrgasmLogic Auto


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

bool modifierKeyIsDown = false

bool [] cosmeticSettings

string currentVersion = "1.04.000"


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
                objectiveSub = 25
            elseif deityName == "Mara"
                objectiveSub = 21
            elseif deityName == "Kynareth"
                return true
            elseif deityName == "Julianos"
                objectiveSub = 23
            elseif deityName == "Dibella"
                objectiveSub = 24
            endif
            if objectiveSub > 0
                if !tssd_dealwithcurseQuest.IsObjectiveCompleted(10 + objectiveSub)

                    tssd_dealwithcurseQuest.SetObjectiveFailed(objectiveSub, !tssd_dealwithcurseQuest.isobjectivefailed(objectiveSub))
                    tssd_dealwithcurseQuest.SetObjectiveDisplayed(objectiveSub)
                    (tssd_dealwithcurseQuest as tssd_curequestvariables).toggleCurse(deityName)
                endif
                return true
            endif
        endif
    endif
    return false
endfunction

Function OpenGrandeMenu()
    if !SafeProcess()
        return
    endif
    if SuccubusDesireLevel.GetValue() <= -101
        int dbgSuccy = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iSkipExplanations:Main")
        startSuccubusLife()
        CustomSkills.OpenCustomSkillMenu("SuccubusBaseSkill")
        return
    endif
    if tEvents.canCelebrate
        Sexlab.StartSceneQuick(PlayerRef)
        tEvents.canCelebrate = false
        SkyInteract myBinding = SkyInteract_Util.GetSkyInteract()
        myBinding.Remove("tssd_getCelebration")
        if CustomSkills.GetAPIVersion() >= 3
            tActions.gainSuccubusXP(100 * Game.QueryStat("Dungeons Cleared"))
            CustomSkills.AdvanceSkill("SuccubusBodySkill", 100 * Game.QueryStat("Dungeons Cleared"))
        endif
        return
    endif
    modifierKeyIsDown = false;Input.IsKeyPressed( MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iModifierHotkey:Main") )
    ObjectReference ref = Game.GetCurrentCrosshairRef()
    if ref
        if !Sexlab.IsActorActive(PlayerRef) && tActions.playerInSafeHaven() && tEvents.isLilac && (ref as Actor) && tActions.isDoggie(ref as Actor) && !(ref as Actor).HasMagicEffect(tActions.TSSD_DrainedDownSide)
            tActions.tDialogue.lilacBeg(ref as Actor)
            SkyInteract myBinding = SkyInteract_Util.GetSkyInteract()
            myBinding.remove("tssd_getTargetCross")
            return
        elseif TSSD_ShrinesWithQuests.HasForm(ref.GetBaseObject())
            String deityName = StringUtil.Substring(DbSkseFunctions.GetFormEditorId(ref.GetBaseObject(), "none"), 8)
            if toggleQuestCurses(deityName)
                return
            endif
        endif
    endif
    sslThreadController _thread =  Sexlab.GetPlayerController()
    b612_SelectList mySelectList = GetSelectList()
    string toSplit = "Abilities;Upgrades;Settings;View Tint Progress"
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
    String resOf = myItems[result]
    if resOf == "Abilities"
        OpenSuccubusAbilities()
    elseif resOf == "Upgrades"
        OpenExpansionMenu()    
    elseif resOf == "Settings"
        OpenSuccubusCosmetics()
    elseif resOf == "TraitsLel"
        GetTraitsLel()
    elseif resOf == "View Tint Progress"
        viewTintProgress()
    endif
EndFunction 

Function OpenExpansionMenu()
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
    String[] myItems = StringUtil.Split("Base;Body;Drain;Seduction;Perk Points",";")    
    GlobalVariable[] skillLevels = new GlobalVariable[5]
    skillLevels[1] = SkillSuccubusBodyLevel
    skillLevels[2] = SkillSuccubusDrainLevel
    skillLevels[3] = SkillSuccubusSeductionLevel
    tssd_trainSuccAbilities trainingThing =  ((Quest.GetQuest("tssd_queststart")) as tssd_trainSuccAbilities)
    trainingThing.SetSkillName(mYitems[index_of])
    trainingThing.SetSkillId( "Succubus" + myItems[index_of] + "Skill")
    trainingThing.SetSkillVariable(skillLevels[index_of])
    (trainingThing).show()

Endfunction

Function startSuccubusLife()
    PlayerRef.AddPerk(TSSD_Base_Explanations)
    tssd_queststart.Start()
    tssd_tints_tracker.start()
    Utility.Wait(0.1)
    tssd_enthrallDialogue.Start()
    SuccubusDesireLevel.SetValue(50)
    tEvents.onGameReload()
    tActions.onGameReload()
    ; tActions.RefreshEnergy(0)
    TSSD_Satiated.Cast(PlayerRef,PlayerRef)
    slsfListener.CheckFlagsSLSF()    
    int EventHandle = ModEvent.Create("SLSF_Reloaded_RegisterMod")
    ModEvent.PushString(EventHandle, "TintsOfASuccubusSecretDesires.esp")
    ModEvent.Send(EventHandle)
    if MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bDebugFactionSpell:Main")
        tActions.toggleDebugFaction(true)
    endif
    int startLevel = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iSuccubusLevel:Main")
    if startLevel > 0
        SuccubusXpAmount.SetValue( startLevel * 10000 )
    endif
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
    if PlayerRef.HasPerk(TSSD_Body_PlayDead1) && Sexlab.GetPlayerController() == none
        tarRef = tActions.getCombatTarget(false)
        if !PlayerRef.IsInCombat()
                if tarRef && tarRef != PlayerRef
                    itemsAsString += ";Act defeated"
                else
                    itemsAsString += ";Act defeated (no Target found)"
            endif
        endif
    endif
    itemsAsString += ";Look for Prey"
    if MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bDebugCheats:Main") && Sexlab.GetPlayerController()
        itemsAsString += ";Cum 10 times"
    endif
    int indexOfA = 1
    if PlayerRef.HasPerk(TSSD_Seduction_Kiss2) && Sexlab.GetPlayerController()
        itemsAsString += ";Steal"
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
        TSSD_SuccubusDetectJuice.SetNthEffectArea(0, radius )
        int oldDur = TSSD_SuccubusDetectJuice.GetNthEffectDuration(0)
        TSSD_SuccubusDetectJuice.SetNthEffectDuration(0, 5)
        TSSD_SuccubusDetectJuice.Cast(PlayerRef, PlayerRef)
        TSSD_SuccubusDetectJuice.SetNthEffectDuration(0, oldDur)
    elseif myItems[result] == "Act defeated"
        tActions.actDefeated(tarRef, true)
    elseif myItems[result] == "Cum 10 times"
        sslThreadController _thread = Sexlab.GetPlayerController()
        Actor[] actorSLel = _thread.GetPositions()
        int indexInIn = 0
        while indexInIn < 10
            int actsIn = 0
            while actsIn < actorSLel.Length
                Actor cA = actorSLel[actsIn]
                
                _thread.ForceOrgasm(cA)
                actsIn += 1
            endwhile
            indexInIn += 1
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
    endif
EndFunction


Event OnUpdateGameTime()
    UnregisterForUpdateGameTime()
    if colorToAdd >= 0
        ShowSuccubusTrait(colorToAdd)
    endif
EndEvent


Function ShowSuccubusTrait(int num)
    
    if tVals.canTakeBools[num] || PlayerRef.HasPerk( getPerkNumber(num))
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
    string nameOf = JDB.solveStr(".tssdtints." + num + ".Name")
    
    TraitsMenu.AddItem("Perk + " + nameOf, JDB.solveStr(".tssdtints." + num + ".description"),"menus/tssd/"+nameOf+".dds")
    String ResText = "Resist "
    
    if num == 9
        ResText = "OHYESIWANTTHISTHISISWHOIAM : "
    elseif PlayerRef.HasPerk(getPerkNumber(11))
        ResText = "Embrace: "
    endif

    TraitsMenu.AddItem(ResText + nameOf, JDB.solveStr(".tssdtints." + num + ".description"), "menus/tssd/"+nameOf+".dds")
            
    String[] resultW = TraitsMenu.Show()
    if resultW[0] == "0" || num == 9 || PlayerRef.HasPerk(getPerkNumber(11))
        PlayerRef.AddPerk(getPerkNumber(num))
        TSSD_SuccubusPerkPoints.Mod(1)
        tOrgasmLogic.incrValAndCheck(11,1)
        tssd_tints_tracker.SetObjectiveDisplayed(num, true)
    endif

    if PlayerRef.HasPerk(getPerkNumber(0)) && PlayerRef.HasPerk(getPerkNumber(1))
        ShowSuccubusTrait(21)
    endif
EndFunction

Function viewTintProgress()
    b612_TraitsMenu TraitsMenu = GetTraitsMenu()
    int jjM = JDB.solveObj(".tssdtints")
    
    int indexIn = 0

    while indexIn < JMap.Count(jjM)
        int toAdd = 0
        int innerJJ = JMap.getObj(jjM, "" + indexIN)
        if getTargetNumber(indexIN) >= 0
            string nameOf = JMap.GetStr(innerJJ, "Name")
            TraitsMenu.AddItem((tEvents.currentVals[indexIn] as int + toAdd) + "/" + JMap.GetInt(innerJJ, "targetNum") + " " + nameOf, "Unlock Method: " + JMap.GetStr(innerJJ, "unlockMethod") +"|" +  JMap.GetStr(innerJJ, "description"), "menus/tssd/"+nameOf+".dds")
        endif
        indexIn += 1
    endwhile
    String[] resultW = TraitsMenu.Show(0,0)
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
    if n == 21
        tVals.canTake21Tutu = true 
    endif
    if n == 22
        tVals.canTake22Tamrind = true 
    endif
    if n == 23
        tVals.canTake23Pueblo = true 
    endif
    if n == 24 
        tVals.canTake24Valencia = true 
    endif
    if n == 25 
        tVals.canTake25Stiletto = true 
    endif
    if n == 26  
        tVals.canTake26Neon = true
    endif
    if n == 27  
        tVals.canTake27Ruby = true
    endif
    if n == 28  
        tVals.canTake28Oblivion = true
    endif
    if n == 29  
        tVals.canTake29Carmine = true
    endif
    if n == 30  
        tVals.canTake30Pastel = true
    endif
    if n == 31  
        tVals.canTake31Monza = true
    endif
    if n == 32  
        tVals.canTake32Mulberry = true
    endif
    if n == 33  
        tVals.canTake33Paco = true
    endif
    if n == 34  
        tVals.canTake34Blood = true
    endif
    if n == 35  
        tVals.canTake35Silver = true
    endif
    if n == 36  
        tVals.canTake36Carissma = true
    endif
    if n == 37  
        tVals.canTake37Temptress = true
    endif
    if n == 38  
        tVals.canTake38Bordeaux = true
    endif


EndFunction