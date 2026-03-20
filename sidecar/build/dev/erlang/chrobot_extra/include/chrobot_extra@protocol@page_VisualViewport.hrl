-record(visual_viewport, {
    offset_x :: float(),
    offset_y :: float(),
    page_x :: float(),
    page_y :: float(),
    client_width :: float(),
    client_height :: float(),
    scale :: float(),
    zoom :: gleam@option:option(float())
}).
