-module(chrobot_extra@protocol@browser).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\protocol\\browser.gleam").
-export([decode__get_version_response/0, reset_permissions/2, close/1, get_version/1, add_privacy_sandbox_enrollment_override/2]).
-export_type([get_version_response/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " > ⚙️  This module was generated from the Chrome DevTools Protocol version **1.3**\n"
    " ## Browser Domain  \n"
    "\n"
    " The Browser domain defines methods and events for browser managing.  \n"
    "\n"
    " [📖   View this domain on the DevTools Protocol API Docs](https://chromedevtools.github.io/devtools-protocol/1-3/Browser/)\n"
).

-type get_version_response() :: {get_version_response,
        binary(),
        binary(),
        binary(),
        binary(),
        binary()}.

-file("src\\chrobot_extra\\protocol\\browser.gleam", 38).
?DOC(false).
-spec decode__get_version_response() -> gleam@dynamic@decode:decoder(get_version_response()).
decode__get_version_response() ->
    begin
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
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
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
                                                    {get_version_response,
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
    end.

-file("src\\chrobot_extra\\protocol\\browser.gleam", 63).
?DOC(
    " Reset all permission management for all origins.\n"
    " \n"
    " Parameters:  \n"
    "  - `browser_context_id` : BrowserContext to reset permissions. When omitted, default browser context is used.\n"
    " \n"
    " Returns:\n"
).
-spec reset_permissions(
    fun((binary(), gleam@option:option(gleam@json:json())) -> THA),
    gleam@option:option(binary())
) -> THA.
reset_permissions(Callback__, Browser_context_id) ->
    Callback__(
        <<"Browser.resetPermissions"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [],
                    chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Browser_context_id,
                        fun(Inner_value__) ->
                            {<<"browserContextId"/utf8>>,
                                gleam@json:string(Inner_value__)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\browser.gleam", 80).
?DOC(" Close browser gracefully.\n").
-spec close(fun((binary(), gleam@option:option(any())) -> THH)) -> THH.
close(Callback__) ->
    Callback__(<<"Browser.close"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\browser.gleam", 91).
?DOC(
    " Returns version information.\n"
    "  - `protocol_version` : Protocol version.\n"
    "  - `product` : Product name.\n"
    "  - `revision` : Product revision.\n"
    "  - `user_agent` : User-Agent.\n"
    "  - `js_version` : V8 version.\n"
).
-spec get_version(
    fun((binary(), gleam@option:option(any())) -> {ok, gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()})
) -> {ok, get_version_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_version(Callback__) ->
    gleam@result:'try'(
        Callback__(<<"Browser.getVersion"/utf8>>, none),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__get_version_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\browser.gleam", 106).
?DOC(
    " Allows a site to use privacy sandbox features that require enrollment\n"
    " without the site actually being enrolled. Only supported on page targets.\n"
    " \n"
    " Parameters:  \n"
    "  - `url`\n"
    " \n"
    " Returns:\n"
).
-spec add_privacy_sandbox_enrollment_override(
    fun((binary(), gleam@option:option(gleam@json:json())) -> THX),
    binary()
) -> THX.
add_privacy_sandbox_enrollment_override(Callback__, Url) ->
    Callback__(
        <<"Browser.addPrivacySandboxEnrollmentOverride"/utf8>>,
        {some, gleam@json:object([{<<"url"/utf8>>, gleam@json:string(Url)}])}
    ).
