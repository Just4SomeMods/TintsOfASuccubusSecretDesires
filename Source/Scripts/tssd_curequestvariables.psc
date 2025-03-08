Scriptname tssd_curequestvariables extends Quest  Conditional

bool Property ArkayCurse Auto Conditional
bool Property DibellaCurse Auto Conditional
bool Property MaraCurse Auto Conditional
bool Property StendarrCurse Auto Conditional
bool Property ZenitharCurse Auto Conditional

Function toggleCurse(string deityName)
    if deityName == "Arkay"
        ArkayCurse = !ArkayCurse
    elseif deityName == "Mara"
        MaraCurse = !MaraCurse
    elseif deityName == "Zenithar"
        ZenitharCurse = !ZenitharCurse
    elseif deityName == "Stendarr"
        StendarrCurse = !StendarrCurse
    elseif deityName == "Dibella"
        DibellaCurse = !DibellaCurse
    endif
Endfunction