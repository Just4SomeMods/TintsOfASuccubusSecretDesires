Scriptname tssd_trainSuccAbilities extends b612_TrainingMenu

String SkillName = ""
int skillValue = 0

GlobalVariable Property SkillVal Auto
GlobalVariable Property SuccubusXpAmount Auto
GlobalVariable Property TOSD_SuccubusPerkPoints Auto
GlobalVariable Property TSSD_PerkPointsBought Auto

Function SetSkillName(String newName)
    SkillName = newName
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
    Return "Master"
EndFunction

String Function GetTimesTrainedLabel()
    Return "Level"
EndFunction

; how many times the player has trained this skill
Int Function GetTimesTrained()
    Return SkillVal.GetValue() as int
EndFunction

; how many times the player can train this skill
Int Function GetAvailableTraining()
    Return 100
EndFunction

; how much training for the next skill up costs
Int Function GetTrainCost()
    if SkillVal == TSSD_PerkPointsBought
        return 1000 * (GetTimesTrained() + 1)
    Endif
    Return 10 * (GetTimesTrained() + 1)
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
    SuccubusXpAmount.SetValue( GetCurrentGold() - GetTrainCost() )
    SkillVal.SetValue((SkillVal.GetValue()) + 1 as int)
    if SkillVal == TSSD_PerkPointsBought
        TOSD_SuccubusPerkPoints.SetValue(TOSD_SuccubusPerkPoints.GetValue() + 1 as int)
    endif

EndFunction

