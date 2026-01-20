Scriptname tssd_SuccubusBrands extends Quest  Conditional

import tssd_utils

bool Property tasksActive = true Auto Conditional Hidden
int Property currentTaskActive = -1 Auto Conditional Hidden
FavorDialogueScript Property DialogueFavorGeneric  Auto  
GlobalVariable Property TSSD_BrandQuestActive Auto
SexLabFramework Property SexLab Auto
Actor Property PlayerRef Auto

bool Property taskNeglected = false Auto Conditional hidden

Function activateStuff()
    RegisterForUpdateGameTime(1)
EndFunction


Event OnUpdateGameTime()
    setTaskActive(-1)
EndEvent

Function setTaskActive(int setTo = -1)
    if setTo < 1
        setTo = Utility.RandomInt(1, 5)
    EndIf
    TSSD_BrandQuestActive.SetValue(setTo)
    Utility.WaitGameTime(24)
    taskNeglected = true
EndFunction

Function doPetting(Actor akTarget)
    bool[] unstrips = new bool[33]
    unstrips[7] = true
    Form[] equips = Sexlab.StripSlots(PlayerRef, unstrips, true)
    bool[] unstripsShields = new bool[33]
    unstripsShields[9] = true
    unstripsShields[32] = true
    Sexlab.StripSlots(akTarget, unstripsShields, false)
    int randI = Utility.RandomInt(2,5)
    playAnimationWithIdle(akTarget, "5a3fB_StandA_A1_S" + randI, "5a3fB_StandA_A2_S" + randI )
    
    ; playAnimationWithIdle(akTarget, "5a3fB_Beh2_A1_S1", "5a3fB_Beh2_A2_S1" )
    Sexlab.UnstripActor(PlayerRef,equips)
EndFunction


Function doDogSpank(Actor akTarget)
    bool[] unstrips = new bool[33]
    unstrips[0] = true
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
    int randI = Utility.RandomInt(2,4)
    playAnimationWithIdle(akTarget, "5a3fB_SpankDog_A1_S" + randI, "5a3fB_SpankDog_A2_S" + randI)
    Sexlab.UnstripActor(PlayerRef,equips)
EndFunction

Function TasksTold(string taskTold, Actor talkerLel)
    DBGTrace(taskTold)
    if taskTold == "TSSD_Tasks_01"
        increaseFame("Slut")
    ElseIf taskTold == "TSSD_Tasks_02"
        increaseFame("Dirty")
    ElseIf taskTold == "TSSD_Tasks_03"
        DialogueFavorGeneric.Brawl(talkerLel)
        Utility.Wait(10)
        increaseFame("Masochist")
    ElseIf taskTold == "TSSD_Tasks_04"
        increaseFame("Whore")
    endif
    TSSD_BrandQuestActive.SetValue(-1)
EndFunction

Function increaseFame(string NameOf)
    Int EventHandle
    EventHandle = ModEvent.Create("SLSF_Reloaded_SendManualFameGain")
    ModEvent.PushString(EventHandle, NameOf)
    ModEvent.PushString(EventHandle, "Current")
    ModEvent.PushInt(EventHandle, 0) 
    ModEvent.PushInt(EventHandle, 10)
    ModEvent.Send(EventHandle)
EndFunction