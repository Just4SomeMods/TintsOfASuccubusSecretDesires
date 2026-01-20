local pools = {
  TSSD_001FB = {"Huh?"},
  TSSD_Tasks_01 = {
    "Don't you think I'd look better naked?"
  },
  TSSD_Tasks_02 = {
    "Watch this!"
  },
  TSSD_Tasks_03 = {
    "(Brawl) I can take you on!"
  },
  TSSD_Tasks_04 = {
    "I need some money pleeeease!"
  }
}

lastDialogue = ""

function replace(text)
  local pool = pools[text]
  if pool then
    if text == "TSSD_001FB" then
      send_mod_event("TSSD_DialogueFinished", lastDialogue, 0.0, speaker_id)
      return pool[math.random(1, #pool)]
    end


    lastDialogue = text
    log_info(text)
    send_mod_event("TSSD_DialogueFinished", lastDialogue, 0.0, speaker_id)
    local nxtText = pool[math.random(1, #pool)]
    log_info(nxtText)
    return nxtText
  end
  return text
end
