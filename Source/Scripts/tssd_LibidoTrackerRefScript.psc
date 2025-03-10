Scriptname tssd_LibidoTrackerRefScript extends ReferenceAlias  
import tssd_utils

Int Property BookNumTracker Auto
GlobalVariable Property TSSD_SuccubusLibido Auto

Event OnInit()
	PO3_Events_Alias.RegisterForBookRead(self)
	RegisterForTrackedStatsEvent()
Endevent


Event OnBookRead(Book akBook)
	float deltaDiff = Game.QueryStat("Books Read") - BookNumTracker
	if deltaDiff > 0
		IncreaseLibido(deltaDiff * 10)
		BookNumTracker = Game.QueryStat("Books Read")
	endif
EndEvent
  
Event OnTrackedStatsEvent(string asStatFilter, int aiStatValue)
	if asStatFilter == "Skill Increases" || asStatFilter == "Locations Discovered"
		IncreaseLibido(10)
	endif
		
endEvent

Function IncreaseLibido(float toIncrease)
	if TSSD_SuccubusLibido.GetValue() >= 0
		TSSD_SuccubusLibido.Mod(toIncrease)
	endif
Endfunction