Scriptname TSSD_DrainMagickaOnCloak extends ActiveMagicEffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	akCaster.DamageAv("Magicka", 30)
	RegisterForSingleUpdate(1)
EndEvent

Event OnUpdate()
	Game.GetPlayer().DamageAv("Magicka", 30)
	RegisterForSingleUpdate(1)
EndEvent