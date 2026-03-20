-record(event_listener, {
    type_ :: binary(),
    use_capture :: boolean(),
    passive :: boolean(),
    once :: boolean(),
    script_id :: chrobot_extra@protocol@runtime:script_id(),
    line_number :: integer(),
    column_number :: integer(),
    handler :: gleam@option:option(chrobot_extra@protocol@runtime:remote_object()),
    original_handler :: gleam@option:option(chrobot_extra@protocol@runtime:remote_object()),
    backend_node_id :: gleam@option:option(chrobot_extra@protocol@dom:backend_node_id())
}).
