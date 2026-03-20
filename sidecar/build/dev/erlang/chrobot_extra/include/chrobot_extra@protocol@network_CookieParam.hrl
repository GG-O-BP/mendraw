-record(cookie_param, {
    name :: binary(),
    value :: binary(),
    url :: gleam@option:option(binary()),
    domain :: gleam@option:option(binary()),
    path :: gleam@option:option(binary()),
    secure :: gleam@option:option(boolean()),
    http_only :: gleam@option:option(boolean()),
    same_site :: gleam@option:option(chrobot_extra@protocol@network:cookie_same_site()),
    expires :: gleam@option:option(chrobot_extra@protocol@network:time_since_epoch())
}).
