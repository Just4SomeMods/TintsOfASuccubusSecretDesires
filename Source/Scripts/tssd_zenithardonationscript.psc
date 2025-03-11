Scriptname tssd_zenithardonationscript extends ObjectReference  

Spell Property TSSD_ZenitharDonationSpell Auto
Perk Property TSSD_ZenitharDibellaPerk Auto

Event OnActivate(ObjectReference akActionRef)
    if Game.GetPlayer().HasPerk(TSSD_ZenitharDibellaPerk)
        TSSD_ZenitharDonationSpell.Cast(Game.GetPlayer(), Game.GetPlayer())
    endif
Endevent
    