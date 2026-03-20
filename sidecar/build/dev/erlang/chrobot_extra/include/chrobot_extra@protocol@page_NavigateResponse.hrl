-record(navigate_response, {
    frame_id :: chrobot_extra@protocol@page:frame_id(),
    loader_id :: gleam@option:option(chrobot_extra@protocol@network:loader_id()),
    error_text :: gleam@option:option(binary())
}).
