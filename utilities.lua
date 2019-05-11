local util = {}

util.textfield_to_uint = function(textfield)
  local number = tonumber(textfield.text)
  if textfield.text and number and (number >= 0) and (number <= 4294967295) and (math.floor(number) == number) then
    return number
  else
    return false
  end
end

util.textfield_to_number = function(textfield)
  local number = tonumber(textfield.text)
  if textfield.text and number then
    return number
  else
    return false
  end
end

util.textfield_to_number_with_error = function(textfield, player)
  local number = util.textfield_to_number(textfield)
  if not number then
    player.print(textfield.name .. " must be a number.")
  end
  return number
end

util.number_to_string = function(number) -- shows up to 6 decimal places
  if number < 0.0001 then
    return string.format("%.6f", tostring(number))
  elseif number > 999 then
    if number > 99999 then
      return string.format("%.f", tostring(number))
    end
    return string.format("%.3f", tostring(number))
  end
  return tostring(math.floor(number * 1000000 + 0.5) / 1000000) -- 0.5 for "rounding"
end

util.check_bounds = function(input, min, max, player, error)
  if input and (input >= min) and (input <= max) then
    return input
  end
  player.print(error)
  return false
end

-- returns table = {["resource-name"] = true, ...}
util.get_table_of_resources = function(number)
  local resources = {}
  for _, prototype in pairs(game.entity_prototypes) do
    if prototype.type == "resource" then
      resources[prototype.name] = true
    end
  end
  return resources
end

return util
