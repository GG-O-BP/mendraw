-record(exception_details, {
    exception_id :: integer(),
    text :: binary(),
    line_number :: integer(),
    column_number :: integer(),
    script_id :: gleam@option:option(chrobot_extra@protocol@runtime:script_id()),
    url :: gleam@option:option(binary()),
    stack_trace :: gleam@option:option(chrobot_extra@protocol@runtime:stack_trace()),
    exception :: gleam@option:option(chrobot_extra@protocol@runtime:remote_object()),
    execution_context_id :: gleam@option:option(chrobot_extra@protocol@runtime:execution_context_id())
}).
