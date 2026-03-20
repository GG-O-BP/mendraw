-record(break_location, {
    script_id :: chrobot_extra@protocol@runtime:script_id(),
    line_number :: integer(),
    column_number :: gleam@option:option(integer()),
    type_ :: gleam@option:option(chrobot_extra@protocol@debugger:break_location_type())
}).
