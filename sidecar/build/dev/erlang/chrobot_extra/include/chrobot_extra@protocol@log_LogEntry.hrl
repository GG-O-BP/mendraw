-record(log_entry, {
    source :: chrobot_extra@protocol@log:log_entry_source(),
    level :: chrobot_extra@protocol@log:log_entry_level(),
    text :: binary(),
    category :: gleam@option:option(chrobot_extra@protocol@log:log_entry_category()),
    timestamp :: chrobot_extra@protocol@runtime:timestamp(),
    url :: gleam@option:option(binary()),
    line_number :: gleam@option:option(integer()),
    stack_trace :: gleam@option:option(chrobot_extra@protocol@runtime:stack_trace()),
    network_request_id :: gleam@option:option(chrobot_extra@protocol@network:request_id()),
    worker_id :: gleam@option:option(binary()),
    args :: gleam@option:option(list(chrobot_extra@protocol@runtime:remote_object()))
}).
