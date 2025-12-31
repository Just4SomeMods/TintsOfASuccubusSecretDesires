local bimboDialogue = { "Uhhm my pimp... what does that mean? Oh drain as in suck as in sex? Yesyesyesyes!",
  "Ohh that always feels so good when I haven't done that in a while!",
  "Everything for you, you made me into the bestest thing I could ever be!" }
local doggieDialogue = { "Let's put you in your place!", "Who's a good doggie? Now stay still while I...", "Yes, I will fuck you, just how you need it.", "Aww look who's in heat?" }


local pools = {
  TSSD_00093 = {
    { "Yes my love?" },
    { "I am yours to command!" },
    { "What do you want my pet?" },
    { "Just this once." }
  },
  TSSD_00096 = {
    { "Just how we like it." },
    { "Just how you like it." },
    { "Just how I like it." },
    { "Just this once." }
  },
  TSSD_00098 = {
    { "Gladly" },
    { "I've longed for your embrace." },
    { "Let me taste your lips." },
    { "Just this once." }
  },
  TSSD_000AF = {
    { "I am going to enjoy this." },
    { "Ooh, let's do this!" },
    { "Oh, let me correct you brat!" }
  },
  TSSD_000C4 = {
    {}, {}, {},
    { "I am in a relationship, I shouldn't agree to this, but your eyes are sooo captiviating.",
      "I think one kiss shouldn't count as cheating?" }
  },
  TSSD_000C6 = {
    { "I do love our CnC sessions." }, { "That roleplay again, sure!" }, { "Who do you think prepared your drink?" },
    { "Who do you think prepared your drink?",
      "You could've just asked!",
      "This is gonna be good." }
  },
  TSSD_000C7 = {
    { "Eww." }, { "Eww." }, { "Eww." },
    { "Eww.",
      "No, thank you." }
  },
  TSSD_000B0 = {
    { "Some pain is good!" }, { "Some pain is good!" }, { "Some pain is good!" },
    { "Eww.",
      "No, thank you." }
  },
  TSSD_000D2 = {
    { "Whatever you say my love." },
    { "Take my money!" },
    { "This is coming out of your stipend." },
    { "I really shouldn't but those hips don't lie!" }

  },
  TSSD_000DA = {
    { "Whatevery you say!." },
    { "Yeees!" },
    { "Hit me how I like it!" },
    { "I probably deserve that." }

  },
  TSSD_000A3 = {
    { "ERROR" }, { "ERROR" }, { "ERROR" },
    { "YAAAAY." }
  },
  TSSD_000A2 = {
    { "ERROR" }, { "ERROR" }, { "ERROR" },
    { "Yaaaay." }
  },
  TSSD_000A1 = {
    { "ERROR" }, { "ERROR" }, { "ERROR" },
    { "Yay." }
  },
  TSSD_00109 = {
    { "ERROR" }, { "ERROR" }, { "ERROR" },
    { "Oh ok then." }
  },
  TSSD_000A6 = {
    { "..." }, { "..." }, { "..." },
    { "..." }
  },
  TSSD_000CD = {
    { "Let's go have some fun!" }, { "Let's go have some fun!" }, { "Let's go have some fun!" },
    { "Let's go have some fun!" }
  },
  TSSD_000B2 = {
    { "You will look so beautiful!" }, { "It's good for your skin!" }, { "Everyone will know that you are mine!" },
    { "I like your enthusiasm!" }
  },
  TSSD_000DD = {
    { "Oh ok then." }, { "Oh ok then." }, { "Oh ok then." }, { "Oh ok then." }
  },
  TSSD_000E1 = {
    { "You've earned it." }, { "Everything for you my queen." }, { "Are you to stupid to keep it? Ugh, fine." }, { "Yeah sure." }
  },
  TSSD_000EE = {
    { "You are the love of my life." }, { "You are the light of my life." }, { "You are a good pet." }, { "You are doing great keep it up!" }
  },
  TSSD_000F5 = {
    { "You are the most perfect person I have ever seen." },
    { "You are the meaning of my life!" },
    { "Without you, I'd be incomplete." },
    { "Your body is a gift from Dibella herself!" }
  },
  TSSD_000F7 = { bimboDialogue, bimboDialogue, bimboDialogue, bimboDialogue

  },
  TSSD_00103 = { { "Sure" }, { "Sure" }, { "Sure" }, { "Sure" }

  },
  TSSD_00111 = { { "I never get tired of that!" }, { "I can lose myself in your body!" }, { "I wanted to sample the merchandise for quite some time now." }, { "Sure" }

  },
  TSSD_0010E = { { "If your okay with that I'll let you watch" }, { "I'll put on a good show!" }, { "It was getting predictable with you anyway." }, { "Sure" }

  },
  TSSD_00133 = { doggieDialogue  },
  TSSD_00139 = { {"Sure"}, {"Sure"},{"Sure"},{"Sure"}  },
  TSSD_0013D = { {"Sure"}, {"Sure"},{"Sure"},{"Sure"}  },
  TSSD_00155 = { {"Sure"}, {"Sure"},{"Sure"},{"Sure"}  },
  TSSD_00142 = { {"Yes, keep coming back for it!", "You always love it!", "You are the most obedient student I ever had!"}  }


}


local function get_thrall_type(pSpeaker_id)
  local thrallDomFaction = get_formid(0x00090, "TintsOfASuccubusSecretDesires.esp")
  local thrallSubFaction = get_formid(0x000A8, "TintsOfASuccubusSecretDesires.esp")
  local thrallNotAThrall = get_formid(0x0008F, "TintsOfASuccubusSecretDesires.esp")
  local thrallType = 1
  if is_in_faction(pSpeaker_id, thrallSubFaction) == 1 then
    thrallType = 2
  end
  if is_in_faction(pSpeaker_id, thrallDomFaction) == 1 then
    thrallType = 3
  end
  if is_in_faction(pSpeaker_id, thrallNotAThrall) == 0 then
    thrallType = 4
  end
  return thrallType
end

function replace(text)
  local pool = pools[text]
  if pool then
    log_info(text)
    local thrallType = get_thrall_type(speaker_id)
    if text ~= "TSSD_00093" then
      send_mod_event("TSSD_DialogueFinished", text, 0.0, speaker_id)
    end
    local nxtText
    if #pool == 1 then
      nxtText = pool[1][math.random(1, #pool[1])]
    else
      nxtText = pool[thrallType][math.random(1, #pool[thrallType])]
    end

    log_info(nxtText)
    return nxtText
  end
  return text
end
