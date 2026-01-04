Scriptname TSSD_SucieDailyScript extends ObjectReference  

Faction Property TSSD_EnthralledFaction Auto
Faction Property TSSD_ThrallDominant Auto
Faction Property TSSD_ThrallSubmissive Auto
import tssd_utils

Event OnInit()
    RegisterForUpdateGameTime(24)
EndEvent

Event OnUpdateGameTime()
    Actor myself = self as Actor
    if myself.GetFactionRank(TSSD_EnthralledFaction) >= 0
        int switchie = Utility.RandomInt(1,3)
        myself.RemoveFromFaction(TSSD_ThrallDominant)
        myself.RemoveFromFaction(TSSD_ThrallSubmissive)
        if switchie == 2
            myself.SetFactionRank(TSSD_ThrallSubmissive,1)
        elseif switchie == 3
            myself.SetFactionRank(TSSD_ThrallDominant,1)
        endif
    endif
EndEvent
