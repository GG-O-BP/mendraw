-record(frame, {
    id :: chrobot_extra@protocol@page:frame_id(),
    parent_id :: gleam@option:option(chrobot_extra@protocol@page:frame_id()),
    loader_id :: chrobot_extra@protocol@network:loader_id(),
    name :: gleam@option:option(binary()),
    url :: binary(),
    security_origin :: binary(),
    mime_type :: binary()
}).
