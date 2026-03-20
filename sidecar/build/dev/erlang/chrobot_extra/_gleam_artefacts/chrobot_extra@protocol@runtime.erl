-module(chrobot_extra@protocol@runtime).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\protocol\\runtime.gleam").
-export([encode__script_id/1, decode__script_id/0, encode__serialization_options_serialization/1, decode__serialization_options_serialization/0, encode__serialization_options/1, decode__serialization_options/0, encode__deep_serialized_value_type/1, decode__deep_serialized_value_type/0, encode__deep_serialized_value/1, decode__deep_serialized_value/0, encode__remote_object_id/1, decode__remote_object_id/0, encode__unserializable_value/1, decode__unserializable_value/0, encode__remote_object_type/1, decode__remote_object_type/0, encode__remote_object_subtype/1, decode__remote_object_subtype/0, encode__remote_object/1, decode__remote_object/0, encode__property_descriptor/1, decode__property_descriptor/0, encode__internal_property_descriptor/1, decode__internal_property_descriptor/0, encode__call_argument/1, decode__call_argument/0, encode__execution_context_id/1, decode__execution_context_id/0, encode__execution_context_description/1, decode__execution_context_description/0, encode__timestamp/1, decode__timestamp/0, encode__time_delta/1, decode__time_delta/0, encode__call_frame/1, decode__call_frame/0, encode__stack_trace/1, encode__exception_details/1, decode__stack_trace/0, decode__exception_details/0, decode__await_promise_response/0, decode__call_function_on_response/0, decode__compile_script_response/0, decode__evaluate_response/0, decode__get_properties_response/0, decode__global_lexical_scope_names_response/0, decode__query_objects_response/0, decode__run_script_response/0, await_promise/4, call_function_on/10, compile_script/5, disable/1, discard_console_entries/1, enable/1, evaluate/9, get_properties/3, global_lexical_scope_names/2, query_objects/3, release_object/2, release_object_group/2, run_if_waiting_for_debugger/1, run_script/9, set_async_call_stack_depth/2, add_binding/3, remove_binding/2]).
-export_type([script_id/0, serialization_options/0, serialization_options_serialization/0, deep_serialized_value/0, deep_serialized_value_type/0, remote_object_id/0, unserializable_value/0, remote_object/0, remote_object_type/0, remote_object_subtype/0, property_descriptor/0, internal_property_descriptor/0, call_argument/0, execution_context_id/0, execution_context_description/0, exception_details/0, timestamp/0, time_delta/0, call_frame/0, stack_trace/0, await_promise_response/0, call_function_on_response/0, compile_script_response/0, evaluate_response/0, get_properties_response/0, global_lexical_scope_names_response/0, query_objects_response/0, run_script_response/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " > ⚙️  This module was generated from the Chrome DevTools Protocol version **1.3**\n"
    " ## Runtime Domain  \n"
    "\n"
    " Runtime domain exposes JavaScript runtime by means of remote evaluation and mirror objects.\n"
    " Evaluation results are returned as mirror object that expose object type, string representation\n"
    " and unique identifier that can be used for further object reference. Original objects are\n"
    " maintained in memory unless they are either explicitly released or are released along with the\n"
    " other objects in their object group.  \n"
    "\n"
    " [📖   View this domain on the DevTools Protocol API Docs](https://chromedevtools.github.io/devtools-protocol/1-3/Runtime/)\n"
).

-type script_id() :: {script_id, binary()}.

-type serialization_options() :: {serialization_options,
        serialization_options_serialization(),
        gleam@option:option(integer()),
        gleam@option:option(gleam@dict:dict(binary(), binary()))}.

-type serialization_options_serialization() :: serialization_options_serialization_deep |
    serialization_options_serialization_json |
    serialization_options_serialization_id_only.

-type deep_serialized_value() :: {deep_serialized_value,
        deep_serialized_value_type(),
        gleam@option:option(gleam@dynamic:dynamic_()),
        gleam@option:option(binary()),
        gleam@option:option(integer())}.

-type deep_serialized_value_type() :: deep_serialized_value_type_undefined |
    deep_serialized_value_type_null |
    deep_serialized_value_type_string |
    deep_serialized_value_type_number |
    deep_serialized_value_type_boolean |
    deep_serialized_value_type_bigint |
    deep_serialized_value_type_regexp |
    deep_serialized_value_type_date |
    deep_serialized_value_type_symbol |
    deep_serialized_value_type_array |
    deep_serialized_value_type_object |
    deep_serialized_value_type_function |
    deep_serialized_value_type_map |
    deep_serialized_value_type_set |
    deep_serialized_value_type_weakmap |
    deep_serialized_value_type_weakset |
    deep_serialized_value_type_error |
    deep_serialized_value_type_proxy |
    deep_serialized_value_type_promise |
    deep_serialized_value_type_typedarray |
    deep_serialized_value_type_arraybuffer |
    deep_serialized_value_type_node |
    deep_serialized_value_type_window |
    deep_serialized_value_type_generator.

-type remote_object_id() :: {remote_object_id, binary()}.

-type unserializable_value() :: {unserializable_value, binary()}.

-type remote_object() :: {remote_object,
        remote_object_type(),
        gleam@option:option(remote_object_subtype()),
        gleam@option:option(binary()),
        gleam@option:option(gleam@dynamic:dynamic_()),
        gleam@option:option(unserializable_value()),
        gleam@option:option(binary()),
        gleam@option:option(remote_object_id())}.

-type remote_object_type() :: remote_object_type_object |
    remote_object_type_function |
    remote_object_type_undefined |
    remote_object_type_string |
    remote_object_type_number |
    remote_object_type_boolean |
    remote_object_type_symbol |
    remote_object_type_bigint.

-type remote_object_subtype() :: remote_object_subtype_array |
    remote_object_subtype_null |
    remote_object_subtype_node |
    remote_object_subtype_regexp |
    remote_object_subtype_date |
    remote_object_subtype_map |
    remote_object_subtype_set |
    remote_object_subtype_weakmap |
    remote_object_subtype_weakset |
    remote_object_subtype_iterator |
    remote_object_subtype_generator |
    remote_object_subtype_error |
    remote_object_subtype_proxy |
    remote_object_subtype_promise |
    remote_object_subtype_typedarray |
    remote_object_subtype_arraybuffer |
    remote_object_subtype_dataview |
    remote_object_subtype_webassemblymemory |
    remote_object_subtype_wasmvalue.

-type property_descriptor() :: {property_descriptor,
        binary(),
        gleam@option:option(remote_object()),
        gleam@option:option(boolean()),
        gleam@option:option(remote_object()),
        gleam@option:option(remote_object()),
        boolean(),
        boolean(),
        gleam@option:option(boolean()),
        gleam@option:option(boolean()),
        gleam@option:option(remote_object())}.

-type internal_property_descriptor() :: {internal_property_descriptor,
        binary(),
        gleam@option:option(remote_object())}.

-type call_argument() :: {call_argument,
        gleam@option:option(gleam@dynamic:dynamic_()),
        gleam@option:option(unserializable_value()),
        gleam@option:option(remote_object_id())}.

-type execution_context_id() :: {execution_context_id, integer()}.

-type execution_context_description() :: {execution_context_description,
        execution_context_id(),
        binary(),
        binary(),
        gleam@option:option(gleam@dict:dict(binary(), binary()))}.

-type exception_details() :: {exception_details,
        integer(),
        binary(),
        integer(),
        integer(),
        gleam@option:option(script_id()),
        gleam@option:option(binary()),
        gleam@option:option(stack_trace()),
        gleam@option:option(remote_object()),
        gleam@option:option(execution_context_id())}.

-type timestamp() :: {timestamp, float()}.

-type time_delta() :: {time_delta, float()}.

-type call_frame() :: {call_frame,
        binary(),
        script_id(),
        binary(),
        integer(),
        integer()}.

-type stack_trace() :: {stack_trace,
        gleam@option:option(binary()),
        list(call_frame()),
        gleam@option:option(stack_trace())}.

-type await_promise_response() :: {await_promise_response,
        remote_object(),
        gleam@option:option(exception_details())}.

-type call_function_on_response() :: {call_function_on_response,
        remote_object(),
        gleam@option:option(exception_details())}.

-type compile_script_response() :: {compile_script_response,
        gleam@option:option(script_id()),
        gleam@option:option(exception_details())}.

-type evaluate_response() :: {evaluate_response,
        remote_object(),
        gleam@option:option(exception_details())}.

-type get_properties_response() :: {get_properties_response,
        list(property_descriptor()),
        gleam@option:option(list(internal_property_descriptor())),
        gleam@option:option(exception_details())}.

-type global_lexical_scope_names_response() :: {global_lexical_scope_names_response,
        list(binary())}.

-type query_objects_response() :: {query_objects_response, remote_object()}.

-type run_script_response() :: {run_script_response,
        remote_object(),
        gleam@option:option(exception_details())}.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 33).
?DOC(false).
-spec encode__script_id(script_id()) -> gleam@json:json().
encode__script_id(Value__) ->
    case Value__ of
        {script_id, Inner_value__} ->
            gleam@json:string(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 40).
?DOC(false).
-spec decode__script_id() -> gleam@dynamic@decode:decoder(script_id()).
decode__script_id() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({script_id, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 69).
?DOC(false).
-spec encode__serialization_options_serialization(
    serialization_options_serialization()
) -> gleam@json:json().
encode__serialization_options_serialization(Value__) ->
    _pipe = case Value__ of
        serialization_options_serialization_deep ->
            <<"deep"/utf8>>;

        serialization_options_serialization_json ->
            <<"json"/utf8>>;

        serialization_options_serialization_id_only ->
            <<"idOnly"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 81).
?DOC(false).
-spec decode__serialization_options_serialization() -> gleam@dynamic@decode:decoder(serialization_options_serialization()).
decode__serialization_options_serialization() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"deep"/utf8>> ->
                        gleam@dynamic@decode:success(
                            serialization_options_serialization_deep
                        );

                    <<"json"/utf8>> ->
                        gleam@dynamic@decode:success(
                            serialization_options_serialization_json
                        );

                    <<"idOnly"/utf8>> ->
                        gleam@dynamic@decode:success(
                            serialization_options_serialization_id_only
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            serialization_options_serialization_deep,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 98).
?DOC(false).
-spec encode__serialization_options(serialization_options()) -> gleam@json:json().
encode__serialization_options(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"serialization"/utf8>>,
                    encode__serialization_options_serialization(
                        erlang:element(2, Value__)
                    )}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(3, Value__),
                fun(Inner_value__) ->
                    {<<"maxDepth"/utf8>>, gleam@json:int(Inner_value__)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(4, Value__),
                fun(Inner_value__@1) ->
                    {<<"additionalParameters"/utf8>>,
                        begin
                            _pipe@2 = maps:to_list(Inner_value__@1),
                            _pipe@3 = gleam@list:map(
                                _pipe@2,
                                fun(I) ->
                                    {erlang:element(1, I),
                                        gleam@json:string(erlang:element(2, I))}
                                end
                            ),
                            gleam@json:object(_pipe@3)
                        end}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 121).
?DOC(false).
-spec decode__serialization_options() -> gleam@dynamic@decode:decoder(serialization_options()).
decode__serialization_options() ->
    begin
        gleam@dynamic@decode:field(
            <<"serialization"/utf8>>,
            decode__serialization_options_serialization(),
            fun(Serialization) ->
                gleam@dynamic@decode:optional_field(
                    <<"maxDepth"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(
                        {decoder, fun gleam@dynamic@decode:decode_int/1}
                    ),
                    fun(Max_depth) ->
                        gleam@dynamic@decode:optional_field(
                            <<"additionalParameters"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                gleam@dynamic@decode:dict(
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_string/1},
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_string/1}
                                )
                            ),
                            fun(Additional_parameters) ->
                                gleam@dynamic@decode:success(
                                    {serialization_options,
                                        Serialization,
                                        Max_depth,
                                        Additional_parameters}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 189).
?DOC(false).
-spec encode__deep_serialized_value_type(deep_serialized_value_type()) -> gleam@json:json().
encode__deep_serialized_value_type(Value__) ->
    _pipe = case Value__ of
        deep_serialized_value_type_undefined ->
            <<"undefined"/utf8>>;

        deep_serialized_value_type_null ->
            <<"null"/utf8>>;

        deep_serialized_value_type_string ->
            <<"string"/utf8>>;

        deep_serialized_value_type_number ->
            <<"number"/utf8>>;

        deep_serialized_value_type_boolean ->
            <<"boolean"/utf8>>;

        deep_serialized_value_type_bigint ->
            <<"bigint"/utf8>>;

        deep_serialized_value_type_regexp ->
            <<"regexp"/utf8>>;

        deep_serialized_value_type_date ->
            <<"date"/utf8>>;

        deep_serialized_value_type_symbol ->
            <<"symbol"/utf8>>;

        deep_serialized_value_type_array ->
            <<"array"/utf8>>;

        deep_serialized_value_type_object ->
            <<"object"/utf8>>;

        deep_serialized_value_type_function ->
            <<"function"/utf8>>;

        deep_serialized_value_type_map ->
            <<"map"/utf8>>;

        deep_serialized_value_type_set ->
            <<"set"/utf8>>;

        deep_serialized_value_type_weakmap ->
            <<"weakmap"/utf8>>;

        deep_serialized_value_type_weakset ->
            <<"weakset"/utf8>>;

        deep_serialized_value_type_error ->
            <<"error"/utf8>>;

        deep_serialized_value_type_proxy ->
            <<"proxy"/utf8>>;

        deep_serialized_value_type_promise ->
            <<"promise"/utf8>>;

        deep_serialized_value_type_typedarray ->
            <<"typedarray"/utf8>>;

        deep_serialized_value_type_arraybuffer ->
            <<"arraybuffer"/utf8>>;

        deep_serialized_value_type_node ->
            <<"node"/utf8>>;

        deep_serialized_value_type_window ->
            <<"window"/utf8>>;

        deep_serialized_value_type_generator ->
            <<"generator"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 220).
?DOC(false).
-spec decode__deep_serialized_value_type() -> gleam@dynamic@decode:decoder(deep_serialized_value_type()).
decode__deep_serialized_value_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"undefined"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_undefined
                        );

                    <<"null"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_null
                        );

                    <<"string"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_string
                        );

                    <<"number"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_number
                        );

                    <<"boolean"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_boolean
                        );

                    <<"bigint"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_bigint
                        );

                    <<"regexp"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_regexp
                        );

                    <<"date"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_date
                        );

                    <<"symbol"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_symbol
                        );

                    <<"array"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_array
                        );

                    <<"object"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_object
                        );

                    <<"function"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_function
                        );

                    <<"map"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_map
                        );

                    <<"set"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_set
                        );

                    <<"weakmap"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_weakmap
                        );

                    <<"weakset"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_weakset
                        );

                    <<"error"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_error
                        );

                    <<"proxy"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_proxy
                        );

                    <<"promise"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_promise
                        );

                    <<"typedarray"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_typedarray
                        );

                    <<"arraybuffer"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_arraybuffer
                        );

                    <<"node"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_node
                        );

                    <<"window"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_window
                        );

                    <<"generator"/utf8>> ->
                        gleam@dynamic@decode:success(
                            deep_serialized_value_type_generator
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            deep_serialized_value_type_undefined,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 255).
?DOC(false).
-spec encode__deep_serialized_value(deep_serialized_value()) -> gleam@json:json().
encode__deep_serialized_value(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"type"/utf8>>,
                    encode__deep_serialized_value_type(
                        erlang:element(2, Value__)
                    )}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(3, Value__),
                fun(Inner_value__) ->
                    {<<"value"/utf8>>,
                        chrobot_extra@internal@utils:alert_encode_dynamic(
                            Inner_value__
                        )}
                end
            ),
            _pipe@2 = chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(4, Value__),
                fun(Inner_value__@1) ->
                    {<<"objectId"/utf8>>, gleam@json:string(Inner_value__@1)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@2,
                erlang:element(5, Value__),
                fun(Inner_value__@2) ->
                    {<<"weakLocalObjectReference"/utf8>>,
                        gleam@json:int(Inner_value__@2)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 276).
?DOC(false).
-spec decode__deep_serialized_value() -> gleam@dynamic@decode:decoder(deep_serialized_value()).
decode__deep_serialized_value() ->
    begin
        gleam@dynamic@decode:field(
            <<"type"/utf8>>,
            decode__deep_serialized_value_type(),
            fun(Type_) ->
                gleam@dynamic@decode:optional_field(
                    <<"value"/utf8>>,
                    none,
                    begin
                        _pipe = {decoder,
                            fun gleam@dynamic@decode:decode_dynamic/1},
                        gleam@dynamic@decode:map(
                            _pipe,
                            fun(Field@0) -> {some, Field@0} end
                        )
                    end,
                    fun(Value) ->
                        gleam@dynamic@decode:optional_field(
                            <<"objectId"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                {decoder,
                                    fun gleam@dynamic@decode:decode_string/1}
                            ),
                            fun(Object_id) ->
                                gleam@dynamic@decode:optional_field(
                                    <<"weakLocalObjectReference"/utf8>>,
                                    none,
                                    gleam@dynamic@decode:optional(
                                        {decoder,
                                            fun gleam@dynamic@decode:decode_int/1}
                                    ),
                                    fun(Weak_local_object_reference) ->
                                        gleam@dynamic@decode:success(
                                            {deep_serialized_value,
                                                Type_,
                                                Value,
                                                Object_id,
                                                Weak_local_object_reference}
                                        )
                                    end
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 310).
?DOC(false).
-spec encode__remote_object_id(remote_object_id()) -> gleam@json:json().
encode__remote_object_id(Value__) ->
    case Value__ of
        {remote_object_id, Inner_value__} ->
            gleam@json:string(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 317).
?DOC(false).
-spec decode__remote_object_id() -> gleam@dynamic@decode:decoder(remote_object_id()).
decode__remote_object_id() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({remote_object_id, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 331).
?DOC(false).
-spec encode__unserializable_value(unserializable_value()) -> gleam@json:json().
encode__unserializable_value(Value__) ->
    case Value__ of
        {unserializable_value, Inner_value__} ->
            gleam@json:string(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 338).
?DOC(false).
-spec decode__unserializable_value() -> gleam@dynamic@decode:decoder(unserializable_value()).
decode__unserializable_value() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({unserializable_value, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 382).
?DOC(false).
-spec encode__remote_object_type(remote_object_type()) -> gleam@json:json().
encode__remote_object_type(Value__) ->
    _pipe = case Value__ of
        remote_object_type_object ->
            <<"object"/utf8>>;

        remote_object_type_function ->
            <<"function"/utf8>>;

        remote_object_type_undefined ->
            <<"undefined"/utf8>>;

        remote_object_type_string ->
            <<"string"/utf8>>;

        remote_object_type_number ->
            <<"number"/utf8>>;

        remote_object_type_boolean ->
            <<"boolean"/utf8>>;

        remote_object_type_symbol ->
            <<"symbol"/utf8>>;

        remote_object_type_bigint ->
            <<"bigint"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 397).
?DOC(false).
-spec decode__remote_object_type() -> gleam@dynamic@decode:decoder(remote_object_type()).
decode__remote_object_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"object"/utf8>> ->
                        gleam@dynamic@decode:success(remote_object_type_object);

                    <<"function"/utf8>> ->
                        gleam@dynamic@decode:success(
                            remote_object_type_function
                        );

                    <<"undefined"/utf8>> ->
                        gleam@dynamic@decode:success(
                            remote_object_type_undefined
                        );

                    <<"string"/utf8>> ->
                        gleam@dynamic@decode:success(remote_object_type_string);

                    <<"number"/utf8>> ->
                        gleam@dynamic@decode:success(remote_object_type_number);

                    <<"boolean"/utf8>> ->
                        gleam@dynamic@decode:success(remote_object_type_boolean);

                    <<"symbol"/utf8>> ->
                        gleam@dynamic@decode:success(remote_object_type_symbol);

                    <<"bigint"/utf8>> ->
                        gleam@dynamic@decode:success(remote_object_type_bigint);

                    _ ->
                        gleam@dynamic@decode:failure(
                            remote_object_type_object,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 439).
?DOC(false).
-spec encode__remote_object_subtype(remote_object_subtype()) -> gleam@json:json().
encode__remote_object_subtype(Value__) ->
    _pipe = case Value__ of
        remote_object_subtype_array ->
            <<"array"/utf8>>;

        remote_object_subtype_null ->
            <<"null"/utf8>>;

        remote_object_subtype_node ->
            <<"node"/utf8>>;

        remote_object_subtype_regexp ->
            <<"regexp"/utf8>>;

        remote_object_subtype_date ->
            <<"date"/utf8>>;

        remote_object_subtype_map ->
            <<"map"/utf8>>;

        remote_object_subtype_set ->
            <<"set"/utf8>>;

        remote_object_subtype_weakmap ->
            <<"weakmap"/utf8>>;

        remote_object_subtype_weakset ->
            <<"weakset"/utf8>>;

        remote_object_subtype_iterator ->
            <<"iterator"/utf8>>;

        remote_object_subtype_generator ->
            <<"generator"/utf8>>;

        remote_object_subtype_error ->
            <<"error"/utf8>>;

        remote_object_subtype_proxy ->
            <<"proxy"/utf8>>;

        remote_object_subtype_promise ->
            <<"promise"/utf8>>;

        remote_object_subtype_typedarray ->
            <<"typedarray"/utf8>>;

        remote_object_subtype_arraybuffer ->
            <<"arraybuffer"/utf8>>;

        remote_object_subtype_dataview ->
            <<"dataview"/utf8>>;

        remote_object_subtype_webassemblymemory ->
            <<"webassemblymemory"/utf8>>;

        remote_object_subtype_wasmvalue ->
            <<"wasmvalue"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 465).
?DOC(false).
-spec decode__remote_object_subtype() -> gleam@dynamic@decode:decoder(remote_object_subtype()).
decode__remote_object_subtype() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"array"/utf8>> ->
                        gleam@dynamic@decode:success(
                            remote_object_subtype_array
                        );

                    <<"null"/utf8>> ->
                        gleam@dynamic@decode:success(remote_object_subtype_null);

                    <<"node"/utf8>> ->
                        gleam@dynamic@decode:success(remote_object_subtype_node);

                    <<"regexp"/utf8>> ->
                        gleam@dynamic@decode:success(
                            remote_object_subtype_regexp
                        );

                    <<"date"/utf8>> ->
                        gleam@dynamic@decode:success(remote_object_subtype_date);

                    <<"map"/utf8>> ->
                        gleam@dynamic@decode:success(remote_object_subtype_map);

                    <<"set"/utf8>> ->
                        gleam@dynamic@decode:success(remote_object_subtype_set);

                    <<"weakmap"/utf8>> ->
                        gleam@dynamic@decode:success(
                            remote_object_subtype_weakmap
                        );

                    <<"weakset"/utf8>> ->
                        gleam@dynamic@decode:success(
                            remote_object_subtype_weakset
                        );

                    <<"iterator"/utf8>> ->
                        gleam@dynamic@decode:success(
                            remote_object_subtype_iterator
                        );

                    <<"generator"/utf8>> ->
                        gleam@dynamic@decode:success(
                            remote_object_subtype_generator
                        );

                    <<"error"/utf8>> ->
                        gleam@dynamic@decode:success(
                            remote_object_subtype_error
                        );

                    <<"proxy"/utf8>> ->
                        gleam@dynamic@decode:success(
                            remote_object_subtype_proxy
                        );

                    <<"promise"/utf8>> ->
                        gleam@dynamic@decode:success(
                            remote_object_subtype_promise
                        );

                    <<"typedarray"/utf8>> ->
                        gleam@dynamic@decode:success(
                            remote_object_subtype_typedarray
                        );

                    <<"arraybuffer"/utf8>> ->
                        gleam@dynamic@decode:success(
                            remote_object_subtype_arraybuffer
                        );

                    <<"dataview"/utf8>> ->
                        gleam@dynamic@decode:success(
                            remote_object_subtype_dataview
                        );

                    <<"webassemblymemory"/utf8>> ->
                        gleam@dynamic@decode:success(
                            remote_object_subtype_webassemblymemory
                        );

                    <<"wasmvalue"/utf8>> ->
                        gleam@dynamic@decode:success(
                            remote_object_subtype_wasmvalue
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            remote_object_subtype_array,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 495).
?DOC(false).
-spec encode__remote_object(remote_object()) -> gleam@json:json().
encode__remote_object(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"type"/utf8>>,
                    encode__remote_object_type(erlang:element(2, Value__))}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(3, Value__),
                fun(Inner_value__) ->
                    {<<"subtype"/utf8>>,
                        encode__remote_object_subtype(Inner_value__)}
                end
            ),
            _pipe@2 = chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(4, Value__),
                fun(Inner_value__@1) ->
                    {<<"className"/utf8>>, gleam@json:string(Inner_value__@1)}
                end
            ),
            _pipe@3 = chrobot_extra@internal@utils:add_optional(
                _pipe@2,
                erlang:element(5, Value__),
                fun(Inner_value__@2) ->
                    {<<"value"/utf8>>,
                        chrobot_extra@internal@utils:alert_encode_dynamic(
                            Inner_value__@2
                        )}
                end
            ),
            _pipe@4 = chrobot_extra@internal@utils:add_optional(
                _pipe@3,
                erlang:element(6, Value__),
                fun(Inner_value__@3) ->
                    {<<"unserializableValue"/utf8>>,
                        encode__unserializable_value(Inner_value__@3)}
                end
            ),
            _pipe@5 = chrobot_extra@internal@utils:add_optional(
                _pipe@4,
                erlang:element(7, Value__),
                fun(Inner_value__@4) ->
                    {<<"description"/utf8>>, gleam@json:string(Inner_value__@4)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@5,
                erlang:element(8, Value__),
                fun(Inner_value__@5) ->
                    {<<"objectId"/utf8>>,
                        encode__remote_object_id(Inner_value__@5)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 522).
?DOC(false).
-spec decode__remote_object() -> gleam@dynamic@decode:decoder(remote_object()).
decode__remote_object() ->
    begin
        gleam@dynamic@decode:field(
            <<"type"/utf8>>,
            decode__remote_object_type(),
            fun(Type_) ->
                gleam@dynamic@decode:optional_field(
                    <<"subtype"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(
                        decode__remote_object_subtype()
                    ),
                    fun(Subtype) ->
                        gleam@dynamic@decode:optional_field(
                            <<"className"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                {decoder,
                                    fun gleam@dynamic@decode:decode_string/1}
                            ),
                            fun(Class_name) ->
                                gleam@dynamic@decode:optional_field(
                                    <<"value"/utf8>>,
                                    none,
                                    begin
                                        _pipe = {decoder,
                                            fun gleam@dynamic@decode:decode_dynamic/1},
                                        gleam@dynamic@decode:map(
                                            _pipe,
                                            fun(Field@0) -> {some, Field@0} end
                                        )
                                    end,
                                    fun(Value) ->
                                        gleam@dynamic@decode:optional_field(
                                            <<"unserializableValue"/utf8>>,
                                            none,
                                            gleam@dynamic@decode:optional(
                                                decode__unserializable_value()
                                            ),
                                            fun(Unserializable_value) ->
                                                gleam@dynamic@decode:optional_field(
                                                    <<"description"/utf8>>,
                                                    none,
                                                    gleam@dynamic@decode:optional(
                                                        {decoder,
                                                            fun gleam@dynamic@decode:decode_string/1}
                                                    ),
                                                    fun(Description) ->
                                                        gleam@dynamic@decode:optional_field(
                                                            <<"objectId"/utf8>>,
                                                            none,
                                                            gleam@dynamic@decode:optional(
                                                                decode__remote_object_id(
                                                                    
                                                                )
                                                            ),
                                                            fun(Object_id) ->
                                                                gleam@dynamic@decode:success(
                                                                    {remote_object,
                                                                        Type_,
                                                                        Subtype,
                                                                        Class_name,
                                                                        Value,
                                                                        Unserializable_value,
                                                                        Description,
                                                                        Object_id}
                                                                )
                                                            end
                                                        )
                                                    end
                                                )
                                            end
                                        )
                                    end
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 599).
?DOC(false).
-spec encode__property_descriptor(property_descriptor()) -> gleam@json:json().
encode__property_descriptor(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"name"/utf8>>,
                    gleam@json:string(erlang:element(2, Value__))},
                {<<"configurable"/utf8>>,
                    gleam@json:bool(erlang:element(7, Value__))},
                {<<"enumerable"/utf8>>,
                    gleam@json:bool(erlang:element(8, Value__))}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(3, Value__),
                fun(Inner_value__) ->
                    {<<"value"/utf8>>, encode__remote_object(Inner_value__)}
                end
            ),
            _pipe@2 = chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(4, Value__),
                fun(Inner_value__@1) ->
                    {<<"writable"/utf8>>, gleam@json:bool(Inner_value__@1)}
                end
            ),
            _pipe@3 = chrobot_extra@internal@utils:add_optional(
                _pipe@2,
                erlang:element(5, Value__),
                fun(Inner_value__@2) ->
                    {<<"get"/utf8>>, encode__remote_object(Inner_value__@2)}
                end
            ),
            _pipe@4 = chrobot_extra@internal@utils:add_optional(
                _pipe@3,
                erlang:element(6, Value__),
                fun(Inner_value__@3) ->
                    {<<"set"/utf8>>, encode__remote_object(Inner_value__@3)}
                end
            ),
            _pipe@5 = chrobot_extra@internal@utils:add_optional(
                _pipe@4,
                erlang:element(9, Value__),
                fun(Inner_value__@4) ->
                    {<<"wasThrown"/utf8>>, gleam@json:bool(Inner_value__@4)}
                end
            ),
            _pipe@6 = chrobot_extra@internal@utils:add_optional(
                _pipe@5,
                erlang:element(10, Value__),
                fun(Inner_value__@5) ->
                    {<<"isOwn"/utf8>>, gleam@json:bool(Inner_value__@5)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@6,
                erlang:element(11, Value__),
                fun(Inner_value__@6) ->
                    {<<"symbol"/utf8>>, encode__remote_object(Inner_value__@6)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 631).
?DOC(false).
-spec decode__property_descriptor() -> gleam@dynamic@decode:decoder(property_descriptor()).
decode__property_descriptor() ->
    begin
        gleam@dynamic@decode:field(
            <<"name"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Name) ->
                gleam@dynamic@decode:optional_field(
                    <<"value"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(decode__remote_object()),
                    fun(Value) ->
                        gleam@dynamic@decode:optional_field(
                            <<"writable"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                {decoder,
                                    fun gleam@dynamic@decode:decode_bool/1}
                            ),
                            fun(Writable) ->
                                gleam@dynamic@decode:optional_field(
                                    <<"get"/utf8>>,
                                    none,
                                    gleam@dynamic@decode:optional(
                                        decode__remote_object()
                                    ),
                                    fun(Get) ->
                                        gleam@dynamic@decode:optional_field(
                                            <<"set"/utf8>>,
                                            none,
                                            gleam@dynamic@decode:optional(
                                                decode__remote_object()
                                            ),
                                            fun(Set) ->
                                                gleam@dynamic@decode:field(
                                                    <<"configurable"/utf8>>,
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_bool/1},
                                                    fun(Configurable) ->
                                                        gleam@dynamic@decode:field(
                                                            <<"enumerable"/utf8>>,
                                                            {decoder,
                                                                fun gleam@dynamic@decode:decode_bool/1},
                                                            fun(Enumerable) ->
                                                                gleam@dynamic@decode:optional_field(
                                                                    <<"wasThrown"/utf8>>,
                                                                    none,
                                                                    gleam@dynamic@decode:optional(
                                                                        {decoder,
                                                                            fun gleam@dynamic@decode:decode_bool/1}
                                                                    ),
                                                                    fun(
                                                                        Was_thrown
                                                                    ) ->
                                                                        gleam@dynamic@decode:optional_field(
                                                                            <<"isOwn"/utf8>>,
                                                                            none,
                                                                            gleam@dynamic@decode:optional(
                                                                                {decoder,
                                                                                    fun gleam@dynamic@decode:decode_bool/1}
                                                                            ),
                                                                            fun(
                                                                                Is_own
                                                                            ) ->
                                                                                gleam@dynamic@decode:optional_field(
                                                                                    <<"symbol"/utf8>>,
                                                                                    none,
                                                                                    gleam@dynamic@decode:optional(
                                                                                        decode__remote_object(
                                                                                            
                                                                                        )
                                                                                    ),
                                                                                    fun(
                                                                                        Symbol
                                                                                    ) ->
                                                                                        gleam@dynamic@decode:success(
                                                                                            {property_descriptor,
                                                                                                Name,
                                                                                                Value,
                                                                                                Writable,
                                                                                                Get,
                                                                                                Set,
                                                                                                Configurable,
                                                                                                Enumerable,
                                                                                                Was_thrown,
                                                                                                Is_own,
                                                                                                Symbol}
                                                                                        )
                                                                                    end
                                                                                )
                                                                            end
                                                                        )
                                                                    end
                                                                )
                                                            end
                                                        )
                                                    end
                                                )
                                            end
                                        )
                                    end
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 698).
?DOC(false).
-spec encode__internal_property_descriptor(internal_property_descriptor()) -> gleam@json:json().
encode__internal_property_descriptor(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"name"/utf8>>,
                    gleam@json:string(erlang:element(2, Value__))}],
            chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(3, Value__),
                fun(Inner_value__) ->
                    {<<"value"/utf8>>, encode__remote_object(Inner_value__)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 710).
?DOC(false).
-spec decode__internal_property_descriptor() -> gleam@dynamic@decode:decoder(internal_property_descriptor()).
decode__internal_property_descriptor() ->
    begin
        gleam@dynamic@decode:field(
            <<"name"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Name) ->
                gleam@dynamic@decode:optional_field(
                    <<"value"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(decode__remote_object()),
                    fun(Value) ->
                        gleam@dynamic@decode:success(
                            {internal_property_descriptor, Name, Value}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 737).
?DOC(false).
-spec encode__call_argument(call_argument()) -> gleam@json:json().
encode__call_argument(Value__) ->
    gleam@json:object(
        begin
            _pipe = [],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(2, Value__),
                fun(Inner_value__) ->
                    {<<"value"/utf8>>,
                        chrobot_extra@internal@utils:alert_encode_dynamic(
                            Inner_value__
                        )}
                end
            ),
            _pipe@2 = chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(3, Value__),
                fun(Inner_value__@1) ->
                    {<<"unserializableValue"/utf8>>,
                        encode__unserializable_value(Inner_value__@1)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@2,
                erlang:element(4, Value__),
                fun(Inner_value__@2) ->
                    {<<"objectId"/utf8>>,
                        encode__remote_object_id(Inner_value__@2)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 753).
?DOC(false).
-spec decode__call_argument() -> gleam@dynamic@decode:decoder(call_argument()).
decode__call_argument() ->
    begin
        gleam@dynamic@decode:optional_field(
            <<"value"/utf8>>,
            none,
            begin
                _pipe = {decoder, fun gleam@dynamic@decode:decode_dynamic/1},
                gleam@dynamic@decode:map(
                    _pipe,
                    fun(Field@0) -> {some, Field@0} end
                )
            end,
            fun(Value) ->
                gleam@dynamic@decode:optional_field(
                    <<"unserializableValue"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(
                        decode__unserializable_value()
                    ),
                    fun(Unserializable_value) ->
                        gleam@dynamic@decode:optional_field(
                            <<"objectId"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                decode__remote_object_id()
                            ),
                            fun(Object_id) ->
                                gleam@dynamic@decode:success(
                                    {call_argument,
                                        Value,
                                        Unserializable_value,
                                        Object_id}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 785).
?DOC(false).
-spec encode__execution_context_id(execution_context_id()) -> gleam@json:json().
encode__execution_context_id(Value__) ->
    case Value__ of
        {execution_context_id, Inner_value__} ->
            gleam@json:int(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 792).
?DOC(false).
-spec decode__execution_context_id() -> gleam@dynamic@decode:decoder(execution_context_id()).
decode__execution_context_id() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({execution_context_id, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 815).
?DOC(false).
-spec encode__execution_context_description(execution_context_description()) -> gleam@json:json().
encode__execution_context_description(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"id"/utf8>>,
                    encode__execution_context_id(erlang:element(2, Value__))},
                {<<"origin"/utf8>>,
                    gleam@json:string(erlang:element(3, Value__))},
                {<<"name"/utf8>>, gleam@json:string(erlang:element(4, Value__))}],
            chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(5, Value__),
                fun(Inner_value__) ->
                    {<<"auxData"/utf8>>,
                        begin
                            _pipe@1 = maps:to_list(Inner_value__),
                            _pipe@2 = gleam@list:map(
                                _pipe@1,
                                fun(I) ->
                                    {erlang:element(1, I),
                                        gleam@json:string(erlang:element(2, I))}
                                end
                            ),
                            gleam@json:object(_pipe@2)
                        end}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 836).
?DOC(false).
-spec decode__execution_context_description() -> gleam@dynamic@decode:decoder(execution_context_description()).
decode__execution_context_description() ->
    begin
        gleam@dynamic@decode:field(
            <<"id"/utf8>>,
            decode__execution_context_id(),
            fun(Id) ->
                gleam@dynamic@decode:field(
                    <<"origin"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Origin) ->
                        gleam@dynamic@decode:field(
                            <<"name"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Name) ->
                                gleam@dynamic@decode:optional_field(
                                    <<"auxData"/utf8>>,
                                    none,
                                    gleam@dynamic@decode:optional(
                                        gleam@dynamic@decode:dict(
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_string/1},
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_string/1}
                                        )
                                    ),
                                    fun(Aux_data) ->
                                        gleam@dynamic@decode:success(
                                            {execution_context_description,
                                                Id,
                                                Origin,
                                                Name,
                                                Aux_data}
                                        )
                                    end
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 961).
?DOC(false).
-spec encode__timestamp(timestamp()) -> gleam@json:json().
encode__timestamp(Value__) ->
    case Value__ of
        {timestamp, Inner_value__} ->
            gleam@json:float(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 968).
?DOC(false).
-spec decode__timestamp() -> gleam@dynamic@decode:decoder(timestamp()).
decode__timestamp() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_float/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({timestamp, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 981).
?DOC(false).
-spec encode__time_delta(time_delta()) -> gleam@json:json().
encode__time_delta(Value__) ->
    case Value__ of
        {time_delta, Inner_value__} ->
            gleam@json:float(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 988).
?DOC(false).
-spec decode__time_delta() -> gleam@dynamic@decode:decoder(time_delta()).
decode__time_delta() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_float/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({time_delta, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1012).
?DOC(false).
-spec encode__call_frame(call_frame()) -> gleam@json:json().
encode__call_frame(Value__) ->
    gleam@json:object(
        [{<<"functionName"/utf8>>,
                gleam@json:string(erlang:element(2, Value__))},
            {<<"scriptId"/utf8>>, encode__script_id(erlang:element(3, Value__))},
            {<<"url"/utf8>>, gleam@json:string(erlang:element(4, Value__))},
            {<<"lineNumber"/utf8>>, gleam@json:int(erlang:element(5, Value__))},
            {<<"columnNumber"/utf8>>,
                gleam@json:int(erlang:element(6, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1023).
?DOC(false).
-spec decode__call_frame() -> gleam@dynamic@decode:decoder(call_frame()).
decode__call_frame() ->
    begin
        gleam@dynamic@decode:field(
            <<"functionName"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Function_name) ->
                gleam@dynamic@decode:field(
                    <<"scriptId"/utf8>>,
                    decode__script_id(),
                    fun(Script_id) ->
                        gleam@dynamic@decode:field(
                            <<"url"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Url) ->
                                gleam@dynamic@decode:field(
                                    <<"lineNumber"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_int/1},
                                    fun(Line_number) ->
                                        gleam@dynamic@decode:field(
                                            <<"columnNumber"/utf8>>,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_int/1},
                                            fun(Column_number) ->
                                                gleam@dynamic@decode:success(
                                                    {call_frame,
                                                        Function_name,
                                                        Script_id,
                                                        Url,
                                                        Line_number,
                                                        Column_number}
                                                )
                                            end
                                        )
                                    end
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1055).
?DOC(false).
-spec encode__stack_trace(stack_trace()) -> gleam@json:json().
encode__stack_trace(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"callFrames"/utf8>>,
                    gleam@json:array(
                        erlang:element(3, Value__),
                        fun encode__call_frame/1
                    )}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(2, Value__),
                fun(Inner_value__) ->
                    {<<"description"/utf8>>, gleam@json:string(Inner_value__)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(4, Value__),
                fun(Inner_value__@1) ->
                    {<<"parent"/utf8>>, encode__stack_trace(Inner_value__@1)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 882).
?DOC(false).
-spec encode__exception_details(exception_details()) -> gleam@json:json().
encode__exception_details(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"exceptionId"/utf8>>,
                    gleam@json:int(erlang:element(2, Value__))},
                {<<"text"/utf8>>, gleam@json:string(erlang:element(3, Value__))},
                {<<"lineNumber"/utf8>>,
                    gleam@json:int(erlang:element(4, Value__))},
                {<<"columnNumber"/utf8>>,
                    gleam@json:int(erlang:element(5, Value__))}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(6, Value__),
                fun(Inner_value__) ->
                    {<<"scriptId"/utf8>>, encode__script_id(Inner_value__)}
                end
            ),
            _pipe@2 = chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(7, Value__),
                fun(Inner_value__@1) ->
                    {<<"url"/utf8>>, gleam@json:string(Inner_value__@1)}
                end
            ),
            _pipe@3 = chrobot_extra@internal@utils:add_optional(
                _pipe@2,
                erlang:element(8, Value__),
                fun(Inner_value__@2) ->
                    {<<"stackTrace"/utf8>>,
                        encode__stack_trace(Inner_value__@2)}
                end
            ),
            _pipe@4 = chrobot_extra@internal@utils:add_optional(
                _pipe@3,
                erlang:element(9, Value__),
                fun(Inner_value__@3) ->
                    {<<"exception"/utf8>>,
                        encode__remote_object(Inner_value__@3)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@4,
                erlang:element(10, Value__),
                fun(Inner_value__@4) ->
                    {<<"executionContextId"/utf8>>,
                        encode__execution_context_id(Inner_value__@4)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1070).
?DOC(false).
-spec decode__stack_trace() -> gleam@dynamic@decode:decoder(stack_trace()).
decode__stack_trace() ->
    begin
        gleam@dynamic@decode:optional_field(
            <<"description"/utf8>>,
            none,
            gleam@dynamic@decode:optional(
                {decoder, fun gleam@dynamic@decode:decode_string/1}
            ),
            fun(Description) ->
                gleam@dynamic@decode:field(
                    <<"callFrames"/utf8>>,
                    gleam@dynamic@decode:list(decode__call_frame()),
                    fun(Call_frames) ->
                        gleam@dynamic@decode:optional_field(
                            <<"parent"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(decode__stack_trace()),
                            fun(Parent) ->
                                gleam@dynamic@decode:success(
                                    {stack_trace,
                                        Description,
                                        Call_frames,
                                        Parent}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 909).
?DOC(false).
-spec decode__exception_details() -> gleam@dynamic@decode:decoder(exception_details()).
decode__exception_details() ->
    begin
        gleam@dynamic@decode:field(
            <<"exceptionId"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Exception_id) ->
                gleam@dynamic@decode:field(
                    <<"text"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Text) ->
                        gleam@dynamic@decode:field(
                            <<"lineNumber"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_int/1},
                            fun(Line_number) ->
                                gleam@dynamic@decode:field(
                                    <<"columnNumber"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_int/1},
                                    fun(Column_number) ->
                                        gleam@dynamic@decode:optional_field(
                                            <<"scriptId"/utf8>>,
                                            none,
                                            gleam@dynamic@decode:optional(
                                                decode__script_id()
                                            ),
                                            fun(Script_id) ->
                                                gleam@dynamic@decode:optional_field(
                                                    <<"url"/utf8>>,
                                                    none,
                                                    gleam@dynamic@decode:optional(
                                                        {decoder,
                                                            fun gleam@dynamic@decode:decode_string/1}
                                                    ),
                                                    fun(Url) ->
                                                        gleam@dynamic@decode:optional_field(
                                                            <<"stackTrace"/utf8>>,
                                                            none,
                                                            gleam@dynamic@decode:optional(
                                                                decode__stack_trace(
                                                                    
                                                                )
                                                            ),
                                                            fun(Stack_trace) ->
                                                                gleam@dynamic@decode:optional_field(
                                                                    <<"exception"/utf8>>,
                                                                    none,
                                                                    gleam@dynamic@decode:optional(
                                                                        decode__remote_object(
                                                                            
                                                                        )
                                                                    ),
                                                                    fun(
                                                                        Exception
                                                                    ) ->
                                                                        gleam@dynamic@decode:optional_field(
                                                                            <<"executionContextId"/utf8>>,
                                                                            none,
                                                                            gleam@dynamic@decode:optional(
                                                                                decode__execution_context_id(
                                                                                    
                                                                                )
                                                                            ),
                                                                            fun(
                                                                                Execution_context_id
                                                                            ) ->
                                                                                gleam@dynamic@decode:success(
                                                                                    {exception_details,
                                                                                        Exception_id,
                                                                                        Text,
                                                                                        Line_number,
                                                                                        Column_number,
                                                                                        Script_id,
                                                                                        Url,
                                                                                        Stack_trace,
                                                                                        Exception,
                                                                                        Execution_context_id}
                                                                                )
                                                                            end
                                                                        )
                                                                    end
                                                                )
                                                            end
                                                        )
                                                    end
                                                )
                                            end
                                        )
                                    end
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1107).
?DOC(false).
-spec decode__await_promise_response() -> gleam@dynamic@decode:decoder(await_promise_response()).
decode__await_promise_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"result"/utf8>>,
            decode__remote_object(),
            fun(Result) ->
                gleam@dynamic@decode:optional_field(
                    <<"exceptionDetails"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(decode__exception_details()),
                    fun(Exception_details) ->
                        gleam@dynamic@decode:success(
                            {await_promise_response, Result, Exception_details}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1135).
?DOC(false).
-spec decode__call_function_on_response() -> gleam@dynamic@decode:decoder(call_function_on_response()).
decode__call_function_on_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"result"/utf8>>,
            decode__remote_object(),
            fun(Result) ->
                gleam@dynamic@decode:optional_field(
                    <<"exceptionDetails"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(decode__exception_details()),
                    fun(Exception_details) ->
                        gleam@dynamic@decode:success(
                            {call_function_on_response,
                                Result,
                                Exception_details}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1163).
?DOC(false).
-spec decode__compile_script_response() -> gleam@dynamic@decode:decoder(compile_script_response()).
decode__compile_script_response() ->
    begin
        gleam@dynamic@decode:optional_field(
            <<"scriptId"/utf8>>,
            none,
            gleam@dynamic@decode:optional(decode__script_id()),
            fun(Script_id) ->
                gleam@dynamic@decode:optional_field(
                    <<"exceptionDetails"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(decode__exception_details()),
                    fun(Exception_details) ->
                        gleam@dynamic@decode:success(
                            {compile_script_response,
                                Script_id,
                                Exception_details}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1195).
?DOC(false).
-spec decode__evaluate_response() -> gleam@dynamic@decode:decoder(evaluate_response()).
decode__evaluate_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"result"/utf8>>,
            decode__remote_object(),
            fun(Result) ->
                gleam@dynamic@decode:optional_field(
                    <<"exceptionDetails"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(decode__exception_details()),
                    fun(Exception_details) ->
                        gleam@dynamic@decode:success(
                            {evaluate_response, Result, Exception_details}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1225).
?DOC(false).
-spec decode__get_properties_response() -> gleam@dynamic@decode:decoder(get_properties_response()).
decode__get_properties_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"result"/utf8>>,
            gleam@dynamic@decode:list(decode__property_descriptor()),
            fun(Result) ->
                gleam@dynamic@decode:optional_field(
                    <<"internalProperties"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(
                        gleam@dynamic@decode:list(
                            decode__internal_property_descriptor()
                        )
                    ),
                    fun(Internal_properties) ->
                        gleam@dynamic@decode:optional_field(
                            <<"exceptionDetails"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                decode__exception_details()
                            ),
                            fun(Exception_details) ->
                                gleam@dynamic@decode:success(
                                    {get_properties_response,
                                        Result,
                                        Internal_properties,
                                        Exception_details}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1257).
?DOC(false).
-spec decode__global_lexical_scope_names_response() -> gleam@dynamic@decode:decoder(global_lexical_scope_names_response()).
decode__global_lexical_scope_names_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"names"/utf8>>,
            gleam@dynamic@decode:list(
                {decoder, fun gleam@dynamic@decode:decode_string/1}
            ),
            fun(Names) ->
                gleam@dynamic@decode:success(
                    {global_lexical_scope_names_response, Names}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1275).
?DOC(false).
-spec decode__query_objects_response() -> gleam@dynamic@decode:decoder(query_objects_response()).
decode__query_objects_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"objects"/utf8>>,
            decode__remote_object(),
            fun(Objects) ->
                gleam@dynamic@decode:success({query_objects_response, Objects})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1295).
?DOC(false).
-spec decode__run_script_response() -> gleam@dynamic@decode:decoder(run_script_response()).
decode__run_script_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"result"/utf8>>,
            decode__remote_object(),
            fun(Result) ->
                gleam@dynamic@decode:optional_field(
                    <<"exceptionDetails"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(decode__exception_details()),
                    fun(Exception_details) ->
                        gleam@dynamic@decode:success(
                            {run_script_response, Result, Exception_details}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1322).
?DOC(
    " Add handler to promise with given promise object id.\n"
    " \n"
    " Parameters:  \n"
    "  - `promise_object_id` : Identifier of the promise.\n"
    "  - `return_by_value` : Whether the result is expected to be a JSON object that should be sent by value.\n"
    "  - `generate_preview` : Whether preview should be generated for the result.\n"
    " \n"
    " Returns:  \n"
    "  - `result` : Promise result. Will contain rejected value if promise was rejected.\n"
    "  - `exception_details` : Exception details if stack strace is available.\n"
).
-spec await_promise(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    remote_object_id(),
    gleam@option:option(boolean()),
    gleam@option:option(boolean())
) -> {ok, await_promise_response()} |
    {error, chrobot_extra@chrome:request_error()}.
await_promise(Callback__, Promise_object_id, Return_by_value, Generate_preview) ->
    gleam@result:'try'(
        Callback__(
            <<"Runtime.awaitPromise"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"promiseObjectId"/utf8>>,
                                encode__remote_object_id(Promise_object_id)}],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Return_by_value,
                            fun(Inner_value__) ->
                                {<<"returnByValue"/utf8>>,
                                    gleam@json:bool(Inner_value__)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Generate_preview,
                            fun(Inner_value__@1) ->
                                {<<"generatePreview"/utf8>>,
                                    gleam@json:bool(Inner_value__@1)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@2 = gleam@dynamic@decode:run(
                Result__,
                decode__await_promise_response()
            ),
            gleam@result:replace_error(_pipe@2, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1372).
?DOC(
    " Calls function with given declaration on the given object. Object group of the result is\n"
    " inherited from the target object.\n"
    " \n"
    " Parameters:  \n"
    "  - `function_declaration` : Declaration of the function to call.\n"
    "  - `object_id` : Identifier of the object to call function on. Either objectId or executionContextId should\n"
    " be specified.\n"
    "  - `arguments` : Call arguments. All call arguments must belong to the same JavaScript world as the target\n"
    " object.\n"
    "  - `silent` : In silent mode exceptions thrown during evaluation are not reported and do not pause\n"
    " execution. Overrides `setPauseOnException` state.\n"
    "  - `return_by_value` : Whether the result is expected to be a JSON object which should be sent by value.\n"
    " Can be overriden by `serializationOptions`.\n"
    "  - `user_gesture` : Whether execution should be treated as initiated by user in the UI.\n"
    "  - `await_promise` : Whether execution should `await` for resulting value and return once awaited promise is\n"
    " resolved.\n"
    "  - `execution_context_id` : Specifies execution context which global object will be used to call function on. Either\n"
    " executionContextId or objectId should be specified.\n"
    "  - `object_group` : Symbolic group name that can be used to release multiple objects. If objectGroup is not\n"
    " specified and objectId is, objectGroup will be inherited from object.\n"
    " \n"
    " Returns:  \n"
    "  - `result` : Call result.\n"
    "  - `exception_details` : Exception details.\n"
).
-spec call_function_on(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    binary(),
    gleam@option:option(remote_object_id()),
    gleam@option:option(list(call_argument())),
    gleam@option:option(boolean()),
    gleam@option:option(boolean()),
    gleam@option:option(boolean()),
    gleam@option:option(boolean()),
    gleam@option:option(execution_context_id()),
    gleam@option:option(binary())
) -> {ok, call_function_on_response()} |
    {error, chrobot_extra@chrome:request_error()}.
call_function_on(
    Callback__,
    Function_declaration,
    Object_id,
    Arguments,
    Silent,
    Return_by_value,
    User_gesture,
    Await_promise,
    Execution_context_id,
    Object_group
) ->
    gleam@result:'try'(
        Callback__(
            <<"Runtime.callFunctionOn"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"functionDeclaration"/utf8>>,
                                gleam@json:string(Function_declaration)}],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Object_id,
                            fun(Inner_value__) ->
                                {<<"objectId"/utf8>>,
                                    encode__remote_object_id(Inner_value__)}
                            end
                        ),
                        _pipe@2 = chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Arguments,
                            fun(Inner_value__@1) ->
                                {<<"arguments"/utf8>>,
                                    gleam@json:array(
                                        Inner_value__@1,
                                        fun encode__call_argument/1
                                    )}
                            end
                        ),
                        _pipe@3 = chrobot_extra@internal@utils:add_optional(
                            _pipe@2,
                            Silent,
                            fun(Inner_value__@2) ->
                                {<<"silent"/utf8>>,
                                    gleam@json:bool(Inner_value__@2)}
                            end
                        ),
                        _pipe@4 = chrobot_extra@internal@utils:add_optional(
                            _pipe@3,
                            Return_by_value,
                            fun(Inner_value__@3) ->
                                {<<"returnByValue"/utf8>>,
                                    gleam@json:bool(Inner_value__@3)}
                            end
                        ),
                        _pipe@5 = chrobot_extra@internal@utils:add_optional(
                            _pipe@4,
                            User_gesture,
                            fun(Inner_value__@4) ->
                                {<<"userGesture"/utf8>>,
                                    gleam@json:bool(Inner_value__@4)}
                            end
                        ),
                        _pipe@6 = chrobot_extra@internal@utils:add_optional(
                            _pipe@5,
                            Await_promise,
                            fun(Inner_value__@5) ->
                                {<<"awaitPromise"/utf8>>,
                                    gleam@json:bool(Inner_value__@5)}
                            end
                        ),
                        _pipe@7 = chrobot_extra@internal@utils:add_optional(
                            _pipe@6,
                            Execution_context_id,
                            fun(Inner_value__@6) ->
                                {<<"executionContextId"/utf8>>,
                                    encode__execution_context_id(
                                        Inner_value__@6
                                    )}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@7,
                            Object_group,
                            fun(Inner_value__@7) ->
                                {<<"objectGroup"/utf8>>,
                                    gleam@json:string(Inner_value__@7)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@8 = gleam@dynamic@decode:run(
                Result__,
                decode__call_function_on_response()
            ),
            gleam@result:replace_error(_pipe@8, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1434).
?DOC(
    " Compiles expression.\n"
    " \n"
    " Parameters:  \n"
    "  - `expression` : Expression to compile.\n"
    "  - `source_url` : Source url to be set for the script.\n"
    "  - `persist_script` : Specifies whether the compiled script should be persisted.\n"
    "  - `execution_context_id` : Specifies in which execution context to perform script run. If the parameter is omitted the\n"
    " evaluation will be performed in the context of the inspected page.\n"
    " \n"
    " Returns:  \n"
    "  - `script_id` : Id of the script.\n"
    "  - `exception_details` : Exception details.\n"
).
-spec compile_script(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    binary(),
    binary(),
    boolean(),
    gleam@option:option(execution_context_id())
) -> {ok, compile_script_response()} |
    {error, chrobot_extra@chrome:request_error()}.
compile_script(
    Callback__,
    Expression,
    Source_url,
    Persist_script,
    Execution_context_id
) ->
    gleam@result:'try'(
        Callback__(
            <<"Runtime.compileScript"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"expression"/utf8>>,
                                gleam@json:string(Expression)},
                            {<<"sourceURL"/utf8>>,
                                gleam@json:string(Source_url)},
                            {<<"persistScript"/utf8>>,
                                gleam@json:bool(Persist_script)}],
                        chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Execution_context_id,
                            fun(Inner_value__) ->
                                {<<"executionContextId"/utf8>>,
                                    encode__execution_context_id(Inner_value__)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@1 = gleam@dynamic@decode:run(
                Result__,
                decode__compile_script_response()
            ),
            gleam@result:replace_error(_pipe@1, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1461).
?DOC(" Disables reporting of execution contexts creation.\n").
-spec disable(fun((binary(), gleam@option:option(any())) -> NAK)) -> NAK.
disable(Callback__) ->
    Callback__(<<"Runtime.disable"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1467).
?DOC(" Discards collected exceptions and console API calls.\n").
-spec discard_console_entries(
    fun((binary(), gleam@option:option(any())) -> NAO)
) -> NAO.
discard_console_entries(Callback__) ->
    Callback__(<<"Runtime.discardConsoleEntries"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1475).
?DOC(
    " Enables reporting of execution contexts creation by means of `executionContextCreated` event.\n"
    " When the reporting gets enabled the event will be sent immediately for each existing execution\n"
    " context.\n"
).
-spec enable(fun((binary(), gleam@option:option(any())) -> NAS)) -> NAS.
enable(Callback__) ->
    Callback__(<<"Runtime.enable"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1501).
?DOC(
    " Evaluates expression on global object.\n"
    " \n"
    " Parameters:  \n"
    "  - `expression` : Expression to evaluate.\n"
    "  - `object_group` : Symbolic group name that can be used to release multiple objects.\n"
    "  - `include_command_line_api` : Determines whether Command Line API should be available during the evaluation.\n"
    "  - `silent` : In silent mode exceptions thrown during evaluation are not reported and do not pause\n"
    " execution. Overrides `setPauseOnException` state.\n"
    "  - `context_id` : Specifies in which execution context to perform evaluation. If the parameter is omitted the\n"
    " evaluation will be performed in the context of the inspected page.\n"
    " This is mutually exclusive with `uniqueContextId`, which offers an\n"
    " alternative way to identify the execution context that is more reliable\n"
    " in a multi-process environment.\n"
    "  - `return_by_value` : Whether the result is expected to be a JSON object that should be sent by value.\n"
    "  - `user_gesture` : Whether execution should be treated as initiated by user in the UI.\n"
    "  - `await_promise` : Whether execution should `await` for resulting value and return once awaited promise is\n"
    " resolved.\n"
    " \n"
    " Returns:  \n"
    "  - `result` : Evaluation result.\n"
    "  - `exception_details` : Exception details.\n"
).
-spec evaluate(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    binary(),
    gleam@option:option(binary()),
    gleam@option:option(boolean()),
    gleam@option:option(boolean()),
    gleam@option:option(execution_context_id()),
    gleam@option:option(boolean()),
    gleam@option:option(boolean()),
    gleam@option:option(boolean())
) -> {ok, evaluate_response()} | {error, chrobot_extra@chrome:request_error()}.
evaluate(
    Callback__,
    Expression,
    Object_group,
    Include_command_line_api,
    Silent,
    Context_id,
    Return_by_value,
    User_gesture,
    Await_promise
) ->
    gleam@result:'try'(
        Callback__(
            <<"Runtime.evaluate"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"expression"/utf8>>,
                                gleam@json:string(Expression)}],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Object_group,
                            fun(Inner_value__) ->
                                {<<"objectGroup"/utf8>>,
                                    gleam@json:string(Inner_value__)}
                            end
                        ),
                        _pipe@2 = chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Include_command_line_api,
                            fun(Inner_value__@1) ->
                                {<<"includeCommandLineAPI"/utf8>>,
                                    gleam@json:bool(Inner_value__@1)}
                            end
                        ),
                        _pipe@3 = chrobot_extra@internal@utils:add_optional(
                            _pipe@2,
                            Silent,
                            fun(Inner_value__@2) ->
                                {<<"silent"/utf8>>,
                                    gleam@json:bool(Inner_value__@2)}
                            end
                        ),
                        _pipe@4 = chrobot_extra@internal@utils:add_optional(
                            _pipe@3,
                            Context_id,
                            fun(Inner_value__@3) ->
                                {<<"contextId"/utf8>>,
                                    encode__execution_context_id(
                                        Inner_value__@3
                                    )}
                            end
                        ),
                        _pipe@5 = chrobot_extra@internal@utils:add_optional(
                            _pipe@4,
                            Return_by_value,
                            fun(Inner_value__@4) ->
                                {<<"returnByValue"/utf8>>,
                                    gleam@json:bool(Inner_value__@4)}
                            end
                        ),
                        _pipe@6 = chrobot_extra@internal@utils:add_optional(
                            _pipe@5,
                            User_gesture,
                            fun(Inner_value__@5) ->
                                {<<"userGesture"/utf8>>,
                                    gleam@json:bool(Inner_value__@5)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@6,
                            Await_promise,
                            fun(Inner_value__@6) ->
                                {<<"awaitPromise"/utf8>>,
                                    gleam@json:bool(Inner_value__@6)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@7 = gleam@dynamic@decode:run(
                Result__,
                decode__evaluate_response()
            ),
            gleam@result:replace_error(_pipe@7, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1559).
?DOC(
    " Returns properties of a given object. Object group of the result is inherited from the target\n"
    " object.\n"
    " \n"
    " Parameters:  \n"
    "  - `object_id` : Identifier of the object to return properties for.\n"
    "  - `own_properties` : If true, returns properties belonging only to the element itself, not to its prototype\n"
    " chain.\n"
    " \n"
    " Returns:  \n"
    "  - `result` : Object properties.\n"
    "  - `internal_properties` : Internal object properties (only of the element itself).\n"
    "  - `exception_details` : Exception details.\n"
).
-spec get_properties(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    remote_object_id(),
    gleam@option:option(boolean())
) -> {ok, get_properties_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_properties(Callback__, Object_id, Own_properties) ->
    gleam@result:'try'(
        Callback__(
            <<"Runtime.getProperties"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"objectId"/utf8>>,
                                encode__remote_object_id(Object_id)}],
                        chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Own_properties,
                            fun(Inner_value__) ->
                                {<<"ownProperties"/utf8>>,
                                    gleam@json:bool(Inner_value__)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@1 = gleam@dynamic@decode:run(
                Result__,
                decode__get_properties_response()
            ),
            gleam@result:replace_error(_pipe@1, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1588).
?DOC(
    " Returns all let, const and class variables from global scope.\n"
    " \n"
    " Parameters:  \n"
    "  - `execution_context_id` : Specifies in which execution context to lookup global scope variables.\n"
    " \n"
    " Returns:  \n"
    "  - `names`\n"
).
-spec global_lexical_scope_names(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    gleam@option:option(execution_context_id())
) -> {ok, global_lexical_scope_names_response()} |
    {error, chrobot_extra@chrome:request_error()}.
global_lexical_scope_names(Callback__, Execution_context_id) ->
    gleam@result:'try'(
        Callback__(
            <<"Runtime.globalLexicalScopeNames"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [],
                        chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Execution_context_id,
                            fun(Inner_value__) ->
                                {<<"executionContextId"/utf8>>,
                                    encode__execution_context_id(Inner_value__)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@1 = gleam@dynamic@decode:run(
                Result__,
                decode__global_lexical_scope_names_response()
            ),
            gleam@result:replace_error(_pipe@1, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1615).
?DOC(
    " This generated protocol command has no description\n"
    " \n"
    " Parameters:  \n"
    "  - `prototype_object_id` : Identifier of the prototype to return objects for.\n"
    "  - `object_group` : Symbolic group name that can be used to release the results.\n"
    " \n"
    " Returns:  \n"
    "  - `objects` : Array with objects.\n"
).
-spec query_objects(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    remote_object_id(),
    gleam@option:option(binary())
) -> {ok, query_objects_response()} |
    {error, chrobot_extra@chrome:request_error()}.
query_objects(Callback__, Prototype_object_id, Object_group) ->
    gleam@result:'try'(
        Callback__(
            <<"Runtime.queryObjects"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"prototypeObjectId"/utf8>>,
                                encode__remote_object_id(Prototype_object_id)}],
                        chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Object_group,
                            fun(Inner_value__) ->
                                {<<"objectGroup"/utf8>>,
                                    gleam@json:string(Inner_value__)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@1 = gleam@dynamic@decode:run(
                Result__,
                decode__query_objects_response()
            ),
            gleam@result:replace_error(_pipe@1, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1643).
?DOC(
    " Releases remote object with given id.\n"
    " \n"
    " Parameters:  \n"
    "  - `object_id` : Identifier of the object to release.\n"
    " \n"
    " Returns:\n"
).
-spec release_object(
    fun((binary(), gleam@option:option(gleam@json:json())) -> NDQ),
    remote_object_id()
) -> NDQ.
release_object(Callback__, Object_id) ->
    Callback__(
        <<"Runtime.releaseObject"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"objectId"/utf8>>, encode__remote_object_id(Object_id)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1661).
?DOC(
    " Releases all remote objects that belong to a given group.\n"
    " \n"
    " Parameters:  \n"
    "  - `object_group` : Symbolic object group name.\n"
    " \n"
    " Returns:\n"
).
-spec release_object_group(
    fun((binary(), gleam@option:option(gleam@json:json())) -> NDV),
    binary()
) -> NDV.
release_object_group(Callback__, Object_group) ->
    Callback__(
        <<"Runtime.releaseObjectGroup"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"objectGroup"/utf8>>, gleam@json:string(Object_group)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1674).
?DOC(" Tells inspected instance to run if it was waiting for debugger to attach.\n").
-spec run_if_waiting_for_debugger(
    fun((binary(), gleam@option:option(any())) -> NEA)
) -> NEA.
run_if_waiting_for_debugger(Callback__) ->
    Callback__(<<"Runtime.runIfWaitingForDebugger"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1697).
?DOC(
    " Runs script with given id in a given context.\n"
    " \n"
    " Parameters:  \n"
    "  - `script_id` : Id of the script to run.\n"
    "  - `execution_context_id` : Specifies in which execution context to perform script run. If the parameter is omitted the\n"
    " evaluation will be performed in the context of the inspected page.\n"
    "  - `object_group` : Symbolic group name that can be used to release multiple objects.\n"
    "  - `silent` : In silent mode exceptions thrown during evaluation are not reported and do not pause\n"
    " execution. Overrides `setPauseOnException` state.\n"
    "  - `include_command_line_api` : Determines whether Command Line API should be available during the evaluation.\n"
    "  - `return_by_value` : Whether the result is expected to be a JSON object which should be sent by value.\n"
    "  - `generate_preview` : Whether preview should be generated for the result.\n"
    "  - `await_promise` : Whether execution should `await` for resulting value and return once awaited promise is\n"
    " resolved.\n"
    " \n"
    " Returns:  \n"
    "  - `result` : Run result.\n"
    "  - `exception_details` : Exception details.\n"
).
-spec run_script(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    script_id(),
    gleam@option:option(execution_context_id()),
    gleam@option:option(binary()),
    gleam@option:option(boolean()),
    gleam@option:option(boolean()),
    gleam@option:option(boolean()),
    gleam@option:option(boolean()),
    gleam@option:option(boolean())
) -> {ok, run_script_response()} | {error, chrobot_extra@chrome:request_error()}.
run_script(
    Callback__,
    Script_id,
    Execution_context_id,
    Object_group,
    Silent,
    Include_command_line_api,
    Return_by_value,
    Generate_preview,
    Await_promise
) ->
    gleam@result:'try'(
        Callback__(
            <<"Runtime.runScript"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"scriptId"/utf8>>,
                                encode__script_id(Script_id)}],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Execution_context_id,
                            fun(Inner_value__) ->
                                {<<"executionContextId"/utf8>>,
                                    encode__execution_context_id(Inner_value__)}
                            end
                        ),
                        _pipe@2 = chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Object_group,
                            fun(Inner_value__@1) ->
                                {<<"objectGroup"/utf8>>,
                                    gleam@json:string(Inner_value__@1)}
                            end
                        ),
                        _pipe@3 = chrobot_extra@internal@utils:add_optional(
                            _pipe@2,
                            Silent,
                            fun(Inner_value__@2) ->
                                {<<"silent"/utf8>>,
                                    gleam@json:bool(Inner_value__@2)}
                            end
                        ),
                        _pipe@4 = chrobot_extra@internal@utils:add_optional(
                            _pipe@3,
                            Include_command_line_api,
                            fun(Inner_value__@3) ->
                                {<<"includeCommandLineAPI"/utf8>>,
                                    gleam@json:bool(Inner_value__@3)}
                            end
                        ),
                        _pipe@5 = chrobot_extra@internal@utils:add_optional(
                            _pipe@4,
                            Return_by_value,
                            fun(Inner_value__@4) ->
                                {<<"returnByValue"/utf8>>,
                                    gleam@json:bool(Inner_value__@4)}
                            end
                        ),
                        _pipe@6 = chrobot_extra@internal@utils:add_optional(
                            _pipe@5,
                            Generate_preview,
                            fun(Inner_value__@5) ->
                                {<<"generatePreview"/utf8>>,
                                    gleam@json:bool(Inner_value__@5)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@6,
                            Await_promise,
                            fun(Inner_value__@6) ->
                                {<<"awaitPromise"/utf8>>,
                                    gleam@json:bool(Inner_value__@6)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@7 = gleam@dynamic@decode:run(
                Result__,
                decode__run_script_response()
            ),
            gleam@result:replace_error(_pipe@7, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1750).
?DOC(
    " Enables or disables async call stacks tracking.\n"
    " \n"
    " Parameters:  \n"
    "  - `max_depth` : Maximum depth of async call stacks. Setting to `0` will effectively disable collecting async\n"
    " call stacks (default).\n"
    " \n"
    " Returns:\n"
).
-spec set_async_call_stack_depth(
    fun((binary(), gleam@option:option(gleam@json:json())) -> NFF),
    integer()
) -> NFF.
set_async_call_stack_depth(Callback__, Max_depth) ->
    Callback__(
        <<"Runtime.setAsyncCallStackDepth"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"maxDepth"/utf8>>, gleam@json:int(Max_depth)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1778).
?DOC(
    " If executionContextId is empty, adds binding with the given name on the\n"
    " global objects of all inspected contexts, including those created later,\n"
    " bindings survive reloads.\n"
    " Binding function takes exactly one argument, this argument should be string,\n"
    " in case of any other input, function throws an exception.\n"
    " Each binding function call produces Runtime.bindingCalled notification.\n"
    " \n"
    " Parameters:  \n"
    "  - `name`\n"
    "  - `execution_context_name` : If specified, the binding is exposed to the executionContext with\n"
    " matching name, even for contexts created after the binding is added.\n"
    " See also `ExecutionContext.name` and `worldName` parameter to\n"
    " `Page.addScriptToEvaluateOnNewDocument`.\n"
    " This parameter is mutually exclusive with `executionContextId`.\n"
    " \n"
    " Returns:\n"
).
-spec add_binding(
    fun((binary(), gleam@option:option(gleam@json:json())) -> NFK),
    binary(),
    gleam@option:option(binary())
) -> NFK.
add_binding(Callback__, Name, Execution_context_name) ->
    Callback__(
        <<"Runtime.addBinding"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [{<<"name"/utf8>>, gleam@json:string(Name)}],
                    chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Execution_context_name,
                        fun(Inner_value__) ->
                            {<<"executionContextName"/utf8>>,
                                gleam@json:string(Inner_value__)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\runtime.gleam", 1804).
?DOC(
    " This method does not remove binding function from global object but\n"
    " unsubscribes current runtime agent from Runtime.bindingCalled notifications.\n"
    " \n"
    " Parameters:  \n"
    "  - `name`\n"
    " \n"
    " Returns:\n"
).
-spec remove_binding(
    fun((binary(), gleam@option:option(gleam@json:json())) -> NFR),
    binary()
) -> NFR.
remove_binding(Callback__, Name) ->
    Callback__(
        <<"Runtime.removeBinding"/utf8>>,
        {some, gleam@json:object([{<<"name"/utf8>>, gleam@json:string(Name)}])}
    ).
