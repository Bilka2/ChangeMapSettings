data.raw["gui-style"]["default"]["pusher"] =
{
  type = "horizontal_flow_style",
  horizontally_stretchable = "on"
}

data.raw["gui-style"]["default"]["deep_frame"] =
{
  type = "frame_style",
  parent = "inside_deep_frame",
  vertical_flow_style =
  {
    type = "vertical_flow_style",
    vertical_spacing = 8
  }
}

data.raw["gui-style"]["default"]["frame_in_deep_frame"] =
{
  type = "frame_style",
  parent = "frame",
  graphical_set =
  {
    base =
    {
      position = {51, 0}, corner_size = 8,
      center = {position = {76, 8}, size = {1, 1}},
      draw_type = "outer"
    },
    shadow = default_inner_shadow
  }
}

data.raw["gui-style"]["default"]["b_inner_frame_no_border"] =
{
  type = "frame_style",
  parent = "b_inner_frame",
  graphical_set =
  {
    base =
    {
      center = {position = {76, 8}, size = {1, 1}},
    },
    -- we only show shadow on the top, to solve the problem of it not being casted from the subheader panel above
    shadow =
    {
      top =
      {
        position = {191, 128},
        size = {1, 8},
        tint = hard_shadow_color,
        draw_type = "inner"
      }
    }
  }
}
