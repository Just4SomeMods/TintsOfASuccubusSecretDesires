Scriptname tssd_energyLossSneakingScript extends activemagiceffect  

Actor Property PlayerRef Auto
GlobalVariable Property SuccubusDesireLevel Auto
tssd_PlayerEventsScript Property tEvents Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)

	RegisterForSingleUpdate(1)
endEvent

Event OnUpdate()
	
    SuccubusDesireLevel.SetValue( SuccubusDesireLevel.GetValue() - 0.2 )
	tEvents.incrValAndCheck(10,0.2)


if PlayerRef.issneaking() && SuccubusDesireLevel.GetValue()  > 1
		RegisterForSingleUpdate(1)
else
	Dispel()
endif
EndEvent