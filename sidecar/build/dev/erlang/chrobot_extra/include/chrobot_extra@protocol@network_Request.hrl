-record(request, {
    url :: binary(),
    url_fragment :: gleam@option:option(binary()),
    method :: binary(),
    headers :: chrobot_extra@protocol@network:headers(),
    has_post_data :: gleam@option:option(boolean()),
    mixed_content_type :: gleam@option:option(chrobot_extra@protocol@security:mixed_content_type()),
    initial_priority :: chrobot_extra@protocol@network:resource_priority(),
    referrer_policy :: chrobot_extra@protocol@network:request_referrer_policy(),
    is_link_preload :: gleam@option:option(boolean())
}).
