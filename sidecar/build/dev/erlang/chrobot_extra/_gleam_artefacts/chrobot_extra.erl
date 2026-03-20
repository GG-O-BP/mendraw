-module(chrobot_extra).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra.gleam").
-export([open/3, with_timeout/2, to_file/2, as_value/2, quit/1, defer_quit/2, page_caller/1, close/1, screenshot/1, pdf/1, down_key/3, up_key/3, press_key/2, insert_char/2, type_text/2, await_load_event/2, launch/0, launch_window/0, launch_with_config/1, launch_with_env/0, eval/2, eval_to_value/2, eval_async/2, get_all_html/1, select/2, select_all/2, call_custom_function_on/5, to_value/3, get_attribute/3, get_property/4, get_text/2, get_inner_html/2, get_outer_html/2, call_custom_function_on_raw/4, click/2, click_selector/2, focus/2, focus_selector/2, call_custom_function_on_object/4, select_from/3, select_all_from/3, poll/2, await_selector/2, create_page/3]).
-export_type([page/0, encoded_file/0, call_argument/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " Welcome to Chrobot! 🤖\n"
    " This module exposes high level functions for browser automation.\n"
    "\n"
    " Some basic concepts:\n"
    "\n"
    " - You'll first want to [`launch`](#launch) an instance of the browser and receive a `Subject` which allows\n"
    " you to send messages to the browser (actor)\n"
    " - You can [`open`](#open) a [`Page`](#Page), which makes the browser browse to a website\n"
    " - Use [`await_selector`](#await_selector) to wait for an element to appear on the page before you interact with it!\n"
    " - You can interact with the page by calling functions in this module with the [`Page`](#Page) you received from [`open`](#open)\n"
    " - For extracting information from the page, select elements with [`select`](#select) or [`select_all`](#select_all),\n"
    "   then use [`get_text`](#get_text), [`get_attribute`](#get_attribute), [`get_property`](#get_property) or [`get_inner_html`](#get_inner_html)\n"
    " - To simulate user input, use [`press_key`](#press_key), [`type_text`](#type_text), [`click`](#click) and [`focus`](#focus)\n"
    " - If you want to make raw protocol calls, you can use [`page_caller`](#page_caller), to create a callback to pass to protocol commands from your [`Page`](#Page)\n"
    " - When you are done with the browser, you should call [`quit`](#quit) to shut it down gracefully\n"
    "\n"
    " The functions in this module just make calls to [`protocol/`](/chrobot/protocol.html)  modules, if you\n"
    " would like to customize the behaviour, take a look at them to see how to make\n"
    " direct protocol calls and pass different defaults.\n"
    "\n"
    " Something to consider:\n"
    " A lot of the functions in this module are interpolating their parameters into\n"
    " JavaScript expressions that are evaluated in the page context.\n"
    " No attempt is made to escape the passed parameters or prevent script injection through them,\n"
    " you should not use the functions in this module with arbitrary strings if you want\n"
    " to treat the pages you are operating on as a secure context.\n"
    "\n"
).

-type page() :: {page,
        gleam@erlang@process:subject(chrobot_extra@chrome:message()),
        integer(),
        chrobot_extra@protocol@target:target_i_d(),
        chrobot_extra@protocol@target:session_i_d()}.

-type encoded_file() :: {encoded_file, binary(), binary()}.

-type call_argument() :: {string_arg, binary()} |
    {int_arg, integer()} |
    {float_arg, float()} |
    {bool_arg, boolean()} |
    {array_arg, list(call_argument())}.

-file("src\\chrobot_extra.gleam", 158).
?DOC(
    " Open a new page in the browser.\n"
    " Returns a response when the protocol call succeeds, please use\n"
    " [`await_selector`](#await_selector) to determine when the page is ready.\n"
    " The timeout passed to this function will be attached to the returned\n"
    " [`Page`](#Page) type to be reused by other functions in this module.\n"
    " You can always adjust it using [`with_timeout`](#with_timeout).\n"
).
-spec open(
    gleam@erlang@process:subject(chrobot_extra@chrome:message()),
    binary(),
    integer()
) -> {ok, page()} | {error, chrobot_extra@chrome:request_error()}.
open(Browser_subject, Url, Time_out) ->
    gleam@result:'try'(
        chrobot_extra@protocol@target:create_target(
            fun(Method, Params) ->
                chrobot_extra@chrome:call(
                    Browser_subject,
                    Method,
                    Params,
                    none,
                    Time_out
                )
            end,
            Url,
            {some, 1920},
            {some, 1080},
            none,
            none
        ),
        fun(Target_response) ->
            gleam@result:'try'(
                chrobot_extra@protocol@target:attach_to_target(
                    fun(Method@1, Params@1) ->
                        chrobot_extra@chrome:call(
                            Browser_subject,
                            Method@1,
                            Params@1,
                            none,
                            Time_out
                        )
                    end,
                    erlang:element(2, Target_response),
                    {some, true}
                ),
                fun(Session_response) ->
                    {ok,
                        {page,
                            Browser_subject,
                            Time_out,
                            erlang:element(2, Target_response),
                            erlang:element(2, Session_response)}}
                end
            )
        end
    ).

-file("src\\chrobot_extra.gleam", 215).
?DOC(" Return an updated `Page` with the desired timeout to apply, in milliseconds\n").
-spec with_timeout(page(), integer()) -> page().
with_timeout(Page, Time_out) ->
    {page,
        erlang:element(2, Page),
        Time_out,
        erlang:element(4, Page),
        erlang:element(5, Page)}.

-file("src\\chrobot_extra.gleam", 267).
?DOC(
    " Write a file returned from [`screenshot`](#screenshot) or [`pdf`](#pdf) to a file.\n"
    " File path should not include the file extension, it will be appended automatically!\n"
    " Will return a FileError from the `simplifile` package if not successfull\n"
).
-spec to_file(encoded_file(), binary()) -> {ok, nil} |
    {error, simplifile:file_error()}.
to_file(Input, Path) ->
    Res = begin
        _pipe = gleam@bit_array:base64_decode(erlang:element(2, Input)),
        gleam@result:replace_error(
            _pipe,
            {unknown, <<"Could not decode base64 string"/utf8>>}
        )
    end,
    gleam@result:'try'(
        Res,
        fun(Binary) ->
            simplifile_erl:write_bits(
                <<<<Path/binary, "."/utf8>>/binary,
                    (erlang:element(3, Input))/binary>>,
                Binary
            )
        end
    ).

-file("src\\chrobot_extra.gleam", 366).
?DOC(
    " Cast a RemoteObject into a value by passing a dynamic decoder.\n"
    " This is a convenience for when you know a RemoteObject is returned by value and not ID,\n"
    " and you want to extract the value from it.\n"
    " Because it accepts a Result, you can chain this to [`eval`](#eval) or [`eval_async`](#eval_async) like so:\n"
    " ```gleam\n"
    " eval(page, \"window.document.documentElement.outerHTML\")\n"
    "   |> as_value(decode_string)\n"
    " ```\n"
).
-spec as_value(
    {ok, chrobot_extra@protocol@runtime:remote_object()} |
        {error, chrobot_extra@chrome:request_error()},
    gleam@dynamic@decode:decoder(RWH)
) -> {ok, RWH} | {error, chrobot_extra@chrome:request_error()}.
as_value(Result, Decoder) ->
    case Result of
        {ok, {remote_object, _, _, _, {some, Value}, _, _, _}} ->
            _pipe = gleam@dynamic@decode:run(Value, Decoder),
            gleam@result:replace_error(_pipe, protocol_error);

        {error, Something} ->
            {error, Something};

        _ ->
            {error, not_found_error}
    end.

-file("src\\chrobot_extra.gleam", 746).
?DOC(" Quit the browser (alias for [`chrome.quit`](/chrobot/chrome.html#quit))\n").
-spec quit(gleam@erlang@process:subject(chrobot_extra@chrome:message())) -> {ok,
        nil} |
    {error, chrobot_extra@chrome:request_error()}.
quit(Browser) ->
    chrobot_extra@chrome:quit(Browser).

-file("src\\chrobot_extra.gleam", 758).
?DOC(
    " Convenience function that lets you defer quitting the browser after you are done with it,\n"
    " it's meant for a `use` expression like this:\n"
    "\n"
    " ```gleam\n"
    " let assert Ok(browser_subject) = browser.launch()\n"
    " use <- browser.defer_quit(browser_subject)\n"
    " // do stuff with the browser\n"
    " ```\n"
).
-spec defer_quit(
    gleam@erlang@process:subject(chrobot_extra@chrome:message()),
    fun(() -> any())
) -> {ok, nil} | {error, chrobot_extra@chrome:request_error()}.
defer_quit(Browser, Body) ->
    Body(),
    chrobot_extra@chrome:quit(Browser).

-file("src\\chrobot_extra.gleam", 823).
?DOC(
    " Cast a session in the target.SessionID type to the\n"
    " string expected by the `chrome` module\n"
).
-spec pass_session(chrobot_extra@protocol@target:session_i_d()) -> gleam@option:option(binary()).
pass_session(Session_id) ->
    case Session_id of
        {session_i_d, Value} ->
            {some, Value}
    end.

-file("src\\chrobot_extra.gleam", 845).
?DOC(
    " Create callback to pass to protocol commands from a `Page`\n"
    " This is useful when you want to make raw protocol calls\n"
    "\n"
    " ## Example\n"
    " ```gleam\n"
    " import chrobot_extra.{open, page_caller}\n"
    " import gleam/option.{None}\n"
    " import chrobot_extra/protocol/page\n"
    " pub fn main() {\n"
    "   let assert Ok(browser) = chrobot_extra.launch()\n"
    "   let assert Ok(page) = open(browser, \"https://example.com\", 5000)\n"
    "   let callback = page_caller(page)\n"
    "   let assert Ok(_) =\n"
    "     page.navigate(callback, \"https://gleam.run\", None, None, None)\n"
    " }\n"
    " ```\n"
).
-spec page_caller(page()) -> fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
        gleam@dynamic:dynamic_()} |
    {error, chrobot_extra@chrome:request_error()}).
page_caller(Page) ->
    fun(Method, Params) ->
        chrobot_extra@chrome:call(
            erlang:element(2, Page),
            Method,
            Params,
            pass_session(erlang:element(5, Page)),
            erlang:element(3, Page)
        )
    end.

-file("src\\chrobot_extra.gleam", 192).
?DOC(" Close the passed page\n").
-spec close(page()) -> {ok, gleam@dynamic:dynamic_()} |
    {error, chrobot_extra@chrome:request_error()}.
close(Page) ->
    chrobot_extra@protocol@target:close_target(
        page_caller(Page),
        erlang:element(4, Page)
    ).

-file("src\\chrobot_extra.gleam", 223).
?DOC(
    " Capture a screenshot of the current page and return it as a base64 encoded string\n"
    " The Ok(result) of this function can be passed to [`to_file`](#to_file)\n"
    "\n"
    " If you want to customize the settings of the output image, use [`page.capture_screenshot`](/chrobot/protocol/page.html#capture_screenshot) directly.\n"
).
-spec screenshot(page()) -> {ok, encoded_file()} |
    {error, chrobot_extra@chrome:request_error()}.
screenshot(Page) ->
    gleam@result:'try'(
        chrobot_extra@protocol@page:capture_screenshot(
            page_caller(Page),
            {some, capture_screenshot_format_png},
            none,
            none
        ),
        fun(Response) ->
            {ok, {encoded_file, erlang:element(2, Response), <<"png"/utf8>>}}
        end
    ).

-file("src\\chrobot_extra.gleam", 241).
?DOC(
    " Export the current page as PDF and return it as a base64 encoded string.\n"
    " Transferring the encoded file from the browser to the chrome agent can take a pretty long time,\n"
    " depending on the document size.\n"
    " Consider setting a larger timeout, you can use `with_timeout` on your existing `Page` to do this.\n"
    " The Ok(result) of this function can be passed to `to_file`\n"
    "\n"
    " If you want to customize the settings of the output document, use [`page.print_to_pdf`](/chrobot/protocol/page.html#print_to_pdf) directly.\n"
).
-spec pdf(page()) -> {ok, encoded_file()} |
    {error, chrobot_extra@chrome:request_error()}.
pdf(Page) ->
    gleam@result:'try'(
        chrobot_extra@protocol@page:print_to_pdf(
            page_caller(Page),
            {some, false},
            {some, false},
            none,
            none,
            none,
            none,
            none,
            none,
            none,
            none,
            none,
            none,
            none,
            none
        ),
        fun(Response) ->
            {ok, {encoded_file, erlang:element(2, Response), <<"pdf"/utf8>>}}
        end
    ).

-file("src\\chrobot_extra.gleam", 451).
?DOC(
    " Simulate a keydown event for a given key.\n"
    "\n"
    " You can pass in latin characters, digits and some DOM key names,\n"
    " The keymap is based on the US keyboard layout.\n"
    "\n"
    " [⌨️ You can see the supported key values here](https://github.com/JonasGruenwald/chrobot/blob/main/src/chrobot/internal/keymap.gleam)\n"
).
-spec down_key(page(), binary(), integer()) -> {ok, nil} |
    {error, chrobot_extra@chrome:request_error()}.
down_key(Page, Key, Modifiers) ->
    Key_data_result = chrobot_extra@internal@keymap:get_key_data(Key),
    case Key_data_result of
        {ok, Key_data} ->
            Text@1 = (case erlang:element(5, Key_data) of
                {some, Text} ->
                    {some, Text};

                none ->
                    {some, Key}
            end),
            _pipe = chrobot_extra@protocol@input:dispatch_key_event(
                page_caller(Page),
                (case Text@1 of
                    {some, _} ->
                        dispatch_key_event_type_key_down;

                    none ->
                        dispatch_key_event_type_raw_key_down
                end),
                {some, Modifiers},
                none,
                Text@1,
                Text@1,
                none,
                erlang:element(3, Key_data),
                erlang:element(4, Key_data),
                erlang:element(2, Key_data),
                none,
                none,
                (case erlang:element(6, Key_data) of
                    {some, 3} ->
                        {some, true};

                    _ ->
                        none
                end),
                none,
                erlang:element(6, Key_data)
            ),
            gleam@result:replace(_pipe, nil);

        {error, nil} ->
            chrobot_extra@internal@utils:warn(
                <<<<"You are attempting to trigger a key which is not supported
by the chrobot virtual keyboard.
The key to be pressed down is: '"/utf8,
                        Key/binary>>/binary,
                    "'.
Chrobot simulates a US keyboard layout,
it's best to stick to ASCII characters and DOM key names!"/utf8>>
            ),
            {error, not_found_error}
    end.

-file("src\\chrobot_extra.gleam", 507).
?DOC(
    " Simulate a keyup event for a given key.\n"
    "\n"
    " You can pass in latin characters, digits and some DOM key names,\n"
    " The keymap is based on the US keyboard layout.\n"
    "\n"
    " [⌨️ You can see the supported key values here](https://github.com/JonasGruenwald/chrobot/blob/main/src/chrobot/internal/keymap.gleam)\n"
).
-spec up_key(page(), binary(), integer()) -> {ok, nil} |
    {error, chrobot_extra@chrome:request_error()}.
up_key(Page, Key, Modifiers) ->
    Key_data_result = chrobot_extra@internal@keymap:get_key_data(Key),
    case Key_data_result of
        {ok, Key_data} ->
            _pipe = chrobot_extra@protocol@input:dispatch_key_event(
                page_caller(Page),
                dispatch_key_event_type_key_up,
                {some, Modifiers},
                none,
                erlang:element(5, Key_data),
                erlang:element(5, Key_data),
                none,
                erlang:element(3, Key_data),
                erlang:element(4, Key_data),
                erlang:element(2, Key_data),
                none,
                none,
                (case erlang:element(6, Key_data) of
                    {some, 3} ->
                        {some, true};

                    _ ->
                        none
                end),
                none,
                erlang:element(6, Key_data)
            ),
            gleam@result:replace(_pipe, nil);

        {error, nil} ->
            chrobot_extra@internal@utils:warn(
                <<<<"You are attempting to trigger a key which is not supported
by the chrobot virtual keyboard.
The key to be released is: '"/utf8,
                        Key/binary>>/binary,
                    "'.
Chrobot simulates a US keyboard layout,
it's best to stick to ASCII characters and DOM key names!"/utf8>>
            ),
            {error, not_found_error}
    end.

-file("src\\chrobot_extra.gleam", 555).
?DOC(
    " Simulate a keypress for a given key.\n"
    " This will trigger a keydown and keyup event in sequence.\n"
    "\n"
    " You can pass in latin characters, digits and some DOM key names,\n"
    " The keymap is based on the US keyboard layout.\n"
    "\n"
    " [⌨️ You can see the supported key values here](https://github.com/JonasGruenwald/chrobot/blob/main/src/chrobot/internal/keymap.gleam)\n"
    "\n"
    " If you want to insert a whole string into an input field, use `type_text` instead.\n"
).
-spec press_key(page(), binary()) -> {ok, nil} |
    {error, chrobot_extra@chrome:request_error()}.
press_key(Page, Key) ->
    gleam@result:'try'(
        down_key(Page, Key, 0),
        fun(_) -> up_key(Page, Key, 0) end
    ).

-file("src\\chrobot_extra.gleam", 563).
?DOC(
    " Insert the given character into a [focus](#focus)ed input field by sending a `char` keyboard event.\n"
    " Note that this does not trigger a keydown or keyup event, see [`press_key`](#press_key) for that.\n"
    " If you want to insert a whole string into an input field, use [`type_text`](#type_text) instead.\n"
).
-spec insert_char(page(), binary()) -> {ok, nil} |
    {error, chrobot_extra@chrome:request_error()}.
insert_char(Page, Key) ->
    _pipe = chrobot_extra@protocol@input:dispatch_key_event(
        page_caller(Page),
        dispatch_key_event_type_char,
        none,
        none,
        {some, Key},
        none,
        none,
        none,
        none,
        none,
        none,
        none,
        none,
        none,
        none
    ),
    gleam@result:replace(_pipe, nil).

-file("src\\chrobot_extra.gleam", 590).
?DOC(
    " Type text by simulating keypresses for each character in the input string.\n"
    " Note: If a character is not supported by the virtual keyboard, it will be inserted using a char event,\n"
    " which will not produce keydown or keyup events.\n"
    " [⌨️ You can see the key values supported by the virtual keyboard here](https://github.com/JonasGruenwald/chrobot/blob/main/src/chrobot/internal/keymap.gleam)\n"
    "\n"
    " If you want to type text into an input field, make sure to [`focus`](#focus) it first!\n"
).
-spec type_text(page(), binary()) -> {ok, nil} |
    {error, chrobot_extra@chrome:request_error()}.
type_text(Page, Input) ->
    _pipe = gleam@string:to_graphemes(Input),
    _pipe@1 = gleam@list:map(
        _pipe,
        fun(Char) -> case chrobot_extra@internal@keymap:get_key_data(Char) of
                {ok, _} ->
                    press_key(Page, Char);

                {error, _} ->
                    insert_char(Page, Char)
            end end
    ),
    _pipe@2 = gleam@result:all(_pipe@1),
    gleam@result:replace(_pipe@2, nil).

-file("src\\chrobot_extra.gleam", 737).
?DOC(
    " Block until the page load event has fired.\n"
    " Note that with local pages, the load event can often fire\n"
    " before the handler is attached.\n"
    " It's best to use [`await_selector`](#await_selector) instead of this\n"
).
-spec await_load_event(
    gleam@erlang@process:subject(chrobot_extra@chrome:message()),
    page()
) -> {ok, gleam@dynamic:dynamic_()} |
    {error, chrobot_extra@chrome:request_error()}.
await_load_event(Browser, Page) ->
    gleam@result:'try'(
        chrobot_extra@protocol@page:enable(page_caller(Page)),
        fun(_) ->
            chrobot_extra@chrome:listen_once(
                Browser,
                <<"Page.loadEventFired"/utf8>>,
                erlang:element(3, Page)
            )
        end
    ).

-file("src\\chrobot_extra.gleam", 859).
?DOC(
    " Validate that the browser responds to protocol messages,\n"
    " and that the protocol version matches the one supported by this library.\n"
).
-spec validate_launch(
    {ok, gleam@erlang@process:subject(chrobot_extra@chrome:message())} |
        {error, chrobot_extra@chrome:launch_error()}
) -> {ok, gleam@erlang@process:subject(chrobot_extra@chrome:message())} |
    {error, chrobot_extra@chrome:launch_error()}.
validate_launch(Launch_result) ->
    gleam@result:'try'(
        Launch_result,
        fun(Instance) ->
            {Major, Minor} = chrobot_extra@protocol:version(),
            Target_protocol_version = <<<<Major/binary, "."/utf8>>/binary,
                Minor/binary>>,
            Version_response = begin
                _pipe = chrobot_extra@chrome:get_version(Instance),
                gleam@result:replace_error(_pipe, unresponsive_after_start)
            end,
            gleam@result:'try'(
                Version_response,
                fun(Actual_version) ->
                    case Target_protocol_version =:= erlang:element(
                        2,
                        Actual_version
                    ) of
                        true ->
                            {ok, Instance};

                        false ->
                            {error,
                                {protocol_version_mismatch,
                                    Target_protocol_version,
                                    erlang:element(2, Actual_version)}}
                    end
                end
            )
        end
    ).

-file("src\\chrobot_extra.gleam", 79).
?DOC(
    " ✨Cleverly✨ try to find a chrome installation and launch it with reasonable defaults.\n"
    "\n"
    " 1. If `CHROBOT_BROWSER_PATH` is set, use that\n"
    " 2. If a local chrome installation is found, use that\n"
    " 3. If a system chrome installation is found, use that\n"
    " 4. If none of the above, return an error\n"
    "\n"
    " If you want to always use a specific chrome installation, take a look at [`launch_with_config`](#launch_with_config) or\n"
    " [`launch_with_env`](#launch_with_env) to set the path explicitly.\n"
    "\n"
    " This function will validate that the browser launched successfully, and the\n"
    " protocol version matches the one supported by this library.\n"
).
-spec launch() -> {ok,
        gleam@erlang@process:subject(chrobot_extra@chrome:message())} |
    {error, chrobot_extra@chrome:launch_error()}.
launch() ->
    Launch_result = validate_launch(chrobot_extra@chrome:launch()),
    case Launch_result of
        {error, could_not_find_executable} ->
            chrobot_extra@internal@utils:err(
                <<"Chrobot could not find a chrome executable to launch!\n"/utf8>>
            ),
            chrobot_extra@internal@utils:hint(
                <<"You can install a local version of chrome for testing with this command:"/utf8>>
            ),
            chrobot_extra@internal@utils:show_cmd(
                <<"gleam run -m chrobot_extra/install"/utf8>>
            ),
            Launch_result;

        Other ->
            Other
    end.

-file("src\\chrobot_extra.gleam", 98).
?DOC(
    " Like [`launch`](#launch), but launches the browser with a visible window, not\n"
    " in headless mode, which is useful for debugging and development.\n"
).
-spec launch_window() -> {ok,
        gleam@erlang@process:subject(chrobot_extra@chrome:message())} |
    {error, chrobot_extra@chrome:launch_error()}.
launch_window() ->
    Launch_result = validate_launch(chrobot_extra@chrome:launch_window()),
    case Launch_result of
        {error, could_not_find_executable} ->
            chrobot_extra@internal@utils:err(
                <<"Chrobot could not find a chrome executable to launch!\n"/utf8>>
            ),
            chrobot_extra@internal@utils:hint(
                <<"You can install a local version of chrome for testing with this command:"/utf8>>
            ),
            chrobot_extra@internal@utils:show_cmd(
                <<"gleam run -m chrobot_extra/install"/utf8>>
            ),
            Launch_result;

        Other ->
            Other
    end.

-file("src\\chrobot_extra.gleam", 130).
?DOC(
    " Launch a browser with the given configuration,\n"
    " to populate the arguments, use [`chrome.get_default_chrome_args`](/chrobot/chrome.html#get_default_chrome_args).\n"
    " This function will validate that the browser launched successfully, and the\n"
    " protocol version matches the one supported by this library.\n"
    "\n"
    " ## Example\n"
    " ```gleam\n"
    " let config =\n"
    " browser.BrowserConfig(\n"
    "   path: \"chrome/linux-116.0.5793.0/chrome-linux64/chrome\",\n"
    "   args: chrome.get_default_chrome_args(),\n"
    "   start_timeout: 5000,\n"
    " )\n"
    " let assert Ok(browser_subject) = launch_with_config(config)\n"
    " ```\n"
).
-spec launch_with_config(chrobot_extra@chrome:browser_config()) -> {ok,
        gleam@erlang@process:subject(chrobot_extra@chrome:message())} |
    {error, chrobot_extra@chrome:launch_error()}.
launch_with_config(Config) ->
    validate_launch(chrobot_extra@chrome:launch_with_config(Config)).

-file("src\\chrobot_extra.gleam", 148).
?DOC(
    " Launch a browser, and read the configuration from environment variables.\n"
    " The browser path variable must be set, all others will fall back to a default.\n"
    "\n"
    " This function will validate that the browser launched successfully, and the\n"
    " protocol version matches the one supported by this library.\n"
    "\n"
    " Configuration variables:\n"
    " - `CHROBOT_BROWSER_PATH` - The path to the browser executable\n"
    " - `CHROBOT_BROWSER_ARGS` - The arguments to pass to the browser, separated by spaces\n"
    " - `CHROBOT_BROWSER_TIMEOUT` - The timeout in milliseconds to wait for the browser to start, must be an integer\n"
    " - `CHROBOT_LOG_LEVEL` - The log level to use, one of `silent`, `warnings`, `info`, `debug`\n"
).
-spec launch_with_env() -> {ok,
        gleam@erlang@process:subject(chrobot_extra@chrome:message())} |
    {error, chrobot_extra@chrome:launch_error()}.
launch_with_env() ->
    validate_launch(chrobot_extra@chrome:launch_with_env()).

-file("src\\chrobot_extra.gleam", 879).
-spec handle_eval_response(
    {ok, chrobot_extra@protocol@runtime:evaluate_response()} |
        {error, chrobot_extra@chrome:request_error()}
) -> {ok, chrobot_extra@protocol@runtime:remote_object()} |
    {error, chrobot_extra@chrome:request_error()}.
handle_eval_response(Eval_response) ->
    case Eval_response of
        {ok, {evaluate_response, _, {some, Exception}}} ->
            {error,
                {runtime_exception,
                    erlang:element(3, Exception),
                    erlang:element(4, Exception),
                    erlang:element(5, Exception)}};

        {ok, {evaluate_response, Result_data, none}} ->
            {ok, Result_data};

        {error, Other} ->
            {error, Other}
    end.

-file("src\\chrobot_extra.gleam", 281).
?DOC(
    " Evaluate some JavaScript on the page and return the result,\n"
    " which will be a [`runtime.RemoteObject`](/chrobot/protocol/runtime.html#RemoteObject) reference.\n"
).
-spec eval(page(), binary()) -> {ok,
        chrobot_extra@protocol@runtime:remote_object()} |
    {error, chrobot_extra@chrome:request_error()}.
eval(Page, Expression) ->
    _pipe = chrobot_extra@protocol@runtime:evaluate(
        page_caller(Page),
        Expression,
        none,
        none,
        {some, false},
        none,
        {some, false},
        {some, true},
        {some, false}
    ),
    handle_eval_response(_pipe).

-file("src\\chrobot_extra.gleam", 300).
-spec eval_to_value(page(), binary()) -> {ok,
        chrobot_extra@protocol@runtime:remote_object()} |
    {error, chrobot_extra@chrome:request_error()}.
eval_to_value(Page, Expression) ->
    _pipe = chrobot_extra@protocol@runtime:evaluate(
        page_caller(Page),
        Expression,
        none,
        none,
        {some, false},
        none,
        {some, true},
        {some, true},
        {some, false}
    ),
    handle_eval_response(_pipe).

-file("src\\chrobot_extra.gleam", 321).
?DOC(
    " Like [`eval`](#eval), but awaits for the result of the evaluation\n"
    " and returns once promise has been resolved\n"
).
-spec eval_async(page(), binary()) -> {ok,
        chrobot_extra@protocol@runtime:remote_object()} |
    {error, chrobot_extra@chrome:request_error()}.
eval_async(Page, Expression) ->
    _pipe = chrobot_extra@protocol@runtime:evaluate(
        page_caller(Page),
        Expression,
        none,
        none,
        {some, false},
        none,
        {some, false},
        {some, true},
        {some, true}
    ),
    handle_eval_response(_pipe).

-file("src\\chrobot_extra.gleam", 651).
?DOC(
    " Return the entire HTML of the page as a string.\n"
    " Returns `document.documentElement.outerHTML` via JavaScript.\n"
).
-spec get_all_html(page()) -> {ok, binary()} |
    {error, chrobot_extra@chrome:request_error()}.
get_all_html(Page) ->
    _pipe = eval(Page, <<"window.document.documentElement.outerHTML"/utf8>>),
    as_value(_pipe, {decoder, fun gleam@dynamic@decode:decode_string/1}).

-file("src\\chrobot_extra.gleam", 895).
-spec handle_object_id_response(
    {ok, chrobot_extra@protocol@runtime:remote_object()} |
        {error, chrobot_extra@chrome:request_error()}
) -> {ok, chrobot_extra@protocol@runtime:remote_object_id()} |
    {error, chrobot_extra@chrome:request_error()}.
handle_object_id_response(Response) ->
    case Response of
        {ok, {remote_object, _, _, _, _, _, _, {some, Remote_object_id}}} ->
            {ok, Remote_object_id};

        {ok, _} ->
            {error, not_found_error};

        {error, Any} ->
            {error, Any}
    end.

-file("src\\chrobot_extra.gleam", 659).
?DOC(
    " Run [`document.querySelector`](https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelector) on the page\n"
    " and return a single [`runtime.RemoteObjectId`](/chrobot/protocol/runtime.html#RemoteObjectId)\n"
    " for the first matching element.\n"
).
-spec select(page(), binary()) -> {ok,
        chrobot_extra@protocol@runtime:remote_object_id()} |
    {error, chrobot_extra@chrome:request_error()}.
select(Page, Selector) ->
    Selector_code = <<<<"window.document.querySelector(\""/utf8,
            Selector/binary>>/binary,
        "\")"/utf8>>,
    _pipe = eval(Page, Selector_code),
    handle_object_id_response(_pipe).

-file("src\\chrobot_extra.gleam", 907).
-spec handle_select_all_response(
    {ok, chrobot_extra@protocol@runtime:remote_object()} |
        {error, chrobot_extra@chrome:request_error()},
    page()
) -> {ok, list(chrobot_extra@protocol@runtime:remote_object_id())} |
    {error, chrobot_extra@chrome:request_error()}.
handle_select_all_response(Result, Page) ->
    case Result of
        {ok, {remote_object, _, _, _, _, _, _, {some, Remote_object_id}}} ->
            gleam@result:'try'(
                chrobot_extra@protocol@runtime:get_properties(
                    page_caller(Page),
                    Remote_object_id,
                    {some, true}
                ),
                fun(Result_properties) -> case Result_properties of
                        {get_properties_response, _, _, {some, Exception}} ->
                            {error,
                                {runtime_exception,
                                    erlang:element(3, Exception),
                                    erlang:element(4, Exception),
                                    erlang:element(5, Exception)}};

                        {get_properties_response, Property_descriptors, _, none} ->
                            {ok,
                                gleam@list:filter_map(
                                    Property_descriptors,
                                    fun(Prop_descriptor) ->
                                        case Prop_descriptor of
                                            {property_descriptor,
                                                _,
                                                {some,
                                                    {remote_object,
                                                        _,
                                                        _,
                                                        _,
                                                        _,
                                                        _,
                                                        _,
                                                        {some, Object_id}}},
                                                _,
                                                _,
                                                _,
                                                _,
                                                _,
                                                _,
                                                _,
                                                _} ->
                                                {ok, Object_id};

                                            _ ->
                                                {error, nil}
                                        end
                                    end
                                )}
                    end end
            );

        {ok, _} ->
            {ok, []};

        {error, Any} ->
            {error, Any}
    end.

-file("src\\chrobot_extra.gleam", 687).
?DOC(
    " Run [`document.querySelectorAll`](https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelectorAll) on the page and return a list of [`runtime.RemoteObjectId`](/chrobot/protocol/runtime.html#RemoteObjectId) items\n"
    " for all matching elements.\n"
).
-spec select_all(page(), binary()) -> {ok,
        list(chrobot_extra@protocol@runtime:remote_object_id())} |
    {error, chrobot_extra@chrome:request_error()}.
select_all(Page, Selector) ->
    Selector_code = <<<<"window.document.querySelectorAll(\""/utf8,
            Selector/binary>>/binary,
        "\")"/utf8>>,
    _pipe = eval(Page, Selector_code),
    handle_select_all_response(_pipe, Page).

-file("src\\chrobot_extra.gleam", 972).
-spec encode_custom_arg(call_argument()) -> gleam@json:json().
encode_custom_arg(Arg) ->
    case Arg of
        {string_arg, Value} ->
            gleam@json:string(Value);

        {int_arg, Value@1} ->
            gleam@json:int(Value@1);

        {float_arg, Value@2} ->
            gleam@json:float(Value@2);

        {bool_arg, Value@3} ->
            gleam@json:bool(Value@3);

        {array_arg, Value@4} ->
            gleam@json:array(Value@4, fun encode_custom_arg/1)
    end.

-file("src\\chrobot_extra.gleam", 982).
-spec encode_custom_arguments(list(call_argument())) -> gleam@json:json().
encode_custom_arguments(Input) ->
    gleam@json:array(
        Input,
        fun(Arg) ->
            gleam@json:object([{<<"value"/utf8>>, encode_custom_arg(Arg)}])
        end
    ).

-file("src\\chrobot_extra.gleam", 1005).
?DOC(
    " This is a version of [`runtime.call_function_on`](/chrobot/protocol/runtime.html#call_function_on) which allows\n"
    " passing in arguments, and always returns the result as a value,\n"
    " which will be decoded by the decoder you pass in\n"
    "\n"
    " You would use it with a JavaScript function declaration like this:\n"
    " ```js\n"
    " function my_function(my_arg) {\n"
    "   // You can access the passed RemoteObject with `this`\n"
    "   const wibble = this.getAttribute('href')\n"
    "   // You have access to the arguments you passed in\n"
    "   const wobble = 'hello ' + my_arg\n"
    "   // You receive this return value, you should pass in a string decoder\n"
    "   // in this case\n"
    "   return wibble + wobble;\n"
    " }\n"
    " ```\n"
).
-spec call_custom_function_on(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    binary(),
    chrobot_extra@protocol@runtime:remote_object_id(),
    list(call_argument()),
    gleam@dynamic@decode:decoder(RYY)
) -> {ok, RYY} | {error, chrobot_extra@chrome:request_error()}.
call_custom_function_on(
    Callback,
    Function_declaration,
    Object_id,
    Arguments,
    Value_decoder
) ->
    Encoded_arguments = encode_custom_arguments(Arguments),
    Payload = {some,
        gleam@json:object(
            [{<<"functionDeclaration"/utf8>>,
                    gleam@json:string(Function_declaration)},
                {<<"objectId"/utf8>>,
                    chrobot_extra@protocol@runtime:encode__remote_object_id(
                        Object_id
                    )},
                {<<"arguments"/utf8>>, Encoded_arguments},
                {<<"returnByValue"/utf8>>, gleam@json:bool(true)}]
        )},
    gleam@result:'try'(
        Callback(<<"Runtime.callFunctionOn"/utf8>>, Payload),
        fun(Result) ->
            gleam@result:'try'(
                begin
                    _pipe = gleam@dynamic@decode:run(
                        Result,
                        chrobot_extra@protocol@runtime:decode__call_function_on_response(
                            
                        )
                    ),
                    gleam@result:replace_error(_pipe, protocol_error)
                end,
                fun(Decoded_response) -> case Decoded_response of
                        {call_function_on_response, _, {some, Exception}} ->
                            {error,
                                {runtime_exception,
                                    erlang:element(3, Exception),
                                    erlang:element(4, Exception),
                                    erlang:element(5, Exception)}};

                        {call_function_on_response,
                            {remote_object, _, _, _, {some, Value}, _, _, _},
                            none} ->
                            _pipe@1 = gleam@dynamic@decode:run(
                                Value,
                                Value_decoder
                            ),
                            gleam@result:replace_error(_pipe@1, protocol_error);

                        _ ->
                            {error, not_found_error}
                    end end
            )
        end
    ).

-file("src\\chrobot_extra.gleam", 339).
?DOC(
    " Evalute a [`runtime.RemoteObjectId`](/chrobot/protocol/runtime.html#RemoteObjectId) to a value,\n"
    " passing in the appropriate decoder function\n"
).
-spec to_value(
    page(),
    chrobot_extra@protocol@runtime:remote_object_id(),
    gleam@dynamic@decode:decoder(SLH)
) -> {ok, SLH} | {error, chrobot_extra@chrome:request_error()}.
to_value(Page, Remote_object_id, Decoder) ->
    Declaration = <<"function to_value(){
    return JSON.stringify(this)
  }"/utf8>>,
    call_custom_function_on(
        page_caller(Page),
        Declaration,
        Remote_object_id,
        [],
        Decoder
    ).

-file("src\\chrobot_extra.gleam", 389).
?DOC(
    " Assuming the passed [`runtime.RemoteObjectId`](/chrobot/protocol/runtime.html#RemoteObjectId) reference is an Element,\n"
    " return an attribute of that element.\n"
    " Attributes are always returned as a string.\n"
    " If the attribute is not found, or the item is not an Element, an error will be returned.\n"
    "\n"
    " ## Example\n"
    " ```gleam\n"
    " let assert Ok(foo_data) = get_attribute(page, item, \"data-foo\")\n"
    " ```\n"
).
-spec get_attribute(
    page(),
    chrobot_extra@protocol@runtime:remote_object_id(),
    binary()
) -> {ok, binary()} | {error, chrobot_extra@chrome:request_error()}.
get_attribute(Page, Item, Attribute_name) ->
    Declaration = <<"function get_arg(attribute_name)
  {
    return this.getAttribute(attribute_name)
  }
"/utf8>>,
    call_custom_function_on(
        page_caller(Page),
        Declaration,
        Item,
        [{string_arg, Attribute_name}],
        {decoder, fun gleam@dynamic@decode:decode_string/1}
    ).

-file("src\\chrobot_extra.gleam", 609).
?DOC(
    " Get a property of a [`runtime.RemoteObjectId`](/chrobot/protocol/runtime.html#RemoteObjectId) and decode it with the provided decoder\n"
    "\n"
    " ## Example\n"
    " ```gleam\n"
    " import gleam/dynamic/decode\n"
    " let assert Ok(link_target) = get_property(page, item, \"href\", decode.string)\n"
    " ```\n"
).
-spec get_property(
    page(),
    chrobot_extra@protocol@runtime:remote_object_id(),
    binary(),
    gleam@dynamic@decode:decoder(SLL)
) -> {ok, SLL} | {error, chrobot_extra@chrome:request_error()}.
get_property(Page, Item, Property_name, Property_decoder) ->
    Declaration = <<"function get_prop(property_name)
  {
    return this[property_name]
  }
"/utf8>>,
    call_custom_function_on(
        page_caller(Page),
        Declaration,
        Item,
        [{string_arg, Property_name}],
        Property_decoder
    ).

-file("src\\chrobot_extra.gleam", 633).
?DOC(
    " Get the text content of an element.\n"
    " Returns the [`HTMLElement.innerText`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/innerText) property via JavaScript, NOT `Node.textContent`.\n"
    " Learn about the differences [here](https://developer.mozilla.org/en-US/docs/Web/API/Node/textContent#differences_from_innertext).\n"
).
-spec get_text(page(), chrobot_extra@protocol@runtime:remote_object_id()) -> {ok,
        binary()} |
    {error, chrobot_extra@chrome:request_error()}.
get_text(Page, Item) ->
    get_property(
        Page,
        Item,
        <<"innerText"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_string/1}
    ).

-file("src\\chrobot_extra.gleam", 639).
?DOC(
    " Get the inner HTML of an element.\n"
    " Returns the [`Element.innerHTML`](https://developer.mozilla.org/en-US/docs/Web/API/Element/innerHTML) JavaScript property.\n"
).
-spec get_inner_html(page(), chrobot_extra@protocol@runtime:remote_object_id()) -> {ok,
        binary()} |
    {error, chrobot_extra@chrome:request_error()}.
get_inner_html(Page, Item) ->
    get_property(
        Page,
        Item,
        <<"innerHTML"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_string/1}
    ).

-file("src\\chrobot_extra.gleam", 645).
?DOC(
    " Get the outer HTML of an element.\n"
    " Returns the [`Element.outerHTML`](https://developer.mozilla.org/en-US/docs/Web/API/Element/outerHTML) JavaScript property.\n"
).
-spec get_outer_html(page(), chrobot_extra@protocol@runtime:remote_object_id()) -> {ok,
        binary()} |
    {error, chrobot_extra@chrome:request_error()}.
get_outer_html(Page, Item) ->
    get_property(
        Page,
        Item,
        <<"outerHTML"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_string/1}
    ).

-file("src\\chrobot_extra.gleam", 1054).
?DOC(
    " This is a version of `call_custom_function_on` which does not attempt\n"
    " to decode the result as a value and just returns it directly instead.\n"
    " Useful when the return value should be discarded or handled in a custom way.\n"
).
-spec call_custom_function_on_raw(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    binary(),
    chrobot_extra@protocol@runtime:remote_object_id(),
    list(call_argument())
) -> {ok, chrobot_extra@protocol@runtime:call_function_on_response()} |
    {error, chrobot_extra@chrome:request_error()}.
call_custom_function_on_raw(
    Callback,
    Function_declaration,
    Object_id,
    Arguments
) ->
    Encoded_arguments = encode_custom_arguments(Arguments),
    Payload = {some,
        gleam@json:object(
            [{<<"functionDeclaration"/utf8>>,
                    gleam@json:string(Function_declaration)},
                {<<"objectId"/utf8>>,
                    chrobot_extra@protocol@runtime:encode__remote_object_id(
                        Object_id
                    )},
                {<<"arguments"/utf8>>, Encoded_arguments},
                {<<"returnByValue"/utf8>>, gleam@json:bool(true)}]
        )},
    gleam@result:'try'(
        Callback(<<"Runtime.callFunctionOn"/utf8>>, Payload),
        fun(Result) ->
            gleam@result:'try'(
                begin
                    _pipe = gleam@dynamic@decode:run(
                        Result,
                        chrobot_extra@protocol@runtime:decode__call_function_on_response(
                            
                        )
                    ),
                    gleam@result:replace_error(_pipe, protocol_error)
                end,
                fun(Decoded_response) -> case Decoded_response of
                        {call_function_on_response, _, {some, Exception}} ->
                            {error,
                                {runtime_exception,
                                    erlang:element(3, Exception),
                                    erlang:element(4, Exception),
                                    erlang:element(5, Exception)}};

                        _ ->
                            {ok, Decoded_response}
                    end end
            )
        end
    ).

-file("src\\chrobot_extra.gleam", 418).
?DOC(
    " Simulate a click on an element.\n"
    " Calls [`HTMLElement.click()`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/click) via JavaScript.\n"
).
-spec click(page(), chrobot_extra@protocol@runtime:remote_object_id()) -> {ok,
        nil} |
    {error, chrobot_extra@chrome:request_error()}.
click(Page, Item) ->
    Declaration = <<"function click_el(){
    return this.click()
  }"/utf8>>,
    _pipe = call_custom_function_on_raw(
        page_caller(Page),
        Declaration,
        Item,
        []
    ),
    gleam@result:replace(_pipe, nil).

-file("src\\chrobot_extra.gleam", 411).
?DOC(
    " Convencience function to simulate a click on an element by selector.\n"
    " See [`click`](#click) for more info.\n"
).
-spec click_selector(page(), binary()) -> {ok, nil} |
    {error, chrobot_extra@chrome:request_error()}.
click_selector(Page, Selector) ->
    gleam@result:'try'(
        select(Page, Selector),
        fun(Item) -> click(Page, Item) end
    ).

-file("src\\chrobot_extra.gleam", 436).
?DOC(
    " Focus an element.\n"
    " Calls [`HTMLElement.focus()`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/focus) via JavaScript.\n"
).
-spec focus(page(), chrobot_extra@protocol@runtime:remote_object_id()) -> {ok,
        nil} |
    {error, chrobot_extra@chrome:request_error()}.
focus(Page, Item) ->
    Declaration = <<"function focus_el(){
    return this.focus()
  }"/utf8>>,
    _pipe = call_custom_function_on_raw(
        page_caller(Page),
        Declaration,
        Item,
        []
    ),
    gleam@result:replace(_pipe, nil).

-file("src\\chrobot_extra.gleam", 429).
?DOC(
    " Convenience function to focus an element by selector.\n"
    " See [`focus`](#focus) for more info.\n"
).
-spec focus_selector(page(), binary()) -> {ok, nil} |
    {error, chrobot_extra@chrome:request_error()}.
focus_selector(Page, Selector) ->
    gleam@result:'try'(
        select(Page, Selector),
        fun(Item) -> focus(Page, Item) end
    ).

-file("src\\chrobot_extra.gleam", 1093).
?DOC(
    " This is a version of `call_custom_function_on` which returns remote objects instead of values.\n"
    " Useful when you want to pass the result to another function that expects a remote object.\n"
).
-spec call_custom_function_on_object(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    binary(),
    chrobot_extra@protocol@runtime:remote_object_id(),
    list(call_argument())
) -> {ok, chrobot_extra@protocol@runtime:remote_object()} |
    {error, chrobot_extra@chrome:request_error()}.
call_custom_function_on_object(
    Callback,
    Function_declaration,
    Object_id,
    Arguments
) ->
    Encoded_arguments = encode_custom_arguments(Arguments),
    Payload = {some,
        gleam@json:object(
            [{<<"functionDeclaration"/utf8>>,
                    gleam@json:string(Function_declaration)},
                {<<"objectId"/utf8>>,
                    chrobot_extra@protocol@runtime:encode__remote_object_id(
                        Object_id
                    )},
                {<<"arguments"/utf8>>, Encoded_arguments},
                {<<"returnByValue"/utf8>>, gleam@json:bool(false)}]
        )},
    gleam@result:'try'(
        Callback(<<"Runtime.callFunctionOn"/utf8>>, Payload),
        fun(Result) ->
            gleam@result:'try'(
                begin
                    _pipe = gleam@dynamic@decode:run(
                        Result,
                        chrobot_extra@protocol@runtime:decode__call_function_on_response(
                            
                        )
                    ),
                    gleam@result:replace_error(_pipe, protocol_error)
                end,
                fun(Decoded_response) -> case Decoded_response of
                        {call_function_on_response, _, {some, Exception}} ->
                            {error,
                                {runtime_exception,
                                    erlang:element(3, Exception),
                                    erlang:element(4, Exception),
                                    erlang:element(5, Exception)}};

                        {call_function_on_response, Result@1, none} ->
                            {ok, Result@1}
                    end end
            )
        end
    ).

-file("src\\chrobot_extra.gleam", 668).
?DOC(
    " Run [`Element.querySelector`](https://developer.mozilla.org/en-US/docs/Web/API/Element/querySelector) on the given\n"
    " element and return a single [`runtime.RemoteObjectId`](/chrobot/protocol/runtime.html#RemoteObjectId)\n"
    " for the first matching child element.\n"
).
-spec select_from(
    page(),
    chrobot_extra@protocol@runtime:remote_object_id(),
    binary()
) -> {ok, chrobot_extra@protocol@runtime:remote_object_id()} |
    {error, chrobot_extra@chrome:request_error()}.
select_from(Page, Item, Selector) ->
    Declaration = <<"function select_from(selector)
  {
    return this.querySelector(selector)
  }
"/utf8>>,
    _pipe = call_custom_function_on_object(
        page_caller(Page),
        Declaration,
        Item,
        [{string_arg, Selector}]
    ),
    handle_object_id_response(_pipe).

-file("src\\chrobot_extra.gleam", 699).
?DOC(
    " Run [`Element.querySelectorAll`](https://developer.mozilla.org/en-US/docs/Web/API/Element/querySelectorAll) on the given\n"
    " element and return a list of [`runtime.RemoteObjectId`](/chrobot/protocol/runtime.html#RemoteObjectId) items\n"
    " for all matching child elements.\n"
).
-spec select_all_from(
    page(),
    chrobot_extra@protocol@runtime:remote_object_id(),
    binary()
) -> {ok, list(chrobot_extra@protocol@runtime:remote_object_id())} |
    {error, chrobot_extra@chrome:request_error()}.
select_all_from(Page, Item, Selector) ->
    Declaration = <<"function select_all_from(selector)
  {
    return this.querySelectorAll(selector)
  }
"/utf8>>,
    _pipe = call_custom_function_on_object(
        page_caller(Page),
        Declaration,
        Item,
        [{string_arg, Selector}]
    ),
    handle_select_all_response(_pipe, Page).

-file("src\\chrobot_extra.gleam", 775).
-spec do_poll(
    fun(() -> {ok, RXY} | {error, chrobot_extra@chrome:request_error()}),
    integer(),
    gleam@option:option(chrobot_extra@chrome:request_error())
) -> {ok, RXY} | {error, chrobot_extra@chrome:request_error()}.
do_poll(Callback, Deadline, Previous_error) ->
    Available_time = Deadline - chrobot_extra_ffi:get_time_ms(),
    gleam@bool:guard(
        Available_time < 0,
        {error, chrome_agent_timeout},
        fun() ->
            Subject = gleam@erlang@process:new_subject(),
            proc_lib:spawn_link(
                fun() -> gleam@erlang@process:send(Subject, Callback()) end
            ),
            Selector = begin
                _pipe = gleam_erlang_ffi:new_selector(),
                gleam@erlang@process:select_map(
                    _pipe,
                    Subject,
                    fun gleam@function:identity/1
                )
            end,
            Result = gleam_erlang_ffi:select(Selector, Available_time),
            Available_time@1 = (Deadline - chrobot_extra_ffi:get_time_ms()) - 5,
            case Result of
                {error, nil} ->
                    case Previous_error of
                        {some, Err} ->
                            {error, Err};

                        none ->
                            {error, chrome_agent_timeout}
                    end;

                {ok, {ok, Res}} ->
                    {ok, Res};

                {ok, {error, Err@1}} when Available_time@1 > 0 ->
                    gleam_erlang_ffi:sleep(5),
                    do_poll(Callback, Deadline, {some, Err@1});

                {ok, {error, Err@2}} ->
                    {error, Err@2}
            end
        end
    ).

-file("src\\chrobot_extra.gleam", 767).
?DOC(" Utility to repeatedly call a browser function until it succeeds or times out.\n").
-spec poll(
    fun(() -> {ok, RXT} | {error, chrobot_extra@chrome:request_error()}),
    integer()
) -> {ok, RXT} | {error, chrobot_extra@chrome:request_error()}.
poll(Callback, Timeout) ->
    Deadline = chrobot_extra_ffi:get_time_ms() + Timeout,
    do_poll(Callback, Deadline, none).

-file("src\\chrobot_extra.gleam", 720).
?DOC(
    " Continously attempt to run a selector, until it succeeds.\n"
    " You can use this after opening a page, to wait for the moment it has initialized\n"
    " enough sufficiently for you to run your automation on it.\n"
    " The final result will be single [`runtime.RemoteObjectId`](/chrobot/protocol/runtime.html#RemoteObjectId)\n"
).
-spec await_selector(page(), binary()) -> {ok,
        chrobot_extra@protocol@runtime:remote_object_id()} |
    {error, chrobot_extra@chrome:request_error()}.
await_selector(Page, Selector) ->
    Polly = fun() ->
        _pipe = eval(
            Page,
            <<<<"window.document.querySelector(\""/utf8, Selector/binary>>/binary,
                "\")"/utf8>>
        ),
        handle_object_id_response(_pipe)
    end,
    poll(Polly, erlang:element(3, Page)).

-file("src\\chrobot_extra.gleam", 198).
?DOC(
    " Similar to [`open`](#open), but creates a new page from HTML that you pass to it.\n"
    " The page will be created under the `about:blank` URL.\n"
).
-spec create_page(
    gleam@erlang@process:subject(chrobot_extra@chrome:message()),
    binary(),
    integer()
) -> {ok, page()} | {error, chrobot_extra@chrome:request_error()}.
create_page(Browser, Html, Time_out) ->
    gleam@result:'try'(
        open(Browser, <<"about:blank"/utf8>>, Time_out),
        fun(Created_page) ->
            gleam@result:'try'(
                await_selector(Created_page, <<"body"/utf8>>),
                fun(_) ->
                    Payload = <<<<"window.document.open();
window.document.write(`"/utf8,
                            Html/binary>>/binary,
                        "`);
window.document.close();
"/utf8>>,
                    gleam@result:'try'(
                        eval(Created_page, Payload),
                        fun(_) -> {ok, Created_page} end
                    )
                end
            )
        end
    ).
