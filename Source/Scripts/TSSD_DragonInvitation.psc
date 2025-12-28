Scriptname TSSD_DragonInvitation extends activemagiceffect  

Keyword Property ActorTypeDragon Auto
SexLabFramework Property SexLab Auto
Faction Property TSSD_MarkedForDeathFaction Auto
Actor Property PlayerRef Auto
import tssd_utils

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Actor[] cT = PO3_SKSEFunctions.GetCombatTargets(PlayerRef)
    int indexIn = 0
    while indexIn < cT.Length
        Actor cAct = cT[indexIn]
        DBGTrace(cAct.GetDisplayName() + " " + cAct.HasKeyword(ActorTypeDragon))
        if cAct.HasKeyword(ActorTypeDragon) && cAct.GetAV("Health") < 300
            if (SexLab.StartSceneQuick(cAct, PlayerRef)) == none
                cAct.Kill(PlayerRef)
            else
                cAct.SetFactionRank(TSSD_MarkedForDeathFaction, 1)
            endif
            
            indexIn = 99
        endif
        indexIN += 1
    endwhile


EndEvent