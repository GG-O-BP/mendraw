-record(touch_point, {
    x :: float(),
    y :: float(),
    radius_x :: gleam@option:option(float()),
    radius_y :: gleam@option:option(float()),
    rotation_angle :: gleam@option:option(float()),
    force :: gleam@option:option(float()),
    tilt_x :: gleam@option:option(float()),
    tilt_y :: gleam@option:option(float()),
    id :: gleam@option:option(float())
}).
