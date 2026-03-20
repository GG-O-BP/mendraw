-record(network_listener, {
    browser :: gleam@erlang@process:subject(chrobot_extra@chrome:message()),
    page :: chrobot_extra:page(),
    listener_subject :: gleam@erlang@process:subject(gleam@dynamic:dynamic_())
}).
