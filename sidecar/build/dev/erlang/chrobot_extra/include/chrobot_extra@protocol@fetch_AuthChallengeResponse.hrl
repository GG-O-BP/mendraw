-record(auth_challenge_response, {
    response :: chrobot_extra@protocol@fetch:auth_challenge_response_response(),
    username :: gleam@option:option(binary()),
    password :: gleam@option:option(binary())
}).
