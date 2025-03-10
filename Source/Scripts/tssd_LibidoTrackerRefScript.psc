Scriptname tssd_LibidoTrackerRefScript extends ReferenceAlias  
import tssd_utils

Float Property gameTimePassed Auto
Int Property BookNumTracker Auto
GlobalVariable Property TSSD_SuccubusLibido Auto
GlobalVariable Property TSSD_SuccubusBreakRank Auto
GlobalVariable Property GameHours Auto
GlobalVariable Property SuccubusDesireLevel Auto

Event OnInit()
	PO3_Events_Alias.RegisterForBookRead(self)
	RegisterForTrackedStatsEvent()
	RegisterForUpdateGameTime(1)
Endevent


Event OnBookRead(Book akBook)
	float deltaDiff = Game.QueryStat("Books Read") - BookNumTracker
	if deltaDiff > 0
		IncreaseLibido(deltaDiff * 2)
		BookNumTracker = Game.QueryStat("Books Read")
	endif
EndEvent
  
Event OnTrackedStatsEvent(string asStatFilter, int aiStatValue)
	if asStatFilter == "Skill Increases" || asStatFilter == "Locations Discovered"
		IncreaseLibido(1)
	endif
endEvent

Function IncreaseLibido(float toIncrease)
	if TSSD_SuccubusLibido.GetValue() >= 0
		GetOwningQuest().ModObjectiveGlobal(toIncrease, TSSD_SuccubusLibido, 0)
	endif
Endfunction

Event OnUpdateGameTime()
	if TSSD_SuccubusLibido.GetValue() >= 0
		float deltaTime = GameHours.GetValue() - gameTimePassed
		IncreaseLibido(deltaTime * 20 )
		gameTimePassed += deltaTime
		if TSSD_SuccubusLibido.GetValue() > 100 && SuccubusDesireLevel.GetValue() < 50
			Debug.Notification("Libido Break")
			TSSD_SuccubusLibido.SetValue(0)
			GetOwningQuest().ModObjectiveGlobal(1, TSSD_SuccubusBreakRank, 1, 10)
			GetOwningQuest().SetObjectiveCompleted(0, false)
		endif
	endIf
  endEvent