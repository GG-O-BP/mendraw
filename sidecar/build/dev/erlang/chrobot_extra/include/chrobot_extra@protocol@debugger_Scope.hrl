-record(scope, {
    type_ :: chrobot_extra@protocol@debugger:scope_type(),
    object :: chrobot_extra@protocol@runtime:remote_object(),
    name :: gleam@option:option(binary()),
    start_location :: gleam@option:option(chrobot_extra@protocol@debugger:location()),
    end_location :: gleam@option:option(chrobot_extra@protocol@debugger:location())
}).
