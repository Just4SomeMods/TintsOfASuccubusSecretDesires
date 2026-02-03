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
Keyword Property LocTypeCastle Auto
Keyword Property ActorTypeCreature Auto
Keyword Property Vampire Auto

Actor Property PlayerRef Auto

Faction Property TSSD_MarkedForDeathFaction Auto
Faction Property TSSD_EnthralledFaction Auto
Faction Property sla_Arousal Auto
Faction Property CurrentFollowerFaction Auto
Faction Property GovRuling Auto

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

ReferenceAlias Property LavenderTarget Auto
ReferenceAlias Property LavenderCuckTarget Auto
Faction Property TSSD_HasCuckedFaction Auto


;;;; BEGIN TINTS

; BEGIN MULBERRY

bool hasTentacles
Race Property DLC2LurkerRace Auto
Race Property DLC2NetchRace Auto
Race Property DLC2SeekerRace Auto

; END MULBERRY

; BEGIN Bordeaux
bool hasStrongPerson
; END Bordeaux

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
	tEvents.currentVals[numOf] = max(0,tEvents.currentVals[numOf] + incrBy)
	tEvents.checkValOf(numOf)
	if numOf == 0 
		tVals.lastCumOnTime = 0.1 
	elseif numOf == 1 
		tVals.lastCumInMe = 0.1 
	elseif numOf == 3 
		tVals.lastRomanticTime = 0.1 
	elseif numOf == 13 
		tVals.lastSpankedTime = 0.1 
	elseif numOf == 15 
		tVals.lastPraiseTime = 0.1 
	elseif numOf == 22 
		tVals.lastRoughTime = 0.1 
	elseif numOf == 23 
		tVals.lastDragon = 0.1 
	elseif numOf == 26 && incrBy >= 50
		tVals.lastSlutCity = 0.1
	elseif numOf == 32
		tVals.lastTentacle = 0.1
	endif
    
	if playerRef.HasPerk(getPerkNumber(numOf))
		if numOf != 19 && numOf != 18 && numOf != 8 && numOf != 10
            if JArray.Count(JDB.solveObj(".tssdtints." + numOf + ".positive")) > 0
                possibleAnnouncements = PapyrusUtil.PushInt(possibleAnnouncements, numOf)
            EndIf
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
    RegisterForModEvent("TSSD_ModTint", "TintMod")

EndFunction

Event TintMod(string eventName, string strArg, float numArg, Form sender)
    int tintNum = JDB.solveInt(".tssdtraits." + strArg + ".index")
    IncrValAndCheck(tintNum, numArg)
    DBGTrace(strArg + numArg)
EndEvent


Event PlayerSceneStart(Form FormRef, int tid)
    tActions.UnregisterForCrosshairRef()
    TSSD_FuckingInvincible.Cast(PlayerRef)
    sslThreadController _thread =  Sexlab.GetController(tid)
    Actor[] ActorsIn = Sexlab.GetController(tid).GetPositions()
    if ActorsIn.Length == 1
        tVals.beingOrdered = true
    endif
    int indexIn = 0
    bool aggressiveY = false
    hasStrongPerson = false
    hasTentacles = false
    bool hasNobility = false
    bool isVeryAroused = PlayerRef.GetFactionRank(sla_Arousal) > 90
    
    while indexIn < ActorsIn.length
        Actor consentingActor = ActorsIn[indexIn]
        DBGTrace(consentingActor.GetDisplayName())
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
            if consentingActor.GetLevel() >= 30
                hasStrongPerson = true
            EndIf
            Race aRace = consentingActor.GetRace()
            if aRace == DLC2LurkerRace || aRace == DLC2NetchRace || aRace == DLC2SeekerRace
                hasTentacles = true
                if playerref.hasPerk(getPerkNumber(32))
		            _thread.SetEnjoyment(PlayerRef, 200)
                EndIf
            EndIf
            if consentingActor.GetFactionRank(GovRuling) >= 0
                hasNobility = true
            EndIf
            
            if !_thread.GetSubmissive(PlayerRef) && !_thread.GetSubmissive(consentingActor)
                if isVeryAroused && consentingActor.GetFactionRank(CurrentFollowerFaction) >= 1
                    incrValAndCheck(5,1)
                endif
                Actor spouseIn = getSpouseOrCourting(consentingActor)
                if spouseIn && consentingActor.GetFactionRank(TSSD_HasCuckedFaction) < 1
                    incrValAndCheck(2, 1)
                    consentingActor.SetFactionRank(TSSD_HasCuckedFaction, 1 )
                    spouseIn.SetFactionRank(TSSD_HasCuckedFaction, 1 )
                    tVals.ruinedRelationships += 1
                    if (consentingActor == (LavenderTarget.GetReference() As Actor) || consentingActor == (LavenderCuckTarget.GetReference() As Actor))
                        tssd_tints_tracker.setObjectiveCompleted(2)
                        LavenderCuckTarget.Clear()
                        LavenderTarget.Clear()
                        tActions.gainSuccubusXP(1000)
                        increaseFame("Slut", 5)
                    endif
                endif
            EndIf
        endif
        indexIn += 1
    endwhile
    if aggressiveY && !tActions.deathModeActivated
        tActions.toggleDeathMode(true, true)
    endif
    if SuccubusDesireLevel.GetValue() > -100.0
        PlayerRef.DispelSpell(TSSD_SuccubusDetectJuice)
    endif
    
   if Game.GetModByName("Tullius Eyes.esp") != 255 && (PlayerRef.HasPerk(getPerkNumber(19)) || tMenus.cosmeticSettings[1] ) && tMenus.cosmeticSettings[0]
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
    
	hadAnnouncement = false
	possibleAnnouncements = new int[1]	
	Location curLoc = Game.GetPlayer().GetCurrentLocation()
	if curLoc 
		bool safeHaven = (curLoc.HasKeyword(LocTypePlayerHouse)) || curLoc.HasKeyword(LocTypeInn) || curLoc.HasKeyword(LocTypeStore)
		if safeHaven
			tActions.RefreshEnergy(100)
    		TSSD_Satiated.Cast(PlayerRef, PlayerRef)
		endif
        if (curLoc.HasKeyword(LocTypeHabitationHasInn)  || curLoc.HasKeyword(LocTypeCastle)) && hasNobility
            IncrValAndCheck(37,1)
        EndIf
	endif
	indexIn = 0
	
	Actor[] aIn = _thread.GetPositions()
	if aIn.Length == 1
		_thread.SetEnjoyment(PlayerRef, 100)
        incrValAndCheck(24, 0)
	endif

 	while indexIn < aIn.Length
        Actor consentingActor = aIn[indexIN] as Actor
		if consentingActor.GetRace().HasKeyword(ActorTypeCreature)
			_thread.SetEnjoyment(consentingActor, 100)
		elseif consentingActor && consentingActor != PlayerRef
            _thread.ModEnjoymentMult(consentingActor, (SkillSuccubusBaseLevel.GetValue() + SkillSuccubusBodyLevel.GetValue() + SkillSuccubusDrainLevel.GetValue() + SkillSuccubusSeductionLevel.GetValue()) / 1000, true )
            
		endif
        if consentingActor.GetFactionRank(TSSD_EnthralledFaction) >= 1
            _thread.ModEnjoymentMult(consentingActor, 3)
        endif
		indexIn += 1
	endwhile
    
    if  hasTagsInternal(_thread, "~boobsuck, ~breastfeed, ~breastfeeding, ~milk, ~milking, ~boobs, ~nipplesuck, ~lactation, -titfuck, -boobjob, -tittyfuck")
        incrValAndCheck(30,1)
    EndIf

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
        int indexF = 0
        while indexF < tEvents.currentFollowers.Length
            Actor consentingActor = tEvents.currentFollowers[indexF]
            SexlabThread SLThread = Sexlab.GetThreadByActor(consentingActor)
            sslThreadController _thread =  Sexlab.GetController(SLThread.GetThreadID())
			int StageCount = SexLabRegistry.GetPathMax(   _Thread.getactivescene()  , "").Length
			int Stage_in = StageCount   - SexLabRegistry.GetPathMax(_Thread.getactivescene() ,_Thread.GetActiveStage()).Length + 1
			while  Stage_in < StageCount 
				_thread.AdvanceStage()
				Stage_in = StageCount   - SexLabRegistry.GetPathMax(_Thread.getactivescene() ,_Thread.GetActiveStage()).Length + 1
			EndWhile
            indexF += 1
        EndWhile
        tActions.toggleDeathMode(true)
    endif
    tVals.beingOrdered = false
    tActions.RegisterForCrosshairRef()
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
        
        if hasTagsInternal(_thread, "~aircum, ~cumonchest, ~cumonbody")
            incrValAndCheck(0,0)
        EndIf
        
        if hasTagsInternal(_thread, "~cuminmouth, ~blowjob")
            incrValAndCheck(1,0)
            incrValAndCheck(12,5)
        EndIf
        
        if hasTagsInternal(_thread, "femdom")
            incrValAndCheck(31, 5)
        EndIf

        if WhoCums.HasKeyword(Vampire)
            incrValAndCheck(34, 1)
        EndIf
        

        if whoCums.GetLevel() >= 30
            incrValAndCheck(38, 1)
        EndIf

        if WhoCums.GetRelationshipRank(PlayerRef) >= 1
            incrValAndCheck(19, 0)
        EndIf
			
		if WhoCums.GetFactionRank(CompanionsCirclePlusKodlak) >=0 || WhoCums.GetFactionRank(WereWolfFaction) > 0 || \
				WhoCums.GetFactionRank(WolfFaction) > 0 || WhoCums.GetRace() == WolfRace || WhoCums.GetRace() == WereWolfBeastRace 
			tVals.lastWolfSex = 0.1
		endif
		if WhoCums.GetFactionRank(TSSD_HypnoMaster) >=0 
			tVals.lastHypnoSession = 0.1
            _thread.ForceOrgasm(PlayerRef)
		endif
        
		if WhoCums.GetRelationshipRank(PlayerRef) >= 4 && PlayerRef.HasPerk(TSSD_DeityMaraPerk)
            MarriageRested.Cast(PlayerRef,PlayerRef)
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
        endif
        
        if WhoCums.GetFactionRank(tEvents.JobTrainerFaction) >= 0 || WhoCums.GetFactionRank(tEvents.TSSD_PotentialHypnoMaster) >= 0
            incrValAndCheck(18, 1)
        endif
	else    
		if _thread.GetSubmissive(PlayerRef)
			incrValAndCheck(20,1)
        	if  tssd_dealwithcurseQuest.isRunning() && !tssd_dealwithcurseQuest.isobjectivefailed(24) ; Dibella
				tActions.increaseGlobalDeity(8,PlayerRef.GetAV("Speechcraft") / 10,500)
			endif
		elseif !tssd_dealwithcurseQuest.isobjectivefailed(24)
			tActions.increaseGlobalDeity(3,PlayerRef.GetAV("Speechcraft")  / 20,1000)
		endif
        
        if _thread.CrtMaleHugePP()
            incrValAndCheck(36,1)
        EndIf
        if hasStrongPerson
            incrValAndCheck(38, 1)
        EndIf
        if hasTentacles
            incrValAndCheck(32, 1)
        EndIf
        
        if hasTagsInternal(_thread, "spanking")
            incrValAndCheck(13,1)
        endif
        
        if hasTagsInternal(_thread, "~rough, ~choking")
            incrValAndCheck(22,1)
        endif

        tVals.lastOrgasm = 0.1
	endif
	if _thread.SameSexThread() && _thread.GetPositions().Length > 1
		incrValAndCheck(4,1)
	endif
	if hasTagsInternal(_thread, "~love, ~loving, ~romance")
		incrValAndCheck(3,0)
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


