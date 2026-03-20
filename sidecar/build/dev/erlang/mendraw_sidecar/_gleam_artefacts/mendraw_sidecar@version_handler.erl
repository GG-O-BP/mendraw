-module(mendraw_sidecar@version_handler).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\mendraw_sidecar\\version_handler.gleam").
-export([handle_all/1, handle_single/1]).

-file("src\\mendraw_sidecar\\version_handler.gleam", 42).
-spec parse_all_request(binary()) -> {ok, {binary(), list(integer())}} |
    {error, binary()}.
parse_all_request(Body) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            <<"session_path"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Session_path) ->
                gleam@dynamic@decode:field(
                    <<"content_ids"/utf8>>,
                    gleam@dynamic@decode:list(
                        {decoder, fun gleam@dynamic@decode:decode_int/1}
                    ),
                    fun(Content_ids) ->
                        gleam@dynamic@decode:success(
                            {Session_path, Content_ids}
                        )
                    end
                )
            end
        )
    end,
    case gleam@json:parse(Body, Decoder) of
        {ok, Result} ->
            {ok, Result};

        {error, _} ->
            {error, <<"session_path, content_ids 필드가 필요합니다"/utf8>>}
    end.

-file("src\\mendraw_sidecar\\version_handler.gleam", 230).
-spec deduplicate_versions(list(mendraw_sidecar@xas_parser:xas_version())) -> list(mendraw_sidecar@xas_parser:xas_version()).
deduplicate_versions(Versions) ->
    erlang:element(
        1,
        gleam@list:fold(
            Versions,
            {[], maps:new()},
            fun(Acc, V) ->
                {Result_list, Seen} = Acc,
                case gleam@dict:has_key(Seen, erlang:element(2, V)) of
                    true ->
                        Acc;

                    false ->
                        {lists:append(Result_list, [V]),
                            gleam@dict:insert(Seen, erlang:element(2, V), true)}
                end
            end
        )
    ).

-file("src\\mendraw_sidecar\\version_handler.gleam", 276).
-spec find_and_click_releases(
    chrobot_extra:page(),
    list(chrobot_extra@protocol@runtime:remote_object_id())
) -> {ok, nil} | {error, chrobot_extra@chrome:request_error()}.
find_and_click_releases(Page, Tabs) ->
    case Tabs of
        [] ->
            {error, not_found_error};

        [Tab | Rest] ->
            case chrobot_extra:get_text(Page, Tab) of
                {ok, Text} ->
                    case gleam_stdlib:contains_string(Text, <<"Releases"/utf8>>) of
                        true ->
                            _pipe = chrobot_extra:click(Page, Tab),
                            gleam@result:map(_pipe, fun(_) -> nil end);

                        false ->
                            find_and_click_releases(Page, Rest)
                    end;

                {error, _} ->
                    find_and_click_releases(Page, Rest)
            end
    end.

-file("src\\mendraw_sidecar\\version_handler.gleam", 266).
-spec try_click_tab_by_text(chrobot_extra:page()) -> {ok, nil} |
    {error, chrobot_extra@chrome:request_error()}.
try_click_tab_by_text(Page) ->
    gleam@result:'try'(
        chrobot_extra:select_all(Page, <<"a[role=\"tab\"]"/utf8>>),
        fun(Tabs) -> find_and_click_releases(Page, Tabs) end
    ).

-file("src\\mendraw_sidecar\\version_handler.gleam", 244).
-spec try_click_releases_tab(chrobot_extra:page()) -> nil.
try_click_releases_tab(Page) ->
    case chrobot_extra:click_selector(Page, <<"a.mx-name-tabPage10"/utf8>>) of
        {ok, _} ->
            nil;

        {error, _} ->
            case try_click_tab_by_text(Page) of
                {ok, _} ->
                    nil;

                {error, _} ->
                    _ = chrobot_extra:eval(
                        Page,
                        <<"(() => { const tabs = document.querySelectorAll('a[role=\"tab\"]'); for (const t of tabs) { if (t.textContent.includes('Releases')) { t.click(); return true; } } return false; })()"/utf8>>
                    ),
                    nil
            end
    end.

-file("src\\mendraw_sidecar\\version_handler.gleam", 137).
-spec collect_versions_impl(
    gleam@erlang@process:subject(chrobot_extra@chrome:message()),
    binary()
) -> {ok, list(mendraw_sidecar@xas_parser:xas_version())} | {error, binary()}.
collect_versions_impl(Browser, Url) ->
    gleam@result:'try'(
        begin
            _pipe = chrobot_extra:open(Browser, <<"about:blank"/utf8>>, 30000),
            gleam@result:map_error(_pipe, fun(_) -> <<"페이지 생성 실패"/utf8>> end)
        end,
        fun(Page) ->
            Result = begin
                gleam@result:'try'(
                    begin
                        _pipe@1 = chrobot_extra@network_listener:start(Page),
                        gleam@result:map_error(
                            _pipe@1,
                            fun(_) -> <<"network listener 시작 실패"/utf8>> end
                        )
                    end,
                    fun(Response_listener) ->
                        Inner_result = begin
                            gleam@result:'try'(
                                begin
                                    _pipe@2 = chrobot_extra@network_idle:start(
                                        Page
                                    ),
                                    gleam@result:map_error(
                                        _pipe@2,
                                        fun(_) ->
                                            <<"network idle listener 시작 실패"/utf8>>
                                        end
                                    )
                                end,
                                fun(Idle_listener) ->
                                    Caller = chrobot_extra:page_caller(Page),
                                    gleam@result:'try'(
                                        begin
                                            _pipe@3 = chrobot_extra@protocol@page:navigate(
                                                Caller,
                                                Url,
                                                none,
                                                none,
                                                none
                                            ),
                                            gleam@result:map_error(
                                                _pipe@3,
                                                fun(_) ->
                                                    <<"네비게이션 실패"/utf8>>
                                                end
                                            )
                                        end,
                                        fun(_) ->
                                            _ = chrobot_extra@network_idle:wait_for_idle(
                                                Idle_listener,
                                                500,
                                                30000
                                            ),
                                            chrobot_extra@network_idle:stop(
                                                Idle_listener
                                            ),
                                            try_click_releases_tab(Page),
                                            case chrobot_extra@network_idle:start(
                                                Page
                                            ) of
                                                {ok, Idle2} ->
                                                    _ = chrobot_extra@network_idle:wait_for_idle(
                                                        Idle2,
                                                        500,
                                                        30000
                                                    ),
                                                    chrobot_extra@network_idle:stop(
                                                        Idle2
                                                    );

                                                {error, _} ->
                                                    nil
                                            end,
                                            gleam_erlang_ffi:sleep(3000),
                                            Xas_responses = begin
                                                _pipe@4 = chrobot_extra@network_listener:collect_responses(
                                                    Response_listener,
                                                    fun(Event) ->
                                                        gleam_stdlib:contains_string(
                                                            erlang:element(
                                                                2,
                                                                erlang:element(
                                                                    3,
                                                                    Event
                                                                )
                                                            ),
                                                            <<"/xas/"/utf8>>
                                                        )
                                                    end
                                                ),
                                                gleam@result:unwrap(_pipe@4, [])
                                            end,
                                            Versions = gleam@list:flat_map(
                                                Xas_responses,
                                                fun(Resp) ->
                                                    mendraw_sidecar@xas_parser:parse_xas_body(
                                                        erlang:element(3, Resp)
                                                    )
                                                end
                                            ),
                                            Unique = deduplicate_versions(
                                                Versions
                                            ),
                                            {ok, Unique}
                                        end
                                    )
                                end
                            )
                        end,
                        chrobot_extra@network_listener:stop(Response_listener),
                        Inner_result
                    end
                )
            end,
            _ = chrobot_extra:close(Page),
            Result
        end
    ).

-file("src\\mendraw_sidecar\\version_handler.gleam", 115).
-spec collect_versions_for_id(
    gleam@erlang@process:subject(chrobot_extra@chrome:message()),
    integer()
) -> list(mendraw_sidecar@xas_parser:xas_version()).
collect_versions_for_id(Browser, Content_id) ->
    Url = <<"https://marketplace.mendix.com/link/component/"/utf8,
        (erlang:integer_to_binary(Content_id))/binary>>,
    case collect_versions_impl(Browser, Url) of
        {ok, Versions} ->
            Versions;

        {error, Msg} ->
            gleam_stdlib:println(
                <<<<<<"  [sidecar] 오류 (id="/utf8,
                            (erlang:integer_to_binary(Content_id))/binary>>/binary,
                        "): "/utf8>>/binary,
                    Msg/binary>>
            ),
            []
    end.

-file("src\\mendraw_sidecar\\version_handler.gleam", 72).
-spec get_all_versions(binary(), list(integer())) -> {ok,
        gleam@dict:dict(integer(), list(mendraw_sidecar@xas_parser:xas_version()))} |
    {error, binary()}.
get_all_versions(Session_path, Content_ids) ->
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
                                        Results = gleam@list:fold(
                                            Content_ids,
                                            maps:new(),
                                            fun(Acc, Content_id) ->
                                                Versions = collect_versions_for_id(
                                                    Browser,
                                                    Content_id
                                                ),
                                                gleam@dict:insert(
                                                    Acc,
                                                    Content_id,
                                                    Versions
                                                )
                                            end
                                        ),
                                        {ok, Results}
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

-file("src\\mendraw_sidecar\\version_handler.gleam", 54).
-spec do_get_all_versions(binary(), list(integer())) -> gleam@http@response:response(mist:response_data()).
do_get_all_versions(Session_path, Content_ids) ->
    case get_all_versions(Session_path, Content_ids) of
        {ok, Results} ->
            Entries = begin
                _pipe = maps:to_list(Results),
                gleam@list:map(
                    _pipe,
                    fun(Entry) ->
                        {Id, Versions} = Entry,
                        {erlang:integer_to_binary(Id),
                            gleam@json:array(
                                Versions,
                                fun mendraw_sidecar@xas_parser:encode_version/1
                            )}
                    end
                )
            end,
            mendraw_sidecar@http_utils:json_response(
                200,
                gleam@json:object(Entries)
            );

        {error, Msg} ->
            mendraw_sidecar@http_utils:error_response(Msg)
    end.

-file("src\\mendraw_sidecar\\version_handler.gleam", 29).
-spec handle_all(gleam@http@request:request(mist@internal@http:connection())) -> gleam@http@response:response(mist:response_data()).
handle_all(Req) ->
    case mendraw_sidecar@http_utils:read_body(Req) of
        {error, Resp} ->
            Resp;

        {ok, Body} ->
            case parse_all_request(Body) of
                {error, Msg} ->
                    mendraw_sidecar@http_utils:error_response(Msg);

                {ok, {Session_path, Content_ids}} ->
                    do_get_all_versions(Session_path, Content_ids)
            end
    end.

-file("src\\mendraw_sidecar\\version_handler.gleam", 313).
-spec parse_single_request(binary()) -> {ok, {binary(), integer(), binary()}} |
    {error, binary()}.
parse_single_request(Body) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            <<"session_path"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Session_path) ->
                gleam@dynamic@decode:field(
                    <<"content_id"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_int/1},
                    fun(Content_id) ->
                        gleam@dynamic@decode:field(
                            <<"target_version"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Target_version) ->
                                gleam@dynamic@decode:success(
                                    {Session_path, Content_id, Target_version}
                                )
                            end
                        )
                    end
                )
            end
        )
    end,
    case gleam@json:parse(Body, Decoder) of
        {ok, Result} ->
            {ok, Result};

        {error, _} ->
            {error,
                <<"session_path, content_id, target_version 필드가 필요합니다"/utf8>>}
    end.

-file("src\\mendraw_sidecar\\version_handler.gleam", 329).
-spec do_get_single_version(binary(), integer(), binary()) -> gleam@http@response:response(mist:response_data()).
do_get_single_version(Session_path, Content_id, Target_version) ->
    case begin
        _pipe = get_all_versions(Session_path, [Content_id]),
        gleam@result:map(
            _pipe,
            fun(Results) ->
                Versions = gleam@result:unwrap(
                    gleam_stdlib:map_get(Results, Content_id),
                    []
                ),
                gleam@list:find(
                    Versions,
                    fun(V) -> erlang:element(5, V) =:= Target_version end
                )
            end
        )
    end of
        {ok, {ok, Version}} ->
            mendraw_sidecar@http_utils:json_response(
                200,
                gleam@json:object(
                    [{<<"s3_id"/utf8>>,
                            gleam@json:string(erlang:element(2, Version))}]
                )
            );

        _ ->
            mendraw_sidecar@http_utils:json_response(
                200,
                gleam@json:object([{<<"s3_id"/utf8>>, gleam@json:null()}])
            )
    end.

-file("src\\mendraw_sidecar\\version_handler.gleam", 300).
-spec handle_single(gleam@http@request:request(mist@internal@http:connection())) -> gleam@http@response:response(mist:response_data()).
handle_single(Req) ->
    case mendraw_sidecar@http_utils:read_body(Req) of
        {error, Resp} ->
            Resp;

        {ok, Body} ->
            case parse_single_request(Body) of
                {error, Msg} ->
                    mendraw_sidecar@http_utils:error_response(Msg);

                {ok, {Session_path, Content_id, Target_version}} ->
                    do_get_single_version(
                        Session_path,
                        Content_id,
                        Target_version
                    )
            end
    end.
