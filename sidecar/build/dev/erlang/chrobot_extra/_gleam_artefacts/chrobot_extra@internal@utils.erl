-module(chrobot_extra@internal@utils).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\internal\\utils.gleam").
-export([add_optional/3, err/1, warn/1, alert_encode_dynamic/1, hint/1, info/1, start_progress/1, set_progress/2, stop_progress/1, show_cmd/1, try_call_with_subject/4, try_call/3, find_map_remove/2, find_remove/2, get_time_ms/0]).
-export_type([call_error/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-type call_error() :: call_timeout |
    {callee_down, gleam@erlang@process:exit_reason()}.

-file("src\\chrobot_extra\\internal\\utils.gleam", 18).
?DOC(false).
-spec term_supports_color() -> boolean().
term_supports_color() ->
    case envoy_ffi:get(<<"TERM"/utf8>>) of
        {ok, <<"dumb"/utf8>>} ->
            false;

        _ ->
            true
    end.

-file("src\\chrobot_extra\\internal\\utils.gleam", 25).
?DOC(false).
-spec add_optional(
    list({binary(), gleam@json:json()}),
    gleam@option:option(HUV),
    fun((HUV) -> {binary(), gleam@json:json()})
) -> list({binary(), gleam@json:json()}).
add_optional(Prop_encoders, Value, Callback) ->
    case Value of
        {some, A} ->
            [Callback(A) | Prop_encoders];

        none ->
            Prop_encoders
    end.

-file("src\\chrobot_extra\\internal\\utils.gleam", 46).
?DOC(false).
-spec align(binary()) -> binary().
align(Content) ->
    gleam@string:replace(Content, <<"\n"/utf8>>, <<"\n            "/utf8>>).

-file("src\\chrobot_extra\\internal\\utils.gleam", 50).
?DOC(false).
-spec err(binary()) -> nil.
err(Content) ->
    case term_supports_color() of
        true ->
            _pipe@4 = (<<<<(begin
                        _pipe = <<"[-_-] ERR! "/utf8>>,
                        _pipe@1 = gleam_community@ansi:bg_red(_pipe),
                        _pipe@2 = gleam_community@ansi:white(_pipe@1),
                        gleam_community@ansi:bold(_pipe@2)
                    end)/binary,
                    " "/utf8>>/binary,
                (begin
                    _pipe@3 = align(Content),
                    gleam_community@ansi:red(_pipe@3)
                end)/binary>>),
            gleam_stdlib:println(_pipe@4);

        false ->
            gleam_stdlib:println(<<"[-_-] ERR! "/utf8, Content/binary>>)
    end.

-file("src\\chrobot_extra\\internal\\utils.gleam", 70).
?DOC(false).
-spec warn(binary()) -> nil.
warn(Content) ->
    case term_supports_color() of
        true ->
            _pipe@4 = (<<<<(begin
                        _pipe = <<"[O_O] HEY! "/utf8>>,
                        _pipe@1 = gleam_community@ansi:bg_yellow(_pipe),
                        _pipe@2 = gleam_community@ansi:black(_pipe@1),
                        gleam_community@ansi:bold(_pipe@2)
                    end)/binary,
                    " "/utf8>>/binary,
                (begin
                    _pipe@3 = align(Content),
                    gleam_community@ansi:yellow(_pipe@3)
                end)/binary>>),
            gleam_stdlib:println(_pipe@4);

        false ->
            gleam_stdlib:println(<<"[O_O] HEY! "/utf8, Content/binary>>)
    end.

-file("src\\chrobot_extra\\internal\\utils.gleam", 36).
?DOC(false).
-spec alert_encode_dynamic(any()) -> gleam@json:json().
alert_encode_dynamic(Input_value) ->
    warn(
        <<"You passed a dymamic value to a protocol encoder!
Dynamic values cannot be encoded, the value will be set to null instead.
This is unlikely to be intentional, you should fix that part of your code."/utf8>>
    ),
    gleam_stdlib:println(
        <<"The value was: "/utf8, (gleam@string:inspect(Input_value))/binary>>
    ),
    gleam@json:null().

-file("src\\chrobot_extra\\internal\\utils.gleam", 90).
?DOC(false).
-spec hint(binary()) -> nil.
hint(Content) ->
    case term_supports_color() of
        true ->
            _pipe@4 = (<<<<(begin
                        _pipe = <<"[>‿0] HINT "/utf8>>,
                        _pipe@1 = gleam_community@ansi:bg_cyan(_pipe),
                        _pipe@2 = gleam_community@ansi:black(_pipe@1),
                        gleam_community@ansi:bold(_pipe@2)
                    end)/binary,
                    " "/utf8>>/binary,
                (begin
                    _pipe@3 = align(Content),
                    gleam_community@ansi:cyan(_pipe@3)
                end)/binary>>),
            gleam_stdlib:println(_pipe@4);

        false ->
            gleam_stdlib:println(<<"[>‿0] HINT "/utf8, Content/binary>>)
    end.

-file("src\\chrobot_extra\\internal\\utils.gleam", 110).
?DOC(false).
-spec info(binary()) -> nil.
info(Content) ->
    case term_supports_color() of
        true ->
            _pipe@4 = (<<<<(begin
                        _pipe = <<"[0‿0] INFO "/utf8>>,
                        _pipe@1 = gleam_community@ansi:bg_white(_pipe),
                        _pipe@2 = gleam_community@ansi:black(_pipe@1),
                        gleam_community@ansi:bold(_pipe@2)
                    end)/binary,
                    " "/utf8>>/binary,
                (begin
                    _pipe@3 = align(Content),
                    gleam_community@ansi:white(_pipe@3)
                end)/binary>>),
            gleam_stdlib:println(_pipe@4);

        false ->
            gleam_stdlib:println(<<"[0‿0] INFO "/utf8, Content/binary>>)
    end.

-file("src\\chrobot_extra\\internal\\utils.gleam", 130).
?DOC(false).
-spec start_progress(binary()) -> gleam@option:option(spinner:spinner()).
start_progress(Text) ->
    case term_supports_color() of
        true ->
            Spinner = begin
                _pipe = spinner:new(Text),
                _pipe@1 = spinner:with_colour(
                    _pipe,
                    fun gleam_community@ansi:blue/1
                ),
                spinner:start(_pipe@1)
            end,
            {some, Spinner};

        false ->
            gleam_stdlib:println(<<"Progress: "/utf8, Text/binary>>),
            none
    end.

-file("src\\chrobot_extra\\internal\\utils.gleam", 146).
?DOC(false).
-spec set_progress(gleam@option:option(spinner:spinner()), binary()) -> nil.
set_progress(Spinner, Text) ->
    case Spinner of
        {some, Spinner@1} ->
            spinner:set_text(Spinner@1, Text);

        none ->
            gleam_stdlib:println(<<"Progress: "/utf8, Text/binary>>),
            nil
    end.

-file("src\\chrobot_extra\\internal\\utils.gleam", 156).
?DOC(false).
-spec stop_progress(gleam@option:option(spinner:spinner())) -> nil.
stop_progress(Spinner) ->
    case Spinner of
        {some, Spinner@1} ->
            spinner:stop(Spinner@1);

        none ->
            nil
    end.

-file("src\\chrobot_extra\\internal\\utils.gleam", 163).
?DOC(false).
-spec show_cmd(binary()) -> nil.
show_cmd(Content) ->
    case term_supports_color() of
        true ->
            _pipe = (<<<<<<<<"\n "/utf8,
                            (gleam_community@ansi:dim(<<"$"/utf8>>))/binary>>/binary,
                        " "/utf8>>/binary,
                    (gleam_community@ansi:bold(Content))/binary>>/binary,
                "\n"/utf8>>),
            gleam_stdlib:println(_pipe);

        false ->
            gleam_stdlib:println(
                <<<<"\n $ "/utf8, Content/binary>>/binary, "\n"/utf8>>
            )
    end.

-file("src\\chrobot_extra\\internal\\utils.gleam", 175).
?DOC(false).
-spec try_call_with_subject(
    gleam@erlang@process:subject(HVJ),
    fun((gleam@erlang@process:subject(HVL)) -> HVJ),
    gleam@erlang@process:subject(HVL),
    integer()
) -> {ok, HVL} | {error, call_error()}.
try_call_with_subject(Subject, Make_request, Reply_subject, Timeout) ->
    case gleam@erlang@process:subject_owner(Subject) of
        {error, nil} ->
            {error, {callee_down, normal}};

        {ok, Owner_pid} ->
            Monitor = gleam@erlang@process:monitor(Owner_pid),
            gleam@erlang@process:send(Subject, Make_request(Reply_subject)),
            Result = begin
                _pipe = gleam_erlang_ffi:new_selector(),
                _pipe@1 = gleam@erlang@process:select_map(
                    _pipe,
                    Reply_subject,
                    fun(Field@0) -> {ok, Field@0} end
                ),
                _pipe@2 = gleam@erlang@process:select_specific_monitor(
                    _pipe@1,
                    Monitor,
                    fun(Down) -> case Down of
                            {process_down, _, _, Reason} ->
                                {error, {callee_down, Reason}};

                            {port_down, _, _, Reason@1} ->
                                {error, {callee_down, Reason@1}}
                        end end
                ),
                gleam_erlang_ffi:select(_pipe@2, Timeout)
            end,
            gleam@erlang@process:demonitor_process(Monitor),
            case Result of
                {error, nil} ->
                    {error, call_timeout};

                {ok, Res} ->
                    Res
            end
    end.

-file("src\\chrobot_extra\\internal\\utils.gleam", 217).
?DOC(false).
-spec try_call(
    gleam@erlang@process:subject(HVQ),
    fun((gleam@erlang@process:subject(HVS)) -> HVQ),
    integer()
) -> {ok, HVS} | {error, call_error()}.
try_call(Subject, Make_request, Timeout) ->
    Reply_subject = gleam@erlang@process:new_subject(),
    try_call_with_subject(Subject, Make_request, Reply_subject, Timeout).

-file("src\\chrobot_extra\\internal\\utils.gleam", 256).
?DOC(false).
-spec find_map_remove_loop(
    list(HWF),
    fun((HWF) -> {ok, HWH} | {error, any()}),
    list(HWF)
) -> {ok, {HWH, list(HWF)}} | {error, nil}.
find_map_remove_loop(List, Mapper, Checked) ->
    case List of
        [] ->
            {error, nil};

        [X | Rest] ->
            case Mapper(X) of
                {ok, Y} ->
                    {ok, {Y, lists:append(lists:reverse(Checked), Rest)}};

                {error, _} ->
                    find_map_remove_loop(Rest, Mapper, [X | Checked])
            end
    end.

-file("src\\chrobot_extra\\internal\\utils.gleam", 249).
?DOC(false).
-spec find_map_remove(list(HVW), fun((HVW) -> {ok, HVY} | {error, any()})) -> {ok,
        {HVY, list(HVW)}} |
    {error, nil}.
find_map_remove(Haystack, Is_desired) ->
    find_map_remove_loop(Haystack, Is_desired, []).

-file("src\\chrobot_extra\\internal\\utils.gleam", 301).
?DOC(false).
-spec find_remove_loop(list(HZR), fun((HZR) -> boolean()), list(HZR)) -> {ok,
        {HZR, list(HZR)}} |
    {error, nil}.
find_remove_loop(Haystack, Predicate, Checked) ->
    case Haystack of
        [] ->
            {error, nil};

        [X | Rest] ->
            case Predicate(X) of
                true ->
                    {ok, {X, lists:append(lists:reverse(Checked), Rest)}};

                false ->
                    find_remove_loop(Rest, Predicate, [X | Checked])
            end
    end.

-file("src\\chrobot_extra\\internal\\utils.gleam", 294).
?DOC(false).
-spec find_remove(list(HWP), fun((HWP) -> boolean())) -> {ok, {HWP, list(HWP)}} |
    {error, nil}.
find_remove(List, Is_desired) ->
    find_remove_loop(List, Is_desired, []).

-file("src\\chrobot_extra\\internal\\utils.gleam", 313).
?DOC(false).
-spec get_time_ms() -> integer().
get_time_ms() ->
    chrobot_extra_ffi:get_time_ms().
