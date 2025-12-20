Scriptname tssd_PlayerEventsScript extends ReferenceAlias


import tssd_utils

float lastGameHour = 999.0

tssd_actions Property tActions Auto
tssd_menus Property tMenus Auto
Quest Property tssd_tints_tracker Auto
tssd_tints_variables Property tVals Auto
Actor Property PlayerRef Auto
GlobalVariable Property TSSD_TypeMahogany Auto
Spell Property tssd_Satiated Auto
MagicEffect Property TSSD_SatiatedEffect Auto
GlobalVariable Property SkillSuccubusDrainLevel Auto
SexLabFramework Property SexLab Auto
Form Property Gold001 Auto
GlobalVariable Property gamehour Auto

int[] colorsToAdd

float[] Property targetNums Auto
float[] Property currentVals Auto

Faction Property TSSD_RevealingOutfit Auto
Faction Property TSSD_Collared Auto

bool isActingDefeated = false
float totalDamageTaken = 0.0
bool[] Property colorsChecked Auto Hidden 
bool crimsonDone = false

; Begin Blush
Faction Property sla_Arousal Auto
; End Blush

String Property FILE_SCHLONGS_OF_SKYRIM = "Schlongs of Skyrim.esp" AutoReadOnly Hidden 
Faction Property SOS_SchlongifiedFaction Auto Hidden

; BEGIN AND

String Property FILE_AND = "Advanced Nudity Detection.esp" AutoReadOnly Hidden 
Bool Property ANDFound = False Auto Hidden Conditional
Faction Property AND_ShowingAssFaction Auto Hidden
Faction Property AND_ShowingChestFaction Auto Hidden
Faction Property AND_ShowingGenitalsFaction Auto Hidden
Faction Property AND_ShowingBraFaction Auto Hidden
Faction Property AND_ShowingUnderwearFaction Auto Hidden
Faction Property AND_ToplessFaction Auto Hidden
Faction Property AND_BottomlessFaction Auto Hidden
Faction Property AND_NudeActorFaction Auto Hidden

; END AND

; BEGIN ZAD

Keyword Property zbfWornCollar Auto Hidden
String Property FILE_ZAZ_ANIMATION_PACK = "ZaZAnimationPack.esm" AutoReadOnly  
Bool Property ZaZAnimationPackFound = False Auto Hidden Conditional

; END ZAD

; BEGIN DD
String Property FILE_DD_ASSETS = "Devious Devices - Assets.esm" AutoReadOnly  
Bool Property DDAssetsFound = False Auto Hidden Conditional
Keyword Property zad_DeviousCollar Auto Hidden 
; END DD

; BEGIN LILAC

Faction Property CompanionsCirclePlusKodlak Auto
Faction Property WereWolfFaction Auto
Faction Property WolfFaction Auto
bool isLilac
bool isCollared
float lastTimeNeededCollar = 0.0

Race Property WolfRace Auto
Race Property WereWolfBeastRace Auto

Perk Property Tssd_tint_Lilac2 Auto

; END LILAC

; BEGIN CARNATION
Faction Property TSSD_BellyWithEggs Auto
; END CARNATION

; BEGIN BIMBO

String Property FILE_CC = "CustomComments.esp" AutoReadOnly Hidden 
bool bimboFound
Quest Property CC_BimbofyPlayer Auto Hidden

; END BIMBO


; BEGIN CUPID
import storageutil

String Property CUM_VAGINAL = "sr.inflater.cum.vaginal" autoreadonly hidden
String Property CUM_ANAL = "sr.inflater.cum.anal" autoreadonly hidden
String Property CUM_ORAL = "sr.inflater.cum.oral" autoreadonly hidden
String Property INFLATION_AMOUNT = "sr.inflater.amount" autoreadonly hidden

GlobalVariable Property TSSD_CumAmountAV Auto

Function calcCumAmountPlayer()
	float infAmount = GetFloatValue(PlayerRef, INFLATION_AMOUNT) 
	TSSD_CumAmountAV.SetValue( max(0.5, 1 / max(1,infAmount/ 3 )))
	tVals.cupidFilledUpAmount = infAmount
	
EndFunction

; END CUPID

; BEGIN TOLOPEA
Faction Property TSSD_HypnoMaster Auto
; END TOLPEA

; BEGIN MAROON

String Property FILE_FADE_TATS = "FadeTattoos.esp" AutoReadOnly  

; END MAROON

Function incrValAndCheck(int numOf, float incrBy)
	currentVals[numOf] += incrBy
	checkValOf(numOf)
	if numOf == 0 tVals.lastCumOnTime = 0.1 endif
	if numOf == 1 tVals.lastCumInMe = 0.1 endif
	if numOf == 3 tVals.lastRomanticTime = 0.1 endif
	
	if numOf == 13 tVals.lastSpankedTime = 0.1 endif
	if numOf == 15 tVals.lastPraiseTime = 0.1 endif
	if numOf == 22 tVals.lastRoughTime = 0.1 endif
EndFunction

Function checkValOf( int numOf )
	int toAdd = 0
	if numOf == 12
		toAdd += Game.QueryStat("Potions Used") + Game.QueryStat("Ingredients Eaten")
	endif
	if !tVals.canTakeBools[numOf] && (currentVals[numOf] + toAdd) >= targetNums[numOf]
		tMenus.ShowSuccubusTrait(numOf)
	endif
endfunction


Function OnOrgasmAny(Actor WhoCums, int Thread)
	
    sslThreadController _thread =  Sexlab.GetController(Thread)
	if WhoCums != PlayerRef 
		if WhoCums.GetFactionRank(CompanionsCirclePlusKodlak) >=0 || WhoCums.GetFactionRank(WereWolfFaction) > 0 || \
				WhoCums.GetFactionRank(WolfFaction) > 0 || WhoCums.GetRace() == WolfRace || WhoCums.GetRace() == WereWolfBeastRace 
			tVals.lastWolfSex = 0.1
		endif
		if WhoCums.GetRelationshipRank(PlayerRef) >= 1
			incrValAndCheck(19,1)
		endif

		if WhoCums.GetFactionRank(SOS_SchlongifiedFaction) > 0
			if _thread.HasSceneTag("cuminmouth") || _thread.HasSceneTag("blowjob")
				incrValAndCheck(12,1)
				incrValAndCheck(1,1)
			elseif _thread.HasSceneTag("vaginal") || _thread.HasSceneTag("anal")
				incrValAndCheck(1,1)
			elseif _thread.HasSceneTag("aircum") || _thread.HasSceneTag("cumonchest") || _thread.HasSceneTag("cumonbody")
				incrValAndCheck(0,1)
			endif
			calcCumAmountPlayer()
		endif
		if WhoCums.GetHighestRelationshiprank() == 3 && !tVals.canTake02Lavenderblush
			incrValAndCheck(2,1)
		endif
		if _thread.HasSceneTag("love") || _thread.HasSceneTag("loving") || _thread.HasSceneTag("romance")
			incrValAndCheck(3,1)
		endif
		if _thread.SameSexThread()
			incrValAndCheck(4,1)
		endif

	else
		if _thread.HasSceneTag("spanking")
			incrValAndCheck(13,1)
		endif
		if _thread.GetSubmissive(PlayerRef)
			incrValAndCheck(20,1)
			if Game.GetModByName(FILE_FADE_TATS) != 255
				incrValAndCheck(8,1)
			endif
		endif
		if _thread.HasSceneTag("rough")
			incrValAndCheck(22,1)
		endif
	endif
EndFunction

;/ Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    if UI.IsMenuOpen("Dialogue Menu") || UI.IsMenuOpen("Barter Menu")
		incrValAndCheck(16, aiItemCount)
    endif

endEvent /;



Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, \
    bool abBashAttack, bool abHitBlocked)
    if PlayerRef.GetAV("Health") < 100 && PlayerRef.HasMagicEffect(TSSD_SatiatedEffect) && (akAggressor as Actor) && \
        (akAggressor as Actor).GetAv("Health") < tActions.getDrainLevel() && !isActingDefeated
		isActingDefeated = true
        Actor tar = tActions.getLonelyTarget()
        if tar && tar != PlayerRef
            tActions.actDefeated(tar, false)
        Endif
		isActingDefeated = false
    endif
    Weapon akW = akSource as Weapon
    if TSSD_TypeMahogany.GetValue() == 1.0 && akW != none && !abHitBlocked
        tActions.gainSuccubusXP(akW.GetBaseDamage() * 20 )
    endif
	incrValAndCheck(14, akW.GetBaseDamage())
	
EndEvent

Function onGameReload()
	isActingDefeated = false
	crimsonDone = false
	lastGameHour = gamehour.GetValue()
    If (Game.GetModByName(FILE_AND) != 255)
		ANDFound = True
		AND_NudeActorFaction = Game.GetFormFromFile(0x831, FILE_AND) as Faction
		AND_ToplessFaction = Game.GetFormFromFile(0x832, FILE_AND) as Faction
		AND_BottomlessFaction = Game.GetFormFromFile(0x833, FILE_AND) as Faction
		AND_ShowingBraFaction = Game.GetFormFromFile(0x834, FILE_AND) as Faction
		AND_ShowingChestFaction = Game.GetFormFromFile(0x82F, FILE_AND) as Faction
		AND_ShowingUnderwearFaction = Game.GetFormFromFile(0x835, FILE_AND) as Faction
		AND_ShowingGenitalsFaction = Game.GetFormFromFile(0x830, FILE_AND) as Faction
		AND_ShowingAssFaction = Game.GetFormFromFile(0x82E, FILE_AND) as Faction
		RegisterForModEvent("AdvancedNudityDetectionUpdate", "OnANDUpdate")
	Else
		ANDFound = False
		AND_NudeActorFaction = none
		AND_ToplessFaction = none
		AND_BottomlessFaction = none
		AND_ShowingBraFaction = none
		AND_ShowingChestFaction = none
		AND_ShowingUnderwearFaction = none
		AND_ShowingGenitalsFaction = none
		AND_ShowingAssFaction = none
		UnregisterForModEvent("AdvancedNudityDetectionUpdate")
	EndIf
	If (Game.GetModByName(FILE_ZAZ_ANIMATION_PACK) != 255)
		ZaZAnimationPackFound = True
		zbfWornCollar = Game.GetFormFromFile(0x8A4E, FILE_ZAZ_ANIMATION_PACK) as Keyword
		PO3_Events_Alias.RegisterForShoutAttack(self)
	Else
		ZaZAnimationPackFound = False
		zbfWornCollar = none
	endif

	If (Game.GetModByName(FILE_DD_ASSETS) != 255)
		DDAssetsFound = True
		zad_DeviousCollar = Game.GetFormFromFile(0x3DF7, FILE_DD_ASSETS) as Keyword
		PO3_Events_Alias.RegisterForShoutAttack(self)
	Else
		DDAssetsFound = False
		zad_DeviousCollar = none
	EndIf

	If (Game.GetModByName(FILE_SCHLONGS_OF_SKYRIM) != 255)
		SOS_SchlongifiedFaction = Game.GetFormFromFile(0xAFF8, FILE_SCHLONGS_OF_SKYRIM) as Faction
	Else
		SOS_SchlongifiedFaction = none
	EndIf
	If (Game.GetModByName(FILE_CC) != 255)
		CC_BimbofyPlayer = Game.GetFormFromFile(0x303FAE, FILE_CC) as Quest
		bimboFound = true
	endif
	if !tVals.canTakeBools[21] && PlayerRef.HasPerk(tMenus.SuccubusTintPerks[0]) && PlayerRef.HasPerk(tMenus.SuccubusTintPerks[1])
		tMenus.ShowSuccubusTrait(21)
	endif
	if PlayerRef.HasPerk(tMenus.SuccubusTintPerks[6])
		addToLilac()
	endif

	RegisterForUpdateGameTime(0.5)
	RegisterForTrackedStatsEvent()
	RegisterForMenu("BarterMenu")

	if !tVals.canTakeBools[10]
		RegisterForModEvent("CurseOfLife_EggLaid","EggLaid")
	endif
	if PlayerRef.HasPerk(tMenus.SuccubusTintPerks[10])
		RegisterForModEvent("CurseOfLife_Updated", "OnCOLUpdated")
	endif

EndFunction


function OnCOLUpdated(form t)
  actor victim = t as actor
  int isFull = (StorageUtil.GetFloatValue(none, "CurseOfLife_BellyCurrentSize", 0.0) > 0) as int
  isFull += (StorageUtil.GetFloatValue(none, "CurseOfLife_CharusCurrentSize", 0.0) + StorageUtil.GetFloatValue(none, "CurseOfLife_SpiderCurrentSize", 0.0) > 0) as int
  PlayerRef.SetFactionRank(TSSD_BellyWithEggs, isFull)
  
endfunction

Function EggLaid(form actorFrom, form egg, int numReleased)
	if  actorFrom as actor == PlayerRef
		incrValAndCheck(10, 1)
		UnregisterForModEvent("CurseOfLife_EggLaid")
		if PlayerRef.HasPerk(tMenus.SuccubusTintPerks[10])
			RegisterForModEvent("CurseOfLife_Updated", "OnCOLUpdated")
		endif
	endif
endfunction

Function addToLilac()
	isLilac = true
	PO3_Events_Alias.RegisterForShoutAttack(self)
	PlayerRef.SetFactionRank(WereWolfFaction, 0)
	PlayerRef.SetFactionRank(WolfFaction, 0 )
EndFunction

Event OnMenuOpen(String MenuName)
	if MenuName == "BarterMenu"
		incrValAndCheck(16,1)
	endif
EndEvent

Event OnTrackedStatsEvent(string asStatFilter, int aiStatValue)
	DBGTRACE(asStatFilter)
    if (asStatFilter == "Ingredients Eaten")
		Debug.MessageBox("YUM")
    endif
endEvent


Event OnUpdateGameTime()
	if !tssd_tints_tracker.IsStageDone(5) && PlayerRef.GetFactionRank(sla_Arousal) > 90
		incrValAndCheck(5,1)
	else
		currentVals[5] = 0
	endif

	if bimboFound && CC_BimbofyPlayer.IsStageDone(20)
		tMenus.ShowSuccubusTrait(9)
	endif

	if IsTopless && IsBottomless
		incrValAndCheck(7, 1)
	else
		currentVals[7] = 0
	endif

	if IsSkimpilyClothed
		incrValAndCheck(17, 1)
	else
		currentVals[17] = 0
	endif

	int indexIn = 0
	string outPut = ""
	while indexIN < currentVals.Length
		int toAdd = 0
		if indexIn == 12
			toAdd = Game.QueryStat("Potions Used") + Game.QueryStat("Ingredients Eaten")
		endif
		outPut += indexIN + ": " + ((currentVals[indexIN] as int) + toAdd) + "/" + (targetNums[indexIN] as int) + " || "
		indexIN += 1
	endwhile
	DBGTRACE(outPut)
	calcCumAmountPlayer()
	float gameTimeDiff = max(0.5, gamehour.GetValue() - lastGameHour)
	;tVals.cupidFilledUpAmount += gameTimeDiff
	tVals.lastCumOnTime += gameTimeDiff
	tVals.lastPraiseTime += gameTimeDiff
	tVals.lastRoughTime += gameTimeDiff
	tVals.lastSpankedTime += gameTimeDiff
	tVals.lastRomanticTime += gameTimeDiff
	tVals.lastCumInMe += gameTimeDiff
	tVals.lastWolfSex += gameTimeDiff
	tVals.lastHypnoSession += gameTimeDiff
	tVals.lastFadeTat += gameTimeDiff

	if tVals.lastFadeTat > 24
		int handle = ModEvent.Create("RapeTattoos_addTattooV2")
		if (handle)
			ModEvent.PushForm(handle, PlayerRef)
			ModEvent.PushInt(handle, 1)
			ModEvent.Send(handle)
		endIf
	endif

	if isLilac && !isCollared
		T_Show("I miss my collar...", "menus/TSSD/small/lilac.dds")
	endif
	if isLilac  && tVals.lastWolfSex > 7 * 24 && PlayerRef.HasPerk(Tssd_tint_Lilac2)
		T_Needs(6)
	endIf
	DBGTRACE(tVals.lastHypnoSession + " " + lastGameHour)
	if PlayerRef.HasPerk(tMenus.SuccubusTintPerks[18]) && tVals.lastHypnoSession > 24 && !PlayerRef.IsInCombat()
		Actor[] allActs = PO3_SKSEFunctions.GetAllActorsInFaction(TSSD_HypnoMaster)
		DBGTRACE(allActs.Length)
		Actor cTarget = allActs[Utility.RandomInt(0, allActs.Length-1)]
		T_Needs(18, cTarget.GetDisplayName())
		Sexlab.StartSceneQuick(PlayerRef)
	endif
EndEvent

Event OnInit()
	
	lastGameHour = gamehour.GetValue()
endEvent


Event OnPlayerShoutAttack(Shout akShout)
	if isLilac
		T_Show("Bark Bark!", "menus/TSSD/small/lilac.dds")
	elseif !tVals.canTakeBools[6] && playerRef.GetFactionRank(TSSD_Collared) >= 1
		PO3_Events_Alias.UnregisterForShoutAttack(self)
		
		incrValAndCheck(6, 1)

	endif
EndEvent

Bool Function IsPlayerSkimpy()
    return (!IsNaked && (IsShowingChest || IsShowingGenitals || IsShowingAss || IsTopless || IsBottomless || IsShowingBra || IsShowingUnderwear))
EndFunction


Event OnANDUpdate()
    Actor Player = PlayerRef    
    IsNaked = IsActorNude(PlayerRef)
    IsShowingBra =      IsActorShowingBra(PlayerRef)
    IsShowingChest =    IsActorShowingChest(PlayerRef)
    IsShowingUnderwear =IsActorShowingUnderwear(PlayerRef)
    IsShowingGenitals = IsActorShowingGenitals(PlayerRef)
    IsShowingAss =      IsActorShowingAss(PlayerRef)
    IsTopless =         IsActorTopless(PlayerRef)
    IsBottomless =      IsActorBottomless(PlayerRef)
    IsSkimpilyClothed = IsPlayerSkimpy()
	isCollared = IsActorCollared(PlayerRef)
    PlayerRef.SetFactionRank(TSSD_RevealingOutfit, IsPlayerRevealing() as int )
    PlayerRef.SetFactionRank(TSSD_Collared, isCollared  as int )

EndEvent


Bool Function IsActorNude(Actor akActor)
	return akActor.GetFactionRank(AND_NudeActorFaction) == 1
EndFunction

Bool Function IsActorTopless(Actor akActor)
	return akActor.GetFactionRank(AND_ToplessFaction) == 1
EndFunction

Bool Function IsActorBottomless(Actor akActor)
	return akActor.GetFactionRank(AND_BottomlessFaction) == 1
EndFunction

Bool Function IsActorShowingBra(Actor akActor)
	return akActor.GetFactionRank(AND_ShowingBraFaction) == 1
EndFunction

Bool Function IsActorShowingChest(Actor akActor)
	return akActor.GetFactionRank(AND_ShowingChestFaction) == 1
EndFunction

Bool Function IsActorShowingUnderwear(Actor akActor)
	return akActor.GetFactionRank(AND_ShowingUnderwearFaction) == 1
EndFunction

Bool Function IsActorShowingGenitals(Actor akActor)
	return akActor.GetFactionRank(AND_ShowingGenitalsFaction) == 1
EndFunction

Bool Function IsActorShowingAss(Actor akActor)
	return akActor.GetFactionRank(AND_ShowingAssFaction) == 1
EndFunction

Bool Function IsPlayerRevealing()
	return !IsNaked && (IsShowingBra || IsShowingUnderwear ||  IsShowingAss)
EndFunction


Bool Function IsActorCollared(Actor akActor)
	If (akActor.WornHasKeyword(zad_DeviousCollar))
		return True
	ElseIf (ZaZAnimationPackFound && akActor.WornHasKeyword(zbfWornCollar))
		return True
	EndIf
	return False
EndFunction 


Bool Property IsNaked = False Auto Conditional Hidden 
Bool Property IsSkimpilyClothed = False Auto Conditional Hidden 
Bool Property IsTopless = False Auto Conditional Hidden
Bool Property IsBottomless = False Auto Conditional Hidden
Bool Property IsShowingBra = False Auto Conditional Hidden
Bool Property IsShowingChest = False Auto Conditional Hidden
Bool Property IsShowingUnderwear = False Auto Conditional Hidden
Bool Property IsShowingGenitals = False Auto Conditional Hidden
Bool Property IsShowingAss = False Auto Conditional Hidden
Bool Property IsArmed = False Auto Conditional Hidden 
Bool Property IsArmored = False Auto Conditional Hidden 


