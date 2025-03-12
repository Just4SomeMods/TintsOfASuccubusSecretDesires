Scriptname tssd_zenithardonationscript extends ObjectReference  

Spell Property TSSD_ZenitharDonationSpell Auto
Perk Property TSSD_DeityZenitharPerk Auto
Message Property TSSD_ZenitharDonationQuestion Auto
Form Property Gold001 Auto
Actor Property PlayerRef Auto

Event OnActivate(ObjectReference akActionRef)
    if Game.GetPlayer().HasPerk(TSSD_DeityZenitharPerk)
        int ibutton = TSSD_ZenitharDonationQuestion.Show()
        if ibutton == 0
            TSSD_ZenitharDonationSpell.Cast(Game.GetPlayer(), Game.GetPlayer())
            PlayerRef.RemoveItem(Gold001)
        endif
    endif
Endevent
    