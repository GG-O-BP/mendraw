-record(get_properties_response, {
    result :: list(chrobot_extra@protocol@runtime:property_descriptor()),
    internal_properties :: gleam@option:option(list(chrobot_extra@protocol@runtime:internal_property_descriptor())),
    exception_details :: gleam@option:option(chrobot_extra@protocol@runtime:exception_details())
}).
