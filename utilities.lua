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

util.float_to_string = function(number)
  return string.format("%f", tostring(number))
end

util.check_bounds = function(input, min, max, player, error)
  if input and (input >= min) and (input <= max) then
    return input
  end
  player.print(error)
  return false
end

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
