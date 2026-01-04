Scriptname tssd_curequestvariables extends Quest  Conditional

bool Property ArkayCurse Auto       Conditional hidden
bool Property DibellaCurse Auto     Conditional hidden
bool Property MaraCurse Auto        Conditional hidden
bool Property StendarrCurse Auto    Conditional hidden
bool Property AkatoshCurse Auto     Conditional hidden
bool Property JulianosCurse Auto    Conditional hidden
bool Property ZenitharCurse Auto    Conditional hidden



bool Property AlduinDone Auto       Conditional Hidden
bool Property DibellaDone Auto      Conditional Hidden
bool Property MaraDone Auto         Conditional Hidden
bool Property JhunalDone Auto       Conditional Hidden
bool Property KynarethDone Auto     Conditional Hidden


Function completeQuest(int index)
    if index == 0
        MaraDone = true
    elseif index == 1
        KynarethDone = true
    elseif index == 2
        JhunalDone = true
    elseif index == 3
        DibellaDone = true
    else
        AlduinDone = true
    endif
EndFunction

Function toggleCurse(string deityName)
    if deityName == "Arkay"
        ArkayCurse = !ArkayCurse
    elseif deityName == "Akatosh"
        AkatoshCurse = !AkatoshCurse
    elseif deityName == "Julianos"
        JulianosCurse = !JulianosCurse
    elseif deityName == "Zenithar"
        ZenitharCurse = !ZenitharCurse
    elseif deityName == "Stendarr"
        StendarrCurse = !StendarrCurse
    elseif deityName == "Dibella"
        DibellaCurse = !DibellaCurse
    endif
Endfunction
