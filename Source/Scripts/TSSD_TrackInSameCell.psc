Scriptname TSSD_TrackInSameCell extends activemagiceffect  
    {ability that will be activated when player is not in the same cell as invisibleObject}

import tssd_utils
tssd_actions Property tActions Auto

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
;/     if tActions.playerInSafeHaven()
		tActions.RegisterForCrosshairRef()
	else
		tActions.UnregisterForCrosshairRef()
	endIf /;
EndEvent