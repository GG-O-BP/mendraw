-record(auth_challenge, {
    source :: gleam@option:option(chrobot_extra@protocol@fetch:auth_challenge_source()),
    origin :: binary(),
    scheme :: binary(),
    realm :: binary()
}).
