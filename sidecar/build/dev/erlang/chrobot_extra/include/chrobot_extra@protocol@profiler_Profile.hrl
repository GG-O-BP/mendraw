-record(profile, {
    nodes :: list(chrobot_extra@protocol@profiler:profile_node()),
    start_time :: float(),
    end_time :: float(),
    samples :: gleam@option:option(list(integer())),
    time_deltas :: gleam@option:option(list(integer()))
}).
