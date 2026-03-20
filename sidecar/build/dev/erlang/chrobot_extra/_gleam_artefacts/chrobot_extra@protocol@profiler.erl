-module(chrobot_extra@protocol@profiler).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\protocol\\profiler.gleam").
-export([encode__position_tick_info/1, encode__profile_node/1, encode__profile/1, decode__position_tick_info/0, decode__profile_node/0, decode__profile/0, encode__coverage_range/1, decode__coverage_range/0, encode__function_coverage/1, decode__function_coverage/0, encode__script_coverage/1, decode__script_coverage/0, decode__get_best_effort_coverage_response/0, decode__start_precise_coverage_response/0, decode__stop_response/0, decode__take_precise_coverage_response/0, disable/1, enable/1, get_best_effort_coverage/1, set_sampling_interval/2, start/1, start_precise_coverage/4, stop/1, stop_precise_coverage/1, take_precise_coverage/1]).
-export_type([profile_node/0, profile/0, position_tick_info/0, coverage_range/0, function_coverage/0, script_coverage/0, get_best_effort_coverage_response/0, start_precise_coverage_response/0, stop_response/0, take_precise_coverage_response/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " > ⚙️  This module was generated from the Chrome DevTools Protocol version **1.3**\n"
    " ## Profiler Domain  \n"
    "\n"
    " This protocol domain has no description.  \n"
    "\n"
    " [📖   View this domain on the DevTools Protocol API Docs](https://chromedevtools.github.io/devtools-protocol/1-3/Profiler/)\n"
).

-type profile_node() :: {profile_node,
        integer(),
        chrobot_extra@protocol@runtime:call_frame(),
        gleam@option:option(integer()),
        gleam@option:option(list(integer())),
        gleam@option:option(binary()),
        gleam@option:option(list(position_tick_info()))}.

-type profile() :: {profile,
        list(profile_node()),
        float(),
        float(),
        gleam@option:option(list(integer())),
        gleam@option:option(list(integer()))}.

-type position_tick_info() :: {position_tick_info, integer(), integer()}.

-type coverage_range() :: {coverage_range, integer(), integer(), integer()}.

-type function_coverage() :: {function_coverage,
        binary(),
        list(coverage_range()),
        boolean()}.

-type script_coverage() :: {script_coverage,
        chrobot_extra@protocol@runtime:script_id(),
        binary(),
        list(function_coverage())}.

-type get_best_effort_coverage_response() :: {get_best_effort_coverage_response,
        list(script_coverage())}.

-type start_precise_coverage_response() :: {start_precise_coverage_response,
        float()}.

-type stop_response() :: {stop_response, profile()}.

-type take_precise_coverage_response() :: {take_precise_coverage_response,
        list(script_coverage()),
        float()}.

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 174).
?DOC(false).
-spec encode__position_tick_info(position_tick_info()) -> gleam@json:json().
encode__position_tick_info(Value__) ->
    gleam@json:object(
        [{<<"line"/utf8>>, gleam@json:int(erlang:element(2, Value__))},
            {<<"ticks"/utf8>>, gleam@json:int(erlang:element(3, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 41).
?DOC(false).
-spec encode__profile_node(profile_node()) -> gleam@json:json().
encode__profile_node(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"id"/utf8>>, gleam@json:int(erlang:element(2, Value__))},
                {<<"callFrame"/utf8>>,
                    chrobot_extra@protocol@runtime:encode__call_frame(
                        erlang:element(3, Value__)
                    )}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(4, Value__),
                fun(Inner_value__) ->
                    {<<"hitCount"/utf8>>, gleam@json:int(Inner_value__)}
                end
            ),
            _pipe@2 = chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(5, Value__),
                fun(Inner_value__@1) ->
                    {<<"children"/utf8>>,
                        gleam@json:array(Inner_value__@1, fun gleam@json:int/1)}
                end
            ),
            _pipe@3 = chrobot_extra@internal@utils:add_optional(
                _pipe@2,
                erlang:element(6, Value__),
                fun(Inner_value__@2) ->
                    {<<"deoptReason"/utf8>>, gleam@json:string(Inner_value__@2)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@3,
                erlang:element(7, Value__),
                fun(Inner_value__@3) ->
                    {<<"positionTicks"/utf8>>,
                        gleam@json:array(
                            Inner_value__@3,
                            fun encode__position_tick_info/1
                        )}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 120).
?DOC(false).
-spec encode__profile(profile()) -> gleam@json:json().
encode__profile(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"nodes"/utf8>>,
                    gleam@json:array(
                        erlang:element(2, Value__),
                        fun encode__profile_node/1
                    )},
                {<<"startTime"/utf8>>,
                    gleam@json:float(erlang:element(3, Value__))},
                {<<"endTime"/utf8>>,
                    gleam@json:float(erlang:element(4, Value__))}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(5, Value__),
                fun(Inner_value__) ->
                    {<<"samples"/utf8>>,
                        gleam@json:array(Inner_value__, fun gleam@json:int/1)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(6, Value__),
                fun(Inner_value__@1) ->
                    {<<"timeDeltas"/utf8>>,
                        gleam@json:array(Inner_value__@1, fun gleam@json:int/1)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 182).
?DOC(false).
-spec decode__position_tick_info() -> gleam@dynamic@decode:decoder(position_tick_info()).
decode__position_tick_info() ->
    begin
        gleam@dynamic@decode:field(
            <<"line"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Line) ->
                gleam@dynamic@decode:field(
                    <<"ticks"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_int/1},
                    fun(Ticks) ->
                        gleam@dynamic@decode:success(
                            {position_tick_info, Line, Ticks}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 66).
?DOC(false).
-spec decode__profile_node() -> gleam@dynamic@decode:decoder(profile_node()).
decode__profile_node() ->
    begin
        gleam@dynamic@decode:field(
            <<"id"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) ->
                gleam@dynamic@decode:field(
                    <<"callFrame"/utf8>>,
                    chrobot_extra@protocol@runtime:decode__call_frame(),
                    fun(Call_frame) ->
                        gleam@dynamic@decode:optional_field(
                            <<"hitCount"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                {decoder, fun gleam@dynamic@decode:decode_int/1}
                            ),
                            fun(Hit_count) ->
                                gleam@dynamic@decode:optional_field(
                                    <<"children"/utf8>>,
                                    none,
                                    gleam@dynamic@decode:optional(
                                        gleam@dynamic@decode:list(
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_int/1}
                                        )
                                    ),
                                    fun(Children) ->
                                        gleam@dynamic@decode:optional_field(
                                            <<"deoptReason"/utf8>>,
                                            none,
                                            gleam@dynamic@decode:optional(
                                                {decoder,
                                                    fun gleam@dynamic@decode:decode_string/1}
                                            ),
                                            fun(Deopt_reason) ->
                                                gleam@dynamic@decode:optional_field(
                                                    <<"positionTicks"/utf8>>,
                                                    none,
                                                    gleam@dynamic@decode:optional(
                                                        gleam@dynamic@decode:list(
                                                            decode__position_tick_info(
                                                                
                                                            )
                                                        )
                                                    ),
                                                    fun(Position_ticks) ->
                                                        gleam@dynamic@decode:success(
                                                            {profile_node,
                                                                Id,
                                                                Call_frame,
                                                                Hit_count,
                                                                Children,
                                                                Deopt_reason,
                                                                Position_ticks}
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

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 137).
?DOC(false).
-spec decode__profile() -> gleam@dynamic@decode:decoder(profile()).
decode__profile() ->
    begin
        gleam@dynamic@decode:field(
            <<"nodes"/utf8>>,
            gleam@dynamic@decode:list(decode__profile_node()),
            fun(Nodes) ->
                gleam@dynamic@decode:field(
                    <<"startTime"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_float/1},
                    fun(Start_time) ->
                        gleam@dynamic@decode:field(
                            <<"endTime"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_float/1},
                            fun(End_time) ->
                                gleam@dynamic@decode:optional_field(
                                    <<"samples"/utf8>>,
                                    none,
                                    gleam@dynamic@decode:optional(
                                        gleam@dynamic@decode:list(
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_int/1}
                                        )
                                    ),
                                    fun(Samples) ->
                                        gleam@dynamic@decode:optional_field(
                                            <<"timeDeltas"/utf8>>,
                                            none,
                                            gleam@dynamic@decode:optional(
                                                gleam@dynamic@decode:list(
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_int/1}
                                                )
                                            ),
                                            fun(Time_deltas) ->
                                                gleam@dynamic@decode:success(
                                                    {profile,
                                                        Nodes,
                                                        Start_time,
                                                        End_time,
                                                        Samples,
                                                        Time_deltas}
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

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 204).
?DOC(false).
-spec encode__coverage_range(coverage_range()) -> gleam@json:json().
encode__coverage_range(Value__) ->
    gleam@json:object(
        [{<<"startOffset"/utf8>>, gleam@json:int(erlang:element(2, Value__))},
            {<<"endOffset"/utf8>>, gleam@json:int(erlang:element(3, Value__))},
            {<<"count"/utf8>>, gleam@json:int(erlang:element(4, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 213).
?DOC(false).
-spec decode__coverage_range() -> gleam@dynamic@decode:decoder(coverage_range()).
decode__coverage_range() ->
    begin
        gleam@dynamic@decode:field(
            <<"startOffset"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Start_offset) ->
                gleam@dynamic@decode:field(
                    <<"endOffset"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_int/1},
                    fun(End_offset) ->
                        gleam@dynamic@decode:field(
                            <<"count"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_int/1},
                            fun(Count) ->
                                gleam@dynamic@decode:success(
                                    {coverage_range,
                                        Start_offset,
                                        End_offset,
                                        Count}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 240).
?DOC(false).
-spec encode__function_coverage(function_coverage()) -> gleam@json:json().
encode__function_coverage(Value__) ->
    gleam@json:object(
        [{<<"functionName"/utf8>>,
                gleam@json:string(erlang:element(2, Value__))},
            {<<"ranges"/utf8>>,
                gleam@json:array(
                    erlang:element(3, Value__),
                    fun encode__coverage_range/1
                )},
            {<<"isBlockCoverage"/utf8>>,
                gleam@json:bool(erlang:element(4, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 249).
?DOC(false).
-spec decode__function_coverage() -> gleam@dynamic@decode:decoder(function_coverage()).
decode__function_coverage() ->
    begin
        gleam@dynamic@decode:field(
            <<"functionName"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Function_name) ->
                gleam@dynamic@decode:field(
                    <<"ranges"/utf8>>,
                    gleam@dynamic@decode:list(decode__coverage_range()),
                    fun(Ranges) ->
                        gleam@dynamic@decode:field(
                            <<"isBlockCoverage"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_bool/1},
                            fun(Is_block_coverage) ->
                                gleam@dynamic@decode:success(
                                    {function_coverage,
                                        Function_name,
                                        Ranges,
                                        Is_block_coverage}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 276).
?DOC(false).
-spec encode__script_coverage(script_coverage()) -> gleam@json:json().
encode__script_coverage(Value__) ->
    gleam@json:object(
        [{<<"scriptId"/utf8>>,
                chrobot_extra@protocol@runtime:encode__script_id(
                    erlang:element(2, Value__)
                )},
            {<<"url"/utf8>>, gleam@json:string(erlang:element(3, Value__))},
            {<<"functions"/utf8>>,
                gleam@json:array(
                    erlang:element(4, Value__),
                    fun encode__function_coverage/1
                )}]
    ).

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 285).
?DOC(false).
-spec decode__script_coverage() -> gleam@dynamic@decode:decoder(script_coverage()).
decode__script_coverage() ->
    begin
        gleam@dynamic@decode:field(
            <<"scriptId"/utf8>>,
            chrobot_extra@protocol@runtime:decode__script_id(),
            fun(Script_id) ->
                gleam@dynamic@decode:field(
                    <<"url"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Url) ->
                        gleam@dynamic@decode:field(
                            <<"functions"/utf8>>,
                            gleam@dynamic@decode:list(
                                decode__function_coverage()
                            ),
                            fun(Functions) ->
                                gleam@dynamic@decode:success(
                                    {script_coverage, Script_id, Url, Functions}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 312).
?DOC(false).
-spec decode__get_best_effort_coverage_response() -> gleam@dynamic@decode:decoder(get_best_effort_coverage_response()).
decode__get_best_effort_coverage_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"result"/utf8>>,
            gleam@dynamic@decode:list(decode__script_coverage()),
            fun(Result) ->
                gleam@dynamic@decode:success(
                    {get_best_effort_coverage_response, Result}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 330).
?DOC(false).
-spec decode__start_precise_coverage_response() -> gleam@dynamic@decode:decoder(start_precise_coverage_response()).
decode__start_precise_coverage_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"timestamp"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_float/1},
            fun(Timestamp) ->
                gleam@dynamic@decode:success(
                    {start_precise_coverage_response, Timestamp}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 348).
?DOC(false).
-spec decode__stop_response() -> gleam@dynamic@decode:decoder(stop_response()).
decode__stop_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"profile"/utf8>>,
            decode__profile(),
            fun(Profile) ->
                gleam@dynamic@decode:success({stop_response, Profile})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 368).
?DOC(false).
-spec decode__take_precise_coverage_response() -> gleam@dynamic@decode:decoder(take_precise_coverage_response()).
decode__take_precise_coverage_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"result"/utf8>>,
            gleam@dynamic@decode:list(decode__script_coverage()),
            fun(Result) ->
                gleam@dynamic@decode:field(
                    <<"timestamp"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_float/1},
                    fun(Timestamp) ->
                        gleam@dynamic@decode:success(
                            {take_precise_coverage_response, Result, Timestamp}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 382).
?DOC(" This generated protocol command has no description\n").
-spec disable(fun((binary(), gleam@option:option(any())) -> VYK)) -> VYK.
disable(Callback__) ->
    Callback__(<<"Profiler.disable"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 388).
?DOC(" This generated protocol command has no description\n").
-spec enable(fun((binary(), gleam@option:option(any())) -> VYO)) -> VYO.
enable(Callback__) ->
    Callback__(<<"Profiler.enable"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 396).
?DOC(
    " Collect coverage data for the current isolate. The coverage data may be incomplete due to\n"
    " garbage collection.\n"
    "  - `result` : Coverage data for the current isolate.\n"
).
-spec get_best_effort_coverage(
    fun((binary(), gleam@option:option(any())) -> {ok, gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()})
) -> {ok, get_best_effort_coverage_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_best_effort_coverage(Callback__) ->
    gleam@result:'try'(
        Callback__(<<"Profiler.getBestEffortCoverage"/utf8>>, none),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__get_best_effort_coverage_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 413).
?DOC(
    " Changes CPU profiler sampling interval. Must be called before CPU profiles recording started.\n"
    " \n"
    " Parameters:  \n"
    "  - `interval` : New sampling interval in microseconds.\n"
    " \n"
    " Returns:\n"
).
-spec set_sampling_interval(
    fun((binary(), gleam@option:option(gleam@json:json())) -> VZE),
    integer()
) -> VZE.
set_sampling_interval(Callback__, Interval) ->
    Callback__(
        <<"Profiler.setSamplingInterval"/utf8>>,
        {some,
            gleam@json:object([{<<"interval"/utf8>>, gleam@json:int(Interval)}])}
    ).

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 426).
?DOC(" This generated protocol command has no description\n").
-spec start(fun((binary(), gleam@option:option(any())) -> VZJ)) -> VZJ.
start(Callback__) ->
    Callback__(<<"Profiler.start"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 442).
?DOC(
    " Enable precise code coverage. Coverage data for JavaScript executed before enabling precise code\n"
    " coverage may be incomplete. Enabling prevents running optimized code and resets execution\n"
    " counters.\n"
    " \n"
    " Parameters:  \n"
    "  - `call_count` : Collect accurate call counts beyond simple 'covered' or 'not covered'.\n"
    "  - `detailed` : Collect block-based coverage.\n"
    "  - `allow_triggered_updates` : Allow the backend to send updates on its own initiative\n"
    " \n"
    " Returns:  \n"
    "  - `timestamp` : Monotonically increasing time (in seconds) when the coverage update was taken in the backend.\n"
).
-spec start_precise_coverage(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    gleam@option:option(boolean()),
    gleam@option:option(boolean()),
    gleam@option:option(boolean())
) -> {ok, start_precise_coverage_response()} |
    {error, chrobot_extra@chrome:request_error()}.
start_precise_coverage(
    Callback__,
    Call_count,
    Detailed,
    Allow_triggered_updates
) ->
    gleam@result:'try'(
        Callback__(
            <<"Profiler.startPreciseCoverage"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Call_count,
                            fun(Inner_value__) ->
                                {<<"callCount"/utf8>>,
                                    gleam@json:bool(Inner_value__)}
                            end
                        ),
                        _pipe@2 = chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Detailed,
                            fun(Inner_value__@1) ->
                                {<<"detailed"/utf8>>,
                                    gleam@json:bool(Inner_value__@1)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@2,
                            Allow_triggered_updates,
                            fun(Inner_value__@2) ->
                                {<<"allowTriggeredUpdates"/utf8>>,
                                    gleam@json:bool(Inner_value__@2)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@3 = gleam@dynamic@decode:run(
                Result__,
                decode__start_precise_coverage_response()
            ),
            gleam@result:replace_error(_pipe@3, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 471).
?DOC(
    " This generated protocol command has no description\n"
    "  - `profile` : Recorded profile.\n"
).
-spec stop(
    fun((binary(), gleam@option:option(any())) -> {ok, gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()})
) -> {ok, stop_response()} | {error, chrobot_extra@chrome:request_error()}.
stop(Callback__) ->
    gleam@result:'try'(
        Callback__(<<"Profiler.stop"/utf8>>, none),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(Result__, decode__stop_response()),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 481).
?DOC(
    " Disable precise code coverage. Disabling releases unnecessary execution count records and allows\n"
    " executing optimized code.\n"
).
-spec stop_precise_coverage(fun((binary(), gleam@option:option(any())) -> WAS)) -> WAS.
stop_precise_coverage(Callback__) ->
    Callback__(<<"Profiler.stopPreciseCoverage"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\profiler.gleam", 490).
?DOC(
    " Collect coverage data for the current isolate, and resets execution counters. Precise code\n"
    " coverage needs to have started.\n"
    "  - `result` : Coverage data for the current isolate.\n"
    "  - `timestamp` : Monotonically increasing time (in seconds) when the coverage update was taken in the backend.\n"
).
-spec take_precise_coverage(
    fun((binary(), gleam@option:option(any())) -> {ok, gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()})
) -> {ok, take_precise_coverage_response()} |
    {error, chrobot_extra@chrome:request_error()}.
take_precise_coverage(Callback__) ->
    gleam@result:'try'(
        Callback__(<<"Profiler.takePreciseCoverage"/utf8>>, none),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__take_precise_coverage_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).
