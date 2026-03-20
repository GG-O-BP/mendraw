-record(compile_script_response, {
    script_id :: gleam@option:option(chrobot_extra@protocol@runtime:script_id()),
    exception_details :: gleam@option:option(chrobot_extra@protocol@runtime:exception_details())
}).
