Scriptname tssd_orgasmenergylogic extends Quest  

import b612
import tssd_utils


Spell Property TSSD_FuckingInvincible Auto
Spell Property tssd_Satiated Auto
Spell Property TSSD_DrainedMarker Auto
Spell Property TSSD_SuccubusDetectJuice Auto
Spell Property TSSD_DrainHealth Auto
Spell Property TSSD_InLoveBuff Auto
Spell Property MarriageRested Auto

GlobalVariable Property TimeOfDayGlobalProperty Auto
GlobalVariable Property SuccubusDesireLevel Auto
GlobalVariable Property SkillSuccubusDrainLevel Auto
GlobalVariable Property SkillSuccubusSeductionLevel Auto
GlobalVariable Property SkillSuccubusBodyLevel Auto
GlobalVariable Property SkillSuccubusBaseLevel Auto
GlobalVariable Property TSSD_InnocentsSlain Auto


Keyword Property LocTypeInn Auto
Keyword Property LocTypePlayerHouse Auto
Keyword Property LocTypeCity Auto
Keyword Property LocTypeClearable Auto
Keyword Property LocTypeHabitation Auto
Keyword Property LocTypeHabitationHasInn Auto
Keyword Property LocTypeStore Auto
Keyword Property ActorTypeCreature Auto

Actor Property PlayerRef Auto

Faction Property TSSD_MarkedForDeathFaction Auto
Faction Property TSSD_EnthralledFaction Auto
Faction Property sla_Arousal Auto
Faction Property CurrentFollowerFaction Auto

SexLabFramework Property SexLab Auto

tssd_actions Property tActions Auto
tssd_PlayerEventsScript Property tEvents Auto
tssd_menus Property tMenus Auto
tssd_tints_variables Property tVals Auto


Quest Property tssd_dealwithcurseQuest Auto
Quest Property TSSD_EvilSuccubusQuest Auto
Quest Property tssd_tints_tracker Auto

Spell Property TSSD_LeaderBuff Auto
Spell Property TSSD_LightningCloak Auto

ImageSpaceModifier Property AzuraFadeToBlack  Auto
ImageSpaceModifier Property BerserkerMainImod  Auto  

HeadPart PlayerEyes

bool hadAnnouncement = false
int[] possibleAnnouncements


Perk Property TSSD_DeityArkayPerk Auto
Perk Property TSSD_DeityMaraPerk Auto
Perk Property TSSD_Tint_Scarlet Auto
Perk Property TSSD_Together_Lightning Auto

;;;; BEGIN TINTS

; Begin Blush

; End Blush


; BEGIN ZAD

Keyword Property zbfWornCollar Auto Hidden
String Property FILE_ZAZ_ANIMATION_PACK = "ZaZAnimationPack.esm" AutoReadOnly  
Bool Property ZaZAnimationPackFound = False Auto Hidden Conditional

; END ZAD


; BEGIN LILAC

Race Property WolfRace Auto
Race Property WereWolfBeastRace Auto
Faction Property CompanionsCirclePlusKodlak Auto
Faction Property WereWolfFaction Auto
Faction Property WolfFaction Auto
bool isCollared
float lastTimeNeededCollar = 0.0
Spell Property TSSD_ProudDogOwnerBuff Auto


; END LILAC

; BEGIN CARNATION

; END CARNATION



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


; BEGIN MARA

bool maraSuccess = false

; END MARA




Function incrValAndCheck(int numOf, float incrBy)
    if numOf >= tEvents.currentVals.Length
        tEvents.currentVals = Utility.ResizeFloatArray(tEvents.currentVals, numOf + 1, 0.0)
    endif
	tEvents.currentVals[numOf] = tEvents.currentVals[numOf] + incrBy
	tEvents.checkValOf(numOf)
	if numOf == 0 
		tVals.lastCumOnTime = 0.1 
	endif
	if numOf == 1 
		tVals.lastCumInMe = 0.1 
	endif
	if numOf == 3 
		tVals.lastRomanticTime = 0.1 
	endif	
	if numOf == 13 
		tVals.lastSpankedTime = 0.1 
	endif
	if numOf == 15 
		tVals.lastPraiseTime = 0.1 
	endif
	if numOf == 22 
		tVals.lastRoughTime = 0.1 
	endif
	if numOf == 23 
		tVals.lastDragon = 0.1 
	endif
	if playerRef.HasPerk(getPerkNumber(numOf))
		if numOf != 19 && numOf != 18 && numOf != 8 && numOf != 10
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


Function onGameReload()
    RegisterForModEvent("PlayerTrack_Start", "PlayerSceneStart")
    RegisterForModEvent("PlayerTrack_End", "PlayerSceneEnd")
	RegisterForModEvent("SexLabOrgasmSeparate", "OnOrgasmAny")
EndFunction

Event PlayerSceneStart(Form FormRef, int tid)
    tActions.UnregisterForCrosshairRef()
    TSSD_FuckingInvincible.Cast(PlayerRef)
    sslThreadController _thread =  Sexlab.GetController(tid)
    Actor[] ActorsIn = Sexlab.GetController(tid).GetPositions()
    if ActorsIn.Length == 1
        incrValAndCheck(24,1)
        tVals.beingOrdered = true
    endif
    int indexIn = 0
    bool aggressiveY = false
    while indexIn < ActorsIn.length
        Actor consentingActor = ActorsIn[indexIn]
        if consentingActor != PlayerRef
            if consentingActor.GetFactionRank(TSSD_HypnoMaster) >= 1
                tVals.beingOrdered = true
            endif
            if consentingActor.GetFactionRank(CurrentFollowerFaction) >= 0
                TSSD_LeaderBuff.Cast(PlayerRef, consentingActor)
            endif
            if _thread.GetSubmissive(PlayerRef) && consentingActor.IsHostileToActor(PlayerRef) && !_thread.GetSubmissive(consentingActor)
                aggressiveY = true
            endif
            if PlayerRef.HasPerk(getPerkNumber(19))  && consentingActor.GetFactionRank(TSSD_EnthralledFaction) == 1
                T_Show("My sweeheart " + consentingActor.GetDisplayName() , "menus/TSSD/ScarletHearts.dds", aiDelay = 2.0)
            endif
        endif
        indexIn += 1
    endwhile
    if aggressiveY && !tActions.deathModeActivated
        tActions.toggleDeathMode(true, true)
    endif
    if SuccubusDesireLevel.GetValue() > -100.0
        PlayerRef.DispelSpell(TSSD_SuccubusDetectJuice)
    endif
    
   if Game.GetModByName("Tullius Eyes.esp") != 255 && (PlayerRef.HasPerk(getPerkNumber(19)) || tActions.cosmeticSettings[1] ) && tActions.cosmeticSettings[0]
        HeadPart tEyes = currentEyes()
        if tEyes
            PlayerEyes = tEyes
        endif
        setHeartEyes(PlayerEyes, true)
    endif
    if tssd_dealwithcurseQuest.GetStage() == 20
        int outerIndex = 0
        bool conSent = true
        actor consentingActor
        while outerIndex < ActorsIn.Length
            consentingActor = ActorsIn[outerIndex]
            if _thread.GetSubmissive(consentingActor)
                conSent = false
            endif
            outerIndex += 1
        endwhile
        if !tssd_dealwithcurseQuest.isobjectivefailed(24) ; Dibella
            int index = 0
            int val_to_increase = 0
            int deityNum = 3
            int toVal = 1000
            if !conSent
                deityNum = 8
                toVal = 500
            endif
            while index < ActorsIn.Length
                Actor WhoCums = ActorsIn[index]
                float lstTime = GetLastTimeSuccd(WhoCums, TimeOfDayGlobalProperty)
                if WhoCums != PlayerRef && (lstTime < 0 || lstTime > 7)
                    val_to_increase += 25
                elseif WhoCums != PlayerRef
                    val_to_increase += 5
                endif
                index+=1
            EndWhile
            tActions.increaseGlobalDeity(deityNum, val_to_increase, toVal)
        endif
        if !tssd_dealwithcurseQuest.isobjectivefailed(21) ; Mara
            int index = 0
            while index < ActorsIn.length
                Actor WhoCums = ActorsIn[index]
                if WhoCums != PlayerRef
                    float lstTime = GetLastTimeSuccd(WhoCums, TimeOfDayGlobalProperty)
                    if !issingle(WhoCums) && lstTime < 0
                        tActions.increaseGlobalDeity(5, 1, 5)
                    endif
                endif
                index+=1
            EndWhile
        endif
    endif
    if tActions.deathModeActivated
        BerserkerMainImod.ApplyCrossFade(1)
    endif

    ; PEventScript 

    
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
	indexIn = 0
	
	Actor[] aIn = _thread.GetPositions()
	if aIn.Length == 1
		_thread.SetEnjoyment(PlayerRef, 100)
	endif
 	while indexIn < aIn.Length
		if aIn[indexIn].GetRace().HasKeyword(ActorTypeCreature)
			_thread.SetEnjoyment(aIn[indexIN], 100)
		elseif aIn[indexIN] != PlayerRef
			_thread.ModEnjoymentMult(aIn[indexIN], (SkillSuccubusBaseLevel.GetValue() + SkillSuccubusBodyLevel.GetValue() + SkillSuccubusDrainLevel.GetValue() + SkillSuccubusSeductionLevel.GetValue()) / 1000, true )
		endif
		indexIn += 1
	endwhile

EndEvent




Event PlayerSceneEnd(Form FormRef, int tid)
    PlayerRef.DispelSpell(TSSD_FuckingInvincible)
    if Game.GetModByName("Tullius Eyes.esp") != 255
        setHeartEyes(PlayerEyes, false)
    endif

    sslThreadController _thread =   Sexlab.GetController(tid)
    Actor[] ActorsIn = _thread.GetPositions()
    int indexIn = 0
    while indexIn < ActorsIn.length
        Actor consentingActor = ActorsIn[indexIn]
        if consentingActor.GetFactionRank(TSSD_MarkedForDeathFaction) >= 1
            consentingActor.Kill(PlayerRef)
        endif
        indexIn += 1
    endwhile   
    if tActions.deathModeActivated
        tActions.toggleDeathMode(true)
    endif
    tVals.beingOrdered = false
    Utility.Wait(1)    
EndEvent


Function OnOrgasmAny(Form ActorRef_Form, int Thread)
    Actor WhoCums = ActorRef_Form as Actor
    sslThreadController _thread =  Sexlab.GetController(Thread)
    if _thread != Sexlab.GetPlayerController()
        if PlayerRef.GetDistance(WhoCums)  < 100 && !PlayerRef.HasPerk(getPerkNumber(19))
            tActions.gainSuccubusXP(100)
        endif
        return
    endif	
	if WhoCums != PlayerRef
        TSSD_DrainedMarker.Cast(PlayerRef, WhoCums)
		if tssd_dealwithcurseQuest.isRunning() && !tssd_dealwithcurseQuest.isobjectivefailed(24) ; Dibella
			if !_thread.GetSubmissive(PlayerRef)
				tActions.increaseGlobalDeity(3,PlayerRef.GetAV("Speechcraft"),10000)
			endif
		endif
			
		if WhoCums.GetFactionRank(CompanionsCirclePlusKodlak) >=0 || WhoCums.GetFactionRank(WereWolfFaction) > 0 || \
				WhoCums.GetFactionRank(WolfFaction) > 0 || WhoCums.GetRace() == WolfRace || WhoCums.GetRace() == WereWolfBeastRace 
			tVals.lastWolfSex = 0.1
		endif
		if WhoCums.GetFactionRank(TSSD_HypnoMaster) >=0 
			tVals.lastHypnoSession = 0.1
            _thread.ForceOrgasm(PlayerRef)
		endif
		if WhoCums.GetRelationshipRank(PlayerRef) >= 1
			incrValAndCheck(19,1)
		endif
		if WhoCums.GetRelationshipRank(PlayerRef) >= 4
			if PlayerRef.HasPerk(TSSD_DeityMaraPerk)
				MarriageRested.Cast(PlayerRef,PlayerRef)
			endif
		endif

		if WhoCums.GetFactionRank(tEvents.SOS_SchlongifiedFaction) >= 0
			if _thread.HasSceneTag("cuminmouth") || _thread.HasSceneTag("blowjob")
				incrValAndCheck(12,1)
				incrValAndCheck(1,0.2)
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
            WhoCums.SetFactionRank(TSSD_MarkedForDeathFaction, 1)
			if succdVal <= drainLevel
				WhoCums.setAV("Health", 10000)
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
            if !PlayerRef.HasPerk(getPerkNumber(19))
			    tActions.gainSuccubusXP(succdVal, reduction + (PlayerRef.HasPerk(getPerkNumber(20)) as int) * succdVal)
            endif
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
				tActions.increaseGlobalDeity(8,PlayerRef.GetAV("Speechcraft") / 10,500)
			endif
			if Game.GetModByName(FILE_FADE_TATS) != 255
				incrValAndCheck(8,1)
			endif
		elseif !tssd_dealwithcurseQuest.isobjectivefailed(24)
			tActions.increaseGlobalDeity(3,PlayerRef.GetAV("Speechcraft")  / 20,1000)
		endif
		if _thread.HasSceneTag("rough")
			incrValAndCheck(22,1)
		endif
        tVals.lastOrgasm = 0.1
	endif
	if _thread.SameSexThread() && _thread.GetPositions().Length > 1
		incrValAndCheck(4,1)
	endif
	if _thread.HasSceneTag("love") || _thread.HasSceneTag("loving") || _thread.HasSceneTag("romance")
		incrValAndCheck(3,1)
	endif

	if !hadAnnouncement  && possibleAnnouncements.Length > 1
		int randOmGGG = Utility.RandomInt(1, possibleAnnouncements.Length - 1)
		int getRando = possibleAnnouncements[randOmGGG]
		T_Needs(getRando, "", false)
		hadAnnouncement = true
	endif
	Utility.Wait(0.1)
	tEvents.calcCumAmountPlayer()
EndFunction


;/ 
Actor Property PlayerRef Auto
SexLabFramework Property SexLab Auto
Faction Property sla_Arousal Auto
GlobalVariable Property TSSD_SuccubusTraits Auto


Function queueStringForAnnouncement(string inputStr)
    nextAnnouncement += inputStr
EndFunction


string Property nextAnnouncement Auto

float[] Function OrgasmEnergyValue(sslThreadController _thread, Actor WhoCums = none)    
    ; announceLogic -- 0 no announcement -- 1 announce self -- 2 add to next announcement
    float dateCheck = TimeOfDayGlobalProperty.GetValue()
    ; TODO
    string[] succubusTraits = GetSuccubusTraitsAll()
    int[] SUCCUBUSTRAITSVALUESBONUS = Utility.CreateIntArray(succubusTraits.Length, 20)
    SUCCUBUSTRAITSVALUESBONUS[2] = 100
    SUCCUBUSTRAITSVALUESBONUS[5] =  0
    float lastMet = 1
    bool[] tActions.cosmeticSettings = ReadInCosmeticSetting()
    bool[] chosenTraits = GetSuccubusTraitsChosen(TSSD_SuccubusTraits, succubusTraits.Length)
    float largestTime = 0
    float[] retVals = Utility.CreateFloatArray(3, 0)
    int nextAnnouncementLineLength = 0
    float energyLosses = 0
    float retval = 0

    if isEnabledAndNotPlayer(WhoCums)
        lastMet = GetLastTimeSuccd(WhoCums, TimeOfDayGlobalProperty)
        if (lastmet  < 0.0) || (lastmet > 1.0)
            lastmet = 1
            retval += 20
        endif
        int index = 0
        while index < SUCCUBUSTRAITSVALUESBONUS.Length
            bool traitYes = false
            if chosenTraits[index]
                traitYes = traitLogic(index, _thread, WhoCums)
                if index == 5
                    nextAnnouncement += WhoCums.GetDisplayName()
                endif
                if traitYes 
                    retval += SUCCUBUSTRAITSVALUESBONUS[index]
                else
                    retVals[2] = retVals[2] + SUCCUBUSTRAITSVALUESBONUS[index] 
                endif
                string announceDial = " " + GetTypeDial(succubusTraits[index], traitYes, true)
                nextAnnouncementLineLength += StringUtil.GetLength(announceDial)
                if nextAnnouncementLineLength > 100
                    nextAnnouncement += "\n"
                    nextAnnouncementLineLength = 0
                endif
                nextAnnouncement += announceDial
            endif
            index += 1
        EndWhile
    endif
    String output = ""
    retVal += energyLosses
    if output != ""
        nextAnnouncement += output +""
    endif
    retVals[0] = retVal 
    return retVals

Endfunction

bool Function traitLogic(int index, sslThreadController _thread, Actor WhoCums)
    float ar_norm = WhoCums.GetFactionRank(sla_Arousal) - 50

    if index == 0
        if _thread.HasSceneTag("Aircum")
            return true
        endif
    elseif index == 1
        if !_thread.HasSceneTag("Aircum")
            if _thread.HasSceneTag("Oral")
                return true
            elseif _thread.HasSceneTag("Anal")
                return true
            elseif _thread.HasSceneTag("Vaginal")
                return true
            endif
        endif
    elseif index == 2
        if !isSingle(WhoCums) && SexlabStatistics.GetTimesMet(WhoCums,PlayerRef) == 0
            return true
        endif
    elseif index == 3
        if _thread.HasSceneTag("love")
            return true
        elseif _thread.HasSceneTag("loving")
            return true
        endif
    elseif index == 4
        if _thread.sameSexThread()
            return true
        endif
    elseif index == 5
        if ar_norm > 0
            return true
        endif
    endif
    return  false
Endfunction /;
