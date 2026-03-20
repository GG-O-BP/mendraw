-module(chrobot_extra@protocol@fetch).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\protocol\\fetch.gleam").
-export([encode__request_id/1, decode__request_id/0, encode__request_stage/1, decode__request_stage/0, encode__request_pattern/1, decode__request_pattern/0, encode__header_entry/1, decode__header_entry/0, encode__auth_challenge_source/1, decode__auth_challenge_source/0, encode__auth_challenge/1, decode__auth_challenge/0, encode__auth_challenge_response_response/1, decode__auth_challenge_response_response/0, encode__auth_challenge_response/1, decode__auth_challenge_response/0, decode__get_response_body_response/0, decode__take_response_body_as_stream_response/0, disable/1, enable/3, fail_request/3, fulfill_request/7, continue_request/6, continue_with_auth/3, get_response_body/2, take_response_body_as_stream/2]).
-export_type([request_id/0, request_stage/0, request_pattern/0, header_entry/0, auth_challenge/0, auth_challenge_source/0, auth_challenge_response/0, auth_challenge_response_response/0, get_response_body_response/0, take_response_body_as_stream_response/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " > ⚙️  This module was generated from the Chrome DevTools Protocol version **1.3**\n"
    " ## Fetch Domain  \n"
    "\n"
    " A domain for letting clients substitute browser's network layer with client code.  \n"
    "\n"
    " [📖   View this domain on the DevTools Protocol API Docs](https://chromedevtools.github.io/devtools-protocol/1-3/Fetch/)\n"
).

-type request_id() :: {request_id, binary()}.

-type request_stage() :: request_stage_request | request_stage_response.

-type request_pattern() :: {request_pattern,
        gleam@option:option(binary()),
        gleam@option:option(chrobot_extra@protocol@network:resource_type()),
        gleam@option:option(request_stage())}.

-type header_entry() :: {header_entry, binary(), binary()}.

-type auth_challenge() :: {auth_challenge,
        gleam@option:option(auth_challenge_source()),
        binary(),
        binary(),
        binary()}.

-type auth_challenge_source() :: auth_challenge_source_server |
    auth_challenge_source_proxy.

-type auth_challenge_response() :: {auth_challenge_response,
        auth_challenge_response_response(),
        gleam@option:option(binary()),
        gleam@option:option(binary())}.

-type auth_challenge_response_response() :: auth_challenge_response_response_default |
    auth_challenge_response_response_cancel_auth |
    auth_challenge_response_response_provide_credentials.

-type get_response_body_response() :: {get_response_body_response,
        binary(),
        boolean()}.

-type take_response_body_as_stream_response() :: {take_response_body_as_stream_response,
        chrobot_extra@protocol@io:stream_handle()}.

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 28).
?DOC(false).
-spec encode__request_id(request_id()) -> gleam@json:json().
encode__request_id(Value__) ->
    case Value__ of
        {request_id, Inner_value__} ->
            gleam@json:string(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 35).
?DOC(false).
-spec decode__request_id() -> gleam@dynamic@decode:decoder(request_id()).
decode__request_id() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({request_id, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 51).
?DOC(false).
-spec encode__request_stage(request_stage()) -> gleam@json:json().
encode__request_stage(Value__) ->
    _pipe = case Value__ of
        request_stage_request ->
            <<"Request"/utf8>>;

        request_stage_response ->
            <<"Response"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 60).
?DOC(false).
-spec decode__request_stage() -> gleam@dynamic@decode:decoder(request_stage()).
decode__request_stage() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"Request"/utf8>> ->
                        gleam@dynamic@decode:success(request_stage_request);

                    <<"Response"/utf8>> ->
                        gleam@dynamic@decode:success(request_stage_response);

                    _ ->
                        gleam@dynamic@decode:failure(
                            request_stage_request,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 84).
?DOC(false).
-spec encode__request_pattern(request_pattern()) -> gleam@json:json().
encode__request_pattern(Value__) ->
    gleam@json:object(
        begin
            _pipe = [],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(2, Value__),
                fun(Inner_value__) ->
                    {<<"urlPattern"/utf8>>, gleam@json:string(Inner_value__)}
                end
            ),
            _pipe@2 = chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(3, Value__),
                fun(Inner_value__@1) ->
                    {<<"resourceType"/utf8>>,
                        chrobot_extra@protocol@network:encode__resource_type(
                            Inner_value__@1
                        )}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@2,
                erlang:element(4, Value__),
                fun(Inner_value__@2) ->
                    {<<"requestStage"/utf8>>,
                        encode__request_stage(Inner_value__@2)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 100).
?DOC(false).
-spec decode__request_pattern() -> gleam@dynamic@decode:decoder(request_pattern()).
decode__request_pattern() ->
    begin
        gleam@dynamic@decode:optional_field(
            <<"urlPattern"/utf8>>,
            none,
            gleam@dynamic@decode:optional(
                {decoder, fun gleam@dynamic@decode:decode_string/1}
            ),
            fun(Url_pattern) ->
                gleam@dynamic@decode:optional_field(
                    <<"resourceType"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(
                        chrobot_extra@protocol@network:decode__resource_type()
                    ),
                    fun(Resource_type) ->
                        gleam@dynamic@decode:optional_field(
                            <<"requestStage"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                decode__request_stage()
                            ),
                            fun(Request_stage) ->
                                gleam@dynamic@decode:success(
                                    {request_pattern,
                                        Url_pattern,
                                        Resource_type,
                                        Request_stage}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 132).
?DOC(false).
-spec encode__header_entry(header_entry()) -> gleam@json:json().
encode__header_entry(Value__) ->
    gleam@json:object(
        [{<<"name"/utf8>>, gleam@json:string(erlang:element(2, Value__))},
            {<<"value"/utf8>>, gleam@json:string(erlang:element(3, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 140).
?DOC(false).
-spec decode__header_entry() -> gleam@dynamic@decode:decoder(header_entry()).
decode__header_entry() ->
    begin
        gleam@dynamic@decode:field(
            <<"name"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Name) ->
                gleam@dynamic@decode:field(
                    <<"value"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Value) ->
                        gleam@dynamic@decode:success(
                            {header_entry, Name, Value}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 171).
?DOC(false).
-spec encode__auth_challenge_source(auth_challenge_source()) -> gleam@json:json().
encode__auth_challenge_source(Value__) ->
    _pipe = case Value__ of
        auth_challenge_source_server ->
            <<"Server"/utf8>>;

        auth_challenge_source_proxy ->
            <<"Proxy"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 180).
?DOC(false).
-spec decode__auth_challenge_source() -> gleam@dynamic@decode:decoder(auth_challenge_source()).
decode__auth_challenge_source() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"Server"/utf8>> ->
                        gleam@dynamic@decode:success(
                            auth_challenge_source_server
                        );

                    <<"Proxy"/utf8>> ->
                        gleam@dynamic@decode:success(
                            auth_challenge_source_proxy
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            auth_challenge_source_server,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 192).
?DOC(false).
-spec encode__auth_challenge(auth_challenge()) -> gleam@json:json().
encode__auth_challenge(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"origin"/utf8>>,
                    gleam@json:string(erlang:element(3, Value__))},
                {<<"scheme"/utf8>>,
                    gleam@json:string(erlang:element(4, Value__))},
                {<<"realm"/utf8>>,
                    gleam@json:string(erlang:element(5, Value__))}],
            chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(2, Value__),
                fun(Inner_value__) ->
                    {<<"source"/utf8>>,
                        encode__auth_challenge_source(Inner_value__)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 206).
?DOC(false).
-spec decode__auth_challenge() -> gleam@dynamic@decode:decoder(auth_challenge()).
decode__auth_challenge() ->
    begin
        gleam@dynamic@decode:optional_field(
            <<"source"/utf8>>,
            none,
            gleam@dynamic@decode:optional(decode__auth_challenge_source()),
            fun(Source) ->
                gleam@dynamic@decode:field(
                    <<"origin"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Origin) ->
                        gleam@dynamic@decode:field(
                            <<"scheme"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Scheme) ->
                                gleam@dynamic@decode:field(
                                    <<"realm"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_string/1},
                                    fun(Realm) ->
                                        gleam@dynamic@decode:success(
                                            {auth_challenge,
                                                Source,
                                                Origin,
                                                Scheme,
                                                Realm}
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

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 251).
?DOC(false).
-spec encode__auth_challenge_response_response(
    auth_challenge_response_response()
) -> gleam@json:json().
encode__auth_challenge_response_response(Value__) ->
    _pipe = case Value__ of
        auth_challenge_response_response_default ->
            <<"Default"/utf8>>;

        auth_challenge_response_response_cancel_auth ->
            <<"CancelAuth"/utf8>>;

        auth_challenge_response_response_provide_credentials ->
            <<"ProvideCredentials"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 263).
?DOC(false).
-spec decode__auth_challenge_response_response() -> gleam@dynamic@decode:decoder(auth_challenge_response_response()).
decode__auth_challenge_response_response() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"Default"/utf8>> ->
                        gleam@dynamic@decode:success(
                            auth_challenge_response_response_default
                        );

                    <<"CancelAuth"/utf8>> ->
                        gleam@dynamic@decode:success(
                            auth_challenge_response_response_cancel_auth
                        );

                    <<"ProvideCredentials"/utf8>> ->
                        gleam@dynamic@decode:success(
                            auth_challenge_response_response_provide_credentials
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            auth_challenge_response_response_default,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 281).
?DOC(false).
-spec encode__auth_challenge_response(auth_challenge_response()) -> gleam@json:json().
encode__auth_challenge_response(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"response"/utf8>>,
                    encode__auth_challenge_response_response(
                        erlang:element(2, Value__)
                    )}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(3, Value__),
                fun(Inner_value__) ->
                    {<<"username"/utf8>>, gleam@json:string(Inner_value__)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(4, Value__),
                fun(Inner_value__@1) ->
                    {<<"password"/utf8>>, gleam@json:string(Inner_value__@1)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 296).
?DOC(false).
-spec decode__auth_challenge_response() -> gleam@dynamic@decode:decoder(auth_challenge_response()).
decode__auth_challenge_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"response"/utf8>>,
            decode__auth_challenge_response_response(),
            fun(Response) ->
                gleam@dynamic@decode:optional_field(
                    <<"username"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(
                        {decoder, fun gleam@dynamic@decode:decode_string/1}
                    ),
                    fun(Username) ->
                        gleam@dynamic@decode:optional_field(
                            <<"password"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                {decoder,
                                    fun gleam@dynamic@decode:decode_string/1}
                            ),
                            fun(Password) ->
                                gleam@dynamic@decode:success(
                                    {auth_challenge_response,
                                        Response,
                                        Username,
                                        Password}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 333).
?DOC(false).
-spec decode__get_response_body_response() -> gleam@dynamic@decode:decoder(get_response_body_response()).
decode__get_response_body_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"body"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Body) ->
                gleam@dynamic@decode:field(
                    <<"base64Encoded"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_bool/1},
                    fun(Base64_encoded) ->
                        gleam@dynamic@decode:success(
                            {get_response_body_response, Body, Base64_encoded}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 352).
?DOC(false).
-spec decode__take_response_body_as_stream_response() -> gleam@dynamic@decode:decoder(take_response_body_as_stream_response()).
decode__take_response_body_as_stream_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"stream"/utf8>>,
            chrobot_extra@protocol@io:decode__stream_handle(),
            fun(Stream) ->
                gleam@dynamic@decode:success(
                    {take_response_body_as_stream_response, Stream}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 362).
?DOC(" Disables the fetch domain.\n").
-spec disable(fun((binary(), gleam@option:option(any())) -> VDL)) -> VDL.
disable(Callback__) ->
    Callback__(<<"Fetch.disable"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 378).
?DOC(
    " Enables issuing of requestPaused events. A request will be paused until client\n"
    " calls one of failRequest, fulfillRequest or continueRequest/continueWithAuth.\n"
    " \n"
    " Parameters:  \n"
    "  - `patterns` : If specified, only requests matching any of these patterns will produce\n"
    " fetchRequested event and will be paused until clients response. If not set,\n"
    " all requests will be affected.\n"
    "  - `handle_auth_requests` : If true, authRequired events will be issued and requests will be paused\n"
    " expecting a call to continueWithAuth.\n"
    " \n"
    " Returns:\n"
).
-spec enable(
    fun((binary(), gleam@option:option(gleam@json:json())) -> VDP),
    gleam@option:option(list(request_pattern())),
    gleam@option:option(boolean())
) -> VDP.
enable(Callback__, Patterns, Handle_auth_requests) ->
    Callback__(
        <<"Fetch.enable"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [],
                    _pipe@1 = chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Patterns,
                        fun(Inner_value__) ->
                            {<<"patterns"/utf8>>,
                                gleam@json:array(
                                    Inner_value__,
                                    fun encode__request_pattern/1
                                )}
                        end
                    ),
                    chrobot_extra@internal@utils:add_optional(
                        _pipe@1,
                        Handle_auth_requests,
                        fun(Inner_value__@1) ->
                            {<<"handleAuthRequests"/utf8>>,
                                gleam@json:bool(Inner_value__@1)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 405).
?DOC(
    " Causes the request to fail with specified reason.\n"
    " \n"
    " Parameters:  \n"
    "  - `request_id` : An id the client received in requestPaused event.\n"
    "  - `error_reason` : Causes the request to fail with the given reason.\n"
    " \n"
    " Returns:\n"
).
-spec fail_request(
    fun((binary(), gleam@option:option(gleam@json:json())) -> VDZ),
    request_id(),
    chrobot_extra@protocol@network:error_reason()
) -> VDZ.
fail_request(Callback__, Request_id, Error_reason) ->
    Callback__(
        <<"Fetch.failRequest"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"requestId"/utf8>>, encode__request_id(Request_id)},
                    {<<"errorReason"/utf8>>,
                        chrobot_extra@protocol@network:encode__error_reason(
                            Error_reason
                        )}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 439).
?DOC(
    " Provides response to the request.\n"
    " \n"
    " Parameters:  \n"
    "  - `request_id` : An id the client received in requestPaused event.\n"
    "  - `response_code` : An HTTP response code.\n"
    "  - `response_headers` : Response headers.\n"
    "  - `binary_response_headers` : Alternative way of specifying response headers as a \\0-separated\n"
    " series of name: value pairs. Prefer the above method unless you\n"
    " need to represent some non-UTF8 values that can't be transmitted\n"
    " over the protocol as text. (Encoded as a base64 string when passed over JSON)\n"
    "  - `body` : A response body. If absent, original response body will be used if\n"
    " the request is intercepted at the response stage and empty body\n"
    " will be used if the request is intercepted at the request stage. (Encoded as a base64 string when passed over JSON)\n"
    "  - `response_phrase` : A textual representation of responseCode.\n"
    " If absent, a standard phrase matching responseCode is used.\n"
    " \n"
    " Returns:\n"
).
-spec fulfill_request(
    fun((binary(), gleam@option:option(gleam@json:json())) -> VEE),
    request_id(),
    integer(),
    gleam@option:option(list(header_entry())),
    gleam@option:option(binary()),
    gleam@option:option(binary()),
    gleam@option:option(binary())
) -> VEE.
fulfill_request(
    Callback__,
    Request_id,
    Response_code,
    Response_headers,
    Binary_response_headers,
    Body,
    Response_phrase
) ->
    Callback__(
        <<"Fetch.fulfillRequest"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [{<<"requestId"/utf8>>,
                            encode__request_id(Request_id)},
                        {<<"responseCode"/utf8>>, gleam@json:int(Response_code)}],
                    _pipe@1 = chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Response_headers,
                        fun(Inner_value__) ->
                            {<<"responseHeaders"/utf8>>,
                                gleam@json:array(
                                    Inner_value__,
                                    fun encode__header_entry/1
                                )}
                        end
                    ),
                    _pipe@2 = chrobot_extra@internal@utils:add_optional(
                        _pipe@1,
                        Binary_response_headers,
                        fun(Inner_value__@1) ->
                            {<<"binaryResponseHeaders"/utf8>>,
                                gleam@json:string(Inner_value__@1)}
                        end
                    ),
                    _pipe@3 = chrobot_extra@internal@utils:add_optional(
                        _pipe@2,
                        Body,
                        fun(Inner_value__@2) ->
                            {<<"body"/utf8>>,
                                gleam@json:string(Inner_value__@2)}
                        end
                    ),
                    chrobot_extra@internal@utils:add_optional(
                        _pipe@3,
                        Response_phrase,
                        fun(Inner_value__@3) ->
                            {<<"responsePhrase"/utf8>>,
                                gleam@json:string(Inner_value__@3)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 487).
?DOC(
    " Continues the request, optionally modifying some of its parameters.\n"
    " \n"
    " Parameters:  \n"
    "  - `request_id` : An id the client received in requestPaused event.\n"
    "  - `url` : If set, the request url will be modified in a way that's not observable by page.\n"
    "  - `method` : If set, the request method is overridden.\n"
    "  - `post_data` : If set, overrides the post data in the request. (Encoded as a base64 string when passed over JSON)\n"
    "  - `headers` : If set, overrides the request headers. Note that the overrides do not\n"
    " extend to subsequent redirect hops, if a redirect happens. Another override\n"
    " may be applied to a different request produced by a redirect.\n"
    " \n"
    " Returns:\n"
).
-spec continue_request(
    fun((binary(), gleam@option:option(gleam@json:json())) -> VES),
    request_id(),
    gleam@option:option(binary()),
    gleam@option:option(binary()),
    gleam@option:option(binary()),
    gleam@option:option(list(header_entry()))
) -> VES.
continue_request(Callback__, Request_id, Url, Method, Post_data, Headers) ->
    Callback__(
        <<"Fetch.continueRequest"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [{<<"requestId"/utf8>>,
                            encode__request_id(Request_id)}],
                    _pipe@1 = chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Url,
                        fun(Inner_value__) ->
                            {<<"url"/utf8>>, gleam@json:string(Inner_value__)}
                        end
                    ),
                    _pipe@2 = chrobot_extra@internal@utils:add_optional(
                        _pipe@1,
                        Method,
                        fun(Inner_value__@1) ->
                            {<<"method"/utf8>>,
                                gleam@json:string(Inner_value__@1)}
                        end
                    ),
                    _pipe@3 = chrobot_extra@internal@utils:add_optional(
                        _pipe@2,
                        Post_data,
                        fun(Inner_value__@2) ->
                            {<<"postData"/utf8>>,
                                gleam@json:string(Inner_value__@2)}
                        end
                    ),
                    chrobot_extra@internal@utils:add_optional(
                        _pipe@3,
                        Headers,
                        fun(Inner_value__@3) ->
                            {<<"headers"/utf8>>,
                                gleam@json:array(
                                    Inner_value__@3,
                                    fun encode__header_entry/1
                                )}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 525).
?DOC(
    " Continues a request supplying authChallengeResponse following authRequired event.\n"
    " \n"
    " Parameters:  \n"
    "  - `request_id` : An id the client received in authRequired event.\n"
    "  - `auth_challenge_response` : Response to  with an authChallenge.\n"
    " \n"
    " Returns:\n"
).
-spec continue_with_auth(
    fun((binary(), gleam@option:option(gleam@json:json())) -> VFG),
    request_id(),
    auth_challenge_response()
) -> VFG.
continue_with_auth(Callback__, Request_id, Auth_challenge_response) ->
    Callback__(
        <<"Fetch.continueWithAuth"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"requestId"/utf8>>, encode__request_id(Request_id)},
                    {<<"authChallengeResponse"/utf8>>,
                        encode__auth_challenge_response(Auth_challenge_response)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 562).
?DOC(
    " Causes the body of the response to be received from the server and\n"
    " returned as a single string. May only be issued for a request that\n"
    " is paused in the Response stage and is mutually exclusive with\n"
    " takeResponseBodyForInterceptionAsStream. Calling other methods that\n"
    " affect the request or disabling fetch domain before body is received\n"
    " results in an undefined behavior.\n"
    " Note that the response body is not available for redirects. Requests\n"
    " paused in the _redirect received_ state may be differentiated by\n"
    " `responseCode` and presence of `location` response header, see\n"
    " comments to `requestPaused` for details.\n"
    " \n"
    " Parameters:  \n"
    "  - `request_id` : Identifier for the intercepted request to get body for.\n"
    " \n"
    " Returns:  \n"
    "  - `body` : Response body.\n"
    "  - `base64_encoded` : True, if content was sent as base64.\n"
).
-spec get_response_body(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    request_id()
) -> {ok, get_response_body_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_response_body(Callback__, Request_id) ->
    gleam@result:'try'(
        Callback__(
            <<"Fetch.getResponseBody"/utf8>>,
            {some,
                gleam@json:object(
                    [{<<"requestId"/utf8>>, encode__request_id(Request_id)}]
                )}
        ),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__get_response_body_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\fetch.gleam", 593).
?DOC(
    " Returns a handle to the stream representing the response body.\n"
    " The request must be paused in the HeadersReceived stage.\n"
    " Note that after this command the request can't be continued\n"
    " as is -- client either needs to cancel it or to provide the\n"
    " response body.\n"
    " The stream only supports sequential read, IO.read will fail if the position\n"
    " is specified.\n"
    " This method is mutually exclusive with getResponseBody.\n"
    " Calling other methods that affect the request or disabling fetch\n"
    " domain before body is received results in an undefined behavior.\n"
    " \n"
    " Parameters:  \n"
    "  - `request_id`\n"
    " \n"
    " Returns:  \n"
    "  - `stream`\n"
).
-spec take_response_body_as_stream(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    request_id()
) -> {ok, take_response_body_as_stream_response()} |
    {error, chrobot_extra@chrome:request_error()}.
take_response_body_as_stream(Callback__, Request_id) ->
    gleam@result:'try'(
        Callback__(
            <<"Fetch.takeResponseBodyAsStream"/utf8>>,
            {some,
                gleam@json:object(
                    [{<<"requestId"/utf8>>, encode__request_id(Request_id)}]
                )}
        ),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__take_response_body_as_stream_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).
