;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 6
Scriptname QF_tssd_perkscripts_08000082 Extends Quest Hidden

;BEGIN ALIAS PROPERTY PlayerRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerRef Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
int max_num_traits = 8
if max_num_traits > TSSD_MaxTraits.GetValue()
        TSSD_MaxTraits.Mod(1 )
        Debug.Messagebox("You can now select " + TSSD_MaxTraits.GetValue() as int + " out of " + max_num_traits + " Traits!")
        if max_num_traits > TSSD_MaxTraits.GetValue()
                        Game.GetPlayer().RemovePerk(TSSD_Base_TraitGain)
        endif

endif
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
RegisterForModEvent("fhu.playerCumUpdate", "OnCumChange")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property TSSD_MaxTraits Auto

String Property CUM_VAGINAL = "sr.inflater.cum.vaginal" autoreadonly hidden
String Property CUM_ANAL = "sr.inflater.cum.anal" autoreadonly hidden
String Property CUM_ORAL = "sr.inflater.cum.oral" autoreadonly hidden

STRING PROPERTY SUCCUBUSLIBIDOINCREASE = "tssd.Libido.Rate" autoreadonly hidden

import storageutil

Function OnCumChange(float currentCum, bool isAnal)
    Actor PlayerRef = Alias_PlayerRef.GetActorReference()
    if GetFloatValue(PlayerRef, CUM_ORAL) > 0
            PlayerRef.AddSpell(TSSD_FilledUpBuffs)
            IntListSet(PlayerRef, SUCCUBUSLIBIDOINCREASE, 0, 0)
    else
            PlayerRef.RemoveSpell(TSSD_FilledUpBuffs)
            IntListSet(PlayerRef, SUCCUBUSLIBIDOINCREASE, 0, 1)
    endif
endfunction

SPELL Property TSSD_FilledUpBuffs  Auto  

Perk Property TSSD_Base_TraitGain  Auto 
