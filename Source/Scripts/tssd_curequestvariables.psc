Scriptname tssd_curequestvariables extends Quest  Conditional

bool Property ArkayCurse Auto       Conditional hidden
bool Property DibellaCurse Auto     Conditional hidden
bool Property MaraCurse Auto        Conditional hidden
bool Property StendarrCurse Auto    Conditional hidden
bool Property AkatoshCurse Auto     Conditional hidden
bool Property JulianosCurse Auto    Conditional hidden
bool Property ZenitharCurse Auto    Conditional 

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