local pools = {
  TSSD_00093 = {
    {"Yes my love?"},
    {"I am yours to command!"},
    {"What do you want my pet?"}
  },
  TSSD_00096 = {
    {"Just how we like it."},
    {"Just how you like it."},
    {"Just how I like it."}
  },
  TSSD_00098 = {
    {"Gladly"},
    {"I've longed for your embrace."},
    {"Let me taste your lips."}
  }
}



function get_thrall_type(pSpeaker_id)

  local thrallDomFaction = get_formid(0x000AA,"TintsOfASuccubusSecretDesires.esp")
  local thrallSubFaction = get_formid(0x000A8,"TintsOfASuccubusSecretDesires.esp")
  local thrallType = 1
  if is_in_faction(pSpeaker_id, thrallSubFaction  ) == 1 then
    thrallType = 2
  end
  if is_in_faction(pSpeaker_id, thrallDomFaction  ) == 1 then 
    thrallType = 3
  end
  return thrallType
end

function replace(text)
    local pool = pools[text]
    if pool then
      local thrallType = get_thrall_type(speaker_id)
      return pool[thrallType][math.random(1, #pool[thrallType])]
    end
    return text
end