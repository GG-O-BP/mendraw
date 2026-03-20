-record(deep_serialized_value, {
    type_ :: chrobot_extra@protocol@runtime:deep_serialized_value_type(),
    value :: gleam@option:option(gleam@dynamic:dynamic_()),
    object_id :: gleam@option:option(binary()),
    weak_local_object_reference :: gleam@option:option(integer())
}).
