Scriptname TSSD_TrackInSameCell extends activemagiceffect
    {ability that will be activated when player is not in the same cell as invisibleObject}

import tssd_utils
Actor Property PlayerRef Auto
tssd_actions Property tActions Auto

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	Utility.Wait(1)
	if tActions.playerInSafeHaven() && tActions.currentSeduced && tActions.currentSeduced != PlayerRef
		tActions.currentSeduced.MoveTo(PlayerRef)
		tActions.TSSD_FollowsPlayer.ForceRefTo(tActions.currentSeduced)
	endIf
EndEvent