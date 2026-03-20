-record(browser_config, {
    path :: binary(),
    args :: list(binary()),
    start_timeout :: integer(),
    log_level :: chrobot_extra@chrome:log_level()
}).
