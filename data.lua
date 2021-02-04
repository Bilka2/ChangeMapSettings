-- To test that noise expressions with custom intended_properties are considered everywhere (set to default, set to current, read)
local noise = require("noise")

data:extend{
  {
    type = "noise-expression",
    name = "test",
    intended_property = "test",
    expression = noise.ridge(noise.var("distance"), -80, 8),
  },
  {
    type = "noise-expression",
    name = "more-test",
    intended_property = "test",
    expression = noise.ridge(noise.var("y"), -10, 6),
  }
}

data.raw["noise-expression"]["elevation"].expression = noise.var("test")
