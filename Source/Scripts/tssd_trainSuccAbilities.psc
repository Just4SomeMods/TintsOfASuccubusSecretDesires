Scriptname tssd_trainSuccAbilities extends b612_TrainingMenu

String SkillName = ""
string skillId = ""
int skillValue = 0

GlobalVariable skillVal
GlobalVariable Property SuccubusXpAmount Auto
GlobalVariable Property TSSD_SuccubusPerkPoints Auto
GlobalVariable Property TSSD_PerkPointsBought Auto
Actor Property PlayerRef Auto
Perk Property TSSD_Base_Explanations Auto
Spell Property TSSD_BaseHealthBodyBuff Auto

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
    Return "5 increases each"
EndFunction

String Function GetTimesTrainedLabel()
    Return "Needs Succubus XP not gold"
EndFunction

; how many times the player has trained this skill
Int Function GetTimesTrained()
    return (SkillVal.GetValue()/5) as int
EndFunction

; how many times the player can train this skill
Int Function GetAvailableTraining()
    Return 999
EndFunction

; how much training for the next skill up costs
Int Function GetTrainCost()
    if SkillVal == TSSD_PerkPointsBought
        return 1000 + 100 * GetTimesTrained()
    Endif
    Return 250 * (GetTimesTrained() + 1)
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
            PlayerRef.AddSpell(TSSD_BaseHealthBodyBuff, false)
        endif
        PlayerRef.RemovePerk(TSSD_Base_Explanations)
        PlayerRef.AddPerk(TSSD_Base_Explanations)
    endif

EndFunction

