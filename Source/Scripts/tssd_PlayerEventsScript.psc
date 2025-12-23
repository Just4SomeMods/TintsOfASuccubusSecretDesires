Scriptname tssd_PlayerEventsScript extends ReferenceAlias


import tssd_utils

float lastGameHour = 999.0

tssd_actions Property tActions Auto
tssd_menus Property tMenus Auto
Quest Property tssd_tints_tracker Auto
tssd_tints_variables Property tVals Auto
Actor Property PlayerRef Auto

Spell Property tssd_Satiated Auto
MagicEffect Property TSSD_SatiatedEffect Auto

GlobalVariable Property SkillSuccubusBaseLevel Auto
GlobalVariable Property SkillSuccubusBodyLevel Auto
GlobalVariable Property SkillSuccubusDrainLevel Auto
GlobalVariable Property SkillSuccubusSeductionLevel Auto
SexLabFramework Property SexLab Auto
Form Property Gold001 Auto
Form Property ReligiousMaraLove Auto
GlobalVariable Property gamehour Auto

Perk Property TSSD_Body_ArousingBody Auto
Perk Property TSSD_Body_StunningBody Auto

int[] colorsToAdd

float[] Property targetNums Auto
float[] Property currentVals Auto

Faction Property TSSD_RevealingOutfit Auto
Faction Property TSSD_Collared Auto

bool isActingDefeated = false
float totalDamageTaken = 0.0
bool[] Property colorsChecked Auto Hidden 
bool crimsonDone = false

Keyword Property LocTypeInn Auto
Keyword Property LocTypePlayerHouse Auto
Keyword Property LocTypeStore Auto
Keyword Property ActorTypeCreature Auto

Perk Property TSSD_DeityArkayPerk Auto
Perk Property TSSD_DeityMaraPerk Auto
Perk Property TSSD_Tint_Scarlet Auto

Quest Property TSSD_EvilSuccubusQuest Auto
Quest Property tssd_dealwithcurseQuest Auto

GlobalVariable Property TSSD_InnocentsSlain Auto

Spell Property TSSD_DrainHealth Auto
Spell Property TSSD_InLoveBuff Auto
Spell Property MarriageRested Auto

Faction Property TSSD_MarkedForDeathFaction Auto

float lastNeedsAnnouncement

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
	float infAmount = GetFloatValue(PlayerRef, INFLATION_AMOUNT) + GetFloatValue(PlayerRef, CUM_ORAL) + GetFloatValue(PlayerRef, CUM_ANAL) + GetFloatValue(PlayerRef, CUM_VAGINAL)
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


bool hadAnnouncement = false
int[] possibleAnnouncements

; BEGIN MARA

bool maraSuccess = false

; END MARA


Function incrValAndCheck(int numOf, float incrBy)
	currentVals[numOf] += incrBy
	checkValOf(numOf)
	if numOf == 0 tVals.lastCumOnTime = 0.1 endif
	if numOf == 1 tVals.lastCumInMe = 0.1 endif
	if numOf == 3 tVals.lastRomanticTime = 0.1 endif
	
	if numOf == 13 tVals.lastSpankedTime = 0.1 endif
	if numOf == 15 tVals.lastPraiseTime = 0.1 endif
	if numOf == 22 tVals.lastRoughTime = 0.1 endif
	if playerRef.HasPerk(tMenus.SuccubusTintPerks[numOf])
		if numOf != 19 && numOf != 18
			possibleAnnouncements = PapyrusUtil.PushInt(possibleAnnouncements, numOf)
			if !tssd_tints_tracker.IsObjectiveFailed(numOf)
				tssd_tints_tracker.SetObjectiveFailed(numOf, false)
			endif
		endif
		if numOf == 19
			PlayerRef.DispelSpell(TSSD_InLoveBuff)
			Utility.Wait(0.1)
			TSSD_InLoveBuff.Cast(PlayerRef,PlayerRef)
		endif
	endif
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

Function OnOrgasmAny(Form ActorRef_Form, int Thread)
	
    Actor WhoCums = ActorRef_Form as Actor
    sslThreadController _thread =  Sexlab.GetController(Thread)
    if _thread != Sexlab.GetPlayerController()
        if PlayerRef.GetDistance(WhoCums) < 100
            tActions.gainSuccubusXP(100)
        endif
        return
    endif
	
	if WhoCums != PlayerRef 
		if tssd_dealwithcurseQuest.isRunning() && !tssd_dealwithcurseQuest.isobjectivefailed(24) ; Dibella
			if !_thread.GetSubmissive(PlayerRef)
				tActions.increaseGlobalDeity(3,10,1000)
			else
				tActions.increaseGlobalDeity(8,5,1000)
			endif
		endif
			
		if WhoCums.GetFactionRank(CompanionsCirclePlusKodlak) >=0 || WhoCums.GetFactionRank(WereWolfFaction) > 0 || \
				WhoCums.GetFactionRank(WolfFaction) > 0 || WhoCums.GetRace() == WolfRace || WhoCums.GetRace() == WereWolfBeastRace 
			tVals.lastWolfSex = 0.1
		endif
		if WhoCums.GetFactionRank(TSSD_HypnoMaster) >=0 
			tVals.lastHypnoSession = 0.1
		endif
		if WhoCums.GetRelationshipRank(PlayerRef) >= 1
			incrValAndCheck(19,1)
		endif
		if WhoCums.GetRelationshipRank(PlayerRef) >= 4
			if PlayerRef.HasPerk(TSSD_DeityMaraPerk)
				MarriageRested.Cast(PlayerRef,PlayerRef)
			endif
		endif

		if WhoCums.GetFactionRank(SOS_SchlongifiedFaction) > 0
			if _thread.HasSceneTag("cuminmouth") || _thread.HasSceneTag("blowjob")
				incrValAndCheck(12,1)
				incrValAndCheck(1,1)
			elseif (_thread.HasSceneTag("vaginal") || _thread.HasSceneTag("anal")) &&  !_thread.HasSceneTag("lesbian")
				incrValAndCheck(1,1)
			elseif _thread.HasSceneTag("aircum") || _thread.HasSceneTag("cumonchest") || _thread.HasSceneTag("cumonbody")
				incrValAndCheck(0,1)
			endif
		endif
		if !issingle( WhoCums)
			incrValAndCheck(2,1)
		endif
		if tActions.deathModeActivated
			int StageCount = SexLabRegistry.GetPathMax(   _Thread.getactivescene()  , "").Length
			int Stage_in = StageCount   - SexLabRegistry.GetPathMax(_Thread.getactivescene() ,_Thread.GetActiveStage()).Length + 1
			float drainLevel = tActions.getDrainLevel()
			float succdVal = min(WhoCums.GetAV("Health"), drainLevel )
			if succdVal <= drainLevel
				WhoCums.setAV("Health", 10000)
				WhoCums.SetFactionRank(TSSD_MarkedForDeathFaction, 1)
				WhoCums.SetAv("Confidence", 0)
			endif
			TSSD_DrainHealth.SetNthEffectMagnitude(0, succdVal )
			TSSD_DrainHealth.Cast(PlayerRef, WhoCums)
			int reduction = 10
			if WhoCums.GetRelationshipRank(playerref) >= 0 && succdVal >= WhoCums.GetAV("Health") && !WhoCums.isHostileToActor(PlayerRef)
				TSSD_EvilSuccubusQuest.ModObjectiveGlobal(1, TSSD_InnocentsSlain)
				if !TSSD_EvilSuccubusQuest.IsRunning()
					TSSD_EvilSuccubusQuest.Start()
					TSSD_EvilSuccubusQuest.SetCurrentStageID(10)
				endif
			elseif PlayerRef.HasPerk(TSSD_DeityArkayPerk)
				reduction += 10
			endif
			tActions.gainSuccubusXP(succdVal, reduction + PlayerRef.HasPerk(tMenus.SuccubusTintPerks[20]) * succdVal)
			while  Stage_in < StageCount 
				_thread.AdvanceStage()
				Stage_in = StageCount   - SexLabRegistry.GetPathMax(_Thread.getactivescene() ,_Thread.GetActiveStage()).Length + 1
			EndWhile
		endif
	else
		if _thread.HasSceneTag("spanking")
			incrValAndCheck(13,1)
		endif
		if _thread.GetSubmissive(PlayerRef)
			incrValAndCheck(20,1)
        	if  tssd_dealwithcurseQuest.isRunning() && !tssd_dealwithcurseQuest.isobjectivefailed(24) ; Dibella
				tActions.increaseGlobalDeity(8,10,500)
			endif
			if Game.GetModByName(FILE_FADE_TATS) != 255
				incrValAndCheck(8,1)
			endif
		elseif !tssd_dealwithcurseQuest.isobjectivefailed(24)
			tActions.increaseGlobalDeity(3,5,1000)
		endif
		if _thread.HasSceneTag("rough")
			incrValAndCheck(22,1)
		endif
	endif
	if _thread.SameSexThread() && _thread.GetPositions().Length > 1
		incrValAndCheck(4,1)
	endif
	if _thread.HasSceneTag("love") || _thread.HasSceneTag("loving") || _thread.HasSceneTag("romance")
		incrValAndCheck(3,1)
	endif

	if (!hadAnnouncement || hadAnnouncement) && possibleAnnouncements.Length > 1
		int randOmGGG = Utility.RandomInt(1, possibleAnnouncements.Length-1)
		int getRando = possibleAnnouncements[randOmGGG]
		T_Needs(getRando, "", false)
		hadAnnouncement = true
	endif
	Utility.Wait(0.1)
	calcCumAmountPlayer()
EndFunction

;/ Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    if UI.IsMenuOpen("Dialogue Menu") || UI.IsMenuOpen("Barter Menu")
		incrValAndCheck(16, aiItemCount)
    endif

endEvent /;



Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, \
    bool abBashAttack, bool abHitBlocked)
	ACtor ak = akAggressor as Actor
    if PlayerRef.GetAV("Health") < 100 && PlayerRef.HasMagicEffect(TSSD_SatiatedEffect) && (akAggressor as Actor) && \
        (akAggressor as Actor).GetAv("Health") < tActions.getDrainLevel() && !isActingDefeated && (akAggressor as Actor).GetAv("Health") > 20
		isActingDefeated = true
        Actor tar = tActions.getCombatTarget(true)
        if tar && tar != PlayerRef
            tActions.actDefeated(tar, false)
        Endif
		isActingDefeated = false
    endif
    Weapon akW = akSource as Weapon
    if PlayerRef.HasPerk(tMenus.SuccubusTintPerks[14]) && akW != none && !abHitBlocked
        tActions.gainSuccubusXP(akW.GetBaseDamage() * 20 )
    endif
	if ak && ak.isHostileToActor(PlayerRef)
		if playerRef.HasPerk(TSSD_Body_ArousingBody)
		
			int eid = ModEvent.Create("slaUpdateExposure")
			ModEvent.PushForm(eid, ak)
			float arousalPush = 10.0
			ModEvent.PushFloat(eid, arousalPush)
			ModEvent.Send(eid)
		endif
		if playerRef.HasPerk(TSSD_Body_StunningBody) && Utility.RandomInt(21, 200) < ak.GetFactionRank(sla_Arousal)
			if ak.GetRace().HasKeyword(ActorTypeCreature)
				ak.ModAV("Health", -100)
			else
				Sexlab.StartSceneQuick(ak)
			endif
		endif
	endif
	if akw
		incrValAndCheck(14, akW.GetBaseDamage())
	endif
	
EndEvent

Function onGameReload()
	isActingDefeated = false
	crimsonDone = false
	lastGameHour = Utility.GetCurrentGameTime() * 24
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

	RegisterForModEvent("CurseOfLife_EggLaid","EggLaid")
	RegisterForModEvent("CurseOfLife_Updated", "OnCOLUpdated")
	RegisterForModEvent("PlayerTrack_Start", "PlayerSceneStartEvent")
	RegisterForModEvent("SexLabOrgasmSeparate", "OnOrgasmAny")
	PO3_Events_Alias.RegisterForActorKilled(self)
EndFunction

Event OnActorKilled(Actor akVictim, Actor akKiller)
	if PlayerRef.HasPerk(TSSD_DeityArkayPerk)
		tActions.RefreshEnergy(5)
	endif
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	if PlayerRef.HasPerk(tMenus.SuccubusTintPerks[2]) && akBaseObject == ReligiousMaraLove
		PlayerRef.UnequipItem(ReligiousMaraLove, true, false)
	endif
EndEvent

Event PlayerSceneStartEvent(Form FormRef, int tid)
	hadAnnouncement = false
	possibleAnnouncements = new int[1]	
	Location curLoc = Game.GetPlayer().GetCurrentLocation()
	if curLoc 
		bool safeHaven = (curLoc.HasKeyword(LocTypePlayerHouse)) || curLoc.HasKeyword(LocTypeInn) || curLoc.HasKeyword(LocTypeStore)
		if safeHaven
			tActions.RefreshEnergy(100)
    		TSSD_Satiated.Cast(PlayerRef, PlayerRef)
		endif
	endif
	int indexIn = 0
	
    sslThreadController _thread =  Sexlab.GetController(tid)
	Actor[] aIn = _thread.GetPositions()
	if aIn.Length == 1
		_thread.SetEnjoyment(PlayerRef, 100)
	endif
	while indexIn < aIn.Length
		if aIn[indexIn].GetRace().HasKeyword(ActorTypeCreature)
			_thread.SetEnjoyment(aIn[indexIN], 100)
		elseif aIn[indexIN] != PlayerRef
			_thread.ModEnjoymentMult(aIn[indexIN], (SkillSuccubusBaseLevel.GetValue() + SkillSuccubusBodyLevel.GetValue() + SkillSuccubusDrainLevel.GetValue() + SkillSuccubusSeductionLevel.GetValue()) / 100, true )
		endif
		indexIn += 1
	endwhile

EndEvent


function OnCOLUpdated(form t)
  actor victim = t as actor
  int isFull = (StorageUtil.GetFloatValue(none, "CurseOfLife_BellyCurrentSize", 0.0) > 0) as int
  isFull += (StorageUtil.GetFloatValue(none, "CurseOfLife_CharusCurrentSize", 0.0) + StorageUtil.GetFloatValue(none, "CurseOfLife_SpiderCurrentSize", 0.0) > 0) as int
  tVals.hasEggs = isFull
  if !maraSuccess && StorageUtil.GetFloatValue(none, "CurseOfLife_BlessingCurrentSize", 0.0) >= 5.0
	tActions.increaseGlobalDeity(0,1,1)
	maraSuccess = true
  endif
  
endfunction

Function EggLaid(form actorFrom, form egg, int numReleased)
	DBGTrace(egg.GetName())
	if  actorFrom as actor == PlayerRef
		incrValAndCheck(10, 1)
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
	calcCumAmountPlayer()
	float gameTimeDiff = max(0.5, Utility.GetCurrentGameTime() * 24 - lastGameHour)
	tVals.lastCumOnTime += gameTimeDiff
	tVals.lastPraiseTime += gameTimeDiff
	tVals.lastRoughTime += gameTimeDiff
	tVals.lastSpankedTime += gameTimeDiff
	tVals.lastRomanticTime += gameTimeDiff
	tVals.lastCumInMe += gameTimeDiff
	tVals.lastWolfSex += gameTimeDiff
	tVals.lastHypnoSession += gameTimeDiff
	tVals.lastFadeTat += gameTimeDiff
	lastNeedsAnnouncement += gameTimeDiff
	int[] tN = new int[1]
	int needsTimerMax =  MCM.GetModSettingInt("TintsOfASuccubusSecretDesires","iSuccubusNeedsTimer:Main")
	if lastNeedsAnnouncement > needsTimerMax  && !PlayerRef.isInCombat()
		if PlayerRef.HasPerk(tMenus.SuccubusTintPerks[0])  && (tVals.lastCumOnTime > needsTimerMax)
			tN = PapyrusUtil.PushInt(tN, 0)
			tssd_tints_tracker.SetObjectiveFailed(0, true)
		endif
		if PlayerRef.HasPerk(tMenus.SuccubusTintPerks[15]) && (tVals.lastPraiseTime > needsTimerMax)
			tN = PapyrusUtil.PushInt(tN, 15)
			tssd_tints_tracker.SetObjectiveFailed(15, true)
		endif
		if PlayerRef.HasPerk(tMenus.SuccubusTintPerks[22]) && (tVals.lastRoughTime > needsTimerMax)
			tN = PapyrusUtil.PushInt(tN, 22)
			tssd_tints_tracker.SetObjectiveFailed(22, true)
		endif
		if PlayerRef.HasPerk(tMenus.SuccubusTintPerks[13]) && (tVals.lastSpankedTime > needsTimerMax)
			tN = PapyrusUtil.PushInt(tN, 13)
			tssd_tints_tracker.SetObjectiveFailed(13, true)
		endif
		if PlayerRef.HasPerk(tMenus.SuccubusTintPerks[3])  && (tVals.lastRomanticTime > needsTimerMax)
			tN = PapyrusUtil.PushInt(tN, 3)
			tssd_tints_tracker.SetObjectiveFailed(3, true)
		endif
		if PlayerRef.HasPerk(tMenus.SuccubusTintPerks[1])  && (tVals.lastCumInMe > needsTimerMax)
			tN = PapyrusUtil.PushInt(tN, 1)
			tssd_tints_tracker.SetObjectiveFailed(1, true)
		endif
		if PlayerRef.HasPerk(tMenus.SuccubusTintPerks[6])  && (tVals.lastWolfSex > needsTimerMax)
			tN = PapyrusUtil.PushInt(tN, 6)
			tssd_tints_tracker.SetObjectiveFailed(6, true)
		endif
		if PlayerRef.HasPerk(tMenus.SuccubusTintPerks[18]) && (tVals.lastHypnoSession > needsTimerMax) * 3
			tN = PapyrusUtil.PushInt(tN, 18)
			Actor[] allActs = PO3_SKSEFunctions.GetAllActorsInFaction(TSSD_HypnoMaster)
			Actor cTarget = allActs[Utility.RandomInt(0, allActs.Length-1)]
			T_Needs(18, cTarget.GetDisplayName())
			if !PlayerRef.isInCombat() && !Sexlab.IsActorActive(PlayerRef)
				Sexlab.StartSceneQuick(PlayerRef) 
				tVals.lastHypnoSession = 0.1
				lastNeedsAnnouncement = 0.1
			endif
		elseif tN.Length > 1
			int nxAnnounce = tN[Utility.RandomInt(1, tN.Length)]
			T_Needs( nxAnnounce )
			lastNeedsAnnouncement = 0.1
		endif
	endif
	

	if tVals.lastFadeTat > 24 && PlayerRef.HasPerk(tMenus.SuccubusTintPerks[8])
		int handle = ModEvent.Create("RapeTattoos_addTattooV2")
		if (handle)
			ModEvent.PushForm(handle, PlayerRef)
			ModEvent.PushInt(handle, 1)
			ModEvent.Send(handle)
		endIf
		tVals.lastFadeTat = 0.1
	endif

	if isLilac && !isCollared && !PlayerRef.isInCombat() && !Sexlab.IsActorActive(PlayerRef)
		T_Show("I miss my collar...", "menus/TSSD/small/lilac.dds")
	endif
EndEvent

Event OnInit()	
	lastGameHour = gamehour.GetValue() * 24
	(Game.GetFormFromFile(0x002B74,"Dawnguard.esm") as Actor).SetFactionRank(TSSD_HypnoMaster, 1)
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


