-record(idle_listener, {
    browser :: gleam@erlang@process:subject(chrobot_extra@chrome:message()),
    request_will_be_sent :: gleam@erlang@process:subject(gleam@dynamic:dynamic_()),
    loading_finished :: gleam@erlang@process:subject(gleam@dynamic:dynamic_()),
    loading_failed :: gleam@erlang@process:subject(gleam@dynamic:dynamic_())
}).
