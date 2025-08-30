Scriptname tssd_widgets extends Quest  

import tssd_utils

int Property tWidgetNum Auto

int[] Property initial_Bar_Vals Auto
float _updateTimer = 0.5
int[] Property new_Bar_Vals Auto

iWant_Widgets Property  iWidgets Auto
GlobalVariable Property SuccubusDesireLevel Auto
GlobalVariable Property TSSD_SuccubusType Auto

bool Property shouldFadeOut Auto

Function onReloadStuff() 
    onInit()
Endfunction

Event OnInit()
	RegisterForModEvent("iWantWidgetsReset", "OniWantWidgetsReset")
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

Function setColorsOfBar()
    if TSSD_SuccubusType.GetValue() > -1
        string curSuccubusType = GetSuccubusTypesAll()[TSSD_SuccubusType.GetValue() as int]
        if SuccubusDesireLevel.GetValue() > 0
            int[] colors = JArray.asIntArray(JDB.solveObj(".tssdkinds."+curSuccubusType+".color"))
            IWidgets.setMeterRGB(tWidgetNum, colors[0], colors[1], colors[2], colors[0], colors[1], colors[2])
        else
            IWidgets.setMeterRGB(tWidgetNum, 0,0,0, 0,0,0)
        endif
    endif
EndFunction

Function UpdateStatus()
    if iWidgets && SuccubusDesireLevel.GetValue() > -101
        iWidgets.doTransitionByTime(tWidgetNum, max(SuccubusDesireLevel.GetValue(), SuccubusDesireLevel.GetValue() * -1) as int, 1.0, "meterpercent" )
        if shouldFadeOut
            iWidgets.doTransitionByTime(tWidgetNum, 0, seconds = 2.0, targetAttribute = "alpha", easingClass = "none",  easingMethod = "none",  delay = 5.0)
        endif
        setColorsOfBar()
    endif
EndFunction

Function UpdateBarPositions()
    string[] filldirections =  StringUtil.Split("left;right;both", ";")
    IWidgets.setMeterFillDirection(tWidgetNum, filldirections[(initial_Bar_Vals[4] > 1) as int])
    if (initial_Bar_Vals[4] == 0 || initial_Bar_Vals[4] == 2)
        IWidgets.setRotation(tWidgetNum,0 )
    else
        IWidgets.setRotation(tWidgetNum,90 )
    endif
    IWidgets.setZoom(tWidgetNum, initial_Bar_Vals[2], initial_Bar_Vals[3])
    iWidgets.setpos(tWidgetNum, initial_Bar_Vals[0], initial_Bar_Vals[1])
EndFunction

Function ListOpenBarsOld()
    String[] barVals = StringUtil.Split("Pos_X;Pos_Y;Size_X;Size_Y;Rotation", ";")
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

    registerForModEvent("EVM_SliderMenuClosed", "OnEVM_OpenBarsClosed")
    
    ExtendedVanillaMenus.SliderMenuMult(SliderParams = BarSliders, InitialValues = CopyToFloatArray(initial_Bar_Vals), TitleText = "My Sliders", AcceptText = "Alright", CancelText = "No Way", WaitForResult = False)

    index = 0
    while index < listLength
		registerForModEvent("EVM_SliderChanged_" + "TSSD_Main_Bar_"+barVals[index],  "TSSD_Main_Bar_"+barVals[index]+"_Event")
        index += 1
	EndWhile    
EndFunction


Event TSSD_Main_Bar_Update(string a_eventName, string a_strArg, float a_numArg, form a_sender)
    iWidgets.setTransparency(tWidgetNum, 100)
    int index = -1
    if a_eventName == "EVM_SliderChanged_TSSD_Main_Bar_Pos_X"
        index = 0
        MCM.SetModSettingInt("TintsOfASuccubusSecretDesires","iBarPosX:Main", (a_numArg) as int)
	elseif a_eventName == "EVM_SliderChanged_TSSD_Main_Bar_Pos_Y"
        index = 1
        MCM.SetModSettingInt("TintsOfASuccubusSecretDesires","iBarPosY:Main", (a_numArg) as int)
	elseif a_eventName == "EVM_SliderChanged_TSSD_Main_Bar_Size_X"
        index = 2
        MCM.SetModSettingInt("TintsOfASuccubusSecretDesires","iBarScaX:Main", (a_numArg) as int)
	elseif a_eventName == "EVM_SliderChanged_TSSD_Main_Bar_Size_Y"
        index = 3
        MCM.SetModSettingInt("TintsOfASuccubusSecretDesires","iBarScaY:Main",  (a_numArg) as int)
	elseif a_eventName == "EVM_SliderChanged_TSSD_Main_Bar_Rotation"
        index = 4
        MCM.SetModSettingInt("TintsOfASuccubusSecretDesires","iBarRota:Main", (a_numArg) as int)
    endif
    if initial_Bar_Vals[index] != a_numArg as int
        initial_Bar_Vals[index] = a_numArg as int
        UpdateBarPositions()
    endif
EndEvent

Event OniWantWidgetsReset(String eventName, String strArg, Float numArg, Form sender)
	If eventName == "iWantWidgetsReset"
        iWidgets = sender As iWant_Widgets
        tWidgetNum = iWidgets.loadMeter(initial_Bar_Vals[0], initial_Bar_Vals[1], false)
        String[] barVals = StringUtil.Split("Pos_X;Pos_Y;Size_X;Size_Y;Rotation", ";")
        int index = 0
        initial_Bar_Vals[0] = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iBarPosX:Main")
        initial_Bar_Vals[1] = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iBarPosY:Main")
        initial_Bar_Vals[2] = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iBarScaX:Main")
        initial_Bar_Vals[3] = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iBarScaY:Main")
        initial_Bar_Vals[4] = MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iBarRota:Main")
        new_Bar_Vals = CopyIntArray(initial_Bar_Vals)
        registerForModEvent("EVM_SliderMenuClosed", "OnEVM_OpenBarsClosed")
        while index < barVals.Length
            float inp = initial_Bar_Vals[index]
            registerForModEvent("EVM_SliderChanged_" + "TSSD_Main_Bar_"+barVals[index],  "TSSD_Main_Bar_"+barVals[index]+"_Event")
            TSSD_Main_Bar_Update("EVM_SliderChanged_" + "TSSD_Main_Bar_"+barVals[index], none, inp, none)
            index += 1
        endwhile
        IWidgets.setVisible(tWidgetNum, 0)
        iWidgets.setTransparency(tWidgetNum, 0)
        UpdateStatus()
        Utility.Wait(10)
        IWidgets.setVisible(tWidgetNum, (SuccubusDesireLevel.GetValue() > -101) as int)
        iWidgets.setTransparency(tWidgetNum, 100)
        UpdateBarPositions()
        UpdateStatus()
	EndIf
	RegisterForSingleUpdate(_updateTimer)
EndEvent



Event OnEVM_OpenBarsClosed(string a_eventName, string a_strArg, float a_numArg, form a_sender)
    if a_numArg == 1 
        new_Bar_Vals = DbMiscFunctions.SplitAsInt(a_strArg)
        initial_Bar_Vals = CopyIntArray(new_Bar_Vals)
        UpdateBarPositions()
        UpdateStatus()
    Endif
EndEvent