Scriptname tssd_drainMarkerEffectScript extends ActiveMagicEffect  
import b512
Actor cActor

int lastChecked

Event OnEffectStart(Actor akTarget, Actor akCaster)
    
    cActor = akTarget
    RegisterForModEvent("TSSD_DrainedTargetHovered", "OnHoveredMe")
endEvent

Event OnHoveredMe(string eventName, string strArg, float numArg, Form sender)
    SkyInteract myBinding = SkyInteract_Util.GetSkyInteract()
    int thisChecked = ( (GetTimeElapsed()* 100 / getDuration()) as int)
    if (sender as Actor) == cActor && thisChecked > lastChecked + 10
        myBinding.Add("tssd_getTargetCross", cActor.GetDisplayName() + " is " + thisChecked  + "% ready" , -1)
    endif
endEvent