Scriptname tssd_smoochscript extends activemagiceffect  

SexLabFramework Property SexLab Auto
Actor Property PlayerRef Auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
    tssd_actions actionsScript = Quest.GetQuest("tssd_queststart") as tssd_actions
    Actor targetRef = Game.GetCurrentCrosshairRef() as Actor
    if targetRef
        actionsScript.addToSmooching(10.0)
        SexLab.StartSceneQuick(PlayerRef, targetRef, asTags="kissing, limitedstrip, -sex")
        sslThreadController _thread =  Sexlab.GetPlayerController()
        _thread.SetNoStripping(PlayerRef)
        _thread.SetNoStripping(targetRef)
    endif
endEvent