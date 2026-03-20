-module(chrobot_extra@network_idle).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\network_idle.gleam").
-export([start/1, stop/1, defer_stop/2, wait_for_idle/3]).
-export_type([idle_listener/0, event_kind/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " Network idle detection for chrobot_extra.\n"
    " Tracks active network requests and waits until no requests are in-flight\n"
    " for a specified quiet period, similar to Playwright's `networkidle`.\n"
).

-opaque idle_listener() :: {idle_listener,
        gleam@erlang@process:subject(chrobot_extra@chrome:message()),
        gleam@erlang@process:subject(gleam@dynamic:dynamic_()),
        gleam@erlang@process:subject(gleam@dynamic:dynamic_()),
        gleam@erlang@process:subject(gleam@dynamic:dynamic_())}.

-type event_kind() :: {request_started, gleam@dynamic:dynamic_()} |
    {request_finished, gleam@dynamic:dynamic_()} |
    {request_failed, gleam@dynamic:dynamic_()}.

-file("src\\chrobot_extra\\network_idle.gleam", 28).
?DOC(
    " Start tracking network activity on the given page.\n"
    " Enables the Network domain and subscribes to request start/finish/fail events.\n"
).
-spec start(chrobot_extra:page()) -> {ok, idle_listener()} |
    {error, chrobot_extra@chrome:request_error()}.
start(Page) ->
    gleam@result:'try'(
        chrobot_extra@protocol@network:enable(
            chrobot_extra:page_caller(Page),
            none
        ),
        fun(_) ->
            Request_will_be_sent = chrobot_extra@chrome:add_listener(
                erlang:element(2, Page),
                <<"Network.requestWillBeSent"/utf8>>
            ),
            Loading_finished = chrobot_extra@chrome:add_listener(
                erlang:element(2, Page),
                <<"Network.loadingFinished"/utf8>>
            ),
            Loading_failed = chrobot_extra@chrome:add_listener(
                erlang:element(2, Page),
                <<"Network.loadingFailed"/utf8>>
            ),
            {ok,
                {idle_listener,
                    erlang:element(2, Page),
                    Request_will_be_sent,
                    Loading_finished,
                    Loading_failed}}
        end
    ).

-file("src\\chrobot_extra\\network_idle.gleam", 48).
?DOC(" Remove all event listeners.\n").
-spec stop(idle_listener()) -> nil.
stop(Listener) ->
    chrobot_extra@chrome:remove_listener(
        erlang:element(2, Listener),
        erlang:element(3, Listener)
    ),
    chrobot_extra@chrome:remove_listener(
        erlang:element(2, Listener),
        erlang:element(4, Listener)
    ),
    chrobot_extra@chrome:remove_listener(
        erlang:element(2, Listener),
        erlang:element(5, Listener)
    ).

-file("src\\chrobot_extra\\network_idle.gleam", 55).
?DOC(" Defer pattern for use expressions.\n").
-spec defer_stop(idle_listener(), fun(() -> TAS)) -> TAS.
defer_stop(Listener, Body) ->
    Result = Body(),
    stop(Listener),
    Result.

-file("src\\chrobot_extra\\network_idle.gleam", 152).
-spec decode_request_id(gleam@dynamic:dynamic_()) -> {ok, binary()} |
    {error, list(gleam@dynamic@decode:decode_error())}.
decode_request_id(Dyn) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            <<"requestId"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Request_id) -> gleam@dynamic@decode:success(Request_id) end
        )
    end,
    gleam@dynamic@decode:run(Dyn, Decoder).

-file("src\\chrobot_extra\\network_idle.gleam", 141).
-spec remove_request(
    gleam@dynamic:dynamic_(),
    gleam@set:set(binary()),
    integer()
) -> {gleam@set:set(binary()), integer()}.
remove_request(Dyn, Active, Now) ->
    case decode_request_id(Dyn) of
        {ok, Id} ->
            {gleam@set:delete(Active, Id), Now};

        {error, _} ->
            {Active, Now}
    end.

-file("src\\chrobot_extra\\network_idle.gleam", 124).
-spec handle_event(event_kind(), gleam@set:set(binary()), integer()) -> {gleam@set:set(binary()),
    integer()}.
handle_event(Event, Active, Now) ->
    case Event of
        {request_started, Dyn} ->
            case decode_request_id(Dyn) of
                {ok, Id} ->
                    {gleam@set:insert(Active, Id), Now};

                {error, _} ->
                    {Active, Now}
            end;

        {request_finished, Dyn@1} ->
            remove_request(Dyn@1, Active, Now);

        {request_failed, Dyn@2} ->
            remove_request(Dyn@2, Active, Now)
    end.

-file("src\\chrobot_extra\\network_idle.gleam", 79).
-spec idle_loop(
    idle_listener(),
    gleam@set:set(binary()),
    integer(),
    integer(),
    integer()
) -> {ok, nil} | {error, chrobot_extra@chrome:request_error()}.
idle_loop(Listener, Active, Last_activity, Quiet_ms, Deadline) ->
    Now = chrobot_extra_ffi:get_time_ms(),
    case Now > Deadline of
        true ->
            {error, chrome_agent_timeout};

        false ->
            case gleam@set:is_empty(Active) andalso ((Now - Last_activity) >= Quiet_ms) of
                true ->
                    {ok, nil};

                false ->
                    Selector = begin
                        _pipe = gleam_erlang_ffi:new_selector(),
                        _pipe@1 = gleam@erlang@process:select_map(
                            _pipe,
                            erlang:element(3, Listener),
                            fun(Field@0) -> {request_started, Field@0} end
                        ),
                        _pipe@2 = gleam@erlang@process:select_map(
                            _pipe@1,
                            erlang:element(4, Listener),
                            fun(Field@0) -> {request_finished, Field@0} end
                        ),
                        gleam@erlang@process:select_map(
                            _pipe@2,
                            erlang:element(5, Listener),
                            fun(Field@0) -> {request_failed, Field@0} end
                        )
                    end,
                    case gleam_erlang_ffi:select(Selector, 10) of
                        {ok, Event} ->
                            {New_active, New_last_activity} = handle_event(
                                Event,
                                Active,
                                Now
                            ),
                            idle_loop(
                                Listener,
                                New_active,
                                New_last_activity,
                                Quiet_ms,
                                Deadline
                            );

                        {error, nil} ->
                            idle_loop(
                                Listener,
                                Active,
                                Last_activity,
                                Quiet_ms,
                                Deadline
                            )
                    end
            end
    end.

-file("src\\chrobot_extra\\network_idle.gleam", 63).
?DOC(
    " Wait until no network requests are in-flight for `quiet_ms` milliseconds.\n"
    " Returns `Error(ChromeAgentTimeout)` if the total `time_out` is exceeded.\n"
).
-spec wait_for_idle(idle_listener(), integer(), integer()) -> {ok, nil} |
    {error, chrobot_extra@chrome:request_error()}.
wait_for_idle(Listener, Quiet_ms, Timeout) ->
    Deadline = chrobot_extra_ffi:get_time_ms() + Timeout,
    Last_activity = chrobot_extra_ffi:get_time_ms(),
    idle_loop(Listener, gleam@set:new(), Last_activity, Quiet_ms, Deadline).
