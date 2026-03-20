-record(cached_resource, {
    url :: binary(),
    type_ :: chrobot_extra@protocol@network:resource_type(),
    response :: gleam@option:option(chrobot_extra@protocol@network:response()),
    body_size :: float()
}).
