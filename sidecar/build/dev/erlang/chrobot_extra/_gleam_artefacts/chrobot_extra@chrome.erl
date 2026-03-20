-module(chrobot_extra@chrome).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\chrome.gleam").
-export([add_listener/2, remove_listener/2, set_log_level/2, send/3, get_default_chrome_args/0, is_local_chrome_path/2, get_local_chrome_path_at/1, get_local_chrome_path/0, process_port_message/2, get_system_chrome_path/0, call/5, listen_once/3, launch_with_config/1, quit/1, get_version/1, resolve_env_cofig/0, launch/0, launch_window/0, launch_with_env/0]).
-export_type([log_level/0, browser_config/0, browser_instance/0, browser_version/0, launch_error/0, request_error/0, browser_state/0, message/0, pending_request/0, browser_response/0, raw_browser_error/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " An actor that manages an instance of the chrome browser via an erlang port.\n"
    " The browser is started to allow remote debugging via pipes, once the pipe is disconnected,\n"
    " chrome should quit automatically.\n"
    " \n"
    " All messages to the browser are sent through this actor to the port, and responses are returned to the sender.\n"
    " The actor manages associating responses with the correct request by adding auto-incrementing ids to the requests,\n"
    " so callers don't need to worry about this.\n"
    " \n"
    " When the browser managed by this actor is closed, the actor will also exit.\n"
    " \n"
    " To start a browser, it's preferrable to use the launch functions from the root chrobot module,\n"
    " which perform additional checks and validations.\n"
    " \n"
).

-type log_level() :: log_level_silent |
    log_level_warnings |
    log_level_info |
    log_level_debug.

-type browser_config() :: {browser_config,
        binary(),
        list(binary()),
        integer(),
        log_level()}.

-type browser_instance() :: {browser_instance, gleam@erlang@port:port_()}.

-type browser_version() :: {browser_version,
        binary(),
        binary(),
        binary(),
        binary(),
        binary()}.

-type launch_error() :: unknow_operating_system |
    could_not_find_executable |
    failed_to_start |
    unresponsive_after_start |
    {protocol_version_mismatch, binary(), binary()}.

-type request_error() :: port_error |
    chrome_agent_timeout |
    chrome_agent_down |
    protocol_error |
    {browser_error, integer(), binary(), binary()} |
    not_found_error |
    {runtime_exception, binary(), integer(), integer()}.

-type browser_state() :: {browser_state,
        browser_instance(),
        integer(),
        list(pending_request()),
        list({binary(), gleam@erlang@process:subject(gleam@dynamic:dynamic_())}),
        gleam@string_tree:string_tree(),
        gleam@option:option(gleam@erlang@process:subject(nil)),
        log_level()}.

-type message() :: {shutdown, gleam@erlang@process:subject(nil)} |
    kill |
    {call,
        gleam@erlang@process:subject({ok, gleam@dynamic:dynamic_()} |
            {error, request_error()}),
        binary(),
        gleam@option:option(gleam@json:json()),
        gleam@option:option(binary())} |
    {send, binary(), gleam@option:option(gleam@json:json())} |
    {add_listener,
        gleam@erlang@process:subject(gleam@dynamic:dynamic_()),
        binary()} |
    {remove_listener, gleam@erlang@process:subject(gleam@dynamic:dynamic_())} |
    {unexpected_port_message, gleam@dynamic:dynamic_()} |
    {port_response, binary()} |
    {set_log_level, log_level()} |
    {port_exit, integer()}.

-type pending_request() :: {pending_request,
        integer(),
        gleam@erlang@process:subject({ok, gleam@dynamic:dynamic_()} |
            {error, request_error()})}.

-type browser_response() :: {browser_response,
        gleam@option:option(integer()),
        gleam@option:option(gleam@dynamic:dynamic_()),
        gleam@option:option(binary()),
        gleam@option:option(gleam@dynamic:dynamic_()),
        gleam@option:option(raw_browser_error())}.

-type raw_browser_error() :: {raw_browser_error,
        gleam@option:option(integer()),
        gleam@option:option(binary()),
        gleam@option:option(binary())}.

-file("src\\chrobot_extra\\chrome.gleam", 310).
?DOC(
    " Add an event listener\n"
    " (Experimental! Event forwarding is not really supported yet)\n"
).
-spec add_listener(gleam@erlang@process:subject(message()), binary()) -> gleam@erlang@process:subject(gleam@dynamic:dynamic_()).
add_listener(Browser, Method) ->
    Event_subject = gleam@erlang@process:new_subject(),
    gleam@erlang@process:send(Browser, {add_listener, Event_subject, Method}),
    Event_subject.

-file("src\\chrobot_extra\\chrome.gleam", 318).
?DOC(
    " Remove an event listener\n"
    " (Experimental! Event forwarding is not really supported yet)\n"
).
-spec remove_listener(
    gleam@erlang@process:subject(message()),
    gleam@erlang@process:subject(gleam@dynamic:dynamic_())
) -> nil.
remove_listener(Browser, Listener) ->
    gleam@erlang@process:send(Browser, {remove_listener, Listener}).

-file("src\\chrobot_extra\\chrome.gleam", 323).
?DOC(" Allows you to set the log level of a running browser instance\n").
-spec set_log_level(gleam@erlang@process:subject(message()), log_level()) -> nil.
set_log_level(Browser, Level) ->
    gleam@erlang@process:send(Browser, {set_log_level, Level}).

-file("src\\chrobot_extra\\chrome.gleam", 332).
?DOC(
    " Issue a protocol call to the browser without waiting for a response,\n"
    " when the response arrives, it will be discarded.\n"
    " It's probably best to not use this and instead just use `call` and discard unneeded responses.\n"
    " All protocol calls yield a response and can be used with `call`, even if they\n"
    " don't specify any response parameters.\n"
).
-spec send(
    gleam@erlang@process:subject(message()),
    binary(),
    gleam@option:option(gleam@json:json())
) -> nil.
send(Browser, Method, Params) ->
    gleam@erlang@process:send(Browser, {send, Method, Params}).

-file("src\\chrobot_extra\\chrome.gleam", 374).
?DOC(
    " Get the default arguments the browser should be started with,\n"
    " to be used inside the `launch_with_config` function\n"
).
-spec get_default_chrome_args() -> list(binary()).
get_default_chrome_args() ->
    [<<"--headless"/utf8>>,
        <<"--disable-accelerated-2d-canvas"/utf8>>,
        <<"--disable-gpu"/utf8>>,
        <<"--allow-pre-commit-input"/utf8>>,
        <<"--disable-background-networking"/utf8>>,
        <<"--disable-background-timer-throttling"/utf8>>,
        <<"--disable-backgrounding-occluded-windows"/utf8>>,
        <<"--disable-breakpad"/utf8>>,
        <<"--disable-client-side-phishing-detection"/utf8>>,
        <<"--disable-component-extensions-with-background-pages"/utf8>>,
        <<"--disable-component-update"/utf8>>,
        <<"--disable-default-apps"/utf8>>,
        <<"--disable-extensions"/utf8>>,
        <<"--disable-features=Translate,BackForwardCache,AcceptCHFrame,MediaRouter,OptimizationHints"/utf8>>,
        <<"--disable-hang-monitor"/utf8>>,
        <<"--disable-ipc-flooding-protection"/utf8>>,
        <<"--disable-popup-blocking"/utf8>>,
        <<"--disable-prompt-on-repost"/utf8>>,
        <<"--disable-renderer-backgrounding"/utf8>>,
        <<"--disable-sync"/utf8>>,
        <<"--enable-automation"/utf8>>,
        <<"--enable-features=NetworkServiceInProcess2"/utf8>>,
        <<"--export-tagged-pdf"/utf8>>,
        <<"--force-color-profile=srgb"/utf8>>,
        <<"--hide-scrollbars"/utf8>>,
        <<"--metrics-recording-only"/utf8>>,
        <<"--no-default-browser-check"/utf8>>,
        <<"--no-first-run"/utf8>>,
        <<"--no-service-autorun"/utf8>>,
        <<"--password-store=basic"/utf8>>,
        <<"--use-mock-keychain"/utf8>>].

-file("src\\chrobot_extra\\chrome.gleam", 398).
?DOC(
    " Returns whether the given path is a local chrome installation, of the kind\n"
    " created by `browser_install` or the puppeteer install script.\n"
    " This can be used to scan a directory with `simplifile.get_files`.\n"
).
-spec is_local_chrome_path(binary(), chrobot_extra@internal@os:os_family()) -> boolean().
is_local_chrome_path(Relative_path, Os_family) ->
    case {Os_family, filepath:split(Relative_path)} of
        {darwin,
            [<<"chrome"/utf8>>,
                <<"mac"/utf8, _/binary>>,
                <<"chrome-"/utf8, _/binary>>,
                <<"Google Chrom"/utf8, _/binary>>,
                <<"Contents"/utf8>>,
                <<"MacOS"/utf8>>,
                <<"Google Chrom"/utf8, _/binary>>]} ->
            true;

        {linux,
            [<<"chrome"/utf8>>,
                <<"linux"/utf8, _/binary>>,
                <<"chrome-"/utf8, _/binary>>,
                <<"chrome"/utf8>>]} ->
            true;

        {windows_nt,
            [<<"chrome"/utf8>>,
                <<"win"/utf8, _/binary>>,
                <<"chrome-"/utf8, _/binary>>,
                <<"chrome.exe"/utf8>>]} ->
            true;

        {_, _} ->
            false
    end.

-file("src\\chrobot_extra\\chrome.gleam", 435).
?DOC(false).
-spec get_local_chrome_path_at(binary()) -> {ok, binary()} |
    {error, launch_error()}.
get_local_chrome_path_at(Base_dir) ->
    case simplifile_erl:is_directory(Base_dir) of
        {ok, true} ->
            Files_res = gleam@result:replace_error(
                simplifile:get_files(Base_dir),
                could_not_find_executable
            ),
            gleam@result:'try'(
                Files_res,
                fun(Files) ->
                    _pipe = gleam@list:find(
                        Files,
                        fun(File) ->
                            is_local_chrome_path(
                                File,
                                chrobot_extra@internal@os:family()
                            )
                        end
                    ),
                    gleam@result:replace_error(_pipe, could_not_find_executable)
                end
            );

        _ ->
            {error, could_not_find_executable}
    end.

-file("src\\chrobot_extra\\chrome.gleam", 430).
?DOC(
    " Try to find a hermetic chrome installation in the current directory,\n"
    " of the kind installed by `browser_install` or the puppeteer install script.\n"
    " The installation must be in a directory called `chrome`.\n"
).
-spec get_local_chrome_path() -> {ok, binary()} | {error, launch_error()}.
get_local_chrome_path() ->
    get_local_chrome_path_at(<<"chrome"/utf8>>).

-file("src\\chrobot_extra\\chrome.gleam", 531).
?DOC(
    " Handle a message from the port that is not a data message.\n"
    " Right now we are handling exit_code messages, which tell us that the port\n"
    " has exited or failed to properly start.\n"
    " Port messages arrive as {Port, {exit_status, int}} - we need to decode at [1]\n"
).
-spec map_non_data_port_msg(gleam@dynamic:dynamic_()) -> message().
map_non_data_port_msg(Msg) ->
    Inner_decoder = begin
        gleam@dynamic@decode:field(
            0,
            gleam@erlang@atom:decoder(),
            fun(Atom_val) ->
                gleam@dynamic@decode:field(
                    1,
                    {decoder, fun gleam@dynamic@decode:decode_int/1},
                    fun(Int_val) ->
                        gleam@dynamic@decode:success({Atom_val, Int_val})
                    end
                )
            end
        )
    end,
    Tuple_decoder = gleam@dynamic@decode:at([1], Inner_decoder),
    case gleam@dynamic@decode:run(Msg, Tuple_decoder) of
        {ok, {Atom_exit_status, Exit_status}} ->
            case Atom_exit_status =:= erlang:binary_to_atom(
                <<"exit_status"/utf8>>
            ) of
                true ->
                    {port_exit, Exit_status};

                false ->
                    {unexpected_port_message, Msg}
            end;

        {error, _} ->
            {unexpected_port_message, Msg}
    end.

-file("src\\chrobot_extra\\chrome.gleam", 517).
?DOC(" Map a raw message from the port to a message that the actor can handle\n").
-spec map_port_message(gleam@dynamic:dynamic_()) -> message().
map_port_message(Message) ->
    case gleam@dynamic@decode:run(
        Message,
        gleam@dynamic@decode:at(
            [1, 1],
            {decoder, fun gleam@dynamic@decode:decode_string/1}
        )
    ) of
        {ok, Data} ->
            {port_response, Data};

        {error, _} ->
            map_non_data_port_msg(Message)
    end.

-file("src\\chrobot_extra\\chrome.gleam", 578).
?DOC(
    " Process a list of port messages that are known to be at least one\n"
    " complete payload, but may be unterminated.  \n"
    " The overflow buffer is already appended to the first message in advance\n"
    " so it is not included as a parameter to this function.  \n"
    " The function may return a newly filled buffer though, if the last message was unterminated.\n"
).
-spec process_port_message_parts(list(binary()), list(binary())) -> {list(binary()),
    gleam@string_tree:string_tree()}.
process_port_message_parts(Parts, Collector) ->
    case Parts of
        [<<""/utf8>>] ->
            {lists:reverse(Collector), gleam@string_tree:new()};

        [Overflow] ->
            {lists:reverse(Collector),
                begin
                    _pipe = gleam@string_tree:new(),
                    gleam@string_tree:append(_pipe, Overflow)
                end};

        [Cur | Rest] ->
            process_port_message_parts(Rest, [Cur | Collector]);

        [] ->
            {lists:reverse(Collector), gleam@string_tree:new()}
    end.

-file("src\\chrobot_extra\\chrome.gleam", 553).
?DOC(false).
-spec process_port_message(binary(), gleam@string_tree:string_tree()) -> {list(binary()),
    gleam@string_tree:string_tree()}.
process_port_message(Input, Buffer) ->
    case gleam@string:split(Input, <<"\x{0000}"/utf8>>) of
        [Unterminated_msg] ->
            {[], gleam@string_tree:append(Buffer, Unterminated_msg)};

        [Single_msg, <<""/utf8>>] ->
            {[begin
                        _pipe = gleam@string_tree:append(Buffer, Single_msg),
                        unicode:characters_to_binary(_pipe)
                    end],
                gleam@string_tree:new()};

        [First | Rest] ->
            Complete_parts = [begin
                    _pipe@1 = gleam@string_tree:append(Buffer, First),
                    unicode:characters_to_binary(_pipe@1)
                end |
                Rest],
            process_port_message_parts(Complete_parts, []);

        [] ->
            {[], Buffer}
    end.

-file("src\\chrobot_extra\\chrome.gleam", 849).
?DOC(
    " Find the pending request in the state and send the response data to the client.\n"
    " Failure to find the associated request will silently discard the response\n"
).
-spec answer_request(browser_state(), integer(), gleam@dynamic:dynamic_()) -> list(pending_request()).
answer_request(State, Id, Data) ->
    Found_request = chrobot_extra@internal@utils:find_map_remove(
        erlang:element(4, State),
        fun(Req) -> case erlang:element(2, Req) =:= Id of
                true ->
                    {ok, Req};

                false ->
                    {error, nil}
            end end
    ),
    case Found_request of
        {ok, {Req@1, Rest}} ->
            gleam@erlang@process:send(erlang:element(3, Req@1), {ok, Data}),
            Rest;

        {error, nil} ->
            erlang:element(4, State)
    end.

-file("src\\chrobot_extra\\chrome.gleam", 1049).
-spec get_first_existing_path(list(binary())) -> {ok, binary()} |
    {error, launch_error()}.
get_first_existing_path(Paths) ->
    Existing_paths = begin
        _pipe = Paths,
        gleam@list:filter(
            _pipe,
            fun(Current) -> case simplifile_erl:is_file(Current) of
                    {ok, Res} ->
                        Res;

                    {error, _} ->
                        false
                end end
        )
    end,
    case Existing_paths of
        [First | _] ->
            {ok, First};

        [] ->
            {error, could_not_find_executable}
    end.

-file("src\\chrobot_extra\\chrome.gleam", 451).
?DOC(" Try to find a system chrome installation in some obvious places.\n").
-spec get_system_chrome_path() -> {ok, binary()} | {error, launch_error()}.
get_system_chrome_path() ->
    case chrobot_extra@internal@os:family() of
        darwin ->
            get_first_existing_path(
                [<<"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"/utf8>>,
                    <<"/Applications/Google Chrome Beta.app/Contents/MacOS/Google Chrome Beta"/utf8>>,
                    <<"/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary"/utf8>>,
                    <<"/Applications/Google Chrome Dev.app/Contents/MacOS/Google Chrome Dev"/utf8>>,
                    <<"/Applications/Chromium.app/Contents/MacOS/Chromium"/utf8>>]
            );

        linux ->
            get_first_existing_path(
                [<<"/opt/google/chrome/chrome"/utf8>>,
                    <<"/opt/google/chrome-beta/chrome"/utf8>>,
                    <<"/opt/google/chrome-unstable/chrome"/utf8>>,
                    <<"/usr/bin/chromium"/utf8>>,
                    <<"/usr/bin/chromium-browser"/utf8>>]
            );

        windows_nt ->
            get_first_existing_path(
                [<<"C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe"/utf8>>,
                    <<"C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe"/utf8>>,
                    <<"C:\\Program Files\\Chromium\\Application\\chrome.exe"/utf8>>,
                    <<"C:\\Program Files (x86)\\Chromium\\Application\\chrome.exe"/utf8>>]
            );

        _ ->
            {error, unknow_operating_system}
    end.

-file("src\\chrobot_extra\\chrome.gleam", 1094).
-spec log_info(browser_state(), binary()) -> nil.
log_info(State, Message) ->
    case erlang:element(8, State) of
        log_level_info ->
            gleam_stdlib:println(
                <<<<<<"[INFO] "/utf8,
                            (gleam@string:inspect(erlang:element(2, State)))/binary>>/binary,
                        ": "/utf8>>/binary,
                    Message/binary>>
            );

        log_level_debug ->
            gleam_stdlib:println(
                <<<<<<"[INFO] "/utf8,
                            (gleam@string:inspect(erlang:element(2, State)))/binary>>/binary,
                        ": "/utf8>>/binary,
                    Message/binary>>
            );

        _ ->
            nil
    end.

-file("src\\chrobot_extra\\chrome.gleam", 1103).
-spec log_warn(browser_state(), binary()) -> nil.
log_warn(State, Message) ->
    case erlang:element(8, State) of
        log_level_info ->
            gleam_stdlib:println(
                <<<<<<"[WARNING] "/utf8,
                            (gleam@string:inspect(erlang:element(2, State)))/binary>>/binary,
                        ": "/utf8>>/binary,
                    Message/binary>>
            );

        log_level_debug ->
            gleam_stdlib:println(
                <<<<<<"[WARNING] "/utf8,
                            (gleam@string:inspect(erlang:element(2, State)))/binary>>/binary,
                        ": "/utf8>>/binary,
                    Message/binary>>
            );

        log_level_warnings ->
            gleam_stdlib:println(
                <<<<<<"[WARNING] "/utf8,
                            (gleam@string:inspect(erlang:element(2, State)))/binary>>/binary,
                        ": "/utf8>>/binary,
                    Message/binary>>
            );

        _ ->
            nil
    end.

-file("src\\chrobot_extra\\chrome.gleam", 878).
?DOC(
    " Find the pending request in the state and send the error data to the client.\n"
    " Failure to find the associated request will log an error\n"
).
-spec answer_failed_request(browser_state(), integer(), raw_browser_error()) -> list(pending_request()).
answer_failed_request(State, Id, Data) ->
    Found_request = chrobot_extra@internal@utils:find_map_remove(
        erlang:element(4, State),
        fun(Req) -> case erlang:element(2, Req) =:= Id of
                true ->
                    {ok, Req};

                false ->
                    {error, nil}
            end end
    ),
    case Found_request of
        {ok, {Req@1, Rest}} ->
            gleam@erlang@process:send(
                erlang:element(3, Req@1),
                {error,
                    {browser_error,
                        gleam@option:unwrap(erlang:element(2, Data), 0),
                        gleam@option:unwrap(
                            erlang:element(3, Data),
                            <<"No message"/utf8>>
                        ),
                        gleam@option:unwrap(
                            erlang:element(4, Data),
                            <<"No data"/utf8>>
                        )}}
            ),
            Rest;

        {error, nil} ->
            log_warn(
                State,
                <<"An error arrived from the browser but could not be associated with a request: "/utf8,
                    (gleam@string:inspect(Data))/binary>>
            ),
            erlang:element(4, State)
    end.

-file("src\\chrobot_extra\\chrome.gleam", 1116).
?DOC(
    " Debug is called lazily, to avoid doing work constructing strings\n"
    " for it that never get used\n"
).
-spec log_debug(browser_state(), fun(() -> binary())) -> nil.
log_debug(State, Callback) ->
    case erlang:element(8, State) of
        log_level_debug ->
            gleam_stdlib:println(
                <<<<<<"[DEBUG] "/utf8,
                            (gleam@string:inspect(erlang:element(2, State)))/binary>>/binary,
                        ": "/utf8>>/binary,
                    (Callback())/binary>>
            );

        _ ->
            nil
    end.

-file("src\\chrobot_extra\\chrome.gleam", 937).
?DOC(
    " Handle a message from the browser, delivered via the port.\n"
    " The message can be a response to a request or an event\n"
).
-spec handle_port_response(browser_state(), binary()) -> browser_state().
handle_port_response(State, Response) ->
    Error_decoder = begin
        gleam@dynamic@decode:optional_field(
            <<"code"/utf8>>,
            none,
            gleam@dynamic@decode:optional(
                {decoder, fun gleam@dynamic@decode:decode_int/1}
            ),
            fun(Code) ->
                gleam@dynamic@decode:optional_field(
                    <<"message"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(
                        {decoder, fun gleam@dynamic@decode:decode_string/1}
                    ),
                    fun(Message) ->
                        gleam@dynamic@decode:optional_field(
                            <<"data"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                {decoder,
                                    fun gleam@dynamic@decode:decode_string/1}
                            ),
                            fun(Data) ->
                                gleam@dynamic@decode:success(
                                    {raw_browser_error, Code, Message, Data}
                                )
                            end
                        )
                    end
                )
            end
        )
    end,
    Response_decoder = begin
        gleam@dynamic@decode:optional_field(
            <<"id"/utf8>>,
            none,
            gleam@dynamic@decode:optional(
                {decoder, fun gleam@dynamic@decode:decode_int/1}
            ),
            fun(Id) ->
                gleam@dynamic@decode:optional_field(
                    <<"result"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(
                        {decoder, fun gleam@dynamic@decode:decode_dynamic/1}
                    ),
                    fun(Result) ->
                        gleam@dynamic@decode:optional_field(
                            <<"method"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                {decoder,
                                    fun gleam@dynamic@decode:decode_string/1}
                            ),
                            fun(Method) ->
                                gleam@dynamic@decode:optional_field(
                                    <<"params"/utf8>>,
                                    none,
                                    gleam@dynamic@decode:optional(
                                        {decoder,
                                            fun gleam@dynamic@decode:decode_dynamic/1}
                                    ),
                                    fun(Params) ->
                                        gleam@dynamic@decode:optional_field(
                                            <<"error"/utf8>>,
                                            none,
                                            gleam@dynamic@decode:optional(
                                                Error_decoder
                                            ),
                                            fun(Error) ->
                                                gleam@dynamic@decode:success(
                                                    {browser_response,
                                                        Id,
                                                        Result,
                                                        Method,
                                                        Params,
                                                        Error}
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
    end,
    case gleam@json:parse(Response, Response_decoder) of
        {ok,
            {browser_response, {some, Id@1}, {some, Result@1}, none, none, none}} ->
            {browser_state,
                erlang:element(2, State),
                erlang:element(3, State),
                answer_request(State, Id@1, Result@1),
                erlang:element(5, State),
                erlang:element(6, State),
                erlang:element(7, State),
                erlang:element(8, State)};

        {ok, {browser_response, {some, Id@2}, _, _, _, {some, Raw_error}}} ->
            {browser_state,
                erlang:element(2, State),
                erlang:element(3, State),
                answer_failed_request(State, Id@2, Raw_error),
                erlang:element(5, State),
                erlang:element(6, State),
                erlang:element(7, State),
                erlang:element(8, State)};

        {ok,
            {browser_response,
                none,
                none,
                {some, Method@1},
                {some, Params@1},
                none}} ->
            gleam@list:each(
                erlang:element(5, State),
                fun(L) -> case erlang:element(1, L) =:= Method@1 of
                        true ->
                            gleam@erlang@process:send(
                                erlang:element(2, L),
                                Params@1
                            );

                        false ->
                            log_debug(
                                State,
                                fun() ->
                                    <<<<<<"Ignored Event: "/utf8,
                                                Method@1/binary>>/binary,
                                            " "/utf8>>/binary,
                                        (gleam@string:inspect(Params@1))/binary>>
                                end
                            ),
                            nil
                    end end
            ),
            State;

        {ok, _} ->
            log_warn(
                State,
                <<"Received an unexpectedly formatted response from the browser"/utf8>>
            ),
            gleam_stdlib:println(gleam@string:inspect(Response)),
            State;

        {error, E} ->
            log_warn(
                State,
                <<"Failed to decode data from port message, ignoring! Resonse and error:"/utf8>>
            ),
            gleam_stdlib:println(gleam@string:inspect({Response, E})),
            State
    end.

-file("src\\chrobot_extra\\chrome.gleam", 1127).
-spec map_call_error(chrobot_extra@internal@utils:call_error()) -> request_error().
map_call_error(Err) ->
    case Err of
        call_timeout ->
            chrome_agent_timeout;

        {callee_down, _} ->
            chrome_agent_down
    end.

-file("src\\chrobot_extra\\chrome.gleam", 275).
?DOC(" Issue a protocol call to the browser and expect a response\n").
-spec call(
    gleam@erlang@process:subject(message()),
    binary(),
    gleam@option:option(gleam@json:json()),
    gleam@option:option(binary()),
    integer()
) -> {ok, gleam@dynamic:dynamic_()} | {error, request_error()}.
call(Browser, Method, Params, Session_id, Time_out) ->
    case chrobot_extra@internal@utils:try_call(
        Browser,
        fun(_capture) -> {call, _capture, Method, Params, Session_id} end,
        Time_out
    ) of
        {ok, Nested_result} ->
            Nested_result;

        {error, Err} ->
            {error, map_call_error(Err)}
    end.

-file("src\\chrobot_extra\\chrome.gleam", 290).
?DOC(
    " A blocking call that waits for a specified event to arrive once,\n"
    " and then resolves, removing the event listener.\n"
).
-spec listen_once(gleam@erlang@process:subject(message()), binary(), integer()) -> {ok,
        gleam@dynamic:dynamic_()} |
    {error, request_error()}.
listen_once(Browser, Method, Time_out) ->
    Event_subject = gleam@erlang@process:new_subject(),
    Call_response = chrobot_extra@internal@utils:try_call_with_subject(
        Browser,
        fun(_capture) -> {add_listener, _capture, Method} end,
        Event_subject,
        Time_out
    ),
    gleam@erlang@process:send(Browser, {remove_listener, Event_subject}),
    _pipe = Call_response,
    gleam@result:map_error(_pipe, fun map_call_error/1).

-file("src\\chrobot_extra\\chrome.gleam", 481).
?DOC(" Returns a function that can be passed to the actor initialiser\n").
-spec create_init_fn(browser_config()) -> fun((gleam@erlang@process:subject(message())) -> {ok,
        gleam@otp@actor:initialised(browser_state(), message(), gleam@erlang@process:subject(message()))} |
    {error, binary()}).
create_init_fn(Cfg) ->
    fun(Subject) ->
        Cmd = erlang:element(2, Cfg),
        Args = [<<"--remote-debugging-pipe"/utf8>> | erlang:element(3, Cfg)],
        Res = chrobot_extra_ffi:open_browser_port(Cmd, Args),
        case Res of
            {ok, Port} ->
                Instance = {browser_instance, Port},
                Initial_state = {browser_state,
                    Instance,
                    0,
                    [],
                    [],
                    gleam@string_tree:new(),
                    none,
                    erlang:element(5, Cfg)},
                log_info(
                    Initial_state,
                    <<"Port opened successfully, actor initialized"/utf8>>
                ),
                Selector = begin
                    _pipe = gleam_erlang_ffi:new_selector(),
                    _pipe@1 = gleam@erlang@process:select_record(
                        _pipe,
                        Port,
                        1,
                        fun map_port_message/1
                    ),
                    gleam@erlang@process:select(_pipe@1, Subject)
                end,
                _pipe@2 = gleam@otp@actor:initialised(Initial_state),
                _pipe@3 = gleam@otp@actor:selecting(_pipe@2, Selector),
                _pipe@4 = gleam@otp@actor:returning(_pipe@3, Subject),
                {ok, _pipe@4};

            {error, Err} ->
                chrobot_extra@internal@utils:err(
                    <<"Browser failed to start!"/utf8>>
                ),
                gleam_stdlib:println(
                    <<"Error: "/utf8, (gleam@string:inspect(Err))/binary>>
                ),
                {error, <<"Browser did not start"/utf8>>}
        end
    end.

-file("src\\chrobot_extra\\chrome.gleam", 1043).
?DOC(
    " Send a JSON encoded string to the browser instance,\n"
    " the JSON payload must already include the `id` field.\n"
    " This function appends a null byte to the end of the message,\n"
    " which is used by the browser to detect when a message ends.\n"
).
-spec send_to_browser(browser_state(), gleam@json:json()) -> {ok,
        gleam@dynamic:dynamic_()} |
    {error, gleam@dynamic:dynamic_()}.
send_to_browser(State, Data) ->
    Payload = gleam@json:to_string(Data),
    log_debug(State, fun() -> <<"Sending Payload: "/utf8, Payload/binary>> end),
    chrobot_extra_ffi:send_to_port(
        erlang:element(2, erlang:element(2, State)),
        <<Payload/binary, "\x{0000}"/utf8>>
    ).

-file("src\\chrobot_extra\\chrome.gleam", 771).
?DOC(
    " Send a request to the browser and expect a response\n"
    " Request params must already be encoded into a JSON structure by the caller\n"
    " The response will be sent back to the client subject when it arrives from the browser\n"
).
-spec handle_call(
    browser_state(),
    gleam@erlang@process:subject({ok, gleam@dynamic:dynamic_()} |
        {error, request_error()}),
    binary(),
    gleam@option:option(gleam@json:json()),
    gleam@option:option(binary())
) -> gleam@otp@actor:next(browser_state(), any()).
handle_call(State, Client, Method, Params, Session_id) ->
    Request_id = erlang:element(3, State),
    Request_memo = {pending_request, Request_id, Client},
    Payload = gleam@json:object(
        begin
            _pipe = [{<<"id"/utf8>>, gleam@json:int(Request_id)},
                {<<"method"/utf8>>, gleam@json:string(Method)}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                Params,
                fun(Some_params) -> {<<"params"/utf8>>, Some_params} end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                Session_id,
                fun(Some_session_id) ->
                    {<<"sessionId"/utf8>>, gleam@json:string(Some_session_id)}
                end
            )
        end
    ),
    case send_to_browser(State, Payload) of
        {error, _} ->
            log_warn(
                State,
                <<"Request call to browser was unsuccessful!"/utf8>>
            ),
            gleam@erlang@process:send(Client, {error, port_error}),
            gleam@otp@actor:continue(
                {browser_state,
                    erlang:element(2, State),
                    Request_id + 1,
                    erlang:element(4, State),
                    erlang:element(5, State),
                    erlang:element(6, State),
                    erlang:element(7, State),
                    erlang:element(8, State)}
            );

        {ok, _} ->
            gleam@otp@actor:continue(
                {browser_state,
                    erlang:element(2, State),
                    Request_id + 1,
                    [Request_memo | erlang:element(4, State)],
                    erlang:element(5, State),
                    erlang:element(6, State),
                    erlang:element(7, State),
                    erlang:element(8, State)}
            )
    end.

-file("src\\chrobot_extra\\chrome.gleam", 819).
?DOC(
    " Send a request that does not expect a response\n"
    " Request params must already be encoded into a JSON structure by the caller\n"
).
-spec handle_send(
    browser_state(),
    binary(),
    gleam@option:option(gleam@json:json())
) -> gleam@otp@actor:next(browser_state(), any()).
handle_send(State, Method, Params) ->
    Request_id = erlang:element(3, State),
    Payload = gleam@json:object(
        begin
            _pipe = [{<<"id"/utf8>>, gleam@json:int(Request_id)},
                {<<"method"/utf8>>, gleam@json:string(Method)}],
            chrobot_extra@internal@utils:add_optional(
                _pipe,
                Params,
                fun(Some_params) -> {<<"params"/utf8>>, Some_params} end
            )
        end
    ),
    case send_to_browser(State, Payload) of
        {error, _} ->
            log_warn(
                State,
                <<"Request sent to browser was unsuccessful!"/utf8>>
            ),
            gleam_stdlib:println(gleam@string:inspect(Payload)),
            nil;

        {ok, _} ->
            nil
    end,
    gleam@otp@actor:continue(
        {browser_state,
            erlang:element(2, State),
            Request_id + 1,
            erlang:element(4, State),
            erlang:element(5, State),
            erlang:element(6, State),
            erlang:element(7, State),
            erlang:element(8, State)}
    ).

-file("src\\chrobot_extra\\chrome.gleam", 641).
?DOC(" The main loop of the actor, handling all messages\n").
-spec loop(browser_state(), message()) -> gleam@otp@actor:next(browser_state(), any()).
loop(State, Message) ->
    case Message of
        kill ->
            log_warn(
                State,
                <<"Received kill signal, actor is shutting down, this is unuasual and means the browser did not respond to a shutdown request in time!"/utf8>>
            ),
            gleam@otp@actor:stop();

        {call, Client, Method, Params, Session_id} ->
            handle_call(State, Client, Method, Params, Session_id);

        {send, Method@1, Params@1} ->
            handle_send(State, Method@1, Params@1);

        {add_listener, Client@1, Method@2} ->
            Updated_listeners = [{Method@2, Client@1} |
                erlang:element(5, State)],
            log_info(
                State,
                <<"Event listeners: "/utf8,
                    (gleam@string:inspect(Updated_listeners))/binary>>
            ),
            gleam@otp@actor:continue(
                {browser_state,
                    erlang:element(2, State),
                    erlang:element(3, State),
                    erlang:element(4, State),
                    Updated_listeners,
                    erlang:element(6, State),
                    erlang:element(7, State),
                    erlang:element(8, State)}
            );

        {remove_listener, Client@2} ->
            Updated_listeners@1 = gleam@list:filter(
                erlang:element(5, State),
                fun(L) -> erlang:element(2, L) /= Client@2 end
            ),
            log_info(
                State,
                <<"Event listeners: "/utf8,
                    (gleam@string:inspect(Updated_listeners@1))/binary>>
            ),
            gleam@otp@actor:continue(
                {browser_state,
                    erlang:element(2, State),
                    erlang:element(3, State),
                    erlang:element(4, State),
                    Updated_listeners@1,
                    erlang:element(6, State),
                    erlang:element(7, State),
                    erlang:element(8, State)}
            );

        {port_response, Data} ->
            {Chunks, Buffer} = process_port_message(
                Data,
                erlang:element(6, State)
            ),
            case string:is_empty(Buffer) of
                false ->
                    log_info(State, <<"buffering browser message!"/utf8>>);

                true ->
                    nil
            end,
            Updated_state = begin
                _pipe = Chunks,
                gleam@list:fold(
                    _pipe,
                    State,
                    fun(Acc, Curr) -> handle_port_response(Acc, Curr) end
                )
            end,
            gleam@otp@actor:continue(
                {browser_state,
                    erlang:element(2, Updated_state),
                    erlang:element(3, Updated_state),
                    erlang:element(4, Updated_state),
                    erlang:element(5, Updated_state),
                    Buffer,
                    erlang:element(7, Updated_state),
                    erlang:element(8, State)}
            );

        {unexpected_port_message, Msg} ->
            log_warn(
                State,
                <<"Got an unexpected message from the port! This should not happen!"/utf8>>
            ),
            gleam_stdlib:println(gleam@string:inspect(Msg)),
            gleam@otp@actor:continue(State);

        {shutdown, Client@3} ->
            log_info(
                State,
                <<"Received shutdown request, attempting to quit browser"/utf8>>
            ),
            handle_send(State, <<"Browser.close"/utf8>>, none),
            gleam@otp@actor:continue(
                {browser_state,
                    erlang:element(2, State),
                    erlang:element(3, State),
                    erlang:element(4, State),
                    erlang:element(5, State),
                    erlang:element(6, State),
                    {some, Client@3},
                    erlang:element(8, State)}
            );

        {port_exit, Exit_status} ->
            case erlang:element(7, State) of
                {some, Client@4} ->
                    log_info(
                        State,
                        <<"Browser exited after shtudown request, actor is shutting down"/utf8>>
                    ),
                    gleam@erlang@process:send(Client@4, nil),
                    gleam@otp@actor:stop();

                _ ->
                    log_warn(
                        State,
                        <<<<"Browser exited but there was no shutdown request! Exit Status: "/utf8,
                                (gleam@string:inspect(Exit_status))/binary>>/binary,
                            " browser actor is shutting down abnormally"/utf8>>
                    ),
                    gleam@otp@actor:stop_abnormal(
                        <<"browser exited abnormally"/utf8>>
                    )
            end;

        {set_log_level, Level} ->
            gleam@otp@actor:continue(
                {browser_state,
                    erlang:element(2, State),
                    erlang:element(3, State),
                    erlang:element(4, State),
                    erlang:element(5, State),
                    erlang:element(6, State),
                    erlang:element(7, State),
                    Level}
            )
    end.

-file("src\\chrobot_extra\\chrome.gleam", 129).
?DOC(
    " Launch a browser with the given configuration,\n"
    " to populate the arguments, use `get_default_chrome_args`.\n"
    " \n"
    " Be aware that this function will not validate that the browser launched successfully,\n"
    " please use the higher level functions from the root chrobot module instead if you want these guarantees.\n"
    " \n"
    " ## Example\n"
    " ```gleam\n"
    " let config =\n"
    " BrowserConfig(\n"
    "   path: \"chrome/linux-116.0.5793.0/chrome-linux64/chrome\",\n"
    "   args: get_default_chrome_args(),\n"
    "   start_timeout: 5000,\n"
    " )\n"
    " let assert Ok(browser_subject) = launch_with_config(config)\n"
    " ```\n"
).
-spec launch_with_config(browser_config()) -> {ok,
        gleam@erlang@process:subject(message())} |
    {error, launch_error()}.
launch_with_config(Cfg) ->
    Launch_result = begin
        _pipe = gleam@otp@actor:new_with_initialiser(
            erlang:element(4, Cfg),
            create_init_fn(Cfg)
        ),
        _pipe@1 = gleam@otp@actor:on_message(_pipe, fun loop/2),
        gleam@otp@actor:start(_pipe@1)
    end,
    case Launch_result of
        {ok, Started} ->
            {ok, erlang:element(3, Started)};

        {error, Err} ->
            gleam_stdlib:println(
                <<"Failed to start browser: "/utf8,
                    (gleam@string:inspect(Err))/binary>>
            ),
            {error, failed_to_start}
    end.

-file("src\\chrobot_extra\\chrome.gleam", 266).
?DOC(
    " Quit the browser and shut down the actor.  \n"
    " This function will attempt graceful shutdown, if the browser does not respond in time,\n"
    " it will also send a kill signal to the actor to force it to shut down.\n"
    " The result typing reflects the success of graceful shutdown.\n"
).
-spec quit(gleam@erlang@process:subject(message())) -> {ok, nil} |
    {error, request_error()}.
quit(Browser) ->
    _ = gleam@erlang@process:send_after(Browser, 10000 * 2, kill),
    _pipe = chrobot_extra@internal@utils:try_call(
        Browser,
        fun(Field@0) -> {shutdown, Field@0} end,
        10000
    ),
    gleam@result:map_error(_pipe, fun map_call_error/1).

-file("src\\chrobot_extra\\chrome.gleam", 342).
?DOC(
    " Hardcoded protocol call to get the browser version\n"
    " See: https://chromedevtools.github.io/devtools-protocol/tot/Browser/#method-getVersion\n"
).
-spec get_version(gleam@erlang@process:subject(message())) -> {ok,
        browser_version()} |
    {error, request_error()}.
get_version(Browser) ->
    gleam@result:'try'(
        call(Browser, <<"Browser.getVersion"/utf8>>, none, none, 10000),
        fun(Res) ->
            Version_decoder = begin
                gleam@dynamic@decode:field(
                    <<"protocolVersion"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Protocol_version) ->
                        gleam@dynamic@decode:field(
                            <<"product"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Product) ->
                                gleam@dynamic@decode:field(
                                    <<"revision"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_string/1},
                                    fun(Revision) ->
                                        gleam@dynamic@decode:field(
                                            <<"userAgent"/utf8>>,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_string/1},
                                            fun(User_agent) ->
                                                gleam@dynamic@decode:field(
                                                    <<"jsVersion"/utf8>>,
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_string/1},
                                                    fun(Js_version) ->
                                                        gleam@dynamic@decode:success(
                                                            {browser_version,
                                                                Protocol_version,
                                                                Product,
                                                                Revision,
                                                                User_agent,
                                                                Js_version}
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
            end,
            case gleam@dynamic@decode:run(Res, Version_decoder) of
                {ok, Version} ->
                    {ok, Version};

                {error, _} ->
                    {error, protocol_error}
            end
        end
    ).

-file("src\\chrobot_extra\\chrome.gleam", 1066).
?DOC(false).
-spec resolve_env_cofig() -> {ok, browser_config()} | {error, nil}.
resolve_env_cofig() ->
    gleam@result:'try'(
        envoy_ffi:get(<<"CHROBOT_BROWSER_PATH"/utf8>>),
        fun(Path) ->
            Args = case envoy_ffi:get(<<"CHROBOT_BROWSER_ARGS"/utf8>>) of
                {ok, Args_string} ->
                    gleam@string:split(Args_string, <<"\n"/utf8>>);

                {error, nil} ->
                    get_default_chrome_args()
            end,
            Time_out = case envoy_ffi:get(<<"CHROBOT_BROWSER_TIMEOUT"/utf8>>) of
                {ok, Timeout_string} ->
                    gleam@result:unwrap(
                        gleam_stdlib:parse_int(Timeout_string),
                        10000
                    );

                {error, nil} ->
                    10000
            end,
            Log_level = case envoy_ffi:get(<<"CHROBOT_LOG_LEVEL"/utf8>>) of
                {ok, <<"silent"/utf8>>} ->
                    log_level_silent;

                {ok, <<"warnings"/utf8>>} ->
                    log_level_warnings;

                {ok, <<"info"/utf8>>} ->
                    log_level_info;

                {ok, <<"debug"/utf8>>} ->
                    log_level_debug;

                {ok, _} ->
                    log_level_warnings;

                {error, nil} ->
                    log_level_warnings
            end,
            {ok, {browser_config, Path, Args, Time_out, Log_level}}
        end
    ).

-file("src\\chrobot_extra\\chrome.gleam", 158).
?DOC(
    " Cleverly try to find a chrome installation and launch it with reasonable defaults.\n"
    " \n"
    " 1. If `CHROBOT_BROWSER_PATH` is set, use that\n"
    " 2. If a local chrome installation is found, use that\n"
    " 3. If a system chrome installation is found, use that\n"
    " 4. If none of the above, return an error\n"
    " \n"
    " If you want to always use a specific chrome installation, take a look at `launch_with_config` or \n"
    " `launch_with_env` to set the path explicitly.\n"
    "  \n"
    " Be aware that this function will not validate that the browser launched successfully,\n"
    " please use the higher level functions from the root chrobot module instead if you want these guarantees.\n"
).
-spec launch() -> {ok, gleam@erlang@process:subject(message())} |
    {error, launch_error()}.
launch() ->
    case resolve_env_cofig() of
        {ok, Env_config} ->
            chrobot_extra@internal@utils:info(
                <<"Launching browser using config provided through environment variables"/utf8>>
            ),
            launch_with_config(Env_config);

        {error, _} ->
            gleam@result:'try'(
                gleam@result:lazy_or(
                    get_local_chrome_path(),
                    fun get_system_chrome_path/0
                ),
                fun(Resolved_chrome_path) ->
                    chrobot_extra@internal@utils:info(
                        <<<<"Launching browser from dynamically resolved path: \""/utf8,
                                Resolved_chrome_path/binary>>/binary,
                            "\""/utf8>>
                    ),
                    launch_with_config(
                        {browser_config,
                            Resolved_chrome_path,
                            get_default_chrome_args(),
                            10000,
                            log_level_warnings}
                    )
                end
            )
    end.

-file("src\\chrobot_extra\\chrome.gleam", 191).
?DOC(
    " Like [`launch`](#launch), but launches the browser with a visible window, not\n"
    " in headless mode, which is useful for debugging and development.\n"
).
-spec launch_window() -> {ok, gleam@erlang@process:subject(message())} |
    {error, launch_error()}.
launch_window() ->
    case resolve_env_cofig() of
        {ok, Env_config} ->
            chrobot_extra@internal@utils:info(
                <<"Launching windowed browser using config provided through environment variables"/utf8>>
            ),
            launch_with_config(
                {browser_config,
                    erlang:element(2, Env_config),
                    begin
                        _pipe = erlang:element(3, Env_config),
                        gleam@list:filter(_pipe, fun(Arg) -> case Arg of
                                    <<"--headless"/utf8>> ->
                                        false;

                                    _ ->
                                        true
                                end end)
                    end,
                    erlang:element(4, Env_config),
                    erlang:element(5, Env_config)}
            );

        {error, _} ->
            gleam@result:'try'(
                gleam@result:lazy_or(
                    get_local_chrome_path(),
                    fun get_system_chrome_path/0
                ),
                fun(Resolved_chrome_path) ->
                    chrobot_extra@internal@utils:info(
                        <<<<"Launching windowed browser from dynamically resolved path: \""/utf8,
                                Resolved_chrome_path/binary>>/binary,
                            "\""/utf8>>
                    ),
                    launch_with_config(
                        {browser_config,
                            Resolved_chrome_path,
                            begin
                                _pipe@1 = get_default_chrome_args(),
                                gleam@list:filter(
                                    _pipe@1,
                                    fun(Arg@1) -> case Arg@1 of
                                            <<"--headless"/utf8>> ->
                                                false;

                                            _ ->
                                                true
                                        end end
                                )
                            end,
                            10000,
                            log_level_warnings}
                    )
                end
            )
    end.

-file("src\\chrobot_extra\\chrome.gleam", 250).
?DOC(
    " Launch a browser, and read the configuration from environment variables.\n"
    " The browser path variable must be set, all others will fall back to a default.\n"
    " \n"
    " Be aware that this function will not validate that the browser launched successfully,\n"
    " please use the higher level functions from the root chrobot module instead if you want these guarantees.\n"
    " \n"
    " Configuration variables:\n"
    " - `CHROBOT_BROWSER_PATH` - The path to the browser executable\n"
    " - `CHROBOT_BROWSER_ARGS` - The arguments to pass to the browser, separated by spaces\n"
    " - `CHROBOT_BROWSER_TIMEOUT` - The timeout in milliseconds to wait for the browser to start, must be an integer\n"
    " - `CHROBOT_LOG_LEVEL` - The log level to use, one of `silent`, `warnings`, `info`, `debug`\n"
).
-spec launch_with_env() -> {ok, gleam@erlang@process:subject(message())} |
    {error, launch_error()}.
launch_with_env() ->
    case resolve_env_cofig() of
        {ok, Env_config} ->
            launch_with_config(Env_config);

        {error, _} ->
            chrobot_extra@internal@utils:err(
                <<"Failed to resolve browser configuration from environment variables, please check that they are set correctly"/utf8>>
            ),
            {error, could_not_find_executable}
    end.
