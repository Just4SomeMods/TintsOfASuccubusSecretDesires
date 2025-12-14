Scriptname tssd_PlayerEventsScript extends ReferenceAlias

tssd_actions Property tActions Auto
Actor Property PlayerRef Auto
GlobalVariable Property TSSD_TypeMahogany Auto
Spell Property tssd_Satiated Auto
MagicEffect Property TSSD_SatiatedEffect Auto
GlobalVariable Property SkillSuccubusDrainLevel Auto

Faction Property TSSD_RevealingOutfit Auto

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

import tssd_utils

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, \
    bool abBashAttack, bool abHitBlocked)
    Weapon akW = akSource as Weapon
    
    if TSSD_TypeMahogany.GetValue() == 1.0 && akW && !abHitBlocked
        tActions.gainSuccubusXP(akW.GetBaseDamage() * 20 )
    endif
    if PlayerRef.GetAV("Health") < 100 && !PlayerRef.HasMagicEffect(TSSD_SatiatedEffect) && (akAggressor as Actor) && \
        (akAggressor as Actor).GetAv("Health") < SkillSuccubusDrainLevel.GetValue()
        Actor tar = tActions.getLonelyTarget()
        if tar && tar != PlayerRef
            tActions.actDefeated(tar)
        endif
    endif
EndEvent

Function onGameReload()
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