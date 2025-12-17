Scriptname tssd_PlayerEventsScript extends ReferenceAlias

tssd_actions Property tActions Auto
tssd_menus Property tMenus Auto
Quest Property tssd_tints_tracker Auto
Actor Property PlayerRef Auto
GlobalVariable Property TSSD_TypeMahogany Auto
Spell Property tssd_Satiated Auto
MagicEffect Property TSSD_SatiatedEffect Auto
GlobalVariable Property SkillSuccubusDrainLevel Auto

int[] colorsToAdd

Faction Property TSSD_RevealingOutfit Auto
Faction Property TSSD_Collared Auto

bool isActingDefeated = false
float totalDamageTaken = 0.0
bool[] Property colorsChecked Auto Hidden 
bool crimsonDone = false

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

import tssd_utils

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, \
    bool abBashAttack, bool abHitBlocked)
    Weapon akW = akSource as Weapon
    if TSSD_TypeMahogany.GetValue() == 1.0 && akW && !abHitBlocked
        tActions.gainSuccubusXP(akW.GetBaseDamage() * 20 )
    endif
    if PlayerRef.GetAV("Health") < 100 && !PlayerRef.HasMagicEffect(TSSD_SatiatedEffect) && (akAggressor as Actor) && \
        (akAggressor as Actor).GetAv("Health") < tActions.getDrainLevel() && !isActingDefeated
		isActingDefeated = true
        Actor tar = tActions.getLonelyTarget()
        if tar && tar != PlayerRef
            tActions.actDefeated(tar, false)
        Endif
		isActingDefeated = false
    endif

	totalDamageTaken += akW.GetBaseDamage()
	if !crimsonDone && totalDamageTaken >= 5
		crimsonDone = true
		tMenus.ShowSuccubusTrait(14)
	endif
EndEvent

Function onGameReload()
	isActingDefeated = false
	crimsonDone = false
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
	Else
		ZaZAnimationPackFound = False
		zbfWornCollar = none
	endif

	If (Game.GetModByName(FILE_DD_ASSETS) != 255)
		DDAssetsFound = True
		zad_DeviousCollar = Game.GetFormFromFile(0x3DF7, FILE_DD_ASSETS) as Keyword
	Else
		DDAssetsFound = False
		zad_DeviousCollar = none
	EndIf

	If (Game.GetModByName(FILE_SCHLONGS_OF_SKYRIM) != 255)
		SOS_SchlongifiedFaction = Game.GetFormFromFile(0xAFF8, FILE_SCHLONGS_OF_SKYRIM) as Faction
	Else
		SOS_SchlongifiedFaction = none
	EndIf
EndFunction



Bool Function IsPlayerSkimpy()
    return (IsNaked && (IsShowingChest || IsShowingGenitals || IsShowingAss || IsTopless || IsBottomless || IsShowingBra || IsShowingUnderwear))
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
    PlayerRef.SetFactionRank(TSSD_RevealingOutfit, IsPlayerRevealing() as int )
    PlayerRef.SetFactionRank(TSSD_Collared, IsActorCollared(PlayerRef) as int )
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


