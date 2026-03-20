-record(execution_context_description, {
    id :: chrobot_extra@protocol@runtime:execution_context_id(),
    origin :: binary(),
    name :: binary(),
    aux_data :: gleam@option:option(gleam@dict:dict(binary(), binary()))
}).
