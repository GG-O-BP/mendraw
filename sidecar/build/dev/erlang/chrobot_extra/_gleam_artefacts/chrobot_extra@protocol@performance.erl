-module(chrobot_extra@protocol@performance).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\protocol\\performance.gleam").
-export([encode__metric/1, decode__metric/0, decode__get_metrics_response/0, disable/1, encode__enable_time_domain/1, enable/2, decode__enable_time_domain/0, get_metrics/1]).
-export_type([metric/0, get_metrics_response/0, enable_time_domain/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " > ⚙️  This module was generated from the Chrome DevTools Protocol version **1.3**\n"
    " ## Performance Domain  \n"
    "\n"
    " This protocol domain has no description.  \n"
    "\n"
    " [📖   View this domain on the DevTools Protocol API Docs](https://chromedevtools.github.io/devtools-protocol/1-3/Performance/)\n"
).

-type metric() :: {metric, binary(), float()}.

-type get_metrics_response() :: {get_metrics_response, list(metric())}.

-type enable_time_domain() :: enable_time_domain_time_ticks |
    enable_time_domain_thread_ticks.

-file("src\\chrobot_extra\\protocol\\performance.gleam", 31).
?DOC(false).
-spec encode__metric(metric()) -> gleam@json:json().
encode__metric(Value__) ->
    gleam@json:object(
        [{<<"name"/utf8>>, gleam@json:string(erlang:element(2, Value__))},
            {<<"value"/utf8>>, gleam@json:float(erlang:element(3, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\performance.gleam", 39).
?DOC(false).
-spec decode__metric() -> gleam@dynamic@decode:decoder(metric()).
decode__metric() ->
    begin
        gleam@dynamic@decode:field(
            <<"name"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Name) ->
                gleam@dynamic@decode:field(
                    <<"value"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_float/1},
                    fun(Value) ->
                        gleam@dynamic@decode:success({metric, Name, Value})
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\performance.gleam", 58).
?DOC(false).
-spec decode__get_metrics_response() -> gleam@dynamic@decode:decoder(get_metrics_response()).
decode__get_metrics_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"metrics"/utf8>>,
            gleam@dynamic@decode:list(decode__metric()),
            fun(Metrics) ->
                gleam@dynamic@decode:success({get_metrics_response, Metrics})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\performance.gleam", 68).
?DOC(" Disable collecting and reporting metrics.\n").
-spec disable(fun((binary(), gleam@option:option(any())) -> VOW)) -> VOW.
disable(Callback__) ->
    Callback__(<<"Performance.disable"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\performance.gleam", 102).
?DOC(false).
-spec encode__enable_time_domain(enable_time_domain()) -> gleam@json:json().
encode__enable_time_domain(Value__) ->
    _pipe = case Value__ of
        enable_time_domain_time_ticks ->
            <<"timeTicks"/utf8>>;

        enable_time_domain_thread_ticks ->
            <<"threadTicks"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\performance.gleam", 79).
?DOC(
    " Enable collecting and reporting metrics.\n"
    " \n"
    " Parameters:  \n"
    "  - `time_domain` : Time domain to use for collecting and reporting duration metrics.\n"
    " \n"
    " Returns:\n"
).
-spec enable(
    fun((binary(), gleam@option:option(gleam@json:json())) -> VPB),
    gleam@option:option(enable_time_domain())
) -> VPB.
enable(Callback__, Time_domain) ->
    Callback__(
        <<"Performance.enable"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [],
                    chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Time_domain,
                        fun(Inner_value__) ->
                            {<<"timeDomain"/utf8>>,
                                encode__enable_time_domain(Inner_value__)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\performance.gleam", 111).
?DOC(false).
-spec decode__enable_time_domain() -> gleam@dynamic@decode:decoder(enable_time_domain()).
decode__enable_time_domain() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"timeTicks"/utf8>> ->
                        gleam@dynamic@decode:success(
                            enable_time_domain_time_ticks
                        );

                    <<"threadTicks"/utf8>> ->
                        gleam@dynamic@decode:success(
                            enable_time_domain_thread_ticks
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            enable_time_domain_time_ticks,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\performance.gleam", 125).
?DOC(
    " Retrieve current values of run-time metrics.\n"
    "  - `metrics` : Current values for run-time metrics.\n"
).
-spec get_metrics(
    fun((binary(), gleam@option:option(any())) -> {ok, gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()})
) -> {ok, get_metrics_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_metrics(Callback__) ->
    gleam@result:'try'(
        Callback__(<<"Performance.getMetrics"/utf8>>, none),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__get_metrics_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).
