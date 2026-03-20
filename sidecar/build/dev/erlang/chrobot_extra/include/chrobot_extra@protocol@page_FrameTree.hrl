-record(frame_tree, {
    frame :: chrobot_extra@protocol@page:frame(),
    child_frames :: gleam@option:option(list(chrobot_extra@protocol@page:frame_tree()))
}).
