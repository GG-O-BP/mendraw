-record(call_frame, {
    call_frame_id :: chrobot_extra@protocol@debugger:call_frame_id(),
    function_name :: binary(),
    function_location :: gleam@option:option(chrobot_extra@protocol@debugger:location()),
    location :: chrobot_extra@protocol@debugger:location(),
    scope_chain :: list(chrobot_extra@protocol@debugger:scope()),
    this :: chrobot_extra@protocol@runtime:remote_object(),
    return_value :: gleam@option:option(chrobot_extra@protocol@runtime:remote_object())
}).
