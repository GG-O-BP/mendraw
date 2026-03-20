-module(chrobot_extra@protocol@security).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\protocol\\security.gleam").
-export([encode__certificate_id/1, decode__certificate_id/0, encode__mixed_content_type/1, decode__mixed_content_type/0, encode__security_state/1, decode__security_state/0, encode__security_state_explanation/1, decode__security_state_explanation/0, encode__certificate_error_action/1, decode__certificate_error_action/0, disable/1, enable/1, set_ignore_certificate_errors/2]).
-export_type([certificate_id/0, mixed_content_type/0, security_state/0, security_state_explanation/0, certificate_error_action/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " > ⚙️  This module was generated from the Chrome DevTools Protocol version **1.3**\n"
    " ## Security Domain  \n"
    "\n"
    " Security  \n"
    "\n"
    " [📖   View this domain on the DevTools Protocol API Docs](https://chromedevtools.github.io/devtools-protocol/1-3/Security/)\n"
).

-type certificate_id() :: {certificate_id, integer()}.

-type mixed_content_type() :: mixed_content_type_blockable |
    mixed_content_type_optionally_blockable |
    mixed_content_type_none.

-type security_state() :: security_state_unknown |
    security_state_neutral |
    security_state_insecure |
    security_state_secure |
    security_state_info |
    security_state_insecure_broken.

-type security_state_explanation() :: {security_state_explanation,
        security_state(),
        binary(),
        binary(),
        binary(),
        mixed_content_type(),
        list(binary()),
        gleam@option:option(list(binary()))}.

-type certificate_error_action() :: certificate_error_action_continue |
    certificate_error_action_cancel.

-file("src\\chrobot_extra\\protocol\\security.gleam", 24).
?DOC(false).
-spec encode__certificate_id(certificate_id()) -> gleam@json:json().
encode__certificate_id(Value__) ->
    case Value__ of
        {certificate_id, Inner_value__} ->
            gleam@json:int(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\security.gleam", 31).
?DOC(false).
-spec decode__certificate_id() -> gleam@dynamic@decode:decoder(certificate_id()).
decode__certificate_id() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({certificate_id, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\security.gleam", 47).
?DOC(false).
-spec encode__mixed_content_type(mixed_content_type()) -> gleam@json:json().
encode__mixed_content_type(Value__) ->
    _pipe = case Value__ of
        mixed_content_type_blockable ->
            <<"blockable"/utf8>>;

        mixed_content_type_optionally_blockable ->
            <<"optionally-blockable"/utf8>>;

        mixed_content_type_none ->
            <<"none"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\security.gleam", 57).
?DOC(false).
-spec decode__mixed_content_type() -> gleam@dynamic@decode:decoder(mixed_content_type()).
decode__mixed_content_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"blockable"/utf8>> ->
                        gleam@dynamic@decode:success(
                            mixed_content_type_blockable
                        );

                    <<"optionally-blockable"/utf8>> ->
                        gleam@dynamic@decode:success(
                            mixed_content_type_optionally_blockable
                        );

                    <<"none"/utf8>> ->
                        gleam@dynamic@decode:success(mixed_content_type_none);

                    _ ->
                        gleam@dynamic@decode:failure(
                            mixed_content_type_blockable,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\security.gleam", 81).
?DOC(false).
-spec encode__security_state(security_state()) -> gleam@json:json().
encode__security_state(Value__) ->
    _pipe = case Value__ of
        security_state_unknown ->
            <<"unknown"/utf8>>;

        security_state_neutral ->
            <<"neutral"/utf8>>;

        security_state_insecure ->
            <<"insecure"/utf8>>;

        security_state_secure ->
            <<"secure"/utf8>>;

        security_state_info ->
            <<"info"/utf8>>;

        security_state_insecure_broken ->
            <<"insecure-broken"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\security.gleam", 94).
?DOC(false).
-spec decode__security_state() -> gleam@dynamic@decode:decoder(security_state()).
decode__security_state() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"unknown"/utf8>> ->
                        gleam@dynamic@decode:success(security_state_unknown);

                    <<"neutral"/utf8>> ->
                        gleam@dynamic@decode:success(security_state_neutral);

                    <<"insecure"/utf8>> ->
                        gleam@dynamic@decode:success(security_state_insecure);

                    <<"secure"/utf8>> ->
                        gleam@dynamic@decode:success(security_state_secure);

                    <<"info"/utf8>> ->
                        gleam@dynamic@decode:success(security_state_info);

                    <<"insecure-broken"/utf8>> ->
                        gleam@dynamic@decode:success(
                            security_state_insecure_broken
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            security_state_unknown,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\security.gleam", 130).
?DOC(false).
-spec encode__security_state_explanation(security_state_explanation()) -> gleam@json:json().
encode__security_state_explanation(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"securityState"/utf8>>,
                    encode__security_state(erlang:element(2, Value__))},
                {<<"title"/utf8>>,
                    gleam@json:string(erlang:element(3, Value__))},
                {<<"summary"/utf8>>,
                    gleam@json:string(erlang:element(4, Value__))},
                {<<"description"/utf8>>,
                    gleam@json:string(erlang:element(5, Value__))},
                {<<"mixedContentType"/utf8>>,
                    encode__mixed_content_type(erlang:element(6, Value__))},
                {<<"certificate"/utf8>>,
                    gleam@json:array(
                        erlang:element(7, Value__),
                        fun gleam@json:string/1
                    )}],
            chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(8, Value__),
                fun(Inner_value__) ->
                    {<<"recommendations"/utf8>>,
                        gleam@json:array(Inner_value__, fun gleam@json:string/1)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\security.gleam", 150).
?DOC(false).
-spec decode__security_state_explanation() -> gleam@dynamic@decode:decoder(security_state_explanation()).
decode__security_state_explanation() ->
    begin
        gleam@dynamic@decode:field(
            <<"securityState"/utf8>>,
            decode__security_state(),
            fun(Security_state) ->
                gleam@dynamic@decode:field(
                    <<"title"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Title) ->
                        gleam@dynamic@decode:field(
                            <<"summary"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Summary) ->
                                gleam@dynamic@decode:field(
                                    <<"description"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_string/1},
                                    fun(Description) ->
                                        gleam@dynamic@decode:field(
                                            <<"mixedContentType"/utf8>>,
                                            decode__mixed_content_type(),
                                            fun(Mixed_content_type) ->
                                                gleam@dynamic@decode:field(
                                                    <<"certificate"/utf8>>,
                                                    gleam@dynamic@decode:list(
                                                        {decoder,
                                                            fun gleam@dynamic@decode:decode_string/1}
                                                    ),
                                                    fun(Certificate) ->
                                                        gleam@dynamic@decode:optional_field(
                                                            <<"recommendations"/utf8>>,
                                                            none,
                                                            gleam@dynamic@decode:optional(
                                                                gleam@dynamic@decode:list(
                                                                    {decoder,
                                                                        fun gleam@dynamic@decode:decode_string/1}
                                                                )
                                                            ),
                                                            fun(Recommendations) ->
                                                                gleam@dynamic@decode:success(
                                                                    {security_state_explanation,
                                                                        Security_state,
                                                                        Title,
                                                                        Summary,
                                                                        Description,
                                                                        Mixed_content_type,
                                                                        Certificate,
                                                                        Recommendations}
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
    end.

-file("src\\chrobot_extra\\protocol\\security.gleam", 190).
?DOC(false).
-spec encode__certificate_error_action(certificate_error_action()) -> gleam@json:json().
encode__certificate_error_action(Value__) ->
    _pipe = case Value__ of
        certificate_error_action_continue ->
            <<"continue"/utf8>>;

        certificate_error_action_cancel ->
            <<"cancel"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\security.gleam", 199).
?DOC(false).
-spec decode__certificate_error_action() -> gleam@dynamic@decode:decoder(certificate_error_action()).
decode__certificate_error_action() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"continue"/utf8>> ->
                        gleam@dynamic@decode:success(
                            certificate_error_action_continue
                        );

                    <<"cancel"/utf8>> ->
                        gleam@dynamic@decode:success(
                            certificate_error_action_cancel
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            certificate_error_action_continue,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\security.gleam", 212).
?DOC(" Disables tracking security state changes.\n").
-spec disable(fun((binary(), gleam@option:option(any())) -> OUT)) -> OUT.
disable(Callback__) ->
    Callback__(<<"Security.disable"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\security.gleam", 218).
?DOC(" Enables tracking security state changes.\n").
-spec enable(fun((binary(), gleam@option:option(any())) -> OUX)) -> OUX.
enable(Callback__) ->
    Callback__(<<"Security.enable"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\security.gleam", 229).
?DOC(
    " Enable/disable whether all certificate errors should be ignored.\n"
    " \n"
    " Parameters:  \n"
    "  - `ignore` : If true, all certificate errors will be ignored.\n"
    " \n"
    " Returns:\n"
).
-spec set_ignore_certificate_errors(
    fun((binary(), gleam@option:option(gleam@json:json())) -> OVB),
    boolean()
) -> OVB.
set_ignore_certificate_errors(Callback__, Ignore) ->
    Callback__(
        <<"Security.setIgnoreCertificateErrors"/utf8>>,
        {some,
            gleam@json:object([{<<"ignore"/utf8>>, gleam@json:bool(Ignore)}])}
    ).
