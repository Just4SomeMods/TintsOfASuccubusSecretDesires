Scriptname tssd_drainMarkerEffectScript extends ActiveMagicEffect  
import b512
Actor cActor
Actor Property PlayerRef Auto
Spell Property TSSD_Satiated Auto
Perk Property TSSD_Tint_Scarlet Auto
import tssd_utils
GlobalVariable Property GameHour Auto
GlobalVariable Property timescale Auto
ImageSpaceModifier Property AzuraFadeToBlack  Auto 
Spell Property TSSD_DrainedMarker Auto

int lastChecked
Spell Property TSSD_CharmToPlace Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    
    cActor = akTarget
    RegisterForModEvent("TSSD_DrainedTargetHovered", "OnHoveredMe")
    RegisterForModEvent("TSSD_WaitReadyTime", "OnAskedWaitTime")    
    RegisterForSingleUpdateGameTime((getDuration() / 3600) * TimeScale.GetValue())
    akTarget.DispelSpell(TSSD_CharmToPlace)
endEvent

Event OnHoveredMe(string eventName, string strArg, float numArg, Form sender)
    if self
        SkyInteract myBinding = SkyInteract_Util.GetSkyInteract()
        int thisChecked = ( ((getDuration() - GetTimeElapsed()) / 3600 * (timescale.GetValue() )) as int)
        if (sender as Actor) == cActor
            myBinding.Add("tssd_getTargetCross", "                         ready in "+ thisChecked  + " h" , -1)
        endif
    endif
endEvent

Event OnAskedWaitTime(string eventName, string strArg, float numArg, Form sender)
    if (sender as Actor)
        
        AzuraFadeToBlack.Apply()
        
        GameHour.Mod((getDuration() - GetTimeElapsed()) / 3600 * (timescale.GetValue() ))
        if PlayerRef.HasPerk(TSSD_Tint_Scarlet)
            TSSD_Satiated.Cast(PlayerRef,PlayerRef)
        EndIf
        Utility.Wait(0.1)
        GameHour.Mod(0.01)
        if self && self != none
            ImageSpaceModifier.RemoveCrossFade(3)
            SkyInteract myBinding = SkyInteract_Util.GetSkyInteract()
            myBinding.Remove("tssd_getTargetCross")
        endif
    endif
EndEvent


Event OnUpdateGameTime()
    Dispel()
    cActor.DispelSpell(TSSD_DrainedMarker)
endEvent