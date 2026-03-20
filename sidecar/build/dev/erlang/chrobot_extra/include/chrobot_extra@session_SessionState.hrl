-record(session_state, {
    cookies :: list(chrobot_extra@protocol@network:cookie()),
    origins :: list(chrobot_extra@session:origin_storage())
}).
