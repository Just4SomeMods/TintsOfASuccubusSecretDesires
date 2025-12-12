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
    {"Let me taste your lips."},
    {"Just this once."}
  },
  TSSD_000AF = {
    {"I am going to enjoy this."},
    {"Ooh, let's do this!"},
    {"Oh, let me correct you brat!"}
  },  
  TSSD_000C4 = {
    {},{},{},
    {"I am in a relationship, I shouldn't agree to this, but your eyes are sooo captiviating.",
    "I think one kiss shouldn't count as cheating?"}
  },
  TSSD_000C6 = {
    {"I do love our CnC sessions."},{"That roleplay again, sure!"},{"Who do you think prepared your drink?"},
    {"Who do you think prepared your drink?",
    "You could've just asked!",
    "This is gonna be good."}
  },
  TSSD_000C7 = {
    {},{},{},
    {"Eww.",
    "No, thank you."}
  },
  TSSD_000D2 = {
    {"Whatever you say my love."},
    {"Take my money!"},
    {"This is coming out of your stipend."},
    {"I really shouldn't but those hips don't lie!"}

  }
}


function get_thrall_type(pSpeaker_id)

  local thrallDomFaction = get_formid(0x000AA,"TintsOfASuccubusSecretDesires.esp")
  local thrallSubFaction = get_formid(0x000A8,"TintsOfASuccubusSecretDesires.esp")
  local thrallNotAThrall = get_formid(0x0008F,"TintsOfASuccubusSecretDesires.esp")
  local thrallType = 1
  if is_in_faction(pSpeaker_id, thrallSubFaction  ) == 1 then
    thrallType = 2
  end
  if is_in_faction(pSpeaker_id, thrallDomFaction  ) == 1 then 
    thrallType = 3
  end
  if is_in_faction(pSpeaker_id, thrallNotAThrall  ) == 0 then 
    thrallType = 4
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