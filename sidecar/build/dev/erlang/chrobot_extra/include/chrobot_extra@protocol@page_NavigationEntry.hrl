-record(navigation_entry, {
    id :: integer(),
    url :: binary(),
    user_typed_url :: binary(),
    title :: binary(),
    transition_type :: chrobot_extra@protocol@page:transition_type()
}).
