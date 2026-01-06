local pPools = {
TSSD_003DF = {"I am still physically dependent on cum, but sex is like a million times better since the curse.","I can't thank you enough for your help! I can wear clothes again! It's great!", "I'm just your usual rich kid who went to the wrong party.", "I'm a pan- and polysexual switch. If you say I just can't decide what I am, I won't correct you.", "I am an illusionist, so the form you currently see is what I want you to see.", "I love your smell. That's a fact about me!"}
}

infosNumber = 1.0
lastPlayerChoice = ""

function replace(text)
  if context == 1 then
    lastPlayerChoice = text
    return text
  end
  local pool = pPools[text]
  if context == 2 and pool then
    log_info(lastPlayerChoice)
    if lastPlayerChoice == "Ehm, nevermind." then
      log_info(tostring(math.floor(infosNumber)))
      if math.floor(infosNumber) > #pool then
        infosNumber = 1
      end
      nxText = pool[math.floor(infosNumber)]
      infosNumber = infosNumber + 0.5
      return nxText
    end
  end
  return text
end