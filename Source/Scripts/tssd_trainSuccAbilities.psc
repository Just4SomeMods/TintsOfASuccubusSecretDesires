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
Spell Property TSSD_StilettoBuffsNNerfs Auto
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
    Return ""
EndFunction

String Function GetTimesTrainedLabel()
    Return "Needs Succubus XP not gold"
EndFunction

; how many times the player has trained this skill
Int Function GetTimesTrained()
    return (SkillVal.GetValue()) as int
EndFunction

; how many times the player can train this skill
Int Function GetAvailableTraining()
    Return 90
EndFunction

; how much training for the next skill up costs
Int Function GetTrainCost()
    Return (Math.Pow((GetTimesTrained()) + 1, 1.95)) as int
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
    SkillVal.Mod(1)
    CustomSkills.ShowSkillIncreaseMessage(skillId, SkillVal.GetValue() as int)
    if SkillName == "Body"
        TSSD_ReverseBodySkill.SetValue( max(0, 100 - skillVal.GetValue()) )
    elseif SkillName == "Drain"            
        TSSD_ReverseDrainSkill.SetValue( max(0, 100 - skillVal.GetValue()) )
    elseif SkillName == "Seduction"
        TSSD_ReverseSeductionSkill.SetValue( max(0, 100 - skillVal.GetValue()) )
        if PlayerRef.HasPerk(getPerkNumber(25))
            PlayerRef.RemoveSpell(TSSD_StilettoBuffsNNerfs)
            Utility.Wait(0.1)
            PlayerRef.AddSpell(TSSD_StilettoBuffsNNerfs, false)
        endif
    endif
    PlayerRef.RemovePerk(TSSD_Base_Explanations)
    Utility.Wait(0.1)
    PlayerRef.AddPerk(TSSD_Base_Explanations)
EndFunction


Event Onb612_TrainingMenu_Close(string eventName, string strArg, float numArg, Form formArg)
    UnregisterForModEvent("b612_TrainingMenu_Ready")
    UnregisterForModEvent("b612_TrainingMenu_Train")
    UnregisterForModEvent("b612_TrainingMenu_Close")
    UI.CloseCustomMenu()
    tMenus.OpenExpansionMenu()
EndEvent
