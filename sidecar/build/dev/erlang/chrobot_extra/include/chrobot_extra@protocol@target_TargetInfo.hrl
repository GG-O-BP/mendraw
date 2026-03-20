-record(target_info, {
    target_id :: chrobot_extra@protocol@target:target_i_d(),
    type_ :: binary(),
    title :: binary(),
    url :: binary(),
    attached :: boolean(),
    opener_id :: gleam@option:option(chrobot_extra@protocol@target:target_i_d())
}).
