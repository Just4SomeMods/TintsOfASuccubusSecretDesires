Scriptname tssd_LibidoTrackerRefScript extends ReferenceAlias  
import tssd_utils
import PapyrusUtil
import storageutil

Float Property gameTimePassed Auto
Int Property BookNumTracker Auto
Actor Property PlayerRef Auto
GlobalVariable Property TSSD_SuccubusLibido Auto
GlobalVariable Property GameHours Auto
GlobalVariable Property SuccubusDesireLevel Auto

STRING PROPERTY SUCCUBUSLIBIDOINCREASE = "tssd.Libido.Rate" autoreadonly hidden
MagicEffect Property TSSD_BeggarLibidoDecrease Auto  
MagicEffect Property TSSD_ZenitharDonationSpellEffect Auto  
Perk Property TSSD_DeityArkayPerk Auto
Perk Property TSSD_DeityDibellaPerk Auto
Perk Property TSSD_DeityMaraPerk Auto
Perk Property TSSD_DeityStendarrPerk Auto
Perk Property TSSD_DeityZenitharPerk Auto
Perk Property TSSD_DeityAllPerk Auto

Keyword Property LocTypeInn Auto
Keyword Property LocTypePlayerHouse Auto
Keyword Property LocTypeCity Auto
Keyword Property LocTypeClearable Auto
Keyword Property LocTypeHabitation Auto
Keyword Property LocTypeHabitationHasInn Auto

Message Property TSSD_GameOverMessage Auto

;/ 
Event OnInit()
	PO3_Events_Alias.RegisterForBookRead(self)
	RegisterForTrackedStatsEvent()
	RegisterForUpdateGameTime(1)
	gameTimePassed = GameHours.GetValue()
	TSSD_SuccubusBreakRank.SetValue(0)
	GetOwningQuest().ModObjectiveGlobal(0, TSSD_SuccubusBreakRank, 1, 10)
Endevent


Event OnBookRead(Book akBook)
	float deltaDiff = Game.QueryStat("Books Read") - BookNumTracker
	if TSSD_TypeScarlet.GetValue() == 1.0 && deltaDiff > 0
		changeLibido(deltaDiff * 2)
		BookNumTracker = Game.QueryStat("Books Read")
	endif
EndEvent
  
Event OnTrackedStatsEvent(string asStatFilter, int aiStatValue)
	; int succubusType = TSSD_SuccubusType.GetValue() as int
	; if succubusType == 1 && ((asStatFilter == "Books Read")  || asStatFilter == "Skill Increases" || asStatFilter == "Locations Discovered")
    ;     Debug.Notification("Oh I gotta talk with them about that!")
	; 	changeLibido(10)
	; endif
endEvent			


Function changeLibido(float toChange)
	toChange *= MCM.GetModSettingFloat("TintsOfASuccubusSecretDesires","fAdjustLibidoGain:Libido")
	bool updatesQues = ReadInCosmeticSetting()[14]
	if TSSD_SuccubusLibido.GetValue() >= 0 &&  MCM.GetModSettingBool("TintsOfASuccubusSecretDesires","bEnableLibido:Libido")
		if toChange > 0 && PlayerRef.HasPerk(TSSD_DeityAllPerk)
			toChange /= 2
		endif
		float curVal = TSSD_SuccubusLibido.GetValue() 
		if curVal + toChange >= 0
			GetOwningQuest().ModObjectiveGlobal(toChange, TSSD_SuccubusLibido, 0, -1, true, true, updatesQues && toChange >= 1)
		else
			GetOwningQuest().ModObjectiveGlobal(curVal * -1, TSSD_SuccubusLibido, 0, -1, true, true, updatesQues && toChange <= -1)
		endif
	endif
Endfunction /;
;/ 
Event OnUpdateGameTime()
	if TSSD_SuccubusLibido.GetValue() >= 0
		int succubusType = TSSD_TypeScarlet.GetValue() as int
		Location curLoc = PlayerRef.GetCurrentLocation()
		float timeBetween = (GameHours.GetValue() - gameTimePassed) * 20
		int multiplierDecrease = 1
		if PlayerRef.HasPerk(TSSD_DeityMaraPerk) && curLoc.HasKeyword(LocTypePlayerHouse)
			multiplierDecrease += 1
		endif
		if PlayerRef.hasmagiceffect(TSSD_BeggarLibidoDecrease)
			multiplierDecrease += 1
		endif
		if PlayerRef.hasmagiceffect(TSSD_ZenitharDonationSpellEffect)   
			multiplierDecrease += 1
		endif
		if (succubusType == 0.0 && ( curLoc.HasKeyword(LocTypeInn) ||  curLoc.HasKeyword(LocTypeHabitationHasInn)) ) 
			IntListSet(PlayerRef, SUCCUBUSLIBIDOINCREASE, 1, 2)
			; DBGTrace(succubusType+"_" +curLoc.HasKeyword(LocTypeHabitationHasInn))
		else        
			IntListSet(PlayerRef, SUCCUBUSLIBIDOINCREASE, 1, 0)
		endif
		; float incr = timeBetween * ( -1 * multiplierDecrease + AddIntValues(IntListToArray (PlayerRef, SUCCUBUSLIBIDOINCREASE) ))
		changeLibido(timeBetween * -1 * multiplierDecrease)
		changeLibido(timeBetween * AddIntValues(IntListToArray (PlayerRef, SUCCUBUSLIBIDOINCREASE)))
		;
		;if TSSD_SuccubusLibido.GetValue() > 100 && SuccubusDesireLevel.GetValue() < -50
		;	Debug.Notification("Libido Break")
		;	changeLibido(-100)
		;	SuccubusDesireLevel.SetValue(100)
		;	if GetOwningQuest().ModObjectiveGlobal(1, TSSD_SuccubusBreakRank, 1, 10)
		;		int ibutton = TSSD_GameOverMessage.Show()
		;		if ibutton == 1
		;			MCM.SetModSettingBool("TintsOfASuccubusSecretDesires","bEnableLibido:Libido", false)
		;		else
		;			GetOwningQuest().SetStage(100)
		;		endif
		;
		;	endif
		;	; GetOwningQuest().SetObjectiveCompleted(0, false)
		;endif
	endIf
	gameTimePassed = GameHours.GetValue()
  endEvent /;