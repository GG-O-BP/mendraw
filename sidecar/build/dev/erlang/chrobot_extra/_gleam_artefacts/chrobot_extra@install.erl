-module(chrobot_extra@install).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\install.gleam").
-export([install_with_config/2, install/0, main/0]).
-export_type([installation_error/0, version_item/0, download_item/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " This module provides basic browser installation functionality, allowing you\n"
    " to install a local version of [Google Chrome for Testing](https://github.com/GoogleChromeLabs/chrome-for-testing) in the current directory on macOS and Linux.\n"
    "\n"
    " ## Usage\n"
    "\n"
    " You may run browser installation directly with\n"
    "\n"
    " ```sh\n"
    " gleam run -m chrobot_extra/install\n"
    " ```\n"
    " When running directly, you can configure the browser version to install by setting the `CHROBOT_TARGET_VERSION` environment variable,\n"
    " it will default to `latest`.\n"
    " You may also set the directory to install under, with `CHROBOT_TARGET_PATH`.\n"
    "\n"
    " The browser will be installed into a directory called `chrome` under the target directory.\n"
    " There is no support for managing multiple browser installations, if an installation is already present for the same version,\n"
    " the script will overwrite it.\n"
    "\n"
    " To uninstall browsers installed by this tool just remove the `chrome` directory created by it, or delete an individual browser\n"
    " installation from inside it.\n"
    "\n"
    " ## Caveats\n"
    "\n"
    " This module attempts to rudimentarily mimic the functionality of the [puppeteer install script](https://pptr.dev/browsers-api),\n"
    " the only goal is to have a quick and convenient way to install browsers locally, for more advanced management of browser\n"
    " installations, please seek out other tools.\n"
    "\n"
    " Supported platforms are limited by what the Google Chrome for Testing distribution supports, which is currently:\n"
    "\n"
    " * linux64\n"
    " * mac-arm64\n"
    " * mac-x64\n"
    " * win32\n"
    " * win64\n"
    "\n"
    " Notably, this distribution **unfortunately does not support ARM64 on Linux**.\n"
    "\n"
    " ### Linux Dependencies\n"
    "\n"
    " The tool does **not** install dependencies on Linux, you must install them yourself.\n"
    "\n"
    " On debian / ubuntu based systems you may install dependencies with the following command:\n"
    "\n"
    " ```sh\n"
    " sudo apt-get update && sudo apt-get install -y \\\n"
    " ca-certificates \\\n"
    " fonts-liberation \\\n"
    " libasound2 \\\n"
    " libatk-bridge2.0-0 \\\n"
    " libatk1.0-0 \\\n"
    " libc6 \\\n"
    " libcairo2 \\\n"
    " libcups2 \\\n"
    " libdbus-1-3 \\\n"
    " libexpat1 \\\n"
    " libfontconfig1 \\\n"
    " libgbm1 \\\n"
    " libgcc1 \\\n"
    " libglib2.0-0 \\\n"
    " libgtk-3-0 \\\n"
    " libnspr4 \\\n"
    " libnss3 \\\n"
    " libpango-1.0-0 \\\n"
    " libpangocairo-1.0-0 \\\n"
    " libstdc++6 \\\n"
    " libx11-6 \\\n"
    " libx11-xcb1 \\\n"
    " libxcb1 \\\n"
    " libxcomposite1 \\\n"
    " libxcursor1 \\\n"
    " libxdamage1 \\\n"
    " libxext6 \\\n"
    " libxfixes3 \\\n"
    " libxi6 \\\n"
    " libxrandr2 \\\n"
    " libxrender1 \\\n"
    " libxss1 \\\n"
    " libxtst6 \\\n"
    " lsb-release \\\n"
    " wget \\\n"
    " xdg-utils\n"
    " ```\n"
).

-type installation_error() :: installation_error.

-type version_item() :: {version_item,
        binary(),
        binary(),
        list(download_item())}.

-type download_item() :: {download_item, binary(), binary()}.

-file("src\\chrobot_extra\\install.gleam", 295).
-spec select_version(binary(), list(version_item())) -> {ok, version_item()} |
    {error, nil}.
select_version(Target, Version_list) ->
    case Target of
        <<"latest"/utf8>> ->
            gleam@list:last(Version_list);

        _ ->
            case gleam_stdlib:contains_string(Target, <<"."/utf8>>) of
                true ->
                    gleam@list:find(
                        Version_list,
                        fun(Item) -> erlang:element(2, Item) =:= Target end
                    );

                false ->
                    _pipe = lists:reverse(Version_list),
                    gleam@list:find(
                        _pipe,
                        fun(Item@1) ->
                            case gleam@string:split(
                                erlang:element(2, Item@1),
                                <<"."/utf8>>
                            ) of
                                [Major | _] when Major =:= Target ->
                                    true;

                                _ ->
                                    false
                            end
                        end
                    )
            end
    end.

-file("src\\chrobot_extra\\install.gleam", 324).
-spec select_download(version_item(), binary()) -> {ok, download_item()} |
    {error, nil}.
select_download(Version, Platform) ->
    gleam@list:find(
        erlang:element(4, Version),
        fun(Item) -> erlang:element(2, Item) =:= Platform end
    ).

-file("src\\chrobot_extra\\install.gleam", 328).
-spec parse_version_list_decoder() -> gleam@dynamic@decode:decoder(list(version_item())).
parse_version_list_decoder() ->
    Download_item_decoder = begin
        gleam@dynamic@decode:field(
            <<"platform"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Platform) ->
                gleam@dynamic@decode:field(
                    <<"url"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Url) ->
                        gleam@dynamic@decode:success(
                            {download_item, Platform, Url}
                        )
                    end
                )
            end
        )
    end,
    Download_list_item_decoder = (gleam@dynamic@decode:field(
        <<"chrome"/utf8>>,
        gleam@dynamic@decode:list(Download_item_decoder),
        fun gleam@dynamic@decode:success/1
    )),
    Version_item_decoder = begin
        gleam@dynamic@decode:field(
            <<"version"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Version) ->
                gleam@dynamic@decode:field(
                    <<"revision"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Revision) ->
                        gleam@dynamic@decode:field(
                            <<"downloads"/utf8>>,
                            Download_list_item_decoder,
                            fun(Downloads) ->
                                gleam@dynamic@decode:success(
                                    {version_item, Version, Revision, Downloads}
                                )
                            end
                        )
                    end
                )
            end
        )
    end,
    gleam@dynamic@decode:field(
        <<"versions"/utf8>>,
        gleam@dynamic@decode:list(Version_item_decoder),
        fun gleam@dynamic@decode:success/1
    ).

-file("src\\chrobot_extra\\install.gleam", 383).
-spec assert_is_json(
    gleam@http@response:response(any()),
    binary(),
    fun(() -> {ok, SRY} | {error, installation_error()})
) -> {ok, SRY} | {error, installation_error()}.
assert_is_json(Res, Human_error, Fun) ->
    case gleam@http@response:get_header(Res, <<"content-type"/utf8>>) of
        {ok, <<"application/json"/utf8>>} ->
            Fun();

        {ok, <<"application/json"/utf8, _/binary>>} ->
            Fun();

        _ ->
            gleam_stdlib:println(<<""/utf8>>),
            chrobot_extra@internal@utils:err(Human_error),
            {error, installation_error}
    end.

-file("src\\chrobot_extra\\install.gleam", 399).
-spec assert_ok(
    {ok, SSC} | {error, any()},
    binary(),
    fun((SSC) -> {ok, SSG} | {error, installation_error()})
) -> {ok, SSG} | {error, installation_error()}.
assert_ok(Result, Human_error, Fun) ->
    case Result of
        {ok, X} ->
            Fun(X);

        {error, Err} ->
            gleam_stdlib:println(<<""/utf8>>),
            chrobot_extra@internal@utils:err(Human_error),
            gleam_stdlib:println(gleam@string:inspect(Err)),
            {error, installation_error}
    end.

-file("src\\chrobot_extra\\install.gleam", 415).
-spec assert_true(
    boolean(),
    binary(),
    fun(() -> {ok, SSL} | {error, installation_error()})
) -> {ok, SSL} | {error, installation_error()}.
assert_true(Condition, Human_error, Fun) ->
    case Condition of
        true ->
            Fun();

        false ->
            gleam_stdlib:println(<<""/utf8>>),
            chrobot_extra@internal@utils:err(Human_error),
            {error, installation_error}
    end.

-file("src\\chrobot_extra\\install.gleam", 485).
-spec new_download_request(binary()) -> {ok,
        gleam@http@request:request(bitstring())} |
    {error, nil}.
new_download_request(Url) ->
    gleam@result:'try'(
        gleam@http@request:to(Url),
        fun(Base_req) -> {ok, gleam@http@request:set_body(Base_req, <<>>)} end
    ).

-file("src\\chrobot_extra\\install.gleam", 347).
-spec resolve_platform() -> {ok, binary()} | {error, binary()}.
resolve_platform() ->
    case {chrobot_extra@internal@os:family(), chrobot_extra_ffi:get_arch()} of
        {darwin, <<"aarch64"/utf8, _/binary>>} ->
            {ok, <<"mac-arm64"/utf8>>};

        {darwin, _} ->
            {ok, <<"mac-x64"/utf8>>};

        {linux, <<"x86_64"/utf8, _/binary>>} ->
            gleam_stdlib:println(<<""/utf8>>),
            chrobot_extra@internal@utils:warn(
                <<"You appear to be on linux, just to let you know, dependencies are not installed automatically by this script,
you must install them yourself! Please check the docs of the install module for further information."/utf8>>
            ),
            {ok, <<"linux64"/utf8>>};

        {windows_nt, <<"x86_64"/utf8, _/binary>>} ->
            {ok, <<"win64"/utf8>>};

        {windows_nt, _} ->
            chrobot_extra@internal@utils:warn(
                <<"The installer thinks you are on a 32-bit Windows system and is installing 32-bit Chrome,
this is unusual, please verify this is correct"/utf8>>
            ),
            {ok, <<"win32"/utf8>>};

        {_, Architecture} ->
            chrobot_extra@internal@utils:err(
                <<<<"Could not resolve an appropriate platform for your system.
Please note that the available platforms are limited by what Google Chrome for Testing supports,
notably, ARM64 on Linux is unfortunately not supported at the moment.
Your architecture is: "/utf8,
                        Architecture/binary>>/binary,
                    "."/utf8>>
            ),
            {error, <<"Unsupported system: "/utf8, Architecture/binary>>}
    end.

-file("src\\chrobot_extra\\install.gleam", 437).
?DOC(
    " Attempt unzip of the downloaded file\n"
    " Notes:\n"
    " The erlang standard library unzip function, does not restore file permissions, and\n"
    " chrome consists of a bunch of executables, setting them all to executable\n"
    " manually is a bit annoying.\n"
    " Therefore, we try to use the system unzip command via a shell instead,\n"
    " and only fall back to the erlang unzip if that fails.\n"
).
-spec unzip(binary(), binary()) -> {ok, nil} | {error, nil}.
unzip(From, To) ->
    chrobot_extra_ffi:run_command(
        <<<<<<"unzip -q "/utf8, From/binary>>/binary, " -d "/utf8>>/binary,
            To/binary>>
    ),
    gleam@result:'try'(
        begin
            _pipe = simplifile_erl:read_directory(To),
            gleam@result:replace_error(_pipe, nil)
        end,
        fun(Installation_dir_entries) ->
            Was_extracted = begin
                _pipe@1 = gleam@list:map(
                    Installation_dir_entries,
                    fun(I) ->
                        simplifile_erl:is_directory(filepath:join(To, I))
                    end
                ),
                gleam@list:any(_pipe@1, fun(Check) -> case Check of
                            {ok, true} ->
                                true;

                            _ ->
                                false
                        end end)
            end,
            case Was_extracted of
                true ->
                    {ok, nil};

                false ->
                    chrobot_extra@internal@utils:warn(
                        <<"Failed to extract downloaded .zip archive using system unzip command, falling back to erlang unzip.
You might run into permission issues when attempting to run the installed binary, this is not ideal!"/utf8>>
                    ),
                    gleam@result:'try'(
                        chrobot_extra_ffi:unzip(From, To),
                        fun(_) ->
                            gleam@result:'try'(
                                begin
                                    _pipe@2 = simplifile:get_files(To),
                                    gleam@result:replace_error(_pipe@2, nil)
                                end,
                                fun(Installation_files) ->
                                    gleam@list:each(
                                        Installation_files,
                                        fun(I@1) ->
                                            case simplifile_erl:is_file(I@1) of
                                                {ok, true} ->
                                                    _ = chrobot_extra_ffi:set_executable(
                                                        I@1
                                                    ),
                                                    nil;

                                                _ ->
                                                    nil
                                            end
                                        end
                                    ),
                                    {ok, nil}
                                end
                            )
                        end
                    )
            end
        end
    ).

-file("src\\chrobot_extra\\install.gleam", 123).
?DOC(
    " Install a specific local version of Google Chrome for Testing to a specific directory.\n"
    " This function is meant to be called in a script, it will log errors and warnings to the console.\n"
    " and return a generic error if installation fails.\n"
).
-spec install_with_config(binary(), binary()) -> {ok, binary()} |
    {error, installation_error()}.
install_with_config(Target_path, Target_version) ->
    Chrome_dir_path = filepath:join(Target_path, <<"chrome"/utf8>>),
    Chrome_dir_path@1 = case Chrome_dir_path of
        <<"./chrome"/utf8>> ->
            <<"chrome"/utf8>>;

        Other ->
            Other
    end,
    gleam_stdlib:println(
        <<<<<<<<"\nPreparing to install Chrome for Testing ("/utf8,
                        Target_version/binary>>/binary,
                    ") into "/utf8>>/binary,
                Chrome_dir_path@1/binary>>/binary,
            ".\n"/utf8>>
    ),
    case chrobot_extra@chrome:get_local_chrome_path_at(Chrome_dir_path@1) of
        {ok, Local_chrome_path} ->
            chrobot_extra@internal@utils:warn(
                <<<<"You already have a local Chrome installation at this path:\n"/utf8,
                        Local_chrome_path/binary>>/binary,
                    "
Chrobot does not support managing multiple browser installations,
you are encouraged to remove old installations manually if you no longer need them."/utf8>>
            );

        {error, _} ->
            nil
    end,
    assert_ok(
        resolve_platform(),
        <<"Platform unsupported"/utf8>>,
        fun(Platform) ->
            P = chrobot_extra@internal@utils:start_progress(
                <<"Fetching available versions..."/utf8>>
            ),
            assert_ok(
                gleam@http@request:to(
                    <<"https://googlechromelabs.github.io/chrome-for-testing/known-good-versions-with-downloads.json"/utf8>>
                ),
                <<"Failed to build version request"/utf8>>,
                fun(Req) ->
                    assert_ok(
                        gleam@httpc:send(Req),
                        <<"Version list request failed, ensure you have an active internet connection."/utf8>>,
                        fun(Res) ->
                            assert_true(
                                erlang:element(2, Res) =:= 200,
                                <<"Version list request returned a non-200 status code."/utf8>>,
                                fun() ->
                                    assert_is_json(
                                        Res,
                                        <<"Version list request returned a response that is not JSON."/utf8>>,
                                        fun() ->
                                            assert_ok(
                                                gleam@json:parse(
                                                    erlang:element(4, Res),
                                                    parse_version_list_decoder()
                                                ),
                                                <<"Failed to decode version list JSON - Maybe the API has changed or is down?"/utf8>>,
                                                fun(Version_list) ->
                                                    assert_ok(
                                                        select_version(
                                                            Target_version,
                                                            Version_list
                                                        ),
                                                        <<<<"Failed to find version "/utf8,
                                                                Target_version/binary>>/binary,
                                                            " in version list"/utf8>>,
                                                        fun(Version) ->
                                                            assert_ok(
                                                                select_download(
                                                                    Version,
                                                                    Platform
                                                                ),
                                                                <<<<<<"Failed to find download for platform "/utf8,
                                                                            Platform/binary>>/binary,
                                                                        " in version "/utf8>>/binary,
                                                                    (erlang:element(
                                                                        2,
                                                                        Version
                                                                    ))/binary>>,
                                                                fun(Download) ->
                                                                    chrobot_extra@internal@utils:stop_progress(
                                                                        P
                                                                    ),
                                                                    gleam_stdlib:println(
                                                                        <<<<<<<<"\nSelected version "/utf8,
                                                                                        (erlang:element(
                                                                                            2,
                                                                                            Version
                                                                                        ))/binary>>/binary,
                                                                                    " for platform "/utf8>>/binary,
                                                                                (erlang:element(
                                                                                    2,
                                                                                    Download
                                                                                ))/binary>>/binary,
                                                                            "\n"/utf8>>
                                                                    ),
                                                                    P@1 = chrobot_extra@internal@utils:start_progress(
                                                                        <<"Downloading Chrome for Testing..."/utf8>>
                                                                    ),
                                                                    assert_ok(
                                                                        new_download_request(
                                                                            erlang:element(
                                                                                3,
                                                                                Download
                                                                            )
                                                                        ),
                                                                        <<"Failed to build download request"/utf8>>,
                                                                        fun(
                                                                            Download_request
                                                                        ) ->
                                                                            assert_ok(
                                                                                gleam@httpc:send_bits(
                                                                                    Download_request
                                                                                ),
                                                                                <<"Download request failed, ensure you have an active internet connection"/utf8>>,
                                                                                fun(
                                                                                    Download_res
                                                                                ) ->
                                                                                    assert_true(
                                                                                        erlang:element(
                                                                                            2,
                                                                                            Download_res
                                                                                        )
                                                                                        =:= 200,
                                                                                        <<"Download request returned a non-200 status code"/utf8>>,
                                                                                        fun(
                                                                                            
                                                                                        ) ->
                                                                                            chrobot_extra@internal@utils:set_progress(
                                                                                                P@1,
                                                                                                <<"Writing download to disk..."/utf8>>
                                                                                            ),
                                                                                            Download_path = filepath:join(
                                                                                                Chrome_dir_path@1,
                                                                                                <<<<<<"chrome_download_"/utf8,
                                                                                                            (erlang:element(
                                                                                                                2,
                                                                                                                Download
                                                                                                            ))/binary>>/binary,
                                                                                                        (erlang:element(
                                                                                                            3,
                                                                                                            Version
                                                                                                        ))/binary>>/binary,
                                                                                                    ".zip"/utf8>>
                                                                                            ),
                                                                                            Installation_dir = filepath:join(
                                                                                                Chrome_dir_path@1,
                                                                                                <<<<Platform/binary,
                                                                                                        "-"/utf8>>/binary,
                                                                                                    (erlang:element(
                                                                                                        2,
                                                                                                        Version
                                                                                                    ))/binary>>
                                                                                            ),
                                                                                            assert_ok(
                                                                                                simplifile:create_directory_all(
                                                                                                    Installation_dir
                                                                                                ),
                                                                                                <<"Failed to create directory"/utf8>>,
                                                                                                fun(
                                                                                                    _
                                                                                                ) ->
                                                                                                    assert_ok(
                                                                                                        simplifile_erl:write_bits(
                                                                                                            Download_path,
                                                                                                            erlang:element(
                                                                                                                4,
                                                                                                                Download_res
                                                                                                            )
                                                                                                        ),
                                                                                                        <<"Failed to write download to disk"/utf8>>,
                                                                                                        fun(
                                                                                                            _
                                                                                                        ) ->
                                                                                                            chrobot_extra@internal@utils:set_progress(
                                                                                                                P@1,
                                                                                                                <<"Extracting download..."/utf8>>
                                                                                                            ),
                                                                                                            assert_ok(
                                                                                                                unzip(
                                                                                                                    Download_path,
                                                                                                                    Installation_dir
                                                                                                                ),
                                                                                                                <<"Failed to extract downloaded .zip archive"/utf8>>,
                                                                                                                fun(
                                                                                                                    _
                                                                                                                ) ->
                                                                                                                    assert_ok(
                                                                                                                        simplifile_erl:delete(
                                                                                                                            Download_path
                                                                                                                        ),
                                                                                                                        <<"Failed to remove downloaded .zip archive! The installation should otherwise have succeeded."/utf8>>,
                                                                                                                        fun(
                                                                                                                            _
                                                                                                                        ) ->
                                                                                                                            assert_ok(
                                                                                                                                simplifile:get_files(
                                                                                                                                    Installation_dir
                                                                                                                                ),
                                                                                                                                <<"Failed to scan installation directory for executable"/utf8>>,
                                                                                                                                fun(
                                                                                                                                    Haystack
                                                                                                                                ) ->
                                                                                                                                    assert_ok(
                                                                                                                                        gleam@list:find(
                                                                                                                                            Haystack,
                                                                                                                                            fun(
                                                                                                                                                File
                                                                                                                                            ) ->
                                                                                                                                                chrobot_extra@chrome:is_local_chrome_path(
                                                                                                                                                    File,
                                                                                                                                                    chrobot_extra@internal@os:family(
                                                                                                                                                        
                                                                                                                                                    )
                                                                                                                                                )
                                                                                                                                            end
                                                                                                                                        ),
                                                                                                                                        <<"Failed to find executable in installation directory"/utf8>>,
                                                                                                                                        fun(
                                                                                                                                            Executable
                                                                                                                                        ) ->
                                                                                                                                            chrobot_extra@internal@utils:stop_progress(
                                                                                                                                                P@1
                                                                                                                                            ),
                                                                                                                                            case chrobot_extra@internal@os:family(
                                                                                                                                                
                                                                                                                                            ) of
                                                                                                                                                linux ->
                                                                                                                                                    chrobot_extra@internal@utils:hint(
                                                                                                                                                        <<"You can run the following command to check wich depencies are missing on your system:"/utf8>>
                                                                                                                                                    ),
                                                                                                                                                    chrobot_extra@internal@utils:show_cmd(
                                                                                                                                                        <<<<"ldd \""/utf8,
                                                                                                                                                                Executable/binary>>/binary,
                                                                                                                                                            "\" | grep not"/utf8>>
                                                                                                                                                    );

                                                                                                                                                _ ->
                                                                                                                                                    nil
                                                                                                                                            end,
                                                                                                                                            chrobot_extra@internal@utils:info(
                                                                                                                                                <<<<<<<<<<"Chrome for Testing ("/utf8,
                                                                                                                                                                    (erlang:element(
                                                                                                                                                                        2,
                                                                                                                                                                        Version
                                                                                                                                                                    ))/binary>>/binary,
                                                                                                                                                                ") installed successfully! The executable is located at:\n"/utf8>>/binary,
                                                                                                                                                            Executable/binary>>/binary,
                                                                                                                                                        "\n"/utf8>>/binary,
                                                                                                                                                    "When using the `launch` command, chrobot should automatically use this local installation."/utf8>>
                                                                                                                                            ),
                                                                                                                                            {ok,
                                                                                                                                                Executable}
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
                                        end
                                    )
                                end
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src\\chrobot_extra\\install.gleam", 113).
?DOC(
    " Install a local version of Google Chrome for Testing.\n"
    " This function is meant to be called in a script, it will log errors and warnings to the console.\n"
    " and return a generic error if installation fails.\n"
).
-spec install() -> {ok, binary()} | {error, installation_error()}.
install() ->
    Target_version = gleam@result:unwrap(
        envoy_ffi:get(<<"CHROBOT_TARGET_VERSION"/utf8>>),
        <<"latest"/utf8>>
    ),
    Target_path = gleam@result:unwrap(
        envoy_ffi:get(<<"CHROBOT_TARGET_PATH"/utf8>>),
        <<"."/utf8>>
    ),
    install_with_config(Target_path, Target_version).

-file("src\\chrobot_extra\\install.gleam", 106).
-spec main() -> {ok, binary()} | {error, installation_error()}.
main() ->
    install().
