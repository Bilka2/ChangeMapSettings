local util = {}
local tableutil = require("__core__/lualib/util").table

util.textfield_to_uint = function(textfield)
  local number = util.textfield_to_number(textfield)
  if number and (number >= 0) and (number <= 4294967295) and (math.floor(number) == number) then
    return number
  end
  return false
end

util.textfield_to_number = function(textfield)
  local number = tonumber(textfield.text)
  if textfield.text and number then
    return number
  elseif textfield.text and textfield.text == "inf" then
    return 1/0
  elseif textfield.text and textfield.text == "-inf" then
    return -(1/0)
  end
  return false
end

util.textfield_to_number_with_error = function(textfield)
  local number = util.textfield_to_number(textfield)
  if not number then
    error(textfield.name .. " must be a number.")
  end
  return number
end

local map_gen_size_lookup =
{
  ["none"] = 0,
  ["very-low"] = 0.5,
  ["very-small"] = 0.5,
  ["very-poor"] = 0.5,
  ["low"] = 1/math.sqrt(2),
  ["small"] = 1/math.sqrt(2),
  ["poor"] = 1/math.sqrt(2),
  ["normal"] = 1,
  ["medium"] = 1,
  ["regular"] = 1,
  ["high"] = math.sqrt(2),
  ["big"] = math.sqrt(2),
  ["good"] = math.sqrt(2),
  ["very-high"] = 2,
  ["very-big"] = 2,
  ["very-good"] = 2
}

util.map_gen_size_to_number = function(map_gen_size) -- passes through 'nil'
  if type(map_gen_size) == "number" then
    return map_gen_size
  end
  return map_gen_size_lookup[map_gen_size]
end

util.number_to_string = function(number) -- shows up to 6 decimal places
  -- well this isn't really the intended usecase but I'd rather not have to work around this
  if type(number) == "string" then
    return number
  end
  if number == math.huge then
    return "inf"
  elseif number == -math.huge then
    return "-inf"
  elseif number < 0.0001 then
    return string.format("%.6f", tostring(number))
  elseif number > 999 then
    if number > 99999 then
      return string.format("%.f", tostring(number))
    end
    return string.format("%.3f", tostring(number))
  end
  return tostring(math.floor(number * 1000000 + 0.5) / 1000000) -- 0.5 for "rounding"
end

util.check_bounds = function(input, min, max, err)
  if input and (input >= min) and (input <= max) then
    return input
  end
  error(err)
  return false
end

-- returns table = {["intended-property"] = {{name = "expression-name", order = "order"}, ...}}
util.get_relevant_noise_expressions = function()
  local expressions = {}
  for name, named_noise_expression in pairs(game.named_noise_expressions) do
    local intended_property = named_noise_expression.intended_property
    if intended_property ~= "" then
      expressions[intended_property] = expressions[intended_property] or {}
      table.insert(expressions[intended_property], {name = name, order = named_noise_expression.order})
    end
  end
  return expressions
end

---@param str LocalisedString
---@return LocalisedString
util.add_info_icon_to_string = function(str)
  return {"", str, " [img=info]"}
end

util.get_possible_noise_expression_properties = function()
  local properties = {}
  for _, named_noise_expression in pairs(game.named_noise_expressions) do
    local intended_property = named_noise_expression.intended_property
    if intended_property ~= "" then
      properties[intended_property] = true
    end
  end
  return properties
end

util.compare_localized_strings = function(string1, string2)
  if type(string1) == "string" then
    string1 = {"", string1}
  end
  if type(string2) == "string" then
    string2 = {"", string2}
  end
  return tableutil.compare(string1, string2)
end

return util
