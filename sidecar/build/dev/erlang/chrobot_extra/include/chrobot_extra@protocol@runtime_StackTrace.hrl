-record(stack_trace, {
    description :: gleam@option:option(binary()),
    call_frames :: list(chrobot_extra@protocol@runtime:call_frame()),
    parent :: gleam@option:option(chrobot_extra@protocol@runtime:stack_trace())
}).
