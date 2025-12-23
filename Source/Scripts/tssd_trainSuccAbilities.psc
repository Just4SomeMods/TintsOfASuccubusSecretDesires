Scriptname tssd_trainSuccAbilities extends b612_TrainingMenu

String SkillName = ""
string skillId = ""
int skillValue = 0

import tssd_utils

GlobalVariable skillVal
GlobalVariable Property SuccubusXpAmount Auto
GlobalVariable Property TSSD_SuccubusPerkPoints Auto
GlobalVariable Property TSSD_PerkPointsBought Auto
GlobalVariable Property TSSD_ReverseBodySkill Auto
GlobalVariable Property TSSD_ReverseDrainSkill Auto
GlobalVariable Property TSSD_ReverseSeductionSkill Auto
Actor Property PlayerRef Auto
Perk Property TSSD_Base_Explanations Auto
Spell Property TSSD_BaseHealthBodyBuff Auto
Tssd_Menus Property tMenus Auto

Function SetSkillName(String newName)
    SkillName = newName
Endfunction

Function SetSkillId(string newID)
    skillId = newID
Endfunction

Function SetSkillVariable(GlobalVariable newVal)
    SkillVal = newVal
Endfunction

; show the skill name being trained
String Function GetSkillName()
    Return SkillName
EndFunction

; shows trainer's skill level
String Function GetTrainerSkill()
    if SkillVal == TSSD_PerkPointsBought
        return ""
    endif
    Return "5 increases each"
EndFunction

String Function GetTimesTrainedLabel()
    Return "Needs Succubus XP not gold"
EndFunction

; how many times the player has trained this skill
Int Function GetTimesTrained()
    if SkillVal == TSSD_PerkPointsBought
        return SkillVal.GetValue() as int
    endif
    return (SkillVal.GetValue()/5) as int
EndFunction

; how many times the player can train this skill
Int Function GetAvailableTraining()
    if SkillVal == TSSD_PerkPointsBought
        Return 99
    endif
    return 20
EndFunction

; how much training for the next skill up costs
Int Function GetTrainCost()
    if SkillVal == TSSD_PerkPointsBought
        return 1000 + 100 * GetTimesTrained()
    Endif
    Return (Math.Pow((GetTimesTrained() * 5) + 1, 1.95) * 5) as int
EndFunction

; how much money the player currently has
Int Function GetCurrentGold()
    Return SuccubusXpAmount.GetValue() as int
EndFunction

; skill's progress, number between 0 and 100
Int Function GetSkillMeterPercent()
    Return 0
EndFunction

; train the skill
Function Train()
    SuccubusXpAmount.Mod( -1 * GetTrainCost() )
    if SkillVal == TSSD_PerkPointsBought
        TSSD_PerkPointsBought.Mod( 1)
        TSSD_SuccubusPerkPoints.Mod(1)
    else
        SkillVal.Mod( 5 )
        CustomSkills.ShowSkillIncreaseMessage(skillId, SkillVal.GetValue() as int)
        ;CustomSkills.IncrementSkill(SkillVal)
    endif
    if PlayerRef.HasPerk(TSSD_Base_Explanations)
        if SkillName == "Body"
            PlayerRef.RemoveSpell(TSSD_BaseHealthBodyBuff)
            Utility.Wait(0.1)
            PlayerRef.AddSpell(TSSD_BaseHealthBodyBuff, false)
            TSSD_ReverseBodySkill.SetValue( max(0, 100 - skillVal.GetValue()) )
        elseif SkillName == "Drain"            
            TSSD_ReverseDrainSkill.SetValue( max(0, 100 - skillVal.GetValue()) )
        elseif SkillName == "Seduction"
            TSSD_ReverseSeductionSkill.SetValue( max(0, 100 - skillVal.GetValue()) )
        endif
        PlayerRef.RemovePerk(TSSD_Base_Explanations)
        PlayerRef.AddPerk(TSSD_Base_Explanations)
    endif
EndFunction


Event Onb612_TrainingMenu_Close(string eventName, string strArg, float numArg, Form formArg)
    UnregisterForModEvent("b612_TrainingMenu_Ready")
    UnregisterForModEvent("b612_TrainingMenu_Train")
    UnregisterForModEvent("b612_TrainingMenu_Close")
    UI.CloseCustomMenu()
    tMenus.OpenExpansionMenu()
EndEvent
