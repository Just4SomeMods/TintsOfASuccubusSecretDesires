Scriptname tssd_startquestscript extends ObjectReference  

import tssd_utils
Quest Property tssd_dealwithcurseQuest Auto

String Property deityName Auto
GlobalVariable Property SuccubusDesireLevel Auto

Event OnActivate(ObjectReference akActionRef)
    if SuccubusDesireLevel.GetValue() > -101 && Input.IsKeyPressed(MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iModifierHotkey:Main"))
        if !tssd_dealwithcurseQuest.IsRunning()
            tssd_dealwithcurseQuest.Start()
            ;tssd_dealwithcurseQuest.setstage(10)
            tssd_dealwithcurseQuest.setstage(20)
        else
            int objectiveSub = 0
            if deityName == "Arkay"
                objectiveSub = 23
            elseif deityName == "Mara"
                objectiveSub = 21
            elseif deityName == "Zenithar"
                objectiveSub = 25
            elseif deityName == "Stendarr"
                objectiveSub = 22
            elseif deityName == "Dibella"
                objectiveSub = 24
            endif
            if objectiveSub > 0   
                tssd_dealwithcurseQuest.SetObjectiveFailed(objectiveSub, !tssd_dealwithcurseQuest.isobjectivefailed(objectiveSub))
                tssd_dealwithcurseQuest.SetObjectiveDisplayed(objectiveSub)
                (tssd_dealwithcurseQuest as tssd_curequestvariables).toggleCurse(deityName)
            endif
        endif

    endif


EndEvent