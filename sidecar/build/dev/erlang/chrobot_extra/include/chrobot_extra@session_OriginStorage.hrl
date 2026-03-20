-record(origin_storage, {
    origin :: binary(),
    local_storage :: list(chrobot_extra@session:storage_entry()),
    session_storage :: list(chrobot_extra@session:storage_entry())
}).
