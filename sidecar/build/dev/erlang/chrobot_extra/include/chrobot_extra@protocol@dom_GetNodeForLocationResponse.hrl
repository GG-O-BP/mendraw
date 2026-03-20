-record(get_node_for_location_response, {
    backend_node_id :: chrobot_extra@protocol@dom:backend_node_id(),
    frame_id :: binary(),
    node_id :: gleam@option:option(chrobot_extra@protocol@dom:node_id())
}).
