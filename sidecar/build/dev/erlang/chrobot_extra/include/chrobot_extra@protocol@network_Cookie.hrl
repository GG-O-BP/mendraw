-record(cookie, {
    name :: binary(),
    value :: binary(),
    domain :: binary(),
    path :: binary(),
    expires :: float(),
    size :: integer(),
    http_only :: boolean(),
    secure :: boolean(),
    session :: boolean(),
    same_site :: gleam@option:option(chrobot_extra@protocol@network:cookie_same_site())
}).
