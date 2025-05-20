Scriptname tssd_menus extends Quest  


import b612
import tssd_utils

Actor Property PlayerRef Auto

tssd_slsfrscript Property slsfListener Auto

SexLabFramework Property SexLab Auto
sslActorStats Property sslStats Auto
tssd_succubusstageendblockhook Property stageEndHook Auto
tssd_widgets Property tWidgets Auto
Faction Property sla_Arousal Auto
tssd_actions Property tActions Auto

Spell[] Property SuccubusAbilitiesSpells Auto
Perk[] Property SuccubusAbilitiesPerks  Auto
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
GlobalVariable Property TSSD_SuccubusType Auto
GlobalVariable Property TSSD_SuccubusLibido Auto
GlobalVariable Property TSSD_SuccubusBreakRank Auto

Perk Property TSSD_Base_Explanations Auto
Perk Property TSSD_Drain_GentleDrain1 Auto
Perk Property TSSD_Seduction_Kiss1 Auto
Perk Property TSSD_Seduction_OfferSex Auto
Perk Property TSSD_Body_PlayDead1 Auto
Perk Property TSSD_Body_DefeatThem1 Auto

Spell Property TSSD_SuccubusDetectJuice Auto

bool lookedAtExplanationsOnce = false
bool modifierKeyIsDown = false

bool [] cosmeticSettings


ImageSpaceModifier Property AzuraFadeToBlack  Auto  
MagicEffect Property TSSD_SuccubusDetectEnergyFF Auto

int Property lastUsed Auto
int Property lastUsedSub  Auto
int spellToggle


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
    tActions.NotificationSpam(myItems[result] )
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
            tActions.NotificationSpam(myItems[result - 1] )
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
    int oldVal = TSSD_SuccubusType.GetValue() as int
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
        TSSD_SuccubusType.SetValue(query)
        if SuccubusDesireLevel.GetValue() == -101
            SuccubusDesireLevel.SetValue(50)
            TSSD_SuccubusLibido.SetValue(50)
            TSSD_SuccubusBreakRank.SetValue(0)
            tActions.updateSuccyNeeds(0)
            int startLevel = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iSuccubusLevel:Main")
            if startLevel > 0
                SuccubusXpAmount.SetValue( startLevel * 10000 )
                PlayerRef.AddPerk(TSSD_Drain_GentleDrain1)
                PlayerRef.AddPerk(TSSD_Seduction_Kiss1)
                PlayerRef.AddPerk(TSSD_Body_PlayDead1)
            endif
            PlayerRef.AddPerk(TSSD_Base_Explanations)
            tActions.RegisterSuccubusEvents()
        endif
        slsfListener.CheckFlagsSLSF()
        if oldVal == -1 && TSSD_SuccubusType.GetValue() > -1
                OpenSuccubusTraits()
                tWidgets.onReloadStuff()
            endif

    endif
        ;if succubusType == 2
            ;DBGTRace(slavetats.simple_add_tattoo(PlayerRef, "Bofs Bimbo Tats Butt", "Butt (Lower) - Sex Doll"))
            
        ;Endif
EndFunction

Function OpenSettingsMenu()
    modifierKeyIsDown = Input.IsKeyPressed( MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iModifierHotkey:Main") )
    string itemString = "Configure Bars"
    Actor Cross = Game.GetCurrentCrosshairRef() as Actor
    if Cross || Sexlab.GetPlayerController()
        itemString += ";Evaluate Needs"
    endif
    itemString += ";Debug Climax Now;Succubus Cosmetics Menu (Toggles)"
    String[] myItems = StringUtil.Split(itemString,";")
    Int result 
    bool canEssDie = false
    
    lastUsedSub > -1.0 ; FOR WHATEVER REASONS THIS NEEDS TO BE HERE
    
    if modifierKeyIsDown && (lastUsedSub > -1.0)
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
    tActions.NotificationSpam(myItems[result] )
    if myItems[result] == "Evaluate Needs"
        if Sexlab.GetPlayerController()
            tActions.EvaluateCompleteScene()
        elseif Cross
            string showboat = "I can't succ " + Cross.GetDisplayName() +"!"
            if tActions.isSuccableOverload(Cross)
                int lasttime = (GetLastTimeSuccd(Cross, TimeOfDayGlobalProperty) * 300) as int
                if lasttime > 100.0 || lasttime < 0.0
                showboat = "This person is full of juicy energy!"
                else
                        showboat = "This person is only " + lasttime + "% ready."
                    endif
                endif
            GetAnnouncement().Show(showboat, "icon.dds", aiDelay = 2.0)
        endif
    elseif myItems[result] == "Debug Climax Now"
        tActions.DebugForceOrgasm()
    elseif myItems[result] == "Configure Bars"
        tWidgets.ListOpenBarsOld()
    elseif myItems[result] == "Succubus Cosmetics Menu (Toggles)"
        OpenSuccubusCosmetics()
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
    tWidgets.shouldFadeOut = cosmeticSettings[5]
Endfunction


bool Function checkAbilityDefeatThem(Actor tarRef)
    if playerRef.HasPerk(TSSD_Body_DefeatThem1)
        if !playerRef.HasPerk(TSSD_Body_DefeatThem1.GetNextPerk().GetNextPerk().GetNextPerk())
            if PlayerRef.GetLevel() <= tarRef.GetLevel() 
                return false
            endif
        endif
        int max_targets = 1 + playerRef.HasPerk(TSSD_Body_DefeatThem1.GetNextPerk().GetNextPerk().GetNextPerk().GetNextPerk()) as int +\
                              playerRef.HasPerk(TSSD_Body_DefeatThem1.GetNextPerk().GetNextPerk().GetNextPerk()) as int
        if tActions.numHostileActors <= max_targets
            if max_targets > 1 
                return true
            endif
            if (tarRef.GetActorValue("Health") < PlayerRef.GetActorValue("Health"))
                return true
            endif 
            if playerRef.HasPerk(TSSD_Body_DefeatThem1.GetNextPerk().GetNextPerk()) 
                return true
            endif
        endif
    endif
Endfunction


Function OpenSuccubusAbilities()
    String itemsAsString = "Allow draining"
    Actor tarRef = none
    if tactions.deathModeActivated
        itemsAsString = "Hold back draining"
    endif
    Actor Cross = Game.GetCurrentCrosshairRef() as Actor
    if PlayerRef.HasPerk(TSSD_Seduction_OfferSex)
        itemsAsString += ";Ask for Sex"
    endif
    tarRef = tActions.searchForTargets()
    if PlayerRef.HasPerk(TSSD_Body_PlayDead1) && !PlayerRef.IsInCombat()
            if tarRef
                itemsAsString += ";Act defeated"
            else
                itemsAsString += ";Act defeated (no Target found)"
        endif
    endif

    itemsAsString += ";Look for Prey"
    
    int indexOfA = 1
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
    Int result
    
    if modifierKeyIsDown && lastUsedSub >= 0
            result = lastUsedSub
    else
        result = GetSelectList().Show(myItems)
        lastUsedSub = result
        if result == -1
            return
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
        tActions.toggleDeathMode()
    elseif myItems[result] == "Look for Prey"
        int radius = tActions.getScanRange()
        Actor[] allAround = MiscUtil.ScanCellNPCs(PlayerRef, radius * 50)
        TSSD_SuccubusDetectJuice.SetNthEffectArea(0, radius )
        int oldDur = TSSD_SuccubusDetectJuice.GetNthEffectDuration(0)
        TSSD_SuccubusDetectJuice.SetNthEffectDuration(0, 5)
        TSSD_SuccubusDetectJuice.Cast(PlayerRef, PlayerRef)
        TSSD_SuccubusDetectJuice.SetNthEffectDuration(0, oldDur)
    elseif myItems[result] == "Ask for Sex" && Cross
            Sexlab.RegisterHook( stageEndHook)
            Sexlab.StartSceneQuick(akActor1 = PlayerRef, akActor2 = Cross)
    elseif myItems[result] == "Act defeated"
        tActions.actDefeated(tarRef)
    elseif myItems[result] == "Rape them!"
        if !tactions.deathModeActivated
            tactions.toggleDeathMode()
        endif
        Sexlab.RegisterHook( tactions.stageEndHook)
        if !Sexlab.StartSceneA(akPositions = PapyrusUtil.PushActor(tactions.cell_ac, PlayerRef), asTags = "", akSubmissives = tactions.cell_ac)
            if !Sexlab.StartScene(akPositions = PapyrusUtil.PushActor(tactions.cell_ac, PlayerRef), asTags = "")
                int tarIndex = 0
                while tarIndex < tactions.cell_ac.Length
                    Actor curT = tactions.cell_ac[tarIndex]
                    if curT && !curT.isDead()
                            tactions.updateSuccyNeeds(  min(curT.GetAV("Health"), 100 + tactions.getDrainLevel() )  )
                            tactions.TSSD_DrainHealth.SetNthEffectMagnitude(0, 100 + tactions.getDrainLevel() )
                            tactions.TSSD_DrainHealth.Cast(PlayerRef, curT)
                    endif
                    tarIndex += 1
                EndWhile
            endif
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
                    tActions.updateSuccyNeeds(-20)
                else
                    PlayerRef.DispelSpell(SuccubusAbilitiesSpells[indexOfA])
                endif
                indexOfA += 1
            endwhile
        endif
    endif
EndFunction

