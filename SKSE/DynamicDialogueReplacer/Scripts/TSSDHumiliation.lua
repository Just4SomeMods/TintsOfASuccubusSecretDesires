local selfHumi = {
    "I am a filthy slut",
    "I am just a toy for everyone's pleasure",
    "I exist to be used",
    "I need to be filled up",
    "I can only cum if I am in pain",
    "I have no hole left to deflower",
    "I am here to chew cum and lick ass",
    "I am a cum dumpster"
}

local humiAnsw = {
  "Go on...",
  "Good..."
}

local pPools = {
  TSSD_000B5 = selfHumi,
  TSSD_000B6 = selfHumi,
  TSSD_000B7 = selfHumi,
  TSSD_000B8 = selfHumi
}

local oPools = {
  TSSD_000B9 = humiAnsw,
  TSSD_000BA = humiAnsw,
  TSSD_000BB = humiAnsw,
  TSSD_000BC = humiAnsw
}

local answersTo = {
  TSSD_000B9 = "TSSD_000B8",
  TSSD_000BC = "TSSD_000B5",
  TSSD_000BB = "TSSD_000B7",
  TSSD_000BA = "TSSD_000B6"

}

savedStrings = {}
saidStrings = {}

internalcounter = 0

function shuffle(tbl) -- suffles numeric indices
    local len, random = #tbl, math.random ;
    for i = len, 2, -1 do
        local j = random( 1, i );
        tbl[i], tbl[j] = tbl[j], tbl[i];
    end
    return tbl;
end


function checkDupli(t)
  seen = {}
  for i = 1, #t do
      element = t[i]  
      if seen[element] then  --check if we've seen the element before
          return true
      else
          seen[element] = true -- set the element to seen
      end
  end
  return false
end

function replace(text)
    local pool = pPools[text]
    local nxtText = text
    if pool then
      if internalcounter == 0 then
        shuffle(selfHumi)
      end
      internalcounter = internalcounter + 1
      nxtText = selfHumi[internalcounter]
      if #saidStrings >= 4 then
        nxtText = table.concat(saidStrings, " and ")
        saidStrings[5] = nxtText
        return string.upper(nxtText)
      end
      savedStrings[text] = nxtText
    end
    
    if internalcounter >= 4 then
      internalcounter = 0
    end

    local aPool = oPools[text]
    if aPool then
      saidStrings[#saidStrings+1] = savedStrings[answersTo[text]]
      savedStrings = {}
      if #saidStrings >= 5 then
        
        send_mod_event("TSSD_HumiliationDoneEvent", "AA", 0.0, speaker_id)
        if checkDupli(saidStrings) then
          nxtText = "You are so pathetic, you can't get this simple thing right!"
        else
          nxtText = "Ohh that was good!"
        end

        saidStrings = {}
        return nxtText
      end
      if #saidStrings >= 4 then
        return "And now louder"
      end
      return aPool[math.random(1, #aPool)]
    end
    return nxtText
end