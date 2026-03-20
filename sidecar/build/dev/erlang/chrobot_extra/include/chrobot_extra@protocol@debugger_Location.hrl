-record(location, {
    script_id :: chrobot_extra@protocol@runtime:script_id(),
    line_number :: integer(),
    column_number :: gleam@option:option(integer())
}).
