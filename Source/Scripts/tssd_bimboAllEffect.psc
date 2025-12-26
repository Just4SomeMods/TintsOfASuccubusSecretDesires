Scriptname tssd_bimboAllEffect extends activemagiceffect  

import tssd_utils

Keyword Property ActorTypeCreature Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if !akTarget.GetRace().HasKeyword(ActorTypeCreature)
        if akTarget.IsChild() || !akTarget.GetRace().IsPlayable()
            UnregisterForModEvent("BoS_CurseAdvance_Event")
            DBGTrace("Delete " + akTarget.GetDisplayName())
        else

            CC_BimbofyNPCv2 bimboQuest = Game.GetFormFromFile(0x4dafd4, "customcomments.esp") as CC_BimbofyNPCv2
            bimboQuest.doBimbofy(GetTargetActor(), 999, -1)
            Dispel()
        endif
    endif
EndEvent
