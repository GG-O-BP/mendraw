-module(chrobot_extra@protocol@log).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\protocol\\log.gleam").
-export([encode__log_entry_source/1, decode__log_entry_source/0, encode__log_entry_level/1, decode__log_entry_level/0, encode__log_entry_category/1, decode__log_entry_category/0, encode__log_entry/1, decode__log_entry/0, encode__violation_setting_name/1, decode__violation_setting_name/0, encode__violation_setting/1, decode__violation_setting/0, clear/1, disable/1, enable/1, start_violations_report/2, stop_violations_report/1]).
-export_type([log_entry/0, log_entry_source/0, log_entry_level/0, log_entry_category/0, violation_setting/0, violation_setting_name/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " > ⚙️  This module was generated from the Chrome DevTools Protocol version **1.3**\n"
    " ## Log Domain  \n"
    "\n"
    " Provides access to log entries.  \n"
    "\n"
    " [📖   View this domain on the DevTools Protocol API Docs](https://chromedevtools.github.io/devtools-protocol/1-3/Log/)\n"
).

-type log_entry() :: {log_entry,
        log_entry_source(),
        log_entry_level(),
        binary(),
        gleam@option:option(log_entry_category()),
        chrobot_extra@protocol@runtime:timestamp(),
        gleam@option:option(binary()),
        gleam@option:option(integer()),
        gleam@option:option(chrobot_extra@protocol@runtime:stack_trace()),
        gleam@option:option(chrobot_extra@protocol@network:request_id()),
        gleam@option:option(binary()),
        gleam@option:option(list(chrobot_extra@protocol@runtime:remote_object()))}.

-type log_entry_source() :: log_entry_source_xml |
    log_entry_source_javascript |
    log_entry_source_network |
    log_entry_source_storage |
    log_entry_source_appcache |
    log_entry_source_rendering |
    log_entry_source_security |
    log_entry_source_deprecation |
    log_entry_source_worker |
    log_entry_source_violation |
    log_entry_source_intervention |
    log_entry_source_recommendation |
    log_entry_source_other.

-type log_entry_level() :: log_entry_level_verbose |
    log_entry_level_info |
    log_entry_level_warning |
    log_entry_level_error.

-type log_entry_category() :: log_entry_category_cors.

-type violation_setting() :: {violation_setting,
        violation_setting_name(),
        float()}.

-type violation_setting_name() :: violation_setting_name_long_task |
    violation_setting_name_long_layout |
    violation_setting_name_blocked_event |
    violation_setting_name_blocked_parser |
    violation_setting_name_discouraged_api_use |
    violation_setting_name_handler |
    violation_setting_name_recurring_handler.

-file("src\\chrobot_extra\\protocol\\log.gleam", 66).
?DOC(false).
-spec encode__log_entry_source(log_entry_source()) -> gleam@json:json().
encode__log_entry_source(Value__) ->
    _pipe = case Value__ of
        log_entry_source_xml ->
            <<"xml"/utf8>>;

        log_entry_source_javascript ->
            <<"javascript"/utf8>>;

        log_entry_source_network ->
            <<"network"/utf8>>;

        log_entry_source_storage ->
            <<"storage"/utf8>>;

        log_entry_source_appcache ->
            <<"appcache"/utf8>>;

        log_entry_source_rendering ->
            <<"rendering"/utf8>>;

        log_entry_source_security ->
            <<"security"/utf8>>;

        log_entry_source_deprecation ->
            <<"deprecation"/utf8>>;

        log_entry_source_worker ->
            <<"worker"/utf8>>;

        log_entry_source_violation ->
            <<"violation"/utf8>>;

        log_entry_source_intervention ->
            <<"intervention"/utf8>>;

        log_entry_source_recommendation ->
            <<"recommendation"/utf8>>;

        log_entry_source_other ->
            <<"other"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\log.gleam", 86).
?DOC(false).
-spec decode__log_entry_source() -> gleam@dynamic@decode:decoder(log_entry_source()).
decode__log_entry_source() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"xml"/utf8>> ->
                        gleam@dynamic@decode:success(log_entry_source_xml);

                    <<"javascript"/utf8>> ->
                        gleam@dynamic@decode:success(
                            log_entry_source_javascript
                        );

                    <<"network"/utf8>> ->
                        gleam@dynamic@decode:success(log_entry_source_network);

                    <<"storage"/utf8>> ->
                        gleam@dynamic@decode:success(log_entry_source_storage);

                    <<"appcache"/utf8>> ->
                        gleam@dynamic@decode:success(log_entry_source_appcache);

                    <<"rendering"/utf8>> ->
                        gleam@dynamic@decode:success(log_entry_source_rendering);

                    <<"security"/utf8>> ->
                        gleam@dynamic@decode:success(log_entry_source_security);

                    <<"deprecation"/utf8>> ->
                        gleam@dynamic@decode:success(
                            log_entry_source_deprecation
                        );

                    <<"worker"/utf8>> ->
                        gleam@dynamic@decode:success(log_entry_source_worker);

                    <<"violation"/utf8>> ->
                        gleam@dynamic@decode:success(log_entry_source_violation);

                    <<"intervention"/utf8>> ->
                        gleam@dynamic@decode:success(
                            log_entry_source_intervention
                        );

                    <<"recommendation"/utf8>> ->
                        gleam@dynamic@decode:success(
                            log_entry_source_recommendation
                        );

                    <<"other"/utf8>> ->
                        gleam@dynamic@decode:success(log_entry_source_other);

                    _ ->
                        gleam@dynamic@decode:failure(
                            log_entry_source_xml,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\log.gleam", 118).
?DOC(false).
-spec encode__log_entry_level(log_entry_level()) -> gleam@json:json().
encode__log_entry_level(Value__) ->
    _pipe = case Value__ of
        log_entry_level_verbose ->
            <<"verbose"/utf8>>;

        log_entry_level_info ->
            <<"info"/utf8>>;

        log_entry_level_warning ->
            <<"warning"/utf8>>;

        log_entry_level_error ->
            <<"error"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\log.gleam", 129).
?DOC(false).
-spec decode__log_entry_level() -> gleam@dynamic@decode:decoder(log_entry_level()).
decode__log_entry_level() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"verbose"/utf8>> ->
                        gleam@dynamic@decode:success(log_entry_level_verbose);

                    <<"info"/utf8>> ->
                        gleam@dynamic@decode:success(log_entry_level_info);

                    <<"warning"/utf8>> ->
                        gleam@dynamic@decode:success(log_entry_level_warning);

                    <<"error"/utf8>> ->
                        gleam@dynamic@decode:success(log_entry_level_error);

                    _ ->
                        gleam@dynamic@decode:failure(
                            log_entry_level_verbose,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\log.gleam", 149).
?DOC(false).
-spec encode__log_entry_category(log_entry_category()) -> gleam@json:json().
encode__log_entry_category(Value__) ->
    _pipe = case Value__ of
        log_entry_category_cors ->
            <<"cors"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\log.gleam", 157).
?DOC(false).
-spec decode__log_entry_category() -> gleam@dynamic@decode:decoder(log_entry_category()).
decode__log_entry_category() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"cors"/utf8>> ->
                        gleam@dynamic@decode:success(log_entry_category_cors);

                    _ ->
                        gleam@dynamic@decode:failure(
                            log_entry_category_cors,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\log.gleam", 168).
?DOC(false).
-spec encode__log_entry(log_entry()) -> gleam@json:json().
encode__log_entry(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"source"/utf8>>,
                    encode__log_entry_source(erlang:element(2, Value__))},
                {<<"level"/utf8>>,
                    encode__log_entry_level(erlang:element(3, Value__))},
                {<<"text"/utf8>>, gleam@json:string(erlang:element(4, Value__))},
                {<<"timestamp"/utf8>>,
                    chrobot_extra@protocol@runtime:encode__timestamp(
                        erlang:element(6, Value__)
                    )}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(5, Value__),
                fun(Inner_value__) ->
                    {<<"category"/utf8>>,
                        encode__log_entry_category(Inner_value__)}
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
                    {<<"lineNumber"/utf8>>, gleam@json:int(Inner_value__@2)}
                end
            ),
            _pipe@4 = chrobot_extra@internal@utils:add_optional(
                _pipe@3,
                erlang:element(9, Value__),
                fun(Inner_value__@3) ->
                    {<<"stackTrace"/utf8>>,
                        chrobot_extra@protocol@runtime:encode__stack_trace(
                            Inner_value__@3
                        )}
                end
            ),
            _pipe@5 = chrobot_extra@internal@utils:add_optional(
                _pipe@4,
                erlang:element(10, Value__),
                fun(Inner_value__@4) ->
                    {<<"networkRequestId"/utf8>>,
                        chrobot_extra@protocol@network:encode__request_id(
                            Inner_value__@4
                        )}
                end
            ),
            _pipe@6 = chrobot_extra@internal@utils:add_optional(
                _pipe@5,
                erlang:element(11, Value__),
                fun(Inner_value__@5) ->
                    {<<"workerId"/utf8>>, gleam@json:string(Inner_value__@5)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@6,
                erlang:element(12, Value__),
                fun(Inner_value__@6) ->
                    {<<"args"/utf8>>,
                        gleam@json:array(
                            Inner_value__@6,
                            fun chrobot_extra@protocol@runtime:encode__remote_object/1
                        )}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\log.gleam", 201).
?DOC(false).
-spec decode__log_entry() -> gleam@dynamic@decode:decoder(log_entry()).
decode__log_entry() ->
    begin
        gleam@dynamic@decode:field(
            <<"source"/utf8>>,
            decode__log_entry_source(),
            fun(Source) ->
                gleam@dynamic@decode:field(
                    <<"level"/utf8>>,
                    decode__log_entry_level(),
                    fun(Level) ->
                        gleam@dynamic@decode:field(
                            <<"text"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Text) ->
                                gleam@dynamic@decode:optional_field(
                                    <<"category"/utf8>>,
                                    none,
                                    gleam@dynamic@decode:optional(
                                        decode__log_entry_category()
                                    ),
                                    fun(Category) ->
                                        gleam@dynamic@decode:field(
                                            <<"timestamp"/utf8>>,
                                            chrobot_extra@protocol@runtime:decode__timestamp(
                                                
                                            ),
                                            fun(Timestamp) ->
                                                gleam@dynamic@decode:optional_field(
                                                    <<"url"/utf8>>,
                                                    none,
                                                    gleam@dynamic@decode:optional(
                                                        {decoder,
                                                            fun gleam@dynamic@decode:decode_string/1}
                                                    ),
                                                    fun(Url) ->
                                                        gleam@dynamic@decode:optional_field(
                                                            <<"lineNumber"/utf8>>,
                                                            none,
                                                            gleam@dynamic@decode:optional(
                                                                {decoder,
                                                                    fun gleam@dynamic@decode:decode_int/1}
                                                            ),
                                                            fun(Line_number) ->
                                                                gleam@dynamic@decode:optional_field(
                                                                    <<"stackTrace"/utf8>>,
                                                                    none,
                                                                    gleam@dynamic@decode:optional(
                                                                        chrobot_extra@protocol@runtime:decode__stack_trace(
                                                                            
                                                                        )
                                                                    ),
                                                                    fun(
                                                                        Stack_trace
                                                                    ) ->
                                                                        gleam@dynamic@decode:optional_field(
                                                                            <<"networkRequestId"/utf8>>,
                                                                            none,
                                                                            gleam@dynamic@decode:optional(
                                                                                chrobot_extra@protocol@network:decode__request_id(
                                                                                    
                                                                                )
                                                                            ),
                                                                            fun(
                                                                                Network_request_id
                                                                            ) ->
                                                                                gleam@dynamic@decode:optional_field(
                                                                                    <<"workerId"/utf8>>,
                                                                                    none,
                                                                                    gleam@dynamic@decode:optional(
                                                                                        {decoder,
                                                                                            fun gleam@dynamic@decode:decode_string/1}
                                                                                    ),
                                                                                    fun(
                                                                                        Worker_id
                                                                                    ) ->
                                                                                        gleam@dynamic@decode:optional_field(
                                                                                            <<"args"/utf8>>,
                                                                                            none,
                                                                                            gleam@dynamic@decode:optional(
                                                                                                gleam@dynamic@decode:list(
                                                                                                    chrobot_extra@protocol@runtime:decode__remote_object(
                                                                                                        
                                                                                                    )
                                                                                                )
                                                                                            ),
                                                                                            fun(
                                                                                                Args
                                                                                            ) ->
                                                                                                gleam@dynamic@decode:success(
                                                                                                    {log_entry,
                                                                                                        Source,
                                                                                                        Level,
                                                                                                        Text,
                                                                                                        Category,
                                                                                                        Timestamp,
                                                                                                        Url,
                                                                                                        Line_number,
                                                                                                        Stack_trace,
                                                                                                        Network_request_id,
                                                                                                        Worker_id,
                                                                                                        Args}
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
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\log.gleam", 282).
?DOC(false).
-spec encode__violation_setting_name(violation_setting_name()) -> gleam@json:json().
encode__violation_setting_name(Value__) ->
    _pipe = case Value__ of
        violation_setting_name_long_task ->
            <<"longTask"/utf8>>;

        violation_setting_name_long_layout ->
            <<"longLayout"/utf8>>;

        violation_setting_name_blocked_event ->
            <<"blockedEvent"/utf8>>;

        violation_setting_name_blocked_parser ->
            <<"blockedParser"/utf8>>;

        violation_setting_name_discouraged_api_use ->
            <<"discouragedAPIUse"/utf8>>;

        violation_setting_name_handler ->
            <<"handler"/utf8>>;

        violation_setting_name_recurring_handler ->
            <<"recurringHandler"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\log.gleam", 296).
?DOC(false).
-spec decode__violation_setting_name() -> gleam@dynamic@decode:decoder(violation_setting_name()).
decode__violation_setting_name() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"longTask"/utf8>> ->
                        gleam@dynamic@decode:success(
                            violation_setting_name_long_task
                        );

                    <<"longLayout"/utf8>> ->
                        gleam@dynamic@decode:success(
                            violation_setting_name_long_layout
                        );

                    <<"blockedEvent"/utf8>> ->
                        gleam@dynamic@decode:success(
                            violation_setting_name_blocked_event
                        );

                    <<"blockedParser"/utf8>> ->
                        gleam@dynamic@decode:success(
                            violation_setting_name_blocked_parser
                        );

                    <<"discouragedAPIUse"/utf8>> ->
                        gleam@dynamic@decode:success(
                            violation_setting_name_discouraged_api_use
                        );

                    <<"handler"/utf8>> ->
                        gleam@dynamic@decode:success(
                            violation_setting_name_handler
                        );

                    <<"recurringHandler"/utf8>> ->
                        gleam@dynamic@decode:success(
                            violation_setting_name_recurring_handler
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            violation_setting_name_long_task,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\log.gleam", 314).
?DOC(false).
-spec encode__violation_setting(violation_setting()) -> gleam@json:json().
encode__violation_setting(Value__) ->
    gleam@json:object(
        [{<<"name"/utf8>>,
                encode__violation_setting_name(erlang:element(2, Value__))},
            {<<"threshold"/utf8>>, gleam@json:float(erlang:element(3, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\log.gleam", 322).
?DOC(false).
-spec decode__violation_setting() -> gleam@dynamic@decode:decoder(violation_setting()).
decode__violation_setting() ->
    begin
        gleam@dynamic@decode:field(
            <<"name"/utf8>>,
            decode__violation_setting_name(),
            fun(Name) ->
                gleam@dynamic@decode:field(
                    <<"threshold"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_float/1},
                    fun(Threshold) ->
                        gleam@dynamic@decode:success(
                            {violation_setting, Name, Threshold}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\log.gleam", 333).
?DOC(" Clears the log.\n").
-spec clear(fun((binary(), gleam@option:option(any())) -> VMW)) -> VMW.
clear(Callback__) ->
    Callback__(<<"Log.clear"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\log.gleam", 339).
?DOC(" Disables log domain, prevents further log entries from being reported to the client.\n").
-spec disable(fun((binary(), gleam@option:option(any())) -> VNA)) -> VNA.
disable(Callback__) ->
    Callback__(<<"Log.disable"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\log.gleam", 346).
?DOC(
    " Enables log domain, sends the entries collected so far to the client by means of the\n"
    " `entryAdded` notification.\n"
).
-spec enable(fun((binary(), gleam@option:option(any())) -> VNE)) -> VNE.
enable(Callback__) ->
    Callback__(<<"Log.enable"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\log.gleam", 357).
?DOC(
    " start violation reporting.\n"
    " \n"
    " Parameters:  \n"
    "  - `config` : Configuration for violations.\n"
    " \n"
    " Returns:\n"
).
-spec start_violations_report(
    fun((binary(), gleam@option:option(gleam@json:json())) -> VNI),
    list(violation_setting())
) -> VNI.
start_violations_report(Callback__, Config) ->
    Callback__(
        <<"Log.startViolationsReport"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"config"/utf8>>,
                        gleam@json:array(
                            Config,
                            fun encode__violation_setting/1
                        )}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\log.gleam", 373).
?DOC(" Stop violation reporting.\n").
-spec stop_violations_report(fun((binary(), gleam@option:option(any())) -> VNO)) -> VNO.
stop_violations_report(Callback__) ->
    Callback__(<<"Log.stopViolationsReport"/utf8>>, none).
