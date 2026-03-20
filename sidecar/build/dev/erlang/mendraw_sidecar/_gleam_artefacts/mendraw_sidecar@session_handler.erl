-module(mendraw_sidecar@session_handler).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\mendraw_sidecar\\session_handler.gleam").
-export([handle/1]).

-file("src\\mendraw_sidecar\\session_handler.gleam", 31).
-spec parse_request(binary()) -> {ok, binary()} | {error, binary()}.
parse_request(Body) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            <<"session_path"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Session_path) -> gleam@dynamic@decode:success(Session_path) end
        )
    end,
    case gleam@json:parse(Body, Decoder) of
        {ok, Path} ->
            {ok, Path};

        {error, _} ->
            {error, <<"session_path 필드가 필요합니다"/utf8>>}
    end.

-file("src\\mendraw_sidecar\\session_handler.gleam", 63).
-spec validate_existing_session(binary()) -> {ok, boolean()} | {error, binary()}.
validate_existing_session(Session_path) ->
    gleam@result:'try'(
        begin
            _pipe = chrobot_extra@session:load_from_file(Session_path),
            gleam@result:map_error(_pipe, fun(_) -> <<"세션 파일 로드 실패"/utf8>> end)
        end,
        fun(State) ->
            gleam@result:'try'(
                begin
                    _pipe@1 = chrobot_extra:launch(),
                    gleam@result:map_error(
                        _pipe@1,
                        fun(_) -> <<"브라우저 시작 실패"/utf8>> end
                    )
                end,
                fun(Browser) ->
                    Result = begin
                        gleam@result:'try'(
                            begin
                                _pipe@2 = chrobot_extra:open(
                                    Browser,
                                    <<"https://marketplace.mendix.com/"/utf8>>,
                                    30000
                                ),
                                gleam@result:map_error(
                                    _pipe@2,
                                    fun(_) -> <<"페이지 열기 실패"/utf8>> end
                                )
                            end,
                            fun(Page) ->
                                gleam@result:'try'(
                                    begin
                                        _pipe@3 = chrobot_extra@session:restore(
                                            Page,
                                            State
                                        ),
                                        gleam@result:map_error(
                                            _pipe@3,
                                            fun(_) -> <<"세션 복원 실패"/utf8>> end
                                        )
                                    end,
                                    fun(_) ->
                                        gleam@result:'try'(
                                            begin
                                                _pipe@4 = chrobot_extra@browser_utils:wait_for_url(
                                                    chrobot_extra:with_timeout(
                                                        Page,
                                                        10000
                                                    ),
                                                    fun(Url) ->
                                                        not gleam_stdlib:contains_string(
                                                            Url,
                                                            <<"login.mendix"/utf8>>
                                                        )
                                                    end,
                                                    10000
                                                ),
                                                gleam@result:map_error(
                                                    _pipe@4,
                                                    fun(_) ->
                                                        <<"URL 확인 실패"/utf8>>
                                                    end
                                                )
                                            end,
                                            fun(Url@1) ->
                                                Valid = not gleam_stdlib:contains_string(
                                                    Url@1,
                                                    <<"login.mendix"/utf8>>
                                                ),
                                                {ok, Valid}
                                            end
                                        )
                                    end
                                )
                            end
                        )
                    end,
                    _ = chrobot_extra:quit(Browser),
                    Result
                end
            )
        end
    ).

-file("src\\mendraw_sidecar\\session_handler.gleam", 118).
-spec interactive_login(binary()) -> {ok, nil} | {error, binary()}.
interactive_login(Session_path) ->
    gleam@result:'try'(
        begin
            _pipe = chrobot_extra:launch_window(),
            gleam@result:map_error(
                _pipe,
                fun(_) -> <<"visible 브라우저 시작 실패"/utf8>> end
            )
        end,
        fun(Browser) ->
            Result = begin
                gleam@result:'try'(
                    begin
                        _pipe@1 = chrobot_extra:open(
                            Browser,
                            <<"https://login.mendix.com/"/utf8>>,
                            30000
                        ),
                        gleam@result:map_error(
                            _pipe@1,
                            fun(_) -> <<"로그인 페이지 열기 실패"/utf8>> end
                        )
                    end,
                    fun(Page) ->
                        gleam@result:'try'(
                            begin
                                _pipe@2 = chrobot_extra@browser_utils:wait_for_url(
                                    chrobot_extra:with_timeout(Page, 300000),
                                    fun(Url) ->
                                        not gleam_stdlib:contains_string(
                                            Url,
                                            <<"login.mendix"/utf8>>
                                        )
                                    end,
                                    300000
                                ),
                                gleam@result:map_error(
                                    _pipe@2,
                                    fun(_) -> <<"로그인 타임아웃 (5분)"/utf8>> end
                                )
                            end,
                            fun(_) ->
                                gleam@result:'try'(
                                    begin
                                        _pipe@3 = chrobot_extra@session:save(
                                            Page
                                        ),
                                        gleam@result:map_error(
                                            _pipe@3,
                                            fun(_) -> <<"세션 저장 실패"/utf8>> end
                                        )
                                    end,
                                    fun(State) ->
                                        gleam@result:'try'(
                                            begin
                                                _pipe@4 = chrobot_extra@session:save_to_file(
                                                    State,
                                                    Session_path
                                                ),
                                                gleam@result:map_error(
                                                    _pipe@4,
                                                    fun(_) ->
                                                        <<"세션 파일 쓰기 실패"/utf8>>
                                                    end
                                                )
                                            end,
                                            fun(_) -> {ok, nil} end
                                        )
                                    end
                                )
                            end
                        )
                    end
                )
            end,
            _ = chrobot_extra:quit(Browser),
            Result
        end
    ).

-file("src\\mendraw_sidecar\\session_handler.gleam", 158).
-spec ok_response() -> gleam@http@response:response(mist:response_data()).
ok_response() ->
    mendraw_sidecar@http_utils:json_response(
        200,
        gleam@json:object([{<<"ok"/utf8>>, gleam@json:bool(true)}])
    ).

-file("src\\mendraw_sidecar\\session_handler.gleam", 104).
-spec do_interactive_login(binary()) -> gleam@http@response:response(mist:response_data()).
do_interactive_login(Session_path) ->
    case interactive_login(Session_path) of
        {ok, nil} ->
            ok_response();

        {error, Msg} ->
            mendraw_sidecar@http_utils:json_response(
                200,
                gleam@json:object(
                    [{<<"ok"/utf8>>, gleam@json:bool(false)},
                        {<<"error"/utf8>>, gleam@json:string(Msg)}]
                )
            )
    end.

-file("src\\mendraw_sidecar\\session_handler.gleam", 42).
-spec do_ensure_session(binary()) -> gleam@http@response:response(mist:response_data()).
do_ensure_session(Session_path) ->
    case simplifile_erl:is_file(Session_path) of
        {ok, true} ->
            case validate_existing_session(Session_path) of
                {ok, true} ->
                    ok_response();

                {ok, false} ->
                    do_interactive_login(Session_path);

                {error, _} ->
                    do_interactive_login(Session_path)
            end;

        _ ->
            do_interactive_login(Session_path)
    end.

-file("src\\mendraw_sidecar\\session_handler.gleam", 19).
-spec handle(gleam@http@request:request(mist@internal@http:connection())) -> gleam@http@response:response(mist:response_data()).
handle(Req) ->
    case mendraw_sidecar@http_utils:read_body(Req) of
        {error, Resp} ->
            Resp;

        {ok, Body} ->
            case parse_request(Body) of
                {error, Msg} ->
                    mendraw_sidecar@http_utils:error_response(Msg);

                {ok, Session_path} ->
                    do_ensure_session(Session_path)
            end
    end.
