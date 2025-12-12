Scriptname tssd_slsfrscript extends Quest  

import tssd_utils

Actor Property PlayerRef Auto

GlobalVariable Property TSSD_SuccubusTraits Auto

sslActorStats Property sslStats Auto
SexLabFramework Property SexLab Auto

Event onInit()
    RegisterForModEvent("TSSD_SuccubusTypeSelected", "CheckFlagsSLSF")
EndEvent

Function CheckFlagsSLSF()
    RegisterForModEvent("SLSF_Reloaded_ReturnModRegisteredState", "SetFlagsSLSF")
    int EventHandle = ModEvent.Create("SLSF_Reloaded_RequestModRegisterState")
    ModEvent.PushString(EventHandle, "TintsOfASuccubusSecretDesires.esp")
    ModEvent.Send(EventHandle)
Endfunction

Function SetFlagsSLSF(string modName, bool isActive)
    if modName == "TintsOfASuccubusSecretDesires.esp" 
        UnregisterForModEvent("SLSF_Reloaded_ReturnModRegisteredState")
        if !isActive
            int EventHandle = ModEvent.Create("SLSF_Reloaded_RegisterMod")
            ModEvent.PushString(EventHandle, "TintsOfASuccubusSecretDesires.esp")
            ModEvent.Send(EventHandle)
        endif
        int EventHandle
        string[] succubusTypes = GetSuccubusTypesAll()
        int typesIndex = 0
        while typesIndex < succubusTypes.Length
            int jarrayIndex = 0
            string isType = succubusTypes[typesIndex]
            string[] jsolve = JArray.asStringArray(JDB.solveObj(".tssdkinds."+isType+".famecat"))
            while jarrayIndex < jsolve.Length
                string cat = jsolve[jarrayIndex]
                EventHandle = ModEvent.Create("SLSF_Reloaded_Set" + cat + "Flag")
                ModEvent.PushString(EventHandle, "TintsOfASuccubusSecretDesires.esp")
                ModEvent.PushBool(EventHandle, false) ; TODO typesIndex == succubusType)
                ModEvent.Send(EventHandle)
                jarrayIndex += 1
            endwhile
            typesIndex += 1
        endwhile
        int traitsIndex = 0
        string[] succubusTraits = GetSuccubusTraitsAll()
        bool[] chosenTraits = GetSuccubusTraitsChosen(TSSD_SuccubusTraits, succubusTraits.Length)
        while traitsIndex < succubusTraits.Length
            int innerTraitsIndex = 0
            string[] catsFame = JArray.asStringArray(JDB.solveObj(".tssdtraits."+succubusTraits[traitsIndex]+".famecat"))
            while innerTraitsIndex < catsFame.Length
                string cat = catsFame[innerTraitsIndex]
                EventHandle = ModEvent.Create("SLSF_Reloaded_Set" + cat + "Flag")
                ModEvent.PushString(EventHandle, "TintsOfASuccubusSecretDesires.esp")
                ModEvent.PushBool(EventHandle, chosenTraits[traitsIndex])
                ModEvent.Send(EventHandle)
                innerTraitsIndex += 1
            endwhile
            traitsIndex += 1
        endwhile
    endif
Endfunction


Function onWaitPassive(float amount_of_hours)
    ;/ int sexualityPlayer = sslStats.GetSexuality(PlayerRef)
    int genderPlayer = min(Sexlab.GetSex(PlayerRef), 1) as int
    if genderPlayer == 0
        sexualityPlayer = 100 - sexualityPlayer
    endif
    int index = 0
    
    string[] succubusTypes = GetSuccubusTypesAll()
    string isType = succubusTypes[succubusType]
    string[] jsolve = JArray.asStringArray(JDB.solveObj(".tssdkinds."+isType+".famecat"))
    int jarrayIndex = 0
    Int EventHandle
    while jarrayIndex < jsolve.Length
        EventHandle = ModEvent.Create("SLSF_Reloaded_SendManualFameGain")
        ModEvent.PushString(EventHandle, jsolve[jarrayIndex])
        ModEvent.PushString(EventHandle, "Current")
        ModEvent.PushInt(EventHandle, 0) 
        ModEvent.PushInt(EventHandle, amount_of_hours as int)
        ModEvent.Send(EventHandle)
        jarrayIndex += 1
    endwhile
    string likesF = StringUtil.Split("Likes Men;Likes Women",";")[(0.5 + Utility.RandomInt(0, sexualityPlayer) / 100) as int]

    EventHandle = ModEvent.Create("SLSF_Reloaded_SendManualFameGain")
    ModEvent.PushString(EventHandle, likesF)
    ModEvent.PushString(EventHandle, "Current")
    ModEvent.PushInt(EventHandle, 0) 
    ModEvent.PushInt(EventHandle, amount_of_hours as int)
    ModEvent.Send(EventHandle)  TODO/; 
Endfunction