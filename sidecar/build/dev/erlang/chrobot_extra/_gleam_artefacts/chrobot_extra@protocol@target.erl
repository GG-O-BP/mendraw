-module(chrobot_extra@protocol@target).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\protocol\\target.gleam").
-export([encode__target_id/1, decode__target_id/0, encode__session_id/1, decode__session_id/0, encode__target_info/1, decode__target_info/0, decode__attach_to_target_response/0, decode__create_browser_context_response/0, decode__get_browser_contexts_response/0, decode__create_target_response/0, decode__get_targets_response/0, activate_target/2, attach_to_target/3, close_target/2, create_browser_context/1, get_browser_contexts/1, create_target/6, detach_from_target/2, dispose_browser_context/2, get_targets/1, set_auto_attach/3, set_discover_targets/2]).
-export_type([target_i_d/0, session_i_d/0, target_info/0, attach_to_target_response/0, create_browser_context_response/0, get_browser_contexts_response/0, create_target_response/0, get_targets_response/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " > ⚙️  This module was generated from the Chrome DevTools Protocol version **1.3**\n"
    " ## Target Domain  \n"
    "\n"
    " Supports additional targets discovery and allows to attach to them.  \n"
    "\n"
    " [📖   View this domain on the DevTools Protocol API Docs](https://chromedevtools.github.io/devtools-protocol/1-3/Target/)\n"
).

-type target_i_d() :: {target_i_d, binary()}.

-type session_i_d() :: {session_i_d, binary()}.

-type target_info() :: {target_info,
        target_i_d(),
        binary(),
        binary(),
        binary(),
        boolean(),
        gleam@option:option(target_i_d())}.

-type attach_to_target_response() :: {attach_to_target_response, session_i_d()}.

-type create_browser_context_response() :: {create_browser_context_response,
        binary()}.

-type get_browser_contexts_response() :: {get_browser_contexts_response,
        list(binary())}.

-type create_target_response() :: {create_target_response, target_i_d()}.

-type get_targets_response() :: {get_targets_response, list(target_info())}.

-file("src\\chrobot_extra\\protocol\\target.gleam", 25).
?DOC(false).
-spec encode__target_id(target_i_d()) -> gleam@json:json().
encode__target_id(Value__) ->
    case Value__ of
        {target_i_d, Inner_value__} ->
            gleam@json:string(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\target.gleam", 32).
?DOC(false).
-spec decode__target_id() -> gleam@dynamic@decode:decoder(target_i_d()).
decode__target_id() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({target_i_d, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\target.gleam", 45).
?DOC(false).
-spec encode__session_id(session_i_d()) -> gleam@json:json().
encode__session_id(Value__) ->
    case Value__ of
        {session_i_d, Inner_value__} ->
            gleam@json:string(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\target.gleam", 52).
?DOC(false).
-spec decode__session_id() -> gleam@dynamic@decode:decoder(session_i_d()).
decode__session_id() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({session_i_d, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\target.gleam", 74).
?DOC(false).
-spec encode__target_info(target_info()) -> gleam@json:json().
encode__target_info(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"targetId"/utf8>>,
                    encode__target_id(erlang:element(2, Value__))},
                {<<"type"/utf8>>, gleam@json:string(erlang:element(3, Value__))},
                {<<"title"/utf8>>,
                    gleam@json:string(erlang:element(4, Value__))},
                {<<"url"/utf8>>, gleam@json:string(erlang:element(5, Value__))},
                {<<"attached"/utf8>>,
                    gleam@json:bool(erlang:element(6, Value__))}],
            chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(7, Value__),
                fun(Inner_value__) ->
                    {<<"openerId"/utf8>>, encode__target_id(Inner_value__)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\target.gleam", 90).
?DOC(false).
-spec decode__target_info() -> gleam@dynamic@decode:decoder(target_info()).
decode__target_info() ->
    begin
        gleam@dynamic@decode:field(
            <<"targetId"/utf8>>,
            decode__target_id(),
            fun(Target_id) ->
                gleam@dynamic@decode:field(
                    <<"type"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Type_) ->
                        gleam@dynamic@decode:field(
                            <<"title"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Title) ->
                                gleam@dynamic@decode:field(
                                    <<"url"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_string/1},
                                    fun(Url) ->
                                        gleam@dynamic@decode:field(
                                            <<"attached"/utf8>>,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_bool/1},
                                            fun(Attached) ->
                                                gleam@dynamic@decode:optional_field(
                                                    <<"openerId"/utf8>>,
                                                    none,
                                                    gleam@dynamic@decode:optional(
                                                        decode__target_id()
                                                    ),
                                                    fun(Opener_id) ->
                                                        gleam@dynamic@decode:success(
                                                            {target_info,
                                                                Target_id,
                                                                Type_,
                                                                Title,
                                                                Url,
                                                                Attached,
                                                                Opener_id}
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

-file("src\\chrobot_extra\\protocol\\target.gleam", 124).
?DOC(false).
-spec decode__attach_to_target_response() -> gleam@dynamic@decode:decoder(attach_to_target_response()).
decode__attach_to_target_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"sessionId"/utf8>>,
            decode__session_id(),
            fun(Session_id) ->
                gleam@dynamic@decode:success(
                    {attach_to_target_response, Session_id}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\target.gleam", 142).
?DOC(false).
-spec decode__create_browser_context_response() -> gleam@dynamic@decode:decoder(create_browser_context_response()).
decode__create_browser_context_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"browserContextId"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Browser_context_id) ->
                gleam@dynamic@decode:success(
                    {create_browser_context_response, Browser_context_id}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\target.gleam", 162).
?DOC(false).
-spec decode__get_browser_contexts_response() -> gleam@dynamic@decode:decoder(get_browser_contexts_response()).
decode__get_browser_contexts_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"browserContextIds"/utf8>>,
            gleam@dynamic@decode:list(
                {decoder, fun gleam@dynamic@decode:decode_string/1}
            ),
            fun(Browser_context_ids) ->
                gleam@dynamic@decode:success(
                    {get_browser_contexts_response, Browser_context_ids}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\target.gleam", 185).
?DOC(false).
-spec decode__create_target_response() -> gleam@dynamic@decode:decoder(create_target_response()).
decode__create_target_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"targetId"/utf8>>,
            decode__target_id(),
            fun(Target_id) ->
                gleam@dynamic@decode:success(
                    {create_target_response, Target_id}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\target.gleam", 203).
?DOC(false).
-spec decode__get_targets_response() -> gleam@dynamic@decode:decoder(get_targets_response()).
decode__get_targets_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"targetInfos"/utf8>>,
            gleam@dynamic@decode:list(decode__target_info()),
            fun(Target_infos) ->
                gleam@dynamic@decode:success(
                    {get_targets_response, Target_infos}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\target.gleam", 221).
?DOC(
    " Activates (focuses) the target.\n"
    " \n"
    " Parameters:  \n"
    "  - `target_id`\n"
    " \n"
    " Returns:\n"
).
-spec activate_target(
    fun((binary(), gleam@option:option(gleam@json:json())) -> RQY),
    target_i_d()
) -> RQY.
activate_target(Callback__, Target_id) ->
    Callback__(
        <<"Target.activateTarget"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"targetId"/utf8>>, encode__target_id(Target_id)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\target.gleam", 243).
?DOC(
    " Attaches to the target with given id.\n"
    " \n"
    " Parameters:  \n"
    "  - `target_id`\n"
    "  - `flatten` : Enables \"flat\" access to the session via specifying sessionId attribute in the commands.\n"
    " We plan to make this the default, deprecate non-flattened mode,\n"
    " and eventually retire it. See crbug.com/991325.\n"
    " \n"
    " Returns:  \n"
    "  - `session_id` : Id assigned to the session.\n"
).
-spec attach_to_target(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    target_i_d(),
    gleam@option:option(boolean())
) -> {ok, attach_to_target_response()} |
    {error, chrobot_extra@chrome:request_error()}.
attach_to_target(Callback__, Target_id, Flatten) ->
    gleam@result:'try'(
        Callback__(
            <<"Target.attachToTarget"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"targetId"/utf8>>,
                                encode__target_id(Target_id)}],
                        chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Flatten,
                            fun(Inner_value__) ->
                                {<<"flatten"/utf8>>,
                                    gleam@json:bool(Inner_value__)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@1 = gleam@dynamic@decode:run(
                Result__,
                decode__attach_to_target_response()
            ),
            gleam@result:replace_error(_pipe@1, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\target.gleam", 271).
?DOC(
    " Closes the target. If the target is a page that gets closed too.\n"
    " \n"
    " Parameters:  \n"
    "  - `target_id`\n"
    " \n"
    " Returns:\n"
).
-spec close_target(
    fun((binary(), gleam@option:option(gleam@json:json())) -> RRS),
    target_i_d()
) -> RRS.
close_target(Callback__, Target_id) ->
    Callback__(
        <<"Target.closeTarget"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"targetId"/utf8>>, encode__target_id(Target_id)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\target.gleam", 290).
?DOC(
    " Creates a new empty BrowserContext. Similar to an incognito profile but you can have more than\n"
    " one.\n"
    " \n"
    " Parameters:  \n"
    " \n"
    " Returns:  \n"
    "  - `browser_context_id` : The id of the context created.\n"
).
-spec create_browser_context(
    fun((binary(), gleam@option:option(any())) -> {ok, gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()})
) -> {ok, create_browser_context_response()} |
    {error, chrobot_extra@chrome:request_error()}.
create_browser_context(Callback__) ->
    gleam@result:'try'(
        Callback__(<<"Target.createBrowserContext"/utf8>>, none),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__create_browser_context_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\target.gleam", 303).
?DOC(
    " Returns all browser contexts created with `Target.createBrowserContext` method.\n"
    "  - `browser_context_ids` : An array of browser context ids.\n"
).
-spec get_browser_contexts(
    fun((binary(), gleam@option:option(any())) -> {ok, gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()})
) -> {ok, get_browser_contexts_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_browser_contexts(Callback__) ->
    gleam@result:'try'(
        Callback__(<<"Target.getBrowserContexts"/utf8>>, none),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__get_browser_contexts_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\target.gleam", 326).
?DOC(
    " Creates a new page.\n"
    " \n"
    " Parameters:  \n"
    "  - `url` : The initial URL the page will be navigated to. An empty string indicates about:blank.\n"
    "  - `width` : Frame width in DIP (headless chrome only).\n"
    "  - `height` : Frame height in DIP (headless chrome only).\n"
    "  - `new_window` : Whether to create a new Window or Tab (chrome-only, false by default).\n"
    "  - `background` : Whether to create the target in background or foreground (chrome-only,\n"
    " false by default).\n"
    " \n"
    " Returns:  \n"
    "  - `target_id` : The id of the page opened.\n"
).
-spec create_target(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    binary(),
    gleam@option:option(integer()),
    gleam@option:option(integer()),
    gleam@option:option(boolean()),
    gleam@option:option(boolean())
) -> {ok, create_target_response()} |
    {error, chrobot_extra@chrome:request_error()}.
create_target(Callback__, Url, Width, Height, New_window, Background) ->
    gleam@result:'try'(
        Callback__(
            <<"Target.createTarget"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"url"/utf8>>, gleam@json:string(Url)}],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Width,
                            fun(Inner_value__) ->
                                {<<"width"/utf8>>,
                                    gleam@json:int(Inner_value__)}
                            end
                        ),
                        _pipe@2 = chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Height,
                            fun(Inner_value__@1) ->
                                {<<"height"/utf8>>,
                                    gleam@json:int(Inner_value__@1)}
                            end
                        ),
                        _pipe@3 = chrobot_extra@internal@utils:add_optional(
                            _pipe@2,
                            New_window,
                            fun(Inner_value__@2) ->
                                {<<"newWindow"/utf8>>,
                                    gleam@json:bool(Inner_value__@2)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@3,
                            Background,
                            fun(Inner_value__@3) ->
                                {<<"background"/utf8>>,
                                    gleam@json:bool(Inner_value__@3)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@4 = gleam@dynamic@decode:run(
                Result__,
                decode__create_target_response()
            ),
            gleam@result:replace_error(_pipe@4, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\target.gleam", 366).
?DOC(
    " Detaches session with given id.\n"
    " \n"
    " Parameters:  \n"
    "  - `session_id` : Session to detach.\n"
    " \n"
    " Returns:\n"
).
-spec detach_from_target(
    fun((binary(), gleam@option:option(gleam@json:json())) -> RTQ),
    gleam@option:option(session_i_d())
) -> RTQ.
detach_from_target(Callback__, Session_id) ->
    Callback__(
        <<"Target.detachFromTarget"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [],
                    chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Session_id,
                        fun(Inner_value__) ->
                            {<<"sessionId"/utf8>>,
                                encode__session_id(Inner_value__)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\target.gleam", 389).
?DOC(
    " Deletes a BrowserContext. All the belonging pages will be closed without calling their\n"
    " beforeunload hooks.\n"
    " \n"
    " Parameters:  \n"
    "  - `browser_context_id`\n"
    " \n"
    " Returns:\n"
).
-spec dispose_browser_context(
    fun((binary(), gleam@option:option(gleam@json:json())) -> RTX),
    binary()
) -> RTX.
dispose_browser_context(Callback__, Browser_context_id) ->
    Callback__(
        <<"Target.disposeBrowserContext"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"browserContextId"/utf8>>,
                        gleam@json:string(Browser_context_id)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\target.gleam", 410).
?DOC(
    " Retrieves a list of available targets.\n"
    " \n"
    " Parameters:  \n"
    " \n"
    " Returns:  \n"
    "  - `target_infos` : The list of targets.\n"
).
-spec get_targets(
    fun((binary(), gleam@option:option(any())) -> {ok, gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()})
) -> {ok, get_targets_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_targets(Callback__) ->
    gleam@result:'try'(
        Callback__(<<"Target.getTargets"/utf8>>, none),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__get_targets_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\target.gleam", 430).
?DOC(
    " Controls whether to automatically attach to new targets which are considered to be related to\n"
    " this one. When turned on, attaches to all existing related targets as well. When turned off,\n"
    " automatically detaches from all currently attached targets.\n"
    " This also clears all targets added by `autoAttachRelated` from the list of targets to watch\n"
    " for creation of related targets.\n"
    " \n"
    " Parameters:  \n"
    "  - `auto_attach` : Whether to auto-attach to related targets.\n"
    "  - `wait_for_debugger_on_start` : Whether to pause new targets when attaching to them. Use `Runtime.runIfWaitingForDebugger`\n"
    " to run paused targets.\n"
    " \n"
    " Returns:\n"
).
-spec set_auto_attach(
    fun((binary(), gleam@option:option(gleam@json:json())) -> RUO),
    boolean(),
    boolean()
) -> RUO.
set_auto_attach(Callback__, Auto_attach, Wait_for_debugger_on_start) ->
    Callback__(
        <<"Target.setAutoAttach"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"autoAttach"/utf8>>, gleam@json:bool(Auto_attach)},
                    {<<"waitForDebuggerOnStart"/utf8>>,
                        gleam@json:bool(Wait_for_debugger_on_start)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\target.gleam", 454).
?DOC(
    " Controls whether to discover available targets and notify via\n"
    " `targetCreated/targetInfoChanged/targetDestroyed` events.\n"
    " \n"
    " Parameters:  \n"
    "  - `discover` : Whether to discover available targets.\n"
    " \n"
    " Returns:\n"
).
-spec set_discover_targets(
    fun((binary(), gleam@option:option(gleam@json:json())) -> RUT),
    boolean()
) -> RUT.
set_discover_targets(Callback__, Discover) ->
    Callback__(
        <<"Target.setDiscoverTargets"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"discover"/utf8>>, gleam@json:bool(Discover)}]
            )}
    ).
