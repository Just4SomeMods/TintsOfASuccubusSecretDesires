ScriptName tssd_utils hidden

import b612

ImageSpaceModifier FadeToBlackHold

float Function Max(float a, float b) Global
    if a > b 
        return a
    endif
    return b
EndFunction

float Function Min(float a, float b) Global
    if b > a 
        return a
    endif
    return b
EndFunction


Bool Function SafeProcess() Global
    return (!Utility.IsInMenuMode()) && (!UI.IsMenuOpen("Dialogue Menu")) && (!UI.IsMenuOpen("Console")) && (!UI.IsMenuOpen("Crafting Menu")) && (!UI.IsMenuOpen("MessageBoxMenu")) && (!UI.IsMenuOpen("ContainerMenu")) &&  (!UI.IsMenuOpen("InventoryMenu")) && (!UI.IsMenuOpen("BarterMenu"))  && (!UI.IsTextInputEnabled())
EndFunction

float[] Function CopyArray(float[] arr1) Global
    float[] arr2 = Utility.CreateFloatArray(arr1.Length)
    int index = 0
    while index < arr2.length
        arr2[index] = arr1[index]
        index+=1
    EndWhile
    return arr2
EndFunction

int[] Function CopyIntArray(int[] arr1) Global
    int[] arr2 = Utility.CreateIntArray(arr1.Length)
    int index = 0
    while index < arr2.length
        arr2[index] = arr1[index]
        index+=1
    EndWhile
    return arr2
EndFunction

float[] Function CopyToFloatArray(int[] arr1) Global
    float[] arr2 = Utility.CreateFloatArray(arr1.Length)
    int index = 0
    while index < arr2.length
        arr2[index] = arr1[index] as float
        index+=1
    EndWhile
    return arr2
EndFunction


String Function GenerateFullPath(String filename) Global
    Return "Data/Tssd/" + filename + ".json"
EndFunction

String [] Function GetSuccubusStartPerksAll() Global
    return JArray.asStringArray(JDB.solveObj(".tssdoverviews.SuccubusSPerks"))
Endfunction

String [] Function GetSuccubusTraitsAll() Global
    return JArray.asStringArray(JDB.solveObj(".tssdoverviews.SuccubusTraits"))
Endfunction


bool[] Function ReadInCosmeticSetting() Global
    string[] settings = StringUtil.Split( MCM.GetModSettingString("TintsOfASuccubusSecretDesires","sCosmeticSettings:Main"), ";" )
    int lengSettings = JValue.count(JDB.solveObj(".tssdsettings"))
    bool[] cosmeticSettings = Utility.CreateBoolArray(lengSettings, false)
    int index = 0
    while index < lengSettings
        cosmeticSettings[index] = (settings[index] as int) as bool
        index += 1
    endwhile
    return cosmeticSettings
Endfunction

bool Function isEnabledAndNotPlayer(Actor curRef) Global
    if !curRef
        return false
    endif
    return curRef.IsEnabled() && curRef != Game.GetPlayer() && !curRef.isDead()
EndFunction


bool Function targetCheckForScan(Actor curRef, keyword animalKeyword) Global
    return isEnabledAndNotPlayer(curRef) && curRef.isHostileToActor(Game.GetPlayer()) && !curRef.HasKeyword(animalKeyword)
Endfunction

bool Function isDeathSuccable(Actor akActor, MagicEffect TSSD_DrainedDownSide, actor playerref, bool ignoreMarker, bool afterSceneEnd = true) Global
    if !isSuccable(akActor, TSSD_DrainedDownSide, playerref, ignoreMarker, afterSceneEnd)
        return false
    endif
    ActorBase ak = (akActor.GetBaseObject() as ActorBase)
    return  !(ak.IsProtected() || ak.IsEssential())
    
EndFunction

int Function isSuccable(Actor akActor, MagicEffect TSSD_DrainedDownSide, actor playerref, bool ignoreMarker, bool afterSceneEnd = true) Global
    ; -1 can't be drained, 0 can only be drained once, 1 can be drained

    if akActor.IsChild() || Game.GetPlayer() == akActor || akActor.HasMagicEffect(TSSD_DrainedDownSide) &&  !ignoreMarker
        return -1
    endif

    return 1
    
EndFunction

float Function GetLastTimeSuccd(Actor Target, GlobalVariable TimeOfDayGlobalProperty) Global
    float lastTime = SexlabStatistics.GetLastEncounterTime(Target,Game.GetPlayer())
    float comparer = TimeOfDayGlobalProperty.GetValue()
    if comparer < lastTime
        return 1
    endif
    if lastTime > 0.0
        return TimeOfDayGlobalProperty.GetValue() - lastTime
    endif
    return -1.0
Endfunction

bool[] Function GetSuccubusTraitsChosen(GlobalVariable TSSD_SuccubusTraits, int numTraits) Global
    int i = 0
    int res = TSSD_SuccubusTraits.GetValue() as int
    bool[] out = Utility.CreateBoolArray(numTraits as int, false)
    while i < numTraits
        out[i] = Math.LogicalAnd(res, Math.Pow(2, i) as int ) > 0
        i+=1
    endwhile
    return out

Endfunction

String Function GetTintDial(string type, bool isPositive = true) Global
    string is_pos = "positive"
    if !isPositive
        is_pos = "negative"
    endif
    string isType = "traits"
    
    int jsolve = JDB.solveObj(".tssd"+isType+"."+type+"."+is_pos)
    if !ReadInCosmeticSetting()[3]
        return JArray.getStr(jsolve, Utility.RandomInt(0, JValue.count(jsolve) - 1 )) + " "
    endif
    return JArray.getStr(jsolve, 0) + " "

Endfunction


Function DBGTrace(string inputOf) Global
    Debug.Trace("tssd_" + inputOf)
Endfunction



Bool Function CheckFileExists(String fullPath) Global
    If !JContainers.fileExistsAtPath(fullPath)
        String msg = "Could not find or read file '" + fullPath + "'"
        Return False
    EndIf
    Return True
EndFunction

Function Maintenance() Global
    int jval = JValue.readFromFile("Data/Tssd/succubustraits.json")
    JDB.SetObj("tssdtraits",  jval  )
    jval = JValue.readFromFile("Data/Tssd/succubustintsUnPivot.json")
    JDB.SetObj("tssdtints",  jval  )
    jval = JValue.readFromFile("Data/Tssd/succubusEnergyPerks.json")
    JDB.SetObj("tssdperks", jval)
    jval = JValue.readFromFile("Data/Tssd/overviews.json")
    JDB.SetObj("tssdoverviews", jval)
    jval = JValue.readFromFile("Data/Tssd/settings.json")
    JDB.SetObj("tssdsettings", jval)
    jval = JValue.readFromFile("Data/Tssd/spellids.json")
    JDB.SetObj("tssdspellids", jval)
    jval = JValue.readFromFile("Data/Tssd/succubusNpcFactions.json")
    JDB.SetObj("tssdfactions", jval)
    jval = JValue.readFromFile("Data/Tssd/oldNorseGods.json")
    JDB.SetObj("oldNorseGods", jval)
    jval = JValue.readFromFile("Data/Tssd/bodyMorphs.json")
    JDB.SetObj("tssdmorphs", jval)
    ReadInCosmeticSetting()
Endfunction


int Function getTargetNumber(int num) Global
    int cNum = JDB.solveInt(".tssdtints." + num + ".targetNum")
    return cNum
EndFunction

Perk Function getPerkNumber(int num) Global
    int cPerk = JDB.solveInt(".tssdtints." + num + ".perk")
    return Game.GetFormFromFile(cPerk as int, "TintsOfASuccubusSecretDesires.esp") as Perk
EndFunction

Headpart Function currentEyes(Actor TargetOf = none) Global
    if TargetOf == none
        TargetOf = Game.GetPlayer()
    endif
    ActorBase Base = TargetOf.GetBaseObject() as ActorBase
    int parts = Base.GetNumHeadParts()
    HeadPart HeartEyes = HeadPart.GetHeadPart("TSSD_FemaleEyesHeart2")
    While parts > 0
        parts -= 1
        int Temp = Base.GetNthHeadPart(parts).GetType()
        If Temp == 2 
            if Base.GetNthHeadPart(Parts) != HeartEyes
                return Base.GetNthHeadPart(Parts)
            endif
            parts = 0
        endIf
    EndWhile
    return none
Endfunction

Function setHeartEyes(HeadPart PlayerEyes, bool on = true, Actor TargetOf = none) Global
    if TargetOf == none
        TargetOf = Game.GetPlayer()
    endif
    HeadPart HeartEyes = HeadPart.GetHeadPart("TSSD_FemaleEyesHeart2")
    if PlayerEyes
        if !on
            TargetOf.ChangeHeadPart( PlayerEyes)
        else
            TargetOf.ChangeHeadPart( HeartEyes )
        endif
        TargetOf.QueueNiNodeUpdate()
    endif
Endfunction

Function T_Show(String asText, String asImagePath = "", Float aiDelay = 2.0, String asKnot = "") Global
    return GetAnnouncement().Show(asText, asImagePath, aiDelay, asKnot)
EndFunction

Function T_Needs(int succTrait, string replacement="", bool isBad=true) Global
    string txtSource = ".needyText"
    if !isBad
        txtSource = ".positive"
    endif
    string[] succNeedy = JArray.asStringArray(JDB.solveObj(".tssdtints." + succTrait + txtSource))
    String nxText = ""
    if succNeedy.Length > 0
        nxText = succNeedy[Utility.RandomInt(0, succNeedy.Length - 1)]
        if replacement != "" && StringUtil.Find(nxText, ";") > 0
            String[] texts = StringUtil.Split(nxText, ";")
            nxText = texts[0] + replacement + texts[1]
        Endif
    Endif
    T_Show( nxText , "menus/tssd/small/" + JDB.solveStr(".tssdtints." + succTrait + ".Name") +".dds" )

    
EndFunction

bool Function isSingle(Actor ak) Global
    AssociationType akCourting = Game.GetFormFromFile(0x1EE23, "skyrim.esm") as AssociationType
    AssociationType akSpouse = Game.GetFormFromFile(0x142CA, "skyrim.esm") as AssociationType
    return !(ak.HasAssociation(akCourting) || ak.HasAssociation(akSpouse))
Endfunction

Function DoFadeOut (Float Time) Global
	(Game.GetFormFromFile(0xF756F, "skyrim.esm") as ImageSpaceModifier).ApplyCrossFade (Time)
  	Utility.Wait (Time)
	Game.FadeOutGame (False,True,50,1)
EndFunction


Function DoFadeIn (Float Time) Global
	Game.FadeOutGame (False,True,0.1,0.1)
	ImageSpaceModifier.RemoveCrossFade (Time)
EndFunction

Function shortFade() Global
    DoFadeOut(1)
    Utility.Wait(1.4)
    DoFadeIn(1)
Endfunction


Function TSSD_ModTint(Actor CmdTargetActor, ActiveMagicEffect _CmdPrimary, string[] param) global
    sl_triggersCmd CmdPrimary = _CmdPrimary as sl_triggersCmd
    Game.GetPlayer().SendModEvent("TSSD_ModTint", param[1], param[2] as float)
    CmdPrimary.CompleteOperationOnActor()
EndFunction

;/
import sl_triggersStatics

sl_triggersExtensionSexLab Function GetExtension() global
    return GetForm_SLT_ExtensionSexLab() as sl_triggersExtensionSexLab
EndFunction

; sltname sl_hasstagetags
; sltgrup SexLab P+
; sltdesc Returns: bool: true iff the SexLab scene has the specified tag, false otherwise
; sltargs string: tag: tag name e.g. "Oral", "Anal", "Vaginal"
; sltargs Form: actor: target Actor
; sltsamp sl_hasstagetags "Oral" $system.self
;  
function sl_hasstagetags(Actor CmdTargetActor, ActiveMagicEffect _CmdPrimary, string[] param) global
	sl_triggersCmd CmdPrimary = _CmdPrimary as sl_triggersCmd

    sl_triggersExtensionSexLab slExtension = GetExtension()
    
    bool nextResult = false
	
	if slExtension.IsEnabled && ParamLengthLT(CmdPrimary, param.Length, 4)
        Actor _targetActor = CmdTargetActor
        if param.Length > 2
            _targetActor = CmdPrimary.ResolveActor(param[2])
        endif
        SexLabThread slthread = (slExtension.SexLabForm as SexLabFramework).GetThreadByActor(_targetActor)
        if slthread
            String[] toCheck = StringUtil.Split(CmdPrimary.ResolveString(param[1]), ", ")
            int toCheckIndex = 0
            bool hasAbortedOrAnyOr = false
            while toCheckIndex < toCheck.Length
                String cTag = toCheck[toCheckIndex]
                bool isPositive = StringUtil.GetNthChar(cTag, 0) != "-"
                bool isOr = StringUtil.GetNthChar(cTag, 0) == "~"
                if isOr
                    hasAbortedOrAnyOr = true
                EndIf
                if !isPositive || isOr
                    cTag = StringUtil.Substring(cTag, 1)
                EndIf
                bool stageHasTag = slthread.HasStageTag(cTag)
                if isOr
                    nextResult = nextResult || stageHasTag
                elseif isPositive != stageHasTag
                    toCheckIndex = toCheck.Length
                    nextResult = false
                    hasAbortedOrAnyOr = true
                endif
                toCheckIndex += 1
            EndWhile
            if !hasAbortedOrAnyOr
                nextResult = true
            EndIf
        endIf
    endif
    CmdPrimary.MostRecentBoolResult = nextResult

    CmdPrimary.CompleteOperationOnActor()
endFunction
/;

bool function hasTagsInternal(SexLabThread slthread, string tagsAsString) global
    bool nextResult = false
    if slthread
        String[] toCheck = StringUtil.Split(tagsAsString, ", ")
        int toCheckIndex = 0
        bool hasAbortedOrAnyOr = false
        while toCheckIndex < toCheck.Length
            String cTag = toCheck[toCheckIndex]
            bool isPositive = StringUtil.GetNthChar(cTag, 0) != "-"
            bool isOr = StringUtil.GetNthChar(cTag, 0) == "~"
            if isOr
                hasAbortedOrAnyOr = true
            EndIf
            if !isPositive || isOr
                cTag = StringUtil.Substring(cTag, 1)
            EndIf
            bool stageHasTag = slthread.HasStageTag(cTag)
            if isOr
                nextResult = nextResult || stageHasTag
            elseif isPositive != stageHasTag
                toCheckIndex = toCheck.Length
                nextResult = false
                hasAbortedOrAnyOr = true
            endif
            toCheckIndex += 1
        EndWhile
        if !hasAbortedOrAnyOr
            nextResult = true
        EndIf
    endIf
    return nextResult
endFunction



Function playAnimationWithIdle(Actor akTarget = none, string firstAnim = "", string secondAnim = "", float timeOfWait = 5.0) Global
    Actor PlayerRef = Game.GetPlayer()
    if akTarget
        DbSkseFunctions.ToggleCollision(akTarget)
        Utility.SetIniBool("bDisablePlayerCollision:Havok", True)
        ; aktarget.ForceRefTo(playerRef)
        ActorUtil.AddPackageOverride(aktarget as Actor, Game.GetFormFromFile(0x654E2, "skyrim.esm") as Package  , 1)
        (aktarget as Actor).EvaluatePackage()
        aktarget.SetAnimationVariableInt("IsNPC", 1) ; disable head tracking
        aktarget.SetAnimationVariableBool("bHumanoidFootIKDisable", True) ; disable inverse kinematics
        aktarget.MoveTo(playerref)
        aktarget.SetDontMove()
        Game.DisablePlayerControls(true, false, false, false, false, false, false)
    EndIf
    game.forcethirdperson()
    debug.sendanimationevent(PlayerRef, firstAnim)
    debug.sendanimationevent(akTarget, secondAnim)
    Utility.Wait(timeOfWait)
    Utility.SetIniBool("bDisablePlayerCollision:Havok",false)
    Game.EnablePlayerControls()
    debug.sendanimationevent(playerref, "idleforcedefaultstate")
    if akTarget
        debug.sendanimationevent(aktarget, "idleforcedefaultstate")

        ActorUtil.RemovePackageOverride(aktarget, Game.GetFormFromFile(0x654E2, "skyrim.esm") as Package)
        (aktarget as Actor).EvaluatePackage()
        aktarget.SetAnimationVariableInt("IsNPC", 1) ; enable head tracking
        aktarget.SetAnimationVariableBool("bHumanoidFootIKDisable", False) ; enable inverse kinematics

        DbSkseFunctions.ToggleCollision(akTarget)
        aktarget.SetDontMove(false)
    EndIf
    debug.sendanimationevent(PlayerRef, "idleforcedefaultstate")
EndFunction