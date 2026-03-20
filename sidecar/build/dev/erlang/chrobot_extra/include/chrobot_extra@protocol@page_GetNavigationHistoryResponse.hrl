-record(get_navigation_history_response, {
    current_index :: integer(),
    entries :: list(chrobot_extra@protocol@page:navigation_entry())
}).
