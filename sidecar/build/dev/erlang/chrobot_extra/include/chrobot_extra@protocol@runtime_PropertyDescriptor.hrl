-record(property_descriptor, {
    name :: binary(),
    value :: gleam@option:option(chrobot_extra@protocol@runtime:remote_object()),
    writable :: gleam@option:option(boolean()),
    get :: gleam@option:option(chrobot_extra@protocol@runtime:remote_object()),
    set :: gleam@option:option(chrobot_extra@protocol@runtime:remote_object()),
    configurable :: boolean(),
    enumerable :: boolean(),
    was_thrown :: gleam@option:option(boolean()),
    is_own :: gleam@option:option(boolean()),
    symbol :: gleam@option:option(chrobot_extra@protocol@runtime:remote_object())
}).
