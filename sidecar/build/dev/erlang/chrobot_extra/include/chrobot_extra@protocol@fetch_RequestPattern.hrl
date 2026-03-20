-record(request_pattern, {
    url_pattern :: gleam@option:option(binary()),
    resource_type :: gleam@option:option(chrobot_extra@protocol@network:resource_type()),
    request_stage :: gleam@option:option(chrobot_extra@protocol@fetch:request_stage())
}).
