-record(call, {
    reply_with :: gleam@erlang@process:subject({ok, gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    method :: binary(),
    params :: gleam@option:option(gleam@json:json()),
    session_id :: gleam@option:option(binary())
}).
