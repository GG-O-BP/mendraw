-record(page, {
    browser :: gleam@erlang@process:subject(chrobot_extra@chrome:message()),
    time_out :: integer(),
    target_id :: chrobot_extra@protocol@target:target_i_d(),
    session_id :: chrobot_extra@protocol@target:session_i_d()
}).
