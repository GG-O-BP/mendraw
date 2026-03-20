-record(box_model, {
    content :: chrobot_extra@protocol@dom:quad(),
    padding :: chrobot_extra@protocol@dom:quad(),
    border :: chrobot_extra@protocol@dom:quad(),
    margin :: chrobot_extra@protocol@dom:quad(),
    width :: integer(),
    height :: integer(),
    shape_outside :: gleam@option:option(chrobot_extra@protocol@dom:shape_outside_info())
}).
