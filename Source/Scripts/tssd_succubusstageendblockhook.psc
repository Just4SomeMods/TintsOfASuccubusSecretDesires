Scriptname tssd_succubusstageendblockhook extends SexLabThreadHook  

Actor Property PlayerRef Auto
SexLabFramework Property SexLab Auto
;bool notFirstToStageLast = false
import tssd_utils

; Called when all of the threads data is set, before the active animation is chosen
Function OnAnimationStarting(SexLabThread akThread)
    ;notFirstToStageLast = false
    ;Debug.Messagebox("LEL")
EndFunction


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

; Called whenever a new stage is picked, including the very first one
Function OnStageStart(SexLabThread akThread)
    
    if   SexLabRegistry.GetPathMax(akThread.getactivescene() ,akThread.GetActiveStage()).Length == 1
        bool someOneunsatisfied = false
        bool conSent = true
        int index = 0
        SexLabThread cur_thread = Sexlab.GetThreadByActor(PlayerRef)
        Actor[] ActorsIn = akThread.GetPositions()
        int[] enjoymentsBefore = Utility.CreateIntArray(ActorsIn.Length, 0)
        sslThreadController _thread = akThread as sslThreadController
        if _thread && cur_thread
            while index <  ActorsIn.length
                Actor akTarget = ActorsIn[index]
                enjoymentsBefore[index] = _thread.GetEnjoyment(ActorsIn[index]) 
                if akTarget != PlayerRef
                    if _thread.ActorAlias(akTarget).GetOrgasmCount() == 0
                        someOneunsatisfied = true
                    Endif
                    if cur_thread.GetSubmissive(akTarget)
                        conSent = false
                    endif
                endif
                index += 1
            EndWhile
            if someOneunsatisfied; && notFirstToStageLast
                ;Sexlab.GetPlayerController().AdvanceStage(true)
                ;akThread.ResetScene(asScenes[0])
                if (!conSent && !cur_thread.GetSubmissive(PlayerRef)) || cur_thread.GetSubmissive(PlayerRef)
                    akThread.ResetScene(cur_thread.GetActiveScene())
                    
                else 
                    cur_thread.SetIsSubmissive(PlayerRef, true)
                    string tagsAsString = GetCumTarget(cur_thread.GetActiveScene())

                    String[] asScenes2 = SexLabRegistry.LookupScenesA( ActorsIn  , tagsAsString + "-Aircum",  akThread.GetSubmissives(), 0, none )
                    akThread.ResetScene(asScenes2[Utility.RandomInt(0, asScenes2.Length)])
                    index = 0
                    while index <  ActorsIn.length
                        actor curActor = ActorsIn[index]
                        if curActor != PlayerRef
                            _thread.AdjustEnjoyment(ActorsIn[index], 50 + enjoymentsBefore[index])
                        endif
                        index += 1
                    EndWhile
                endif
            endif
            ;notFirstToStageLast = true
        else
            
            ;notFirstToStageLast = false
        endif
    endif
EndFunction
; 
; ; Called whenever a stage ends, including the very last one
; Function OnStageEnd(SexLabThread akThread)
;     ;Debug.Messagebox("End of " + SexLabRegistry.GetPathMax(akThread.getactivescene() ,akThread.GetActiveStage()).Length)
;     ; On Stage End seems to be broken
; EndFunction
; 
; ; Called once the animation has ended
; Function OnAnimationEnd(SexLabThread akThread)
;     ;Debug.Messagebox("Yeah")
; EndFunction


Event OnInit()
      Register()
      Parent.OnInit()
  EndEvent