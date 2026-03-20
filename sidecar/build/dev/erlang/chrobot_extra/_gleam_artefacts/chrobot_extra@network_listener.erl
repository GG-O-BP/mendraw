-module(chrobot_extra@network_listener).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\network_listener.gleam").
-export([start/1, stop/1, defer_stop/2, drain_events/1, collect_responses/2]).
-export_type([response_received_event/0, response_with_body/0, network_listener/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " Network response event listener for chrobot_extra.\n"
    " Provides a high-level API to subscribe to and collect network responses.\n"
).

-type response_received_event() :: {response_received_event,
        chrobot_extra@protocol@network:request_id(),
        chrobot_extra@protocol@network:response()}.

-type response_with_body() :: {response_with_body,
        response_received_event(),
        binary()}.

-opaque network_listener() :: {network_listener,
        gleam@erlang@process:subject(chrobot_extra@chrome:message()),
        chrobot_extra:page(),
        gleam@erlang@process:subject(gleam@dynamic:dynamic_())}.

-file("src\\chrobot_extra\\network_listener.gleam", 37).
?DOC(" Network 도메인 활성화 + responseReceived 이벤트 리스너 등록\n").
-spec start(chrobot_extra:page()) -> {ok, network_listener()} |
    {error, chrobot_extra@chrome:request_error()}.
start(Page) ->
    gleam@result:'try'(
        chrobot_extra@protocol@network:enable(
            chrobot_extra:page_caller(Page),
            none
        ),
        fun(_) ->
            Listener_subject = chrobot_extra@chrome:add_listener(
                erlang:element(2, Page),
                <<"Network.responseReceived"/utf8>>
            ),
            {ok,
                {network_listener,
                    erlang:element(2, Page),
                    Page,
                    Listener_subject}}
        end
    ).

-file("src\\chrobot_extra\\network_listener.gleam", 52).
?DOC(" 리스너 해제\n").
-spec stop(network_listener()) -> nil.
stop(Listener) ->
    chrobot_extra@chrome:remove_listener(
        erlang:element(2, Listener),
        erlang:element(4, Listener)
    ).

-file("src\\chrobot_extra\\network_listener.gleam", 57).
?DOC(" use 표현식용 defer 패턴\n").
-spec defer_stop(network_listener(), fun(() -> TDI)) -> TDI.
defer_stop(Listener, Body) ->
    Result = Body(),
    stop(Listener),
    Result.

-file("src\\chrobot_extra\\network_listener.gleam", 97).
-spec collect_bodies(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    list(response_received_event()),
    list(response_with_body())
) -> {ok, list(response_with_body())} |
    {error, chrobot_extra@chrome:request_error()}.
collect_bodies(Caller, Events, Acc) ->
    case Events of
        [] ->
            {ok, lists:reverse(Acc)};

        [Event | Rest] ->
            gleam@result:'try'(
                chrobot_extra@protocol@network:get_response_body(
                    Caller,
                    erlang:element(2, Event)
                ),
                fun(Resp) ->
                    With_body = {response_with_body,
                        Event,
                        erlang:element(2, Resp)},
                    collect_bodies(Caller, Rest, [With_body | Acc])
                end
            )
    end.

-file("src\\chrobot_extra\\network_listener.gleam", 115).
-spec decode_response_received_event() -> gleam@dynamic@decode:decoder(response_received_event()).
decode_response_received_event() ->
    gleam@dynamic@decode:field(
        <<"requestId"/utf8>>,
        chrobot_extra@protocol@network:decode__request_id(),
        fun(Request_id) ->
            gleam@dynamic@decode:field(
                <<"response"/utf8>>,
                chrobot_extra@protocol@network:decode__response(),
                fun(Response) ->
                    gleam@dynamic@decode:success(
                        {response_received_event, Request_id, Response}
                    )
                end
            )
        end
    ).

-file("src\\chrobot_extra\\network_listener.gleam", 71).
-spec drain_loop(
    gleam@erlang@process:selector(gleam@dynamic:dynamic_()),
    list(response_received_event())
) -> list(response_received_event()).
drain_loop(Selector, Acc) ->
    case gleam_erlang_ffi:select(Selector, 0) of
        {ok, Dyn} ->
            case gleam@dynamic@decode:run(Dyn, decode_response_received_event()) of
                {ok, Event} ->
                    drain_loop(Selector, [Event | Acc]);

                {error, _} ->
                    drain_loop(Selector, Acc)
            end;

        {error, nil} ->
            lists:reverse(Acc)
    end.

-file("src\\chrobot_extra\\network_listener.gleam", 64).
?DOC(" listener_subject에서 현재까지 도착한 이벤트를 모두 꺼내서 디코딩\n").
-spec drain_events(network_listener()) -> list(response_received_event()).
drain_events(Listener) ->
    Selector = begin
        _pipe = gleam_erlang_ffi:new_selector(),
        gleam@erlang@process:select(_pipe, erlang:element(4, Listener))
    end,
    drain_loop(Selector, []).

-file("src\\chrobot_extra\\network_listener.gleam", 87).
?DOC(" drain_events + URL 필터 + get_response_body로 본문까지 수집\n").
-spec collect_responses(
    network_listener(),
    fun((response_received_event()) -> boolean())
) -> {ok, list(response_with_body())} |
    {error, chrobot_extra@chrome:request_error()}.
collect_responses(Listener, Filter) ->
    Events = drain_events(Listener),
    Filtered = gleam@list:filter(Events, Filter),
    Caller = chrobot_extra:page_caller(erlang:element(3, Listener)),
    collect_bodies(Caller, Filtered, []).
