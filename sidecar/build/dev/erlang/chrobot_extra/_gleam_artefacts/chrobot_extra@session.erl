-module(chrobot_extra@session).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\session.gleam").
-export([restore/2, save_to_file/2, save/1, load_from_file/1]).
-export_type([session_state/0, origin_storage/0, storage_entry/0, session_error/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " Session persistence module for saving and restoring browser session state.\n"
    " Provides functionality similar to Playwright's `storageState` API.\n"
    "\n"
    " Usage:\n"
    " ```gleam\n"
    " // Save session\n"
    " let assert Ok(state) = session.save(page)\n"
    " let assert Ok(Nil) = session.save_to_file(state, \"session.json\")\n"
    "\n"
    " // Restore session\n"
    " let assert Ok(state) = session.load_from_file(\"session.json\")\n"
    " let assert Ok(Nil) = session.restore(page, state)\n"
    " ```\n"
).

-type session_state() :: {session_state,
        list(chrobot_extra@protocol@network:cookie()),
        list(origin_storage())}.

-type origin_storage() :: {origin_storage,
        binary(),
        list(storage_entry()),
        list(storage_entry())}.

-type storage_entry() :: {storage_entry, binary(), binary()}.

-type session_error() :: {file_error, simplifile:file_error()} |
    json_error |
    {browser_error, chrobot_extra@chrome:request_error()}.

-file("src\\chrobot_extra\\session.gleam", 162).
-spec cookie_to_param(chrobot_extra@protocol@network:cookie()) -> chrobot_extra@protocol@network:cookie_param().
cookie_to_param(Cookie) ->
    {cookie_param,
        erlang:element(2, Cookie),
        erlang:element(3, Cookie),
        none,
        {some, erlang:element(4, Cookie)},
        {some, erlang:element(5, Cookie)},
        {some, erlang:element(9, Cookie)},
        {some, erlang:element(8, Cookie)},
        erlang:element(11, Cookie),
        case erlang:element(10, Cookie) of
            true ->
                none;

            false ->
                {some, {time_since_epoch, erlang:element(6, Cookie)}}
        end}.

-file("src\\chrobot_extra\\session.gleam", 179).
-spec build_storage_restore_js(binary(), list(storage_entry())) -> binary().
build_storage_restore_js(Storage_name, Entries) ->
    Set_statements = begin
        _pipe = gleam@list:map(
            Entries,
            fun(Entry) ->
                <<<<<<<<<<Storage_name/binary, ".setItem("/utf8>>/binary,
                                (gleam@json:to_string(
                                    gleam@json:string(erlang:element(2, Entry))
                                ))/binary>>/binary,
                            ", "/utf8>>/binary,
                        (gleam@json:to_string(
                            gleam@json:string(erlang:element(3, Entry))
                        ))/binary>>/binary,
                    ");"/utf8>>
            end
        ),
        gleam@list:fold(
            _pipe,
            <<""/utf8>>,
            fun(Acc, S) -> <<Acc/binary, S/binary>> end
        )
    end,
    <<<<Storage_name/binary, ".clear();"/utf8>>/binary, Set_statements/binary>>.

-file("src\\chrobot_extra\\session.gleam", 93).
?DOC(" Restore session state to a page (cookies + storage).\n").
-spec restore(chrobot_extra:page(), session_state()) -> {ok, nil} |
    {error, session_error()}.
restore(Page, State) ->
    Caller = chrobot_extra:page_caller(Page),
    Cookie_params = gleam@list:map(
        erlang:element(2, State),
        fun cookie_to_param/1
    ),
    _pipe@2 = case Cookie_params of
        [] ->
            {ok, nil};

        Params ->
            _pipe = chrobot_extra@protocol@network:set_cookies(Caller, Params),
            _pipe@1 = gleam@result:map(_pipe, fun(_) -> nil end),
            gleam@result:map_error(
                _pipe@1,
                fun(Field@0) -> {browser_error, Field@0} end
            )
    end,
    gleam@result:'try'(
        _pipe@2,
        fun(_) ->
            gleam@result:'try'(
                begin
                    _pipe@3 = chrobot_extra:eval_to_value(
                        Page,
                        <<"window.location.origin"/utf8>>
                    ),
                    _pipe@4 = gleam@result:'try'(
                        _pipe@3,
                        fun(Ro) ->
                            chrobot_extra:as_value(
                                {ok, Ro},
                                {decoder,
                                    fun gleam@dynamic@decode:decode_string/1}
                            )
                        end
                    ),
                    gleam@result:map_error(
                        _pipe@4,
                        fun(Field@0) -> {browser_error, Field@0} end
                    )
                end,
                fun(Origin_data) ->
                    Matching_origins = gleam@list:filter(
                        erlang:element(3, State),
                        fun(O) -> erlang:element(2, O) =:= Origin_data end
                    ),
                    case Matching_origins of
                        [] ->
                            {ok, nil};

                        [Origin | _] ->
                            Local_js = build_storage_restore_js(
                                <<"localStorage"/utf8>>,
                                erlang:element(3, Origin)
                            ),
                            Session_js = build_storage_restore_js(
                                <<"sessionStorage"/utf8>>,
                                erlang:element(4, Origin)
                            ),
                            gleam@result:'try'(
                                begin
                                    _pipe@5 = chrobot_extra:eval(Page, Local_js),
                                    _pipe@6 = gleam@result:map(
                                        _pipe@5,
                                        fun(_) -> nil end
                                    ),
                                    gleam@result:map_error(
                                        _pipe@6,
                                        fun(Field@0) -> {browser_error, Field@0} end
                                    )
                                end,
                                fun(_) ->
                                    _pipe@7 = chrobot_extra:eval(
                                        Page,
                                        Session_js
                                    ),
                                    _pipe@8 = gleam@result:map(
                                        _pipe@7,
                                        fun(_) -> nil end
                                    ),
                                    gleam@result:map_error(
                                        _pipe@8,
                                        fun(Field@0) -> {browser_error, Field@0} end
                                    )
                                end
                            )
                    end
                end
            )
        end
    ).

-file("src\\chrobot_extra\\session.gleam", 215).
-spec encode_storage_entry(storage_entry()) -> gleam@json:json().
encode_storage_entry(Entry) ->
    gleam@json:object(
        [{<<"name"/utf8>>, gleam@json:string(erlang:element(2, Entry))},
            {<<"value"/utf8>>, gleam@json:string(erlang:element(3, Entry))}]
    ).

-file("src\\chrobot_extra\\session.gleam", 204).
-spec encode_origin_storage(origin_storage()) -> gleam@json:json().
encode_origin_storage(Origin) ->
    gleam@json:object(
        [{<<"origin"/utf8>>, gleam@json:string(erlang:element(2, Origin))},
            {<<"localStorage"/utf8>>,
                gleam@json:array(
                    erlang:element(3, Origin),
                    fun encode_storage_entry/1
                )},
            {<<"sessionStorage"/utf8>>,
                gleam@json:array(
                    erlang:element(4, Origin),
                    fun encode_storage_entry/1
                )}]
    ).

-file("src\\chrobot_extra\\session.gleam", 197).
-spec encode_session_state(session_state()) -> gleam@json:json().
encode_session_state(State) ->
    gleam@json:object(
        [{<<"cookies"/utf8>>,
                gleam@json:array(
                    erlang:element(2, State),
                    fun chrobot_extra@protocol@network:encode__cookie/1
                )},
            {<<"origins"/utf8>>,
                gleam@json:array(
                    erlang:element(3, State),
                    fun encode_origin_storage/1
                )}]
    ).

-file("src\\chrobot_extra\\session.gleam", 141).
?DOC(" Save session state to a JSON file.\n").
-spec save_to_file(session_state(), binary()) -> {ok, nil} |
    {error, session_error()}.
save_to_file(State, Path) ->
    Json_string = begin
        _pipe = encode_session_state(State),
        gleam@json:to_string(_pipe)
    end,
    _pipe@1 = simplifile:write(Path, Json_string),
    gleam@result:map_error(_pipe@1, fun(Field@0) -> {file_error, Field@0} end).

-file("src\\chrobot_extra\\session.gleam", 248).
-spec decode_storage_entry() -> gleam@dynamic@decode:decoder(storage_entry()).
decode_storage_entry() ->
    gleam@dynamic@decode:field(
        <<"name"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_string/1},
        fun(Name) ->
            gleam@dynamic@decode:field(
                <<"value"/utf8>>,
                {decoder, fun gleam@dynamic@decode:decode_string/1},
                fun(Value) ->
                    gleam@dynamic@decode:success({storage_entry, Name, Value})
                end
            )
        end
    ).

-file("src\\chrobot_extra\\session.gleam", 231).
-spec decode_origin_storage() -> gleam@dynamic@decode:decoder(origin_storage()).
decode_origin_storage() ->
    gleam@dynamic@decode:field(
        <<"origin"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_string/1},
        fun(Origin) ->
            gleam@dynamic@decode:field(
                <<"localStorage"/utf8>>,
                gleam@dynamic@decode:list(decode_storage_entry()),
                fun(Local_storage) ->
                    gleam@dynamic@decode:field(
                        <<"sessionStorage"/utf8>>,
                        gleam@dynamic@decode:list(decode_storage_entry()),
                        fun(Session_storage) ->
                            gleam@dynamic@decode:success(
                                {origin_storage,
                                    Origin,
                                    Local_storage,
                                    Session_storage}
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src\\chrobot_extra\\session.gleam", 52).
?DOC(" Capture the current session state from a page (cookies + storage).\n").
-spec save(chrobot_extra:page()) -> {ok, session_state()} |
    {error, session_error()}.
save(Page) ->
    Caller = chrobot_extra:page_caller(Page),
    gleam@result:'try'(
        begin
            _pipe = chrobot_extra@protocol@network:get_cookies(Caller, none),
            gleam@result:map_error(
                _pipe,
                fun(Field@0) -> {browser_error, Field@0} end
            )
        end,
        fun(Cookies_response) ->
            gleam@result:'try'(
                begin
                    _pipe@1 = chrobot_extra:eval_to_value(
                        Page,
                        <<"JSON.stringify({
        origin: window.location.origin,
        localStorage: Object.entries(localStorage).map(([k,v]) => ({name:k, value:v})),
        sessionStorage: Object.entries(sessionStorage).map(([k,v]) => ({name:k, value:v}))
      })"/utf8>>
                    ),
                    _pipe@2 = gleam@result:'try'(
                        _pipe@1,
                        fun(Remote_object) ->
                            chrobot_extra:as_value(
                                {ok, Remote_object},
                                {decoder,
                                    fun gleam@dynamic@decode:decode_string/1}
                            )
                        end
                    ),
                    gleam@result:map_error(
                        _pipe@2,
                        fun(Field@0) -> {browser_error, Field@0} end
                    )
                end,
                fun(Storage_json) ->
                    gleam@result:'try'(
                        begin
                            _pipe@3 = gleam@json:parse(
                                Storage_json,
                                decode_origin_storage()
                            ),
                            gleam@result:replace_error(_pipe@3, json_error)
                        end,
                        fun(Origin_storage) ->
                            Origins = case erlang:element(2, Origin_storage) of
                                <<""/utf8>> ->
                                    [];

                                _ ->
                                    [Origin_storage]
                            end,
                            {ok,
                                {session_state,
                                    erlang:element(2, Cookies_response),
                                    Origins}}
                        end
                    )
                end
            )
        end
    ).

-file("src\\chrobot_extra\\session.gleam", 222).
-spec decode_session_state() -> gleam@dynamic@decode:decoder(session_state()).
decode_session_state() ->
    gleam@dynamic@decode:field(
        <<"cookies"/utf8>>,
        gleam@dynamic@decode:list(
            chrobot_extra@protocol@network:decode__cookie()
        ),
        fun(Cookies) ->
            gleam@dynamic@decode:field(
                <<"origins"/utf8>>,
                gleam@dynamic@decode:list(decode_origin_storage()),
                fun(Origins) ->
                    gleam@dynamic@decode:success(
                        {session_state, Cookies, Origins}
                    )
                end
            )
        end
    ).

-file("src\\chrobot_extra\\session.gleam", 151).
?DOC(" Load session state from a JSON file.\n").
-spec load_from_file(binary()) -> {ok, session_state()} |
    {error, session_error()}.
load_from_file(Path) ->
    gleam@result:'try'(
        begin
            _pipe = simplifile:read(Path),
            gleam@result:map_error(
                _pipe,
                fun(Field@0) -> {file_error, Field@0} end
            )
        end,
        fun(Contents) ->
            _pipe@1 = gleam@json:parse(Contents, decode_session_state()),
            gleam@result:replace_error(_pipe@1, json_error)
        end
    ).
