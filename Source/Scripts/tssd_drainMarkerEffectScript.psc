Scriptname tssd_drainMarkerEffectScript extends ActiveMagicEffect  
import b512
Actor cActor
import tssd_utils
GlobalVariable Property GameHour Auto
GlobalVariable Property timescale Auto
ImageSpaceModifier Property AzuraFadeToBlack  Auto  

int lastChecked

Event OnEffectStart(Actor akTarget, Actor akCaster)
    
    cActor = akTarget
    RegisterForModEvent("TSSD_DrainedTargetHovered", "OnHoveredMe")
    RegisterForModEvent("TSSD_WaitReadyTime", "OnAskedWaitTime")    
endEvent

Event OnHoveredMe(string eventName, string strArg, float numArg, Form sender)
    if self
        SkyInteract myBinding = SkyInteract_Util.GetSkyInteract()
        int thisChecked = ( (GetTimeElapsed()* 100 / getDuration()) as int)
        if (sender as Actor) == cActor
            myBinding.Add("tssd_getTargetCross", "                         "+ thisChecked  + "% ready" , -1)
        endif
    endif
endEvent

Event OnAskedWaitTime(string eventName, string strArg, float numArg, Form sender)
    if (sender as Actor)
            
        AzuraFadeToBlack.Apply()
        
        GameHour.Mod((getDuration() - GetTimeElapsed()) / 3600 * (timescale.GetValue() ))
        Utility.Wait(0.1)
        Dispel()
        ImageSpaceModifier.RemoveCrossFade(3)
        SkyInteract myBinding = SkyInteract_Util.GetSkyInteract()
        myBinding.Remove("tssd_getTargetCross")
    endif
EndEvent