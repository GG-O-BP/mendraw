-record(app_manifest_error, {
    message :: binary(),
    critical :: integer(),
    line :: integer(),
    column :: integer()
}).
