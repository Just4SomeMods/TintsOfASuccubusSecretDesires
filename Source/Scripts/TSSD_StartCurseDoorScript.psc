Scriptname TSSD_StartCurseDoorScript extends ObjectReference  

Message Property TSSD_PeepingKim Auto
Actor Property PlayerRef Auto
Actor Property CursedWoman Auto
Actor Property QuestGiver Auto
SexLabFramework Property SexLab Auto
Quest Property TSSD_StartCurse Auto
tssd_menus Property tMenus Auto

Faction Property TSSD_EnthralledFaction Auto

ImageSpaceModifier Property AzuraFadeToBlack  Auto

bool canActivateAgain = true
bool morphsApplied = false

import tssd_utils

Event OnActivate(ObjectReference akActionRef)
	if canActivateAgain
		canActivateAgain = false
		int outPut = TSSD_PeepingKim.Show()
		if !morphsApplied
			morphsApplied = true
		endif
		if outPut == 0
			DoFadeOut(1)
			Lock(false)
			TSSD_StartCurse.SetStage(10)
			Debug.MessageBox("She looks directly into your eyes. Suddenly your body moves on its own. You kneel and strip. She phases through the door with a big smile...")
			RegisterForModEvent("HookAnimationEnd_TSSD_MyLocalHook", "AnimEnd")
			SexLab.StartSceneQuick(PlayerRef, CursedWoman, asHook="TSSD_MyLocalHook")

			TSSD_StartCurse.SetObjectiveCompleted(10, true)
			Utility.Wait(2)
			DoFadeIn(1)
		else
			canActivateAgain = true
		endif
	endif
EndEvent

Event AnimEnd(int aiThreadID, bool abHasPlayer)
	UnregisterForModEvent("HookAnimationEnd_TSSD_MyLocalHook")
	DoFadeOut(1)
	Debug.MessageBox("Several hours later...")

	Actor inflater = QuestGiver
	Int handle = ModEvent.Create("SR_InflateEvent")
	ModEvent.PushForm(handle, PlayerRef)
	ModEvent.PushBool(handle, true)
	ModEvent.PushInt(handle, 7)
	ModEvent.PushFloat(handle, 3)
	ModEvent.PushInt(handle, 2)
	ModEvent.PushString(handle, "")
	ModEvent.Send(handle)
	
	handle = ModEvent.Create("SR_InflateEvent")
	ModEvent.PushForm(handle, CursedWoman)
	ModEvent.PushBool(handle, true)
	ModEvent.PushInt(handle, 7)
	ModEvent.PushFloat(handle, 3)
	ModEvent.PushInt(handle, 2)
	ModEvent.PushString(handle, "")
	ModEvent.Send(handle)


	SexLab.AddCumFxLayers(PlayerRef, 0, 4)
	SexLab.AddCumFxLayers(PlayerRef, 1, 4)
	SexLab.AddCumFxLayers(PlayerRef, 2, 4)
	RegisterForModEvent("HookAnimationEnd_TSSD_MySecond", "AnimEndTwo")
	SexLab.StartSceneQuick(PlayerRef, CursedWoman,QuestGiver, asHook="TSSD_MySecond")
	DoFadeIn(1)
EndEvent

Event AnimEndTwo(int aiThreadID, bool abHasPlayer)
	TSSD_StartCurse.SetStage(20)
	DoFadeOut(1)
	Sexlab.ClearCum(Game.GetPlayer())
	Sexlab.ClearCum(CursedWoman)
	Utility.Wait(2)
	DoFadeIn(1)
	CursedWoman.SetFactionRank(TSSD_EnthralledFaction, 1)
EndEvent
