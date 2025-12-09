local pools = {
  TSSD_0008D = {
    "[TSSD Enthrall Sweetheart] Do you want to make us official?"
  }
}


function replace(text)
    local pool = pools[text]
    if pool then
      --local thrallType = get_thrall_type(speaker_id)
      return pool[1]
    end
    return text
end