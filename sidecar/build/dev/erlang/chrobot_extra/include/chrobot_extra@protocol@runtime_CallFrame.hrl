-record(call_frame, {
    function_name :: binary(),
    script_id :: chrobot_extra@protocol@runtime:script_id(),
    url :: binary(),
    line_number :: integer(),
    column_number :: integer()
}).
