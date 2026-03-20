-record(remote_object, {
    type_ :: chrobot_extra@protocol@runtime:remote_object_type(),
    subtype :: gleam@option:option(chrobot_extra@protocol@runtime:remote_object_subtype()),
    class_name :: gleam@option:option(binary()),
    value :: gleam@option:option(gleam@dynamic:dynamic_()),
    unserializable_value :: gleam@option:option(chrobot_extra@protocol@runtime:unserializable_value()),
    description :: gleam@option:option(binary()),
    object_id :: gleam@option:option(chrobot_extra@protocol@runtime:remote_object_id())
}).
