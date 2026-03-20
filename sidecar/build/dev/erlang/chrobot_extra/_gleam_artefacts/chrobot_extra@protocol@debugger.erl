-module(chrobot_extra@protocol@debugger).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\protocol\\debugger.gleam").
-export([encode__breakpoint_id/1, decode__breakpoint_id/0, encode__call_frame_id/1, decode__call_frame_id/0, encode__location/1, decode__location/0, encode__scope_type/1, decode__scope_type/0, encode__scope/1, encode__call_frame/1, decode__scope/0, decode__call_frame/0, encode__search_match/1, decode__search_match/0, encode__break_location_type/1, decode__break_location_type/0, encode__break_location/1, decode__break_location/0, encode__script_language/1, decode__script_language/0, encode__debug_symbols_type/1, decode__debug_symbols_type/0, encode__debug_symbols/1, decode__debug_symbols/0, decode__evaluate_on_call_frame_response/0, decode__get_possible_breakpoints_response/0, decode__get_script_source_response/0, decode__search_in_content_response/0, decode__set_breakpoint_response/0, decode__set_instrumentation_breakpoint_response/0, decode__set_breakpoint_by_url_response/0, decode__set_script_source_response/0, encode__continue_to_location_target_call_frames/1, continue_to_location/3, decode__continue_to_location_target_call_frames/0, disable/1, enable/1, evaluate_on_call_frame/8, get_possible_breakpoints/4, get_script_source/2, pause/1, remove_breakpoint/2, restart_frame/2, resume/2, search_in_content/5, set_async_call_stack_depth/2, set_breakpoint/3, encode__set_instrumentation_breakpoint_instrumentation/1, set_instrumentation_breakpoint/2, decode__set_instrumentation_breakpoint_instrumentation/0, set_breakpoint_by_url/7, set_breakpoints_active/2, encode__set_pause_on_exceptions_state/1, set_pause_on_exceptions/2, decode__set_pause_on_exceptions_state/0, set_script_source/4, set_skip_all_pauses/2, set_variable_value/5, step_into/1, step_out/1, step_over/1]).
-export_type([breakpoint_id/0, call_frame_id/0, location/0, call_frame/0, scope/0, scope_type/0, search_match/0, break_location/0, break_location_type/0, script_language/0, debug_symbols/0, debug_symbols_type/0, evaluate_on_call_frame_response/0, get_possible_breakpoints_response/0, get_script_source_response/0, search_in_content_response/0, set_breakpoint_response/0, set_instrumentation_breakpoint_response/0, set_breakpoint_by_url_response/0, set_script_source_response/0, continue_to_location_target_call_frames/0, set_instrumentation_breakpoint_instrumentation/0, set_pause_on_exceptions_state/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " > ⚙️  This module was generated from the Chrome DevTools Protocol version **1.3**\n"
    " ## Debugger Domain  \n"
    "\n"
    " Debugger domain exposes JavaScript debugging capabilities. It allows setting and removing\n"
    " breakpoints, stepping through execution, exploring stack traces, etc.  \n"
    "\n"
    " [📖   View this domain on the DevTools Protocol API Docs](https://chromedevtools.github.io/devtools-protocol/1-3/Debugger/)\n"
).

-type breakpoint_id() :: {breakpoint_id, binary()}.

-type call_frame_id() :: {call_frame_id, binary()}.

-type location() :: {location,
        chrobot_extra@protocol@runtime:script_id(),
        integer(),
        gleam@option:option(integer())}.

-type call_frame() :: {call_frame,
        call_frame_id(),
        binary(),
        gleam@option:option(location()),
        location(),
        list(scope()),
        chrobot_extra@protocol@runtime:remote_object(),
        gleam@option:option(chrobot_extra@protocol@runtime:remote_object())}.

-type scope() :: {scope,
        scope_type(),
        chrobot_extra@protocol@runtime:remote_object(),
        gleam@option:option(binary()),
        gleam@option:option(location()),
        gleam@option:option(location())}.

-type scope_type() :: scope_type_global |
    scope_type_local |
    scope_type_with |
    scope_type_closure |
    scope_type_catch |
    scope_type_block |
    scope_type_script |
    scope_type_eval |
    scope_type_module |
    scope_type_wasm_expression_stack.

-type search_match() :: {search_match, float(), binary()}.

-type break_location() :: {break_location,
        chrobot_extra@protocol@runtime:script_id(),
        integer(),
        gleam@option:option(integer()),
        gleam@option:option(break_location_type())}.

-type break_location_type() :: break_location_type_debugger_statement |
    break_location_type_call |
    break_location_type_return.

-type script_language() :: script_language_java_script |
    script_language_web_assembly.

-type debug_symbols() :: {debug_symbols,
        debug_symbols_type(),
        gleam@option:option(binary())}.

-type debug_symbols_type() :: debug_symbols_type_none |
    debug_symbols_type_source_map |
    debug_symbols_type_embedded_dwarf |
    debug_symbols_type_external_dwarf.

-type evaluate_on_call_frame_response() :: {evaluate_on_call_frame_response,
        chrobot_extra@protocol@runtime:remote_object(),
        gleam@option:option(chrobot_extra@protocol@runtime:exception_details())}.

-type get_possible_breakpoints_response() :: {get_possible_breakpoints_response,
        list(break_location())}.

-type get_script_source_response() :: {get_script_source_response,
        binary(),
        gleam@option:option(binary())}.

-type search_in_content_response() :: {search_in_content_response,
        list(search_match())}.

-type set_breakpoint_response() :: {set_breakpoint_response,
        breakpoint_id(),
        location()}.

-type set_instrumentation_breakpoint_response() :: {set_instrumentation_breakpoint_response,
        breakpoint_id()}.

-type set_breakpoint_by_url_response() :: {set_breakpoint_by_url_response,
        breakpoint_id(),
        list(location())}.

-type set_script_source_response() :: {set_script_source_response,
        gleam@option:option(chrobot_extra@protocol@runtime:exception_details())}.

-type continue_to_location_target_call_frames() :: continue_to_location_target_call_frames_any |
    continue_to_location_target_call_frames_current.

-type set_instrumentation_breakpoint_instrumentation() :: set_instrumentation_breakpoint_instrumentation_before_script_execution |
    set_instrumentation_breakpoint_instrumentation_before_script_with_source_map_execution.

-type set_pause_on_exceptions_state() :: set_pause_on_exceptions_state_none |
    set_pause_on_exceptions_state_caught |
    set_pause_on_exceptions_state_uncaught |
    set_pause_on_exceptions_state_all.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 28).
?DOC(false).
-spec encode__breakpoint_id(breakpoint_id()) -> gleam@json:json().
encode__breakpoint_id(Value__) ->
    case Value__ of
        {breakpoint_id, Inner_value__} ->
            gleam@json:string(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 35).
?DOC(false).
-spec decode__breakpoint_id() -> gleam@dynamic@decode:decoder(breakpoint_id()).
decode__breakpoint_id() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({breakpoint_id, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 48).
?DOC(false).
-spec encode__call_frame_id(call_frame_id()) -> gleam@json:json().
encode__call_frame_id(Value__) ->
    case Value__ of
        {call_frame_id, Inner_value__} ->
            gleam@json:string(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 55).
?DOC(false).
-spec decode__call_frame_id() -> gleam@dynamic@decode:decoder(call_frame_id()).
decode__call_frame_id() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({call_frame_id, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 75).
?DOC(false).
-spec encode__location(location()) -> gleam@json:json().
encode__location(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"scriptId"/utf8>>,
                    chrobot_extra@protocol@runtime:encode__script_id(
                        erlang:element(2, Value__)
                    )},
                {<<"lineNumber"/utf8>>,
                    gleam@json:int(erlang:element(3, Value__))}],
            chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(4, Value__),
                fun(Inner_value__) ->
                    {<<"columnNumber"/utf8>>, gleam@json:int(Inner_value__)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 88).
?DOC(false).
-spec decode__location() -> gleam@dynamic@decode:decoder(location()).
decode__location() ->
    begin
        gleam@dynamic@decode:field(
            <<"scriptId"/utf8>>,
            chrobot_extra@protocol@runtime:decode__script_id(),
            fun(Script_id) ->
                gleam@dynamic@decode:field(
                    <<"lineNumber"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_int/1},
                    fun(Line_number) ->
                        gleam@dynamic@decode:optional_field(
                            <<"columnNumber"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                {decoder, fun gleam@dynamic@decode:decode_int/1}
                            ),
                            fun(Column_number) ->
                                gleam@dynamic@decode:success(
                                    {location,
                                        Script_id,
                                        Line_number,
                                        Column_number}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 209).
?DOC(false).
-spec encode__scope_type(scope_type()) -> gleam@json:json().
encode__scope_type(Value__) ->
    _pipe = case Value__ of
        scope_type_global ->
            <<"global"/utf8>>;

        scope_type_local ->
            <<"local"/utf8>>;

        scope_type_with ->
            <<"with"/utf8>>;

        scope_type_closure ->
            <<"closure"/utf8>>;

        scope_type_catch ->
            <<"catch"/utf8>>;

        scope_type_block ->
            <<"block"/utf8>>;

        scope_type_script ->
            <<"script"/utf8>>;

        scope_type_eval ->
            <<"eval"/utf8>>;

        scope_type_module ->
            <<"module"/utf8>>;

        scope_type_wasm_expression_stack ->
            <<"wasm-expression-stack"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 226).
?DOC(false).
-spec decode__scope_type() -> gleam@dynamic@decode:decoder(scope_type()).
decode__scope_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"global"/utf8>> ->
                        gleam@dynamic@decode:success(scope_type_global);

                    <<"local"/utf8>> ->
                        gleam@dynamic@decode:success(scope_type_local);

                    <<"with"/utf8>> ->
                        gleam@dynamic@decode:success(scope_type_with);

                    <<"closure"/utf8>> ->
                        gleam@dynamic@decode:success(scope_type_closure);

                    <<"catch"/utf8>> ->
                        gleam@dynamic@decode:success(scope_type_catch);

                    <<"block"/utf8>> ->
                        gleam@dynamic@decode:success(scope_type_block);

                    <<"script"/utf8>> ->
                        gleam@dynamic@decode:success(scope_type_script);

                    <<"eval"/utf8>> ->
                        gleam@dynamic@decode:success(scope_type_eval);

                    <<"module"/utf8>> ->
                        gleam@dynamic@decode:success(scope_type_module);

                    <<"wasm-expression-stack"/utf8>> ->
                        gleam@dynamic@decode:success(
                            scope_type_wasm_expression_stack
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            scope_type_global,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 246).
?DOC(false).
-spec encode__scope(scope()) -> gleam@json:json().
encode__scope(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"type"/utf8>>,
                    encode__scope_type(erlang:element(2, Value__))},
                {<<"object"/utf8>>,
                    chrobot_extra@protocol@runtime:encode__remote_object(
                        erlang:element(3, Value__)
                    )}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(4, Value__),
                fun(Inner_value__) ->
                    {<<"name"/utf8>>, gleam@json:string(Inner_value__)}
                end
            ),
            _pipe@2 = chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(5, Value__),
                fun(Inner_value__@1) ->
                    {<<"startLocation"/utf8>>,
                        encode__location(Inner_value__@1)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@2,
                erlang:element(6, Value__),
                fun(Inner_value__@2) ->
                    {<<"endLocation"/utf8>>, encode__location(Inner_value__@2)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 127).
?DOC(false).
-spec encode__call_frame(call_frame()) -> gleam@json:json().
encode__call_frame(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"callFrameId"/utf8>>,
                    encode__call_frame_id(erlang:element(2, Value__))},
                {<<"functionName"/utf8>>,
                    gleam@json:string(erlang:element(3, Value__))},
                {<<"location"/utf8>>,
                    encode__location(erlang:element(5, Value__))},
                {<<"scopeChain"/utf8>>,
                    gleam@json:array(
                        erlang:element(6, Value__),
                        fun encode__scope/1
                    )},
                {<<"this"/utf8>>,
                    chrobot_extra@protocol@runtime:encode__remote_object(
                        erlang:element(7, Value__)
                    )}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(4, Value__),
                fun(Inner_value__) ->
                    {<<"functionLocation"/utf8>>,
                        encode__location(Inner_value__)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(8, Value__),
                fun(Inner_value__@1) ->
                    {<<"returnValue"/utf8>>,
                        chrobot_extra@protocol@runtime:encode__remote_object(
                            Inner_value__@1
                        )}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 265).
?DOC(false).
-spec decode__scope() -> gleam@dynamic@decode:decoder(scope()).
decode__scope() ->
    begin
        gleam@dynamic@decode:field(
            <<"type"/utf8>>,
            decode__scope_type(),
            fun(Type_) ->
                gleam@dynamic@decode:field(
                    <<"object"/utf8>>,
                    chrobot_extra@protocol@runtime:decode__remote_object(),
                    fun(Object) ->
                        gleam@dynamic@decode:optional_field(
                            <<"name"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                {decoder,
                                    fun gleam@dynamic@decode:decode_string/1}
                            ),
                            fun(Name) ->
                                gleam@dynamic@decode:optional_field(
                                    <<"startLocation"/utf8>>,
                                    none,
                                    gleam@dynamic@decode:optional(
                                        decode__location()
                                    ),
                                    fun(Start_location) ->
                                        gleam@dynamic@decode:optional_field(
                                            <<"endLocation"/utf8>>,
                                            none,
                                            gleam@dynamic@decode:optional(
                                                decode__location()
                                            ),
                                            fun(End_location) ->
                                                gleam@dynamic@decode:success(
                                                    {scope,
                                                        Type_,
                                                        Object,
                                                        Name,
                                                        Start_location,
                                                        End_location}
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

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 146).
?DOC(false).
-spec decode__call_frame() -> gleam@dynamic@decode:decoder(call_frame()).
decode__call_frame() ->
    begin
        gleam@dynamic@decode:field(
            <<"callFrameId"/utf8>>,
            decode__call_frame_id(),
            fun(Call_frame_id) ->
                gleam@dynamic@decode:field(
                    <<"functionName"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Function_name) ->
                        gleam@dynamic@decode:optional_field(
                            <<"functionLocation"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(decode__location()),
                            fun(Function_location) ->
                                gleam@dynamic@decode:field(
                                    <<"location"/utf8>>,
                                    decode__location(),
                                    fun(Location) ->
                                        gleam@dynamic@decode:field(
                                            <<"scopeChain"/utf8>>,
                                            gleam@dynamic@decode:list(
                                                decode__scope()
                                            ),
                                            fun(Scope_chain) ->
                                                gleam@dynamic@decode:field(
                                                    <<"this"/utf8>>,
                                                    chrobot_extra@protocol@runtime:decode__remote_object(
                                                        
                                                    ),
                                                    fun(This) ->
                                                        gleam@dynamic@decode:optional_field(
                                                            <<"returnValue"/utf8>>,
                                                            none,
                                                            gleam@dynamic@decode:optional(
                                                                chrobot_extra@protocol@runtime:decode__remote_object(
                                                                    
                                                                )
                                                            ),
                                                            fun(Return_value) ->
                                                                gleam@dynamic@decode:success(
                                                                    {call_frame,
                                                                        Call_frame_id,
                                                                        Function_name,
                                                                        Function_location,
                                                                        Location,
                                                                        Scope_chain,
                                                                        This,
                                                                        Return_value}
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

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 306).
?DOC(false).
-spec encode__search_match(search_match()) -> gleam@json:json().
encode__search_match(Value__) ->
    gleam@json:object(
        [{<<"lineNumber"/utf8>>, gleam@json:float(erlang:element(2, Value__))},
            {<<"lineContent"/utf8>>,
                gleam@json:string(erlang:element(3, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 314).
?DOC(false).
-spec decode__search_match() -> gleam@dynamic@decode:decoder(search_match()).
decode__search_match() ->
    begin
        gleam@dynamic@decode:field(
            <<"lineNumber"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_float/1},
            fun(Line_number) ->
                gleam@dynamic@decode:field(
                    <<"lineContent"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Line_content) ->
                        gleam@dynamic@decode:success(
                            {search_match, Line_number, Line_content}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 347).
?DOC(false).
-spec encode__break_location_type(break_location_type()) -> gleam@json:json().
encode__break_location_type(Value__) ->
    _pipe = case Value__ of
        break_location_type_debugger_statement ->
            <<"debuggerStatement"/utf8>>;

        break_location_type_call ->
            <<"call"/utf8>>;

        break_location_type_return ->
            <<"return"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 357).
?DOC(false).
-spec decode__break_location_type() -> gleam@dynamic@decode:decoder(break_location_type()).
decode__break_location_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"debuggerStatement"/utf8>> ->
                        gleam@dynamic@decode:success(
                            break_location_type_debugger_statement
                        );

                    <<"call"/utf8>> ->
                        gleam@dynamic@decode:success(break_location_type_call);

                    <<"return"/utf8>> ->
                        gleam@dynamic@decode:success(break_location_type_return);

                    _ ->
                        gleam@dynamic@decode:failure(
                            break_location_type_debugger_statement,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 374).
?DOC(false).
-spec encode__break_location(break_location()) -> gleam@json:json().
encode__break_location(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"scriptId"/utf8>>,
                    chrobot_extra@protocol@runtime:encode__script_id(
                        erlang:element(2, Value__)
                    )},
                {<<"lineNumber"/utf8>>,
                    gleam@json:int(erlang:element(3, Value__))}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(4, Value__),
                fun(Inner_value__) ->
                    {<<"columnNumber"/utf8>>, gleam@json:int(Inner_value__)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(5, Value__),
                fun(Inner_value__@1) ->
                    {<<"type"/utf8>>,
                        encode__break_location_type(Inner_value__@1)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 390).
?DOC(false).
-spec decode__break_location() -> gleam@dynamic@decode:decoder(break_location()).
decode__break_location() ->
    begin
        gleam@dynamic@decode:field(
            <<"scriptId"/utf8>>,
            chrobot_extra@protocol@runtime:decode__script_id(),
            fun(Script_id) ->
                gleam@dynamic@decode:field(
                    <<"lineNumber"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_int/1},
                    fun(Line_number) ->
                        gleam@dynamic@decode:optional_field(
                            <<"columnNumber"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                {decoder, fun gleam@dynamic@decode:decode_int/1}
                            ),
                            fun(Column_number) ->
                                gleam@dynamic@decode:optional_field(
                                    <<"type"/utf8>>,
                                    none,
                                    gleam@dynamic@decode:optional(
                                        decode__break_location_type()
                                    ),
                                    fun(Type_) ->
                                        gleam@dynamic@decode:success(
                                            {break_location,
                                                Script_id,
                                                Line_number,
                                                Column_number,
                                                Type_}
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

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 421).
?DOC(false).
-spec encode__script_language(script_language()) -> gleam@json:json().
encode__script_language(Value__) ->
    _pipe = case Value__ of
        script_language_java_script ->
            <<"JavaScript"/utf8>>;

        script_language_web_assembly ->
            <<"WebAssembly"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 430).
?DOC(false).
-spec decode__script_language() -> gleam@dynamic@decode:decoder(script_language()).
decode__script_language() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"JavaScript"/utf8>> ->
                        gleam@dynamic@decode:success(
                            script_language_java_script
                        );

                    <<"WebAssembly"/utf8>> ->
                        gleam@dynamic@decode:success(
                            script_language_web_assembly
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            script_language_java_script,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 461).
?DOC(false).
-spec encode__debug_symbols_type(debug_symbols_type()) -> gleam@json:json().
encode__debug_symbols_type(Value__) ->
    _pipe = case Value__ of
        debug_symbols_type_none ->
            <<"None"/utf8>>;

        debug_symbols_type_source_map ->
            <<"SourceMap"/utf8>>;

        debug_symbols_type_embedded_dwarf ->
            <<"EmbeddedDWARF"/utf8>>;

        debug_symbols_type_external_dwarf ->
            <<"ExternalDWARF"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 472).
?DOC(false).
-spec decode__debug_symbols_type() -> gleam@dynamic@decode:decoder(debug_symbols_type()).
decode__debug_symbols_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"None"/utf8>> ->
                        gleam@dynamic@decode:success(debug_symbols_type_none);

                    <<"SourceMap"/utf8>> ->
                        gleam@dynamic@decode:success(
                            debug_symbols_type_source_map
                        );

                    <<"EmbeddedDWARF"/utf8>> ->
                        gleam@dynamic@decode:success(
                            debug_symbols_type_embedded_dwarf
                        );

                    <<"ExternalDWARF"/utf8>> ->
                        gleam@dynamic@decode:success(
                            debug_symbols_type_external_dwarf
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            debug_symbols_type_none,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 486).
?DOC(false).
-spec encode__debug_symbols(debug_symbols()) -> gleam@json:json().
encode__debug_symbols(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"type"/utf8>>,
                    encode__debug_symbols_type(erlang:element(2, Value__))}],
            chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(3, Value__),
                fun(Inner_value__) ->
                    {<<"externalURL"/utf8>>, gleam@json:string(Inner_value__)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 498).
?DOC(false).
-spec decode__debug_symbols() -> gleam@dynamic@decode:decoder(debug_symbols()).
decode__debug_symbols() ->
    begin
        gleam@dynamic@decode:field(
            <<"type"/utf8>>,
            decode__debug_symbols_type(),
            fun(Type_) ->
                gleam@dynamic@decode:optional_field(
                    <<"externalURL"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(
                        {decoder, fun gleam@dynamic@decode:decode_string/1}
                    ),
                    fun(External_url) ->
                        gleam@dynamic@decode:success(
                            {debug_symbols, Type_, External_url}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 523).
?DOC(false).
-spec decode__evaluate_on_call_frame_response() -> gleam@dynamic@decode:decoder(evaluate_on_call_frame_response()).
decode__evaluate_on_call_frame_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"result"/utf8>>,
            chrobot_extra@protocol@runtime:decode__remote_object(),
            fun(Result) ->
                gleam@dynamic@decode:optional_field(
                    <<"exceptionDetails"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(
                        chrobot_extra@protocol@runtime:decode__exception_details(
                            
                        )
                    ),
                    fun(Exception_details) ->
                        gleam@dynamic@decode:success(
                            {evaluate_on_call_frame_response,
                                Result,
                                Exception_details}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 549).
?DOC(false).
-spec decode__get_possible_breakpoints_response() -> gleam@dynamic@decode:decoder(get_possible_breakpoints_response()).
decode__get_possible_breakpoints_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"locations"/utf8>>,
            gleam@dynamic@decode:list(decode__break_location()),
            fun(Locations) ->
                gleam@dynamic@decode:success(
                    {get_possible_breakpoints_response, Locations}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 572).
?DOC(false).
-spec decode__get_script_source_response() -> gleam@dynamic@decode:decoder(get_script_source_response()).
decode__get_script_source_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"scriptSource"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Script_source) ->
                gleam@dynamic@decode:optional_field(
                    <<"bytecode"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(
                        {decoder, fun gleam@dynamic@decode:decode_string/1}
                    ),
                    fun(Bytecode) ->
                        gleam@dynamic@decode:success(
                            {get_script_source_response,
                                Script_source,
                                Bytecode}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 598).
?DOC(false).
-spec decode__search_in_content_response() -> gleam@dynamic@decode:decoder(search_in_content_response()).
decode__search_in_content_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"result"/utf8>>,
            gleam@dynamic@decode:list(decode__search_match()),
            fun(Result) ->
                gleam@dynamic@decode:success(
                    {search_in_content_response, Result}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 618).
?DOC(false).
-spec decode__set_breakpoint_response() -> gleam@dynamic@decode:decoder(set_breakpoint_response()).
decode__set_breakpoint_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"breakpointId"/utf8>>,
            decode__breakpoint_id(),
            fun(Breakpoint_id) ->
                gleam@dynamic@decode:field(
                    <<"actualLocation"/utf8>>,
                    decode__location(),
                    fun(Actual_location) ->
                        gleam@dynamic@decode:success(
                            {set_breakpoint_response,
                                Breakpoint_id,
                                Actual_location}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 640).
?DOC(false).
-spec decode__set_instrumentation_breakpoint_response() -> gleam@dynamic@decode:decoder(set_instrumentation_breakpoint_response()).
decode__set_instrumentation_breakpoint_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"breakpointId"/utf8>>,
            decode__breakpoint_id(),
            fun(Breakpoint_id) ->
                gleam@dynamic@decode:success(
                    {set_instrumentation_breakpoint_response, Breakpoint_id}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 662).
?DOC(false).
-spec decode__set_breakpoint_by_url_response() -> gleam@dynamic@decode:decoder(set_breakpoint_by_url_response()).
decode__set_breakpoint_by_url_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"breakpointId"/utf8>>,
            decode__breakpoint_id(),
            fun(Breakpoint_id) ->
                gleam@dynamic@decode:field(
                    <<"locations"/utf8>>,
                    gleam@dynamic@decode:list(decode__location()),
                    fun(Locations) ->
                        gleam@dynamic@decode:success(
                            {set_breakpoint_by_url_response,
                                Breakpoint_id,
                                Locations}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 684).
?DOC(false).
-spec decode__set_script_source_response() -> gleam@dynamic@decode:decoder(set_script_source_response()).
decode__set_script_source_response() ->
    begin
        gleam@dynamic@decode:optional_field(
            <<"exceptionDetails"/utf8>>,
            none,
            gleam@dynamic@decode:optional(
                chrobot_extra@protocol@runtime:decode__exception_details()
            ),
            fun(Exception_details) ->
                gleam@dynamic@decode:success(
                    {set_script_source_response, Exception_details}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 735).
?DOC(false).
-spec encode__continue_to_location_target_call_frames(
    continue_to_location_target_call_frames()
) -> gleam@json:json().
encode__continue_to_location_target_call_frames(Value__) ->
    _pipe = case Value__ of
        continue_to_location_target_call_frames_any ->
            <<"any"/utf8>>;

        continue_to_location_target_call_frames_current ->
            <<"current"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 704).
?DOC(
    " Continues execution until specific location is reached.\n"
    " \n"
    " Parameters:  \n"
    "  - `location` : Location to continue to.\n"
    "  - `target_call_frames`\n"
    " \n"
    " Returns:\n"
).
-spec continue_to_location(
    fun((binary(), gleam@option:option(gleam@json:json())) -> TWS),
    location(),
    gleam@option:option(continue_to_location_target_call_frames())
) -> TWS.
continue_to_location(Callback__, Location, Target_call_frames) ->
    Callback__(
        <<"Debugger.continueToLocation"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [{<<"location"/utf8>>, encode__location(Location)}],
                    chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Target_call_frames,
                        fun(Inner_value__) ->
                            {<<"targetCallFrames"/utf8>>,
                                encode__continue_to_location_target_call_frames(
                                    Inner_value__
                                )}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 746).
?DOC(false).
-spec decode__continue_to_location_target_call_frames() -> gleam@dynamic@decode:decoder(continue_to_location_target_call_frames()).
decode__continue_to_location_target_call_frames() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"any"/utf8>> ->
                        gleam@dynamic@decode:success(
                            continue_to_location_target_call_frames_any
                        );

                    <<"current"/utf8>> ->
                        gleam@dynamic@decode:success(
                            continue_to_location_target_call_frames_current
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            continue_to_location_target_call_frames_any,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 763).
?DOC(" Disables debugger for given page.\n").
-spec disable(fun((binary(), gleam@option:option(any())) -> TXG)) -> TXG.
disable(Callback__) ->
    Callback__(<<"Debugger.disable"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 774).
?DOC(
    " Enables debugger for the given page. Clients should not assume that the debugging has been\n"
    " enabled until the result for this command is received.\n"
    " \n"
    " Parameters:  \n"
    " \n"
    " Returns:\n"
).
-spec enable(fun((binary(), gleam@option:option(any())) -> TXK)) -> TXK.
enable(Callback__) ->
    Callback__(<<"Debugger.enable"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 796).
?DOC(
    " Evaluates expression on a given call frame.\n"
    " \n"
    " Parameters:  \n"
    "  - `call_frame_id` : Call frame identifier to evaluate on.\n"
    "  - `expression` : Expression to evaluate.\n"
    "  - `object_group` : String object group name to put result into (allows rapid releasing resulting object handles\n"
    " using `releaseObjectGroup`).\n"
    "  - `include_command_line_api` : Specifies whether command line API should be available to the evaluated expression, defaults\n"
    " to false.\n"
    "  - `silent` : In silent mode exceptions thrown during evaluation are not reported and do not pause\n"
    " execution. Overrides `setPauseOnException` state.\n"
    "  - `return_by_value` : Whether the result is expected to be a JSON object that should be sent by value.\n"
    "  - `throw_on_side_effect` : Whether to throw an exception if side effect cannot be ruled out during evaluation.\n"
    " \n"
    " Returns:  \n"
    "  - `result` : Object wrapper for the evaluation result.\n"
    "  - `exception_details` : Exception details.\n"
).
-spec evaluate_on_call_frame(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    call_frame_id(),
    binary(),
    gleam@option:option(binary()),
    gleam@option:option(boolean()),
    gleam@option:option(boolean()),
    gleam@option:option(boolean()),
    gleam@option:option(boolean())
) -> {ok, evaluate_on_call_frame_response()} |
    {error, chrobot_extra@chrome:request_error()}.
evaluate_on_call_frame(
    Callback__,
    Call_frame_id,
    Expression,
    Object_group,
    Include_command_line_api,
    Silent,
    Return_by_value,
    Throw_on_side_effect
) ->
    gleam@result:'try'(
        Callback__(
            <<"Debugger.evaluateOnCallFrame"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"callFrameId"/utf8>>,
                                encode__call_frame_id(Call_frame_id)},
                            {<<"expression"/utf8>>,
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
                            Return_by_value,
                            fun(Inner_value__@3) ->
                                {<<"returnByValue"/utf8>>,
                                    gleam@json:bool(Inner_value__@3)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@4,
                            Throw_on_side_effect,
                            fun(Inner_value__@4) ->
                                {<<"throwOnSideEffect"/utf8>>,
                                    gleam@json:bool(Inner_value__@4)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@5 = gleam@dynamic@decode:run(
                Result__,
                decode__evaluate_on_call_frame_response()
            ),
            gleam@result:replace_error(_pipe@5, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 847).
?DOC(
    " Returns possible locations for breakpoint. scriptId in start and end range locations should be\n"
    " the same.\n"
    " \n"
    " Parameters:  \n"
    "  - `start` : Start of range to search possible breakpoint locations in.\n"
    "  - `end` : End of range to search possible breakpoint locations in (excluding). When not specified, end\n"
    " of scripts is used as end of range.\n"
    "  - `restrict_to_function` : Only consider locations which are in the same (non-nested) function as start.\n"
    " \n"
    " Returns:  \n"
    "  - `locations` : List of the possible breakpoint locations.\n"
).
-spec get_possible_breakpoints(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    location(),
    gleam@option:option(location()),
    gleam@option:option(boolean())
) -> {ok, get_possible_breakpoints_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_possible_breakpoints(Callback__, Start, End, Restrict_to_function) ->
    gleam@result:'try'(
        Callback__(
            <<"Debugger.getPossibleBreakpoints"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"start"/utf8>>, encode__location(Start)}],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            End,
                            fun(Inner_value__) ->
                                {<<"end"/utf8>>,
                                    encode__location(Inner_value__)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Restrict_to_function,
                            fun(Inner_value__@1) ->
                                {<<"restrictToFunction"/utf8>>,
                                    gleam@json:bool(Inner_value__@1)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@2 = gleam@dynamic@decode:run(
                Result__,
                decode__get_possible_breakpoints_response()
            ),
            gleam@result:replace_error(_pipe@2, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 881).
?DOC(
    " Returns source for the script with given id.\n"
    " \n"
    " Parameters:  \n"
    "  - `script_id` : Id of the script to get source for.\n"
    " \n"
    " Returns:  \n"
    "  - `script_source` : Script source (empty in case of Wasm bytecode).\n"
    "  - `bytecode` : Wasm bytecode. (Encoded as a base64 string when passed over JSON)\n"
).
-spec get_script_source(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    chrobot_extra@protocol@runtime:script_id()
) -> {ok, get_script_source_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_script_source(Callback__, Script_id) ->
    gleam@result:'try'(
        Callback__(
            <<"Debugger.getScriptSource"/utf8>>,
            {some,
                gleam@json:object(
                    [{<<"scriptId"/utf8>>,
                            chrobot_extra@protocol@runtime:encode__script_id(
                                Script_id
                            )}]
                )}
        ),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__get_script_source_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 897).
?DOC(" Stops on the next JavaScript statement.\n").
-spec pause(fun((binary(), gleam@option:option(any())) -> TZP)) -> TZP.
pause(Callback__) ->
    Callback__(<<"Debugger.pause"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 908).
?DOC(
    " Removes JavaScript breakpoint.\n"
    " \n"
    " Parameters:  \n"
    "  - `breakpoint_id`\n"
    " \n"
    " Returns:\n"
).
-spec remove_breakpoint(
    fun((binary(), gleam@option:option(gleam@json:json())) -> TZT),
    breakpoint_id()
) -> TZT.
remove_breakpoint(Callback__, Breakpoint_id) ->
    Callback__(
        <<"Debugger.removeBreakpoint"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"breakpointId"/utf8>>, encode__breakpoint_id(Breakpoint_id)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 938).
?DOC(
    " Restarts particular call frame from the beginning. The old, deprecated\n"
    " behavior of `restartFrame` is to stay paused and allow further CDP commands\n"
    " after a restart was scheduled. This can cause problems with restarting, so\n"
    " we now continue execution immediatly after it has been scheduled until we\n"
    " reach the beginning of the restarted frame.\n"
    " \n"
    " To stay back-wards compatible, `restartFrame` now expects a `mode`\n"
    " parameter to be present. If the `mode` parameter is missing, `restartFrame`\n"
    " errors out.\n"
    " \n"
    " The various return values are deprecated and `callFrames` is always empty.\n"
    " Use the call frames from the `Debugger#paused` events instead, that fires\n"
    " once V8 pauses at the beginning of the restarted function.\n"
    " \n"
    " Parameters:  \n"
    "  - `call_frame_id` : Call frame identifier to evaluate on.\n"
    " \n"
    " Returns:\n"
).
-spec restart_frame(
    fun((binary(), gleam@option:option(gleam@json:json())) -> TZY),
    call_frame_id()
) -> TZY.
restart_frame(Callback__, Call_frame_id) ->
    Callback__(
        <<"Debugger.restartFrame"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"callFrameId"/utf8>>, encode__call_frame_id(Call_frame_id)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 960).
?DOC(
    " Resumes JavaScript execution.\n"
    " \n"
    " Parameters:  \n"
    "  - `terminate_on_resume` : Set to true to terminate execution upon resuming execution. In contrast\n"
    " to Runtime.terminateExecution, this will allows to execute further\n"
    " JavaScript (i.e. via evaluation) until execution of the paused code\n"
    " is actually resumed, at which point termination is triggered.\n"
    " If execution is currently not paused, this parameter has no effect.\n"
    " \n"
    " Returns:\n"
).
-spec resume(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UAD),
    gleam@option:option(boolean())
) -> UAD.
resume(Callback__, Terminate_on_resume) ->
    Callback__(
        <<"Debugger.resume"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [],
                    chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Terminate_on_resume,
                        fun(Inner_value__) ->
                            {<<"terminateOnResume"/utf8>>,
                                gleam@json:bool(Inner_value__)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 986).
?DOC(
    " Searches for given string in script content.\n"
    " \n"
    " Parameters:  \n"
    "  - `script_id` : Id of the script to search in.\n"
    "  - `query` : String to search for.\n"
    "  - `case_sensitive` : If true, search is case sensitive.\n"
    "  - `is_regex` : If true, treats string parameter as regex.\n"
    " \n"
    " Returns:  \n"
    "  - `result` : List of search matches.\n"
).
-spec search_in_content(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    chrobot_extra@protocol@runtime:script_id(),
    binary(),
    gleam@option:option(boolean()),
    gleam@option:option(boolean())
) -> {ok, search_in_content_response()} |
    {error, chrobot_extra@chrome:request_error()}.
search_in_content(Callback__, Script_id, Query, Case_sensitive, Is_regex) ->
    gleam@result:'try'(
        Callback__(
            <<"Debugger.searchInContent"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"scriptId"/utf8>>,
                                chrobot_extra@protocol@runtime:encode__script_id(
                                    Script_id
                                )},
                            {<<"query"/utf8>>, gleam@json:string(Query)}],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Case_sensitive,
                            fun(Inner_value__) ->
                                {<<"caseSensitive"/utf8>>,
                                    gleam@json:bool(Inner_value__)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Is_regex,
                            fun(Inner_value__@1) ->
                                {<<"isRegex"/utf8>>,
                                    gleam@json:bool(Inner_value__@1)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@2 = gleam@dynamic@decode:run(
                Result__,
                decode__search_in_content_response()
            ),
            gleam@result:replace_error(_pipe@2, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 1021).
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
    fun((binary(), gleam@option:option(gleam@json:json())) -> UBB),
    integer()
) -> UBB.
set_async_call_stack_depth(Callback__, Max_depth) ->
    Callback__(
        <<"Debugger.setAsyncCallStackDepth"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"maxDepth"/utf8>>, gleam@json:int(Max_depth)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 1043).
?DOC(
    " Sets JavaScript breakpoint at a given location.\n"
    " \n"
    " Parameters:  \n"
    "  - `location` : Location to set breakpoint in.\n"
    "  - `condition` : Expression to use as a breakpoint condition. When specified, debugger will only stop on the\n"
    " breakpoint if this expression evaluates to true.\n"
    " \n"
    " Returns:  \n"
    "  - `breakpoint_id` : Id of the created breakpoint for further reference.\n"
    "  - `actual_location` : Location this breakpoint resolved into.\n"
).
-spec set_breakpoint(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    location(),
    gleam@option:option(binary())
) -> {ok, set_breakpoint_response()} |
    {error, chrobot_extra@chrome:request_error()}.
set_breakpoint(Callback__, Location, Condition) ->
    gleam@result:'try'(
        Callback__(
            <<"Debugger.setBreakpoint"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"location"/utf8>>,
                                encode__location(Location)}],
                        chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Condition,
                            fun(Inner_value__) ->
                                {<<"condition"/utf8>>,
                                    gleam@json:string(Inner_value__)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@1 = gleam@dynamic@decode:run(
                Result__,
                decode__set_breakpoint_response()
            ),
            gleam@result:replace_error(_pipe@1, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 1102).
?DOC(false).
-spec encode__set_instrumentation_breakpoint_instrumentation(
    set_instrumentation_breakpoint_instrumentation()
) -> gleam@json:json().
encode__set_instrumentation_breakpoint_instrumentation(Value__) ->
    _pipe = case Value__ of
        set_instrumentation_breakpoint_instrumentation_before_script_execution ->
            <<"beforeScriptExecution"/utf8>>;

        set_instrumentation_breakpoint_instrumentation_before_script_with_source_map_execution ->
            <<"beforeScriptWithSourceMapExecution"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 1072).
?DOC(
    " Sets instrumentation breakpoint.\n"
    " \n"
    " Parameters:  \n"
    "  - `instrumentation` : Instrumentation name.\n"
    " \n"
    " Returns:  \n"
    "  - `breakpoint_id` : Id of the created breakpoint for further reference.\n"
).
-spec set_instrumentation_breakpoint(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    set_instrumentation_breakpoint_instrumentation()
) -> {ok, set_instrumentation_breakpoint_response()} |
    {error, chrobot_extra@chrome:request_error()}.
set_instrumentation_breakpoint(Callback__, Instrumentation) ->
    gleam@result:'try'(
        Callback__(
            <<"Debugger.setInstrumentationBreakpoint"/utf8>>,
            {some,
                gleam@json:object(
                    [{<<"instrumentation"/utf8>>,
                            encode__set_instrumentation_breakpoint_instrumentation(
                                Instrumentation
                            )}]
                )}
        ),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__set_instrumentation_breakpoint_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 1115).
?DOC(false).
-spec decode__set_instrumentation_breakpoint_instrumentation() -> gleam@dynamic@decode:decoder(set_instrumentation_breakpoint_instrumentation()).
decode__set_instrumentation_breakpoint_instrumentation() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"beforeScriptExecution"/utf8>> ->
                        gleam@dynamic@decode:success(
                            set_instrumentation_breakpoint_instrumentation_before_script_execution
                        );

                    <<"beforeScriptWithSourceMapExecution"/utf8>> ->
                        gleam@dynamic@decode:success(
                            set_instrumentation_breakpoint_instrumentation_before_script_with_source_map_execution
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            set_instrumentation_breakpoint_instrumentation_before_script_execution,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 1155).
?DOC(
    " Sets JavaScript breakpoint at given location specified either by URL or URL regex. Once this\n"
    " command is issued, all existing parsed scripts will have breakpoints resolved and returned in\n"
    " `locations` property. Further matching script parsing will result in subsequent\n"
    " `breakpointResolved` events issued. This logical breakpoint will survive page reloads.\n"
    " \n"
    " Parameters:  \n"
    "  - `line_number` : Line number to set breakpoint at.\n"
    "  - `url` : URL of the resources to set breakpoint on.\n"
    "  - `url_regex` : Regex pattern for the URLs of the resources to set breakpoints on. Either `url` or\n"
    " `urlRegex` must be specified.\n"
    "  - `script_hash` : Script hash of the resources to set breakpoint on.\n"
    "  - `column_number` : Offset in the line to set breakpoint at.\n"
    "  - `condition` : Expression to use as a breakpoint condition. When specified, debugger will only stop on the\n"
    " breakpoint if this expression evaluates to true.\n"
    " \n"
    " Returns:  \n"
    "  - `breakpoint_id` : Id of the created breakpoint for further reference.\n"
    "  - `locations` : List of the locations this breakpoint resolved into upon addition.\n"
).
-spec set_breakpoint_by_url(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    integer(),
    gleam@option:option(binary()),
    gleam@option:option(binary()),
    gleam@option:option(binary()),
    gleam@option:option(integer()),
    gleam@option:option(binary())
) -> {ok, set_breakpoint_by_url_response()} |
    {error, chrobot_extra@chrome:request_error()}.
set_breakpoint_by_url(
    Callback__,
    Line_number,
    Url,
    Url_regex,
    Script_hash,
    Column_number,
    Condition
) ->
    gleam@result:'try'(
        Callback__(
            <<"Debugger.setBreakpointByUrl"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"lineNumber"/utf8>>,
                                gleam@json:int(Line_number)}],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Url,
                            fun(Inner_value__) ->
                                {<<"url"/utf8>>,
                                    gleam@json:string(Inner_value__)}
                            end
                        ),
                        _pipe@2 = chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Url_regex,
                            fun(Inner_value__@1) ->
                                {<<"urlRegex"/utf8>>,
                                    gleam@json:string(Inner_value__@1)}
                            end
                        ),
                        _pipe@3 = chrobot_extra@internal@utils:add_optional(
                            _pipe@2,
                            Script_hash,
                            fun(Inner_value__@2) ->
                                {<<"scriptHash"/utf8>>,
                                    gleam@json:string(Inner_value__@2)}
                            end
                        ),
                        _pipe@4 = chrobot_extra@internal@utils:add_optional(
                            _pipe@3,
                            Column_number,
                            fun(Inner_value__@3) ->
                                {<<"columnNumber"/utf8>>,
                                    gleam@json:int(Inner_value__@3)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@4,
                            Condition,
                            fun(Inner_value__@4) ->
                                {<<"condition"/utf8>>,
                                    gleam@json:string(Inner_value__@4)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@5 = gleam@dynamic@decode:run(
                Result__,
                decode__set_breakpoint_by_url_response()
            ),
            gleam@result:replace_error(_pipe@5, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 1199).
?DOC(
    " Activates / deactivates all breakpoints on the page.\n"
    " \n"
    " Parameters:  \n"
    "  - `active` : New value for breakpoints active state.\n"
    " \n"
    " Returns:\n"
).
-spec set_breakpoints_active(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UDN),
    boolean()
) -> UDN.
set_breakpoints_active(Callback__, Active) ->
    Callback__(
        <<"Debugger.setBreakpointsActive"/utf8>>,
        {some,
            gleam@json:object([{<<"active"/utf8>>, gleam@json:bool(Active)}])}
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 1242).
?DOC(false).
-spec encode__set_pause_on_exceptions_state(set_pause_on_exceptions_state()) -> gleam@json:json().
encode__set_pause_on_exceptions_state(Value__) ->
    _pipe = case Value__ of
        set_pause_on_exceptions_state_none ->
            <<"none"/utf8>>;

        set_pause_on_exceptions_state_caught ->
            <<"caught"/utf8>>;

        set_pause_on_exceptions_state_uncaught ->
            <<"uncaught"/utf8>>;

        set_pause_on_exceptions_state_all ->
            <<"all"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 1218).
?DOC(
    " Defines pause on exceptions state. Can be set to stop on all exceptions, uncaught exceptions,\n"
    " or caught exceptions, no exceptions. Initial pause on exceptions state is `none`.\n"
    " \n"
    " Parameters:  \n"
    "  - `state` : Pause on exceptions mode.\n"
    " \n"
    " Returns:\n"
).
-spec set_pause_on_exceptions(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UDT),
    set_pause_on_exceptions_state()
) -> UDT.
set_pause_on_exceptions(Callback__, State) ->
    Callback__(
        <<"Debugger.setPauseOnExceptions"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"state"/utf8>>,
                        encode__set_pause_on_exceptions_state(State)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 1253).
?DOC(false).
-spec decode__set_pause_on_exceptions_state() -> gleam@dynamic@decode:decoder(set_pause_on_exceptions_state()).
decode__set_pause_on_exceptions_state() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"none"/utf8>> ->
                        gleam@dynamic@decode:success(
                            set_pause_on_exceptions_state_none
                        );

                    <<"caught"/utf8>> ->
                        gleam@dynamic@decode:success(
                            set_pause_on_exceptions_state_caught
                        );

                    <<"uncaught"/utf8>> ->
                        gleam@dynamic@decode:success(
                            set_pause_on_exceptions_state_uncaught
                        );

                    <<"all"/utf8>> ->
                        gleam@dynamic@decode:success(
                            set_pause_on_exceptions_state_all
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            set_pause_on_exceptions_state_none,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 1283).
?DOC(
    " Edits JavaScript source live.\n"
    " \n"
    " In general, functions that are currently on the stack can not be edited with\n"
    " a single exception: If the edited function is the top-most stack frame and\n"
    " that is the only activation of that function on the stack. In this case\n"
    " the live edit will be successful and a `Debugger.restartFrame` for the\n"
    " top-most function is automatically triggered.\n"
    " \n"
    " Parameters:  \n"
    "  - `script_id` : Id of the script to edit.\n"
    "  - `script_source` : New content of the script.\n"
    "  - `dry_run` : If true the change will not actually be applied. Dry run may be used to get result\n"
    " description without actually modifying the code.\n"
    " \n"
    " Returns:  \n"
    "  - `exception_details` : Exception details if any. Only present when `status` is `CompileError`.\n"
).
-spec set_script_source(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    chrobot_extra@protocol@runtime:script_id(),
    binary(),
    gleam@option:option(boolean())
) -> {ok, set_script_source_response()} |
    {error, chrobot_extra@chrome:request_error()}.
set_script_source(Callback__, Script_id, Script_source, Dry_run) ->
    gleam@result:'try'(
        Callback__(
            <<"Debugger.setScriptSource"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"scriptId"/utf8>>,
                                chrobot_extra@protocol@runtime:encode__script_id(
                                    Script_id
                                )},
                            {<<"scriptSource"/utf8>>,
                                gleam@json:string(Script_source)}],
                        chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Dry_run,
                            fun(Inner_value__) ->
                                {<<"dryRun"/utf8>>,
                                    gleam@json:bool(Inner_value__)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@1 = gleam@dynamic@decode:run(
                Result__,
                decode__set_script_source_response()
            ),
            gleam@result:replace_error(_pipe@1, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 1313).
?DOC(
    " Makes page not interrupt on any pauses (breakpoint, exception, dom exception etc).\n"
    " \n"
    " Parameters:  \n"
    "  - `skip` : New value for skip pauses state.\n"
    " \n"
    " Returns:\n"
).
-spec set_skip_all_pauses(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UEW),
    boolean()
) -> UEW.
set_skip_all_pauses(Callback__, Skip) ->
    Callback__(
        <<"Debugger.setSkipAllPauses"/utf8>>,
        {some, gleam@json:object([{<<"skip"/utf8>>, gleam@json:bool(Skip)}])}
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 1336).
?DOC(
    " Changes value of variable in a callframe. Object-based scopes are not supported and must be\n"
    " mutated manually.\n"
    " \n"
    " Parameters:  \n"
    "  - `scope_number` : 0-based number of scope as was listed in scope chain. Only 'local', 'closure' and 'catch'\n"
    " scope types are allowed. Other scopes could be manipulated manually.\n"
    "  - `variable_name` : Variable name.\n"
    "  - `new_value` : New variable value.\n"
    "  - `call_frame_id` : Id of callframe that holds variable.\n"
    " \n"
    " Returns:\n"
).
-spec set_variable_value(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UFB),
    integer(),
    binary(),
    chrobot_extra@protocol@runtime:call_argument(),
    call_frame_id()
) -> UFB.
set_variable_value(
    Callback__,
    Scope_number,
    Variable_name,
    New_value,
    Call_frame_id
) ->
    Callback__(
        <<"Debugger.setVariableValue"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"scopeNumber"/utf8>>, gleam@json:int(Scope_number)},
                    {<<"variableName"/utf8>>, gleam@json:string(Variable_name)},
                    {<<"newValue"/utf8>>,
                        chrobot_extra@protocol@runtime:encode__call_argument(
                            New_value
                        )},
                    {<<"callFrameId"/utf8>>,
                        encode__call_frame_id(Call_frame_id)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 1362).
?DOC(
    " Steps into the function call.\n"
    " \n"
    " Parameters:  \n"
    " \n"
    " Returns:\n"
).
-spec step_into(fun((binary(), gleam@option:option(any())) -> UFG)) -> UFG.
step_into(Callback__) ->
    Callback__(<<"Debugger.stepInto"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 1368).
?DOC(" Steps out of the function call.\n").
-spec step_out(fun((binary(), gleam@option:option(any())) -> UFK)) -> UFK.
step_out(Callback__) ->
    Callback__(<<"Debugger.stepOut"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\debugger.gleam", 1378).
?DOC(
    " Steps over the statement.\n"
    " \n"
    " Parameters:  \n"
    " \n"
    " Returns:\n"
).
-spec step_over(fun((binary(), gleam@option:option(any())) -> UFO)) -> UFO.
step_over(Callback__) ->
    Callback__(<<"Debugger.stepOver"/utf8>>, none).
