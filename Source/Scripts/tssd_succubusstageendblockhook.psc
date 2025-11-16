Scriptname tssd_succubusstageendblockhook extends SexLabThreadHook  

Actor Property PlayerRef Auto
SexLabFramework Property SexLab Auto
;bool notFirstToStageLast = false
import tssd_utils
tssd_actions Property tActions Auto


string Function GetCumTarget(string scene_id) global
	int i = 3
	string[] targets_of = new string[3]
	targets_of[0] = "Anal"
	targets_of[1] = "Vaginal"
	targets_of[2] = "Oral"
	while i > 0
		i -= 1
		if SexlabRegistry.IsSceneTag(scene_id, targets_of[i])
			return targets_of[i] + ", "
		endif
	endwhile
	return ""
endFunction