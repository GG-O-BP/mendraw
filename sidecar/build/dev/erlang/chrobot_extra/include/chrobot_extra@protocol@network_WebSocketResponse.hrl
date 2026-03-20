-record(web_socket_response, {
    status :: integer(),
    status_text :: binary(),
    headers :: chrobot_extra@protocol@network:headers(),
    headers_text :: gleam@option:option(binary()),
    request_headers :: gleam@option:option(chrobot_extra@protocol@network:headers()),
    request_headers_text :: gleam@option:option(binary())
}).
