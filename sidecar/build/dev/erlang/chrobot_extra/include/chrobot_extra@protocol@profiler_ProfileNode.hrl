-record(profile_node, {
    id :: integer(),
    call_frame :: chrobot_extra@protocol@runtime:call_frame(),
    hit_count :: gleam@option:option(integer()),
    children :: gleam@option:option(list(integer())),
    deopt_reason :: gleam@option:option(binary()),
    position_ticks :: gleam@option:option(list(chrobot_extra@protocol@profiler:position_tick_info()))
}).
