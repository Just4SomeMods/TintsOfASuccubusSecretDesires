Scriptname tssd_tints_variables extends Quest  Conditional

tssd_PlayerEventsScript Property tEvents Auto conditional

import tssd_utils
tssd_menus Property tMenus Auto
Actor Property PlayerRef Auto
ReferenceAlias Property LavenderTarget Auto
ReferenceAlias Property LavenderCuckTarget Auto
Faction Property TSSD_HasCuckedFaction Auto

float Property cupidFilledUpAmount = 0.0 Auto Conditional hidden
float Property lastCumOnTime = 164.0 Auto Conditional hidden
float Property lastPraiseTime = 164.0 Auto Conditional hidden
float Property lastRoughTime = 164.0 Auto Conditional hidden
float Property lastSpankedTime = 164.0 Auto Conditional hidden
float Property lastRomanticTime = 164.0 Auto Conditional hidden
float Property lastCumInMe = 164.0 Auto Conditional hidden
float Property lastWolfSex = 164.0 Auto Conditional hidden
float Property lastHypnoSession = 164.0 Auto Conditional hidden
float Property lastFadeTat = 164.0 Auto Conditional hidden
float Property lastMasturbated = 164.0 Auto Conditional hidden
float Property lastDragon = 164.0 Auto Conditional hidden
float Property lastTentacle = 164.0 Auto Conditional hidden
float Property lastOrgasm = 164.0 Auto Conditional hidden
float Property lastSlutCity = 164.0 Auto Conditional hidden
float Property lastBreastFed = 164.0 Auto Conditional hidden
float Property lastBarter = 0.0 Auto Conditional hidden
float Property hasEggs = 0.0 Auto Conditional hidden
int Property ruinedRelationships = 1 Auto Conditional hidden
bool Property isGagged = false Auto Conditional hidden
bool Property isNude = false Auto Conditional hidden
bool Property isHeeled = false Auto Conditional hidden
bool Property isWearingCS = false Auto Conditional hidden
bool Property isWearingNP = false Auto Conditional hidden
bool Property isWearingSkimpy = false Auto Conditional hidden
bool Property beingOrdered = false Auto Conditional hidden

bool Property talkingWithNonWolf = false Auto Conditional hidden
bool Property canTake00Razzmatazz = false Auto Conditional hidden
bool Property canTake01Cupid = false Auto Conditional hidden
bool Property canTake02Lavenderblush = false Auto Conditional hidden
bool Property canTake03Carnation = false Auto Conditional hidden
bool Property canTake04Tosca = false Auto Conditional hidden
bool Property canTake05Blush = false Auto Conditional hidden
bool Property canTake06Lilac = false Auto Conditional hidden
bool Property canTake07Pink = false Auto Conditional hidden
bool Property canTake08Maroon = false Auto Conditional hidden
bool Property canTake09Pink2 = false Auto Conditional hidden
bool Property canTake10Crusta = false Auto Conditional hidden
bool Property canTake11Sangria = false Auto Conditional hidden
bool Property canTake12Mystic = false Auto Conditional hidden
bool Property canTake13Geraldine = false Auto Conditional hidden
bool Property canTake14Crimson = false Auto Conditional hidden
bool Property canTake15Cerise = false Auto Conditional hidden
bool Property canTake16Plum = false Auto Conditional hidden
bool Property canTake17Pompadour = false Auto Conditional hidden
bool Property canTake18Tolopea = false Auto Conditional hidden
bool Property canTake19Scarlet = false Auto Conditional hidden
bool Property canTake20Mahogany = false Auto Conditional hidden
bool Property canTake21Tutu = false Auto Conditional hidden
bool Property canTake22Tamrind = false Auto Conditional hidden
bool Property canTake23Pueblo = false Auto Conditional hidden
bool Property canTake24Valencia = false Auto Conditional hidden
bool Property canTake25Stiletto = false Auto Conditional hidden
bool Property canTake26Neon = false Auto Conditional hidden
bool Property canTake27Ruby = false Auto Conditional hidden
bool Property canTake28Oblivion = false Auto Conditional hidden
bool Property canTake29Carmine = false Auto Conditional hidden
bool Property canTake30Pastel = false Auto Conditional hidden
bool Property canTake31Monza = false Auto Conditional hidden
bool Property canTake32Mulberry = false Auto Conditional hidden
bool Property canTake33Paco = false Auto Conditional hidden
bool Property canTake34Blood = false Auto Conditional hidden
bool Property canTake35Silver = false Auto Conditional hidden
bool Property canTake36Carissma = false Auto Conditional hidden
bool Property canTake37Temptress = false Auto Conditional hidden
bool Property canTake38Bordeaux = false Auto Conditional hidden
Bool[] Property canTakeBools  Auto  


function set_color()

	
    JValue.cleanPool("SlaveTatsHighLevel")
    int mashedCol = getCombinedColor()
    JMap.setInt(tMenus.neckTattoo, "color", mashedCol)
    slavetats.mark_actor(PlayerRef)
	slavetats.synchronize_tattoos(PlayerRef, false)
    RegisterForUpdateGameTime(1)

EndFunction

Event OnInit()
    RegisterForUpdateGameTime(1)
    RegisterForMenu("Dialogue Menu")
EndEvent

Event OnUpdateGameTime()
    RegisterForMenu("Dialogue Menu")
    ; DBGTrace("UPDATELEL")
EndEvent

Event OnMenuOpen(string MenuName)
    if MenuName == "Dialogue Menu"
        if playerref.hasperk(getPerkNumber(2)) && !LavenderTarget.GetReference()
            Utility.Wait(0.5)
            Actor tempActor = SPE_Actor.GetPlayerSpeechTarget()
            if tempActor && !isSingle(tempActor) && tempActor.GetFactionRank(TSSD_HasCuckedFaction) < 1
                LavenderTarget.ForceRefTo(tempActor)
                Actor getSps = TTRF_RelationsFinder.GetSpouse(tempActor)
                if !getSps
                    getSps = TTRF_RelationsFinder.GetCourting(tempActor)
                endif
                DBGTrace(getSPS)
                LavenderCuckTarget.ForceRefTo(getSps)
                tempActor.SetFactionRank(TSSD_HasCuckedFaction, 0)
                getSps.SetFactionRank(TSSD_HasCuckedFaction, 0)
                SetObjectiveCompleted(2, false)
                SetObjectiveDisplayed(2, false)
                SetObjectiveDisplayed(2)
            EndIf
        EndIf
    EndIf
EndEvent