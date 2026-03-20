-module(chrobot_extra@protocol@dom_debugger).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\protocol\\dom_debugger.gleam").
-export([encode__dom_breakpoint_type/1, decode__dom_breakpoint_type/0, encode__event_listener/1, decode__event_listener/0, decode__get_event_listeners_response/0, get_event_listeners/4, remove_dom_breakpoint/3, remove_event_listener_breakpoint/2, remove_xhr_breakpoint/2, set_dom_breakpoint/3, set_event_listener_breakpoint/2, set_xhr_breakpoint/2]).
-export_type([d_o_m_breakpoint_type/0, event_listener/0, get_event_listeners_response/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " > ⚙️  This module was generated from the Chrome DevTools Protocol version **1.3**\n"
    " ## DOMDebugger Domain  \n"
    "\n"
    " DOM debugging allows setting breakpoints on particular DOM operations and events. JavaScript\n"
    " execution will stop on these operations as if there was a regular breakpoint set.  \n"
    "\n"
    " [📖   View this domain on the DevTools Protocol API Docs](https://chromedevtools.github.io/devtools-protocol/1-3/DOMDebugger/)\n"
).

-type d_o_m_breakpoint_type() :: d_o_m_breakpoint_type_subtree_modified |
    d_o_m_breakpoint_type_attribute_modified |
    d_o_m_breakpoint_type_node_removed.

-type event_listener() :: {event_listener,
        binary(),
        boolean(),
        boolean(),
        boolean(),
        chrobot_extra@protocol@runtime:script_id(),
        integer(),
        integer(),
        gleam@option:option(chrobot_extra@protocol@runtime:remote_object()),
        gleam@option:option(chrobot_extra@protocol@runtime:remote_object()),
        gleam@option:option(chrobot_extra@protocol@dom:backend_node_id())}.

-type get_event_listeners_response() :: {get_event_listeners_response,
        list(event_listener())}.

-file("src\\chrobot_extra\\protocol\\dom_debugger.gleam", 31).
?DOC(false).
-spec encode__dom_breakpoint_type(d_o_m_breakpoint_type()) -> gleam@json:json().
encode__dom_breakpoint_type(Value__) ->
    _pipe = case Value__ of
        d_o_m_breakpoint_type_subtree_modified ->
            <<"subtree-modified"/utf8>>;

        d_o_m_breakpoint_type_attribute_modified ->
            <<"attribute-modified"/utf8>>;

        d_o_m_breakpoint_type_node_removed ->
            <<"node-removed"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\dom_debugger.gleam", 41).
?DOC(false).
-spec decode__dom_breakpoint_type() -> gleam@dynamic@decode:decoder(d_o_m_breakpoint_type()).
decode__dom_breakpoint_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"subtree-modified"/utf8>> ->
                        gleam@dynamic@decode:success(
                            d_o_m_breakpoint_type_subtree_modified
                        );

                    <<"attribute-modified"/utf8>> ->
                        gleam@dynamic@decode:success(
                            d_o_m_breakpoint_type_attribute_modified
                        );

                    <<"node-removed"/utf8>> ->
                        gleam@dynamic@decode:success(
                            d_o_m_breakpoint_type_node_removed
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            d_o_m_breakpoint_type_subtree_modified,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom_debugger.gleam", 81).
?DOC(false).
-spec encode__event_listener(event_listener()) -> gleam@json:json().
encode__event_listener(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"type"/utf8>>,
                    gleam@json:string(erlang:element(2, Value__))},
                {<<"useCapture"/utf8>>,
                    gleam@json:bool(erlang:element(3, Value__))},
                {<<"passive"/utf8>>,
                    gleam@json:bool(erlang:element(4, Value__))},
                {<<"once"/utf8>>, gleam@json:bool(erlang:element(5, Value__))},
                {<<"scriptId"/utf8>>,
                    chrobot_extra@protocol@runtime:encode__script_id(
                        erlang:element(6, Value__)
                    )},
                {<<"lineNumber"/utf8>>,
                    gleam@json:int(erlang:element(7, Value__))},
                {<<"columnNumber"/utf8>>,
                    gleam@json:int(erlang:element(8, Value__))}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(9, Value__),
                fun(Inner_value__) ->
                    {<<"handler"/utf8>>,
                        chrobot_extra@protocol@runtime:encode__remote_object(
                            Inner_value__
                        )}
                end
            ),
            _pipe@2 = chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(10, Value__),
                fun(Inner_value__@1) ->
                    {<<"originalHandler"/utf8>>,
                        chrobot_extra@protocol@runtime:encode__remote_object(
                            Inner_value__@1
                        )}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@2,
                erlang:element(11, Value__),
                fun(Inner_value__@2) ->
                    {<<"backendNodeId"/utf8>>,
                        chrobot_extra@protocol@dom:encode__backend_node_id(
                            Inner_value__@2
                        )}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\dom_debugger.gleam", 105).
?DOC(false).
-spec decode__event_listener() -> gleam@dynamic@decode:decoder(event_listener()).
decode__event_listener() ->
    begin
        gleam@dynamic@decode:field(
            <<"type"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Type_) ->
                gleam@dynamic@decode:field(
                    <<"useCapture"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_bool/1},
                    fun(Use_capture) ->
                        gleam@dynamic@decode:field(
                            <<"passive"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_bool/1},
                            fun(Passive) ->
                                gleam@dynamic@decode:field(
                                    <<"once"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_bool/1},
                                    fun(Once) ->
                                        gleam@dynamic@decode:field(
                                            <<"scriptId"/utf8>>,
                                            chrobot_extra@protocol@runtime:decode__script_id(
                                                
                                            ),
                                            fun(Script_id) ->
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
                                                                gleam@dynamic@decode:optional_field(
                                                                    <<"handler"/utf8>>,
                                                                    none,
                                                                    gleam@dynamic@decode:optional(
                                                                        chrobot_extra@protocol@runtime:decode__remote_object(
                                                                            
                                                                        )
                                                                    ),
                                                                    fun(Handler) ->
                                                                        gleam@dynamic@decode:optional_field(
                                                                            <<"originalHandler"/utf8>>,
                                                                            none,
                                                                            gleam@dynamic@decode:optional(
                                                                                chrobot_extra@protocol@runtime:decode__remote_object(
                                                                                    
                                                                                )
                                                                            ),
                                                                            fun(
                                                                                Original_handler
                                                                            ) ->
                                                                                gleam@dynamic@decode:optional_field(
                                                                                    <<"backendNodeId"/utf8>>,
                                                                                    none,
                                                                                    gleam@dynamic@decode:optional(
                                                                                        chrobot_extra@protocol@dom:decode__backend_node_id(
                                                                                            
                                                                                        )
                                                                                    ),
                                                                                    fun(
                                                                                        Backend_node_id
                                                                                    ) ->
                                                                                        gleam@dynamic@decode:success(
                                                                                            {event_listener,
                                                                                                Type_,
                                                                                                Use_capture,
                                                                                                Passive,
                                                                                                Once,
                                                                                                Script_id,
                                                                                                Line_number,
                                                                                                Column_number,
                                                                                                Handler,
                                                                                                Original_handler,
                                                                                                Backend_node_id}
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

-file("src\\chrobot_extra\\protocol\\dom_debugger.gleam", 155).
?DOC(false).
-spec decode__get_event_listeners_response() -> gleam@dynamic@decode:decoder(get_event_listeners_response()).
decode__get_event_listeners_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"listeners"/utf8>>,
            gleam@dynamic@decode:list(decode__event_listener()),
            fun(Listeners) ->
                gleam@dynamic@decode:success(
                    {get_event_listeners_response, Listeners}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom_debugger.gleam", 178).
?DOC(
    " Returns event listeners of the given object.\n"
    " \n"
    " Parameters:  \n"
    "  - `object_id` : Identifier of the object to return listeners for.\n"
    "  - `depth` : The maximum depth at which Node children should be retrieved, defaults to 1. Use -1 for the\n"
    " entire subtree or provide an integer larger than 0.\n"
    "  - `pierce` : Whether or not iframes and shadow roots should be traversed when returning the subtree\n"
    " (default is false). Reports listeners for all contexts if pierce is enabled.\n"
    " \n"
    " Returns:  \n"
    "  - `listeners` : Array of relevant listeners.\n"
).
-spec get_event_listeners(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    chrobot_extra@protocol@runtime:remote_object_id(),
    gleam@option:option(integer()),
    gleam@option:option(boolean())
) -> {ok, get_event_listeners_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_event_listeners(Callback__, Object_id, Depth, Pierce) ->
    gleam@result:'try'(
        Callback__(
            <<"DOMDebugger.getEventListeners"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"objectId"/utf8>>,
                                chrobot_extra@protocol@runtime:encode__remote_object_id(
                                    Object_id
                                )}],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Depth,
                            fun(Inner_value__) ->
                                {<<"depth"/utf8>>,
                                    gleam@json:int(Inner_value__)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Pierce,
                            fun(Inner_value__@1) ->
                                {<<"pierce"/utf8>>,
                                    gleam@json:bool(Inner_value__@1)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@2 = gleam@dynamic@decode:run(
                Result__,
                decode__get_event_listeners_response()
            ),
            gleam@result:replace_error(_pipe@2, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\dom_debugger.gleam", 211).
?DOC(
    " Removes DOM breakpoint that was set using `setDOMBreakpoint`.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Identifier of the node to remove breakpoint from.\n"
    "  - `type_` : Type of the breakpoint to remove.\n"
    " \n"
    " Returns:\n"
).
-spec remove_dom_breakpoint(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UKA),
    chrobot_extra@protocol@dom:node_id(),
    d_o_m_breakpoint_type()
) -> UKA.
remove_dom_breakpoint(Callback__, Node_id, Type_) ->
    Callback__(
        <<"DOMDebugger.removeDOMBreakpoint"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"nodeId"/utf8>>,
                        chrobot_extra@protocol@dom:encode__node_id(Node_id)},
                    {<<"type"/utf8>>, encode__dom_breakpoint_type(Type_)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\dom_debugger.gleam", 234).
?DOC(
    " Removes breakpoint on particular DOM event.\n"
    " \n"
    " Parameters:  \n"
    "  - `event_name` : Event name.\n"
    " \n"
    " Returns:\n"
).
-spec remove_event_listener_breakpoint(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UKF),
    binary()
) -> UKF.
remove_event_listener_breakpoint(Callback__, Event_name) ->
    Callback__(
        <<"DOMDebugger.removeEventListenerBreakpoint"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"eventName"/utf8>>, gleam@json:string(Event_name)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\dom_debugger.gleam", 255).
?DOC(
    " Removes breakpoint from XMLHttpRequest.\n"
    " \n"
    " Parameters:  \n"
    "  - `url` : Resource URL substring.\n"
    " \n"
    " Returns:\n"
).
-spec remove_xhr_breakpoint(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UKK),
    binary()
) -> UKK.
remove_xhr_breakpoint(Callback__, Url) ->
    Callback__(
        <<"DOMDebugger.removeXHRBreakpoint"/utf8>>,
        {some, gleam@json:object([{<<"url"/utf8>>, gleam@json:string(Url)}])}
    ).

-file("src\\chrobot_extra\\protocol\\dom_debugger.gleam", 274).
?DOC(
    " Sets breakpoint on particular operation with DOM.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Identifier of the node to set breakpoint on.\n"
    "  - `type_` : Type of the operation to stop upon.\n"
    " \n"
    " Returns:\n"
).
-spec set_dom_breakpoint(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UKP),
    chrobot_extra@protocol@dom:node_id(),
    d_o_m_breakpoint_type()
) -> UKP.
set_dom_breakpoint(Callback__, Node_id, Type_) ->
    Callback__(
        <<"DOMDebugger.setDOMBreakpoint"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"nodeId"/utf8>>,
                        chrobot_extra@protocol@dom:encode__node_id(Node_id)},
                    {<<"type"/utf8>>, encode__dom_breakpoint_type(Type_)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\dom_debugger.gleam", 297).
?DOC(
    " Sets breakpoint on particular DOM event.\n"
    " \n"
    " Parameters:  \n"
    "  - `event_name` : DOM Event name to stop on (any DOM event will do).\n"
    " \n"
    " Returns:\n"
).
-spec set_event_listener_breakpoint(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UKU),
    binary()
) -> UKU.
set_event_listener_breakpoint(Callback__, Event_name) ->
    Callback__(
        <<"DOMDebugger.setEventListenerBreakpoint"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"eventName"/utf8>>, gleam@json:string(Event_name)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\dom_debugger.gleam", 315).
?DOC(
    " Sets breakpoint on XMLHttpRequest.\n"
    " \n"
    " Parameters:  \n"
    "  - `url` : Resource URL substring. All XHRs having this substring in the URL will get stopped upon.\n"
    " \n"
    " Returns:\n"
).
-spec set_xhr_breakpoint(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UKZ),
    binary()
) -> UKZ.
set_xhr_breakpoint(Callback__, Url) ->
    Callback__(
        <<"DOMDebugger.setXHRBreakpoint"/utf8>>,
        {some, gleam@json:object([{<<"url"/utf8>>, gleam@json:string(Url)}])}
    ).
