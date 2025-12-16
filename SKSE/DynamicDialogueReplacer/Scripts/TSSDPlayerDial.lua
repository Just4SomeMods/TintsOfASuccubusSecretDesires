

local pools = {
  TSSD_0008D = {
    "[TSSD Enthrall Sweetheart] Do you want to make us official?"
  }
}

savedStrings = {}

internalcounter = 0

function replace(text)
    local pool = pools[text]
    local nxtText = text
    if pool then
      --local thrallType = get_thrall_type(speaker_id)
       nxtText = pool[math.random(1, #pool)]
    end

    if internalcounter > 0 then 
       nxtText = pools["TSSD_000B2"][math.random(1, #pools["TSSD_000B2"])]
    end



    if text == "TSSD_000B2" then
      internalcounter = 1
    end
    if internalcounter >= 4 then
      internalcounter = 0
    end

    return nxtText
end