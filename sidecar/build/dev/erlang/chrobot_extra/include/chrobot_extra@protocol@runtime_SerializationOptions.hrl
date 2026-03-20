-record(serialization_options, {
    serialization :: chrobot_extra@protocol@runtime:serialization_options_serialization(),
    max_depth :: gleam@option:option(integer()),
    additional_parameters :: gleam@option:option(gleam@dict:dict(binary(), binary()))
}).
