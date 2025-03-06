ScriptName tssd_utils hidden


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
    If (!Utility.IsInMenuMode()) && (!UI.IsMenuOpen("Dialogue Menu")) && (!UI.IsMenuOpen("Console")) && (!UI.IsMenuOpen("Crafting Menu")) && (!UI.IsMenuOpen("MessageBoxMenu")) && (!UI.IsMenuOpen("ContainerMenu")) && (!UI.IsMenuOpen("InventoryMenu")) && (!UI.IsMenuOpen("BarterMenu")) && (!UI.IsTextInputEnabled())
    Return True
    Else
    Return False
    EndIf
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


String Function GenerateFullPath(String filename) Global
    Return "Data/Tssd/" + filename + ".json"
EndFunction

String [] Function GetSuccubusTypesAll() Global
    return JArray.asStringArray(JDB.solveObj(".tssdoverviews.SuccubusKinds"))
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


bool Function isSuccable(Actor akActor, MagicEffect TSSD_DraineMarkerEffect) Global
    ActorBase ak = (akActor.GetBaseObject() as ActorBase)
    return !( Game.GetPlayer() == akActor || ak.IsProtected() || ak.IsEssential()) || (false && MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bKillEssentials:Main")) && !akActor.IsChild() && !akActor.HasMagicEffect(TSSD_DraineMarkerEffect)
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

String Function GetTypeDial(string type, bool isPositive, bool isTrait = false) Global
    string is_pos = "positive"
    if !isPositive
        is_pos = "negative"
    endif
    string isType = "kinds"
    if isTrait
        isType = "traits"
    endif
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
    DBGTrace(!JContainers.fileExistsAtPath(fullPath))
    If !JContainers.fileExistsAtPath(fullPath)
        String msg = "Could not find or read file '" + fullPath + "'"
        Return False
    EndIf
    Return True
EndFunction

Function Maintenance(GlobalVariable TSSD_SuccubusType) Global
    int succubusType = TSSD_SuccubusType.GetValue() as int
    int jval = JValue.readFromFile("Data/Tssd/succubustraits.json")
    JDB.SetObj("tssdtraits", jval)
    jval = JValue.readFromFile("Data/Tssd/succubuskinds.json")
    JDB.SetObj("tssdkinds", jval)
    jval = JValue.readFromFile("Data/Tssd/overviews.json")
    JDB.SetObj("tssdoverviews", jval)
    jval = JValue.readFromFile("Data/Tssd/settings.json")
    JDB.SetObj("tssdsettings", jval)
    jval = JValue.readFromFile("Data/Tssd/spellids.json")
    JDB.SetObj("tssdspellids", jval)
    ReadInCosmeticSetting()
Endfunction

Headpart Function currentEyes() Global
    Actor playerRef = Game.GetPlayer()
    ActorBase Base = PlayerRef.GetBaseObject() as ActorBase
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

Function setHeartEyes(HeadPart PlayerEyes, bool on = true) Global
    Actor playerRef = Game.GetPlayer()
    HeadPart HeartEyes = HeadPart.GetHeadPart("TSSD_FemaleEyesHeart2")
    if PlayerEyes
        if !on
            playerRef.ChangeHeadPart( PlayerEyes)
        else
            playerRef.ChangeHeadPart( HeartEyes )
        endif
        playerRef.QueueNiNodeUpdate()
    endif
Endfunction
