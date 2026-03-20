-record(initiator, {
    type_ :: chrobot_extra@protocol@network:initiator_type(),
    stack :: gleam@option:option(chrobot_extra@protocol@runtime:stack_trace()),
    url :: gleam@option:option(binary()),
    line_number :: gleam@option:option(float()),
    column_number :: gleam@option:option(float()),
    request_id :: gleam@option:option(chrobot_extra@protocol@network:request_id())
}).
