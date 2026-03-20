-record(security_state_explanation, {
    security_state :: chrobot_extra@protocol@security:security_state(),
    title :: binary(),
    summary :: binary(),
    description :: binary(),
    mixed_content_type :: chrobot_extra@protocol@security:mixed_content_type(),
    certificate :: list(binary()),
    recommendations :: gleam@option:option(list(binary()))
}).
