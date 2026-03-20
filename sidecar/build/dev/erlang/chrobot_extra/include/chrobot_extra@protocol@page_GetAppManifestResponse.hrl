-record(get_app_manifest_response, {
    url :: binary(),
    errors :: list(chrobot_extra@protocol@page:app_manifest_error()),
    data :: gleam@option:option(binary())
}).
