local pools = {
  TSSD_001FB = { "Huh?" },
  TSSD_Tasks_001 = {
    "Watch this!", "You're gonna love this", "I'm gonna make a mess", "This is gonna be fun", "Get ready",
    "You won't believe this", "This is gonna be hot", "I dare you to watch", "This is gonna be embarrassing",
    "This is gonna be fun"
  },
  TSSD_Tasks_002 = {
    "(Brawl) I can take you on!"
  },
  TSSD_Tasks_003 = {
    "Spare some coin for a poor girl?", "I'm broke, can you help?", "I need money, please", "Got any spare change?",
    "I'm desperate, can you help?", "I need money, please", "I'm broke, can you help?", "Got any spare change?",
    "I need money, please", "I'm desperate, can you help?"
  },
  TSSD_Tasks_004 = {
    "Don't you think I'd look better naked?", "I bet you wish you could touch me",
    "I bet you wish you could see me naked", "How comfortable is your bed?"
  },
  TSSD_Tasks_005 = {
    "I don't feel so good", "I'm dizzy", "I'm feeling lightheaded"
  },
  TSSD_Tasks_006 = {
    "Do you want to play with my hair?", "My hair is so soft, touch it"
  },
  TSSD_Tasks_007 = {
    "[Sob]... I lost my favorite doll!", "[Sob]... Someone pulled my hair!"
  },
  TSSD_Tasks_008 = {
    "I love you!", "I LOVE YOU!"
  },
  TSSD_Tasks_009 = {
    "Can I polish your boots?", "I'll polish your boots!"
  },
  TSSD_Tasks_101 = {
    "Let me slip into something more comfortable", "You won't mind if I change right here, will you?",
    "I need to change, if you don't mind."
  },
  TSSD_Tasks_102 = {
    "(Brawl) I can take you on!"
  },
  TSSD_Tasks_103 = { "I'm starving, feed me?", "I can't reach my food, help me?", "I'm too tired to eat, you do it." },
  TSSD_Tasks_104 = { "My shoulders are so tense, help me?", "I need a massage, please?", "I'm so stressed, help me?" },
  TSSD_Tasks_105 = { "I'm so cold, can you hold me?", "I need to be warm, can you hold me?", "I'm freezing, can you hold me?" },
  TSSD_Tasks_106 = { "I need to feel safe, can you hold me?", "I'm scared, can you hold me?", "I need your arms around me, can you hold me?" },
  TSSD_Tasks_107 = { "I'm so scared, can you hold me?", "I need to feel safe, can you hold me?", "I'm terrified, can you hold me?" },
  TSSD_Tasks_108 = { "Oops, sorry!", "Whoops, clumsy me!", "I'm so sorry!" },
  TSSD_Tasks_109 = { "I've wanted to kiss you for so long", "I can't resist you anymore", "I need to kiss you right now" },
  TSSD_Tasks_110 = { "I need to hold your hand", "I feel so alone, hold my hand?", "I need to feel connected, hold my hand?" },
  TSSD_Tasks_111 = { "I'm so aroused right now", "I can't stop thinking about it", "I need to tell you something" },
  TSSD_Tasks_201 = {
    "I need to take my clothes off", "You won't mind if I undress here, will you?", "I need to feel the air on my skin",
    "I need to be naked right now", "I need to show you something"
  },
  TSSD_Tasks_202 = {
    "Watch this", "You won't believe this", "I'm gonna make a mess", "This is gonna be fun", "Get ready"
  },
  TSSD_Tasks_203 = {
    "I'm such a slut", "I'm your little whore", "I'm your toy", "I'm your plaything", "I'm your bitch"
  },
  TSSD_Tasks_204 = {
    "I need to feel your chest", "I need to feel your skin", "I need to feel your warmth", "I need to feel your strength",
    "I need to feel your power"
  },
  TSSD_Tasks_205 = {
    "Touch me here", "I need your hand here", "I need you to feel this", "I need you to grab me", "I need you to hold me"
  },
  TSSD_Tasks_206 = {
    "Aa~h~ ngh!", "Yes! Yes!", "I'm coming!", "I'm cumming!", "I'm cumming!"
  },
  TSSD_Tasks_207 = {
    "(Brawl) I don't need my clothes to fight you!"
  },
  TSSD_Tasks_208 = {
    "Spank me!"
  },   TSSD_Tasks_301 = {
    "I need to feel your body", "I need to rub against you", "I need to feel your skin", "I need to feel your warmth", "I need to feel your strength"
  },
  TSSD_Tasks_302 = {
    "I need to feel your chest", "I need to feel your skin", "I need to feel your warmth", "I need to feel your strength", "I need to feel your power"
  },
  TSSD_Tasks_303 = {
    "Watch this", "You won't believe this", "I'm gonna make a mess", "This is gonna be fun", "Get ready"
  },
  TSSD_Tasks_304 = {
    "I need you", "I need you now", "I need you to fuck me", "I need you to take me", "I need you to use me"
  },
  TSSD_Tasks_305 = {
      "Break me, I beg you.",
      "I crave your cruelty, show me what you've got.",
      "I crave your dominance, your control, your power.",
      "I crave your pain, your pleasure, your touch.",
      "I exist to be degraded, to be humiliated, to be used.",
      "I exist to be used, to be broken, to be discarded.",
      "I exist to serve your pleasure, nothing more.",
      "I live to be degraded, to be humiliated.",
      "I'm nothing but a hole for you to fill.",
      "I'm nothing but a warm body for you to use.",
      "I'm your little slut, your little whore, your little bitch.",
      "I'm your little toy, your little plaything, your little pet.",
      "I'm your property, your possession, your plaything.",
      "Make me scream, make me bleed, make me yours.",
      "My body is your canvas, paint it however you like.",
      "The harder you hit me the louder I moan.",
      "The only right I have is to be used!",
      "Use me like the filthy toy I am."

  },
  TSSD_Tasks_306 = {
    "Watch this", "You won't believe this", "I'm gonna make a mess", "This is gonna be fun", "Get ready"
  },
  TSSD_Tasks_307 = {
    "(Brawl) If you are stronger than me I'll let you do anything you want to me!"
  },
  TSSD_Tasks_308 = {
    "Spank me!"
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
