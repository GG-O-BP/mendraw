-module(chrobot_extra@protocol@io).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\protocol\\io.gleam").
-export([encode__stream_handle/1, decode__stream_handle/0, decode__read_response/0, decode__resolve_blob_response/0, close/2, read/4, resolve_blob/2]).
-export_type([stream_handle/0, read_response/0, resolve_blob_response/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " > ⚙️  This module was generated from the Chrome DevTools Protocol version **1.3**\n"
    " ## IO Domain  \n"
    "\n"
    " Input/Output operations for streams produced by DevTools.  \n"
    "\n"
    " [📖   View this domain on the DevTools Protocol API Docs](https://chromedevtools.github.io/devtools-protocol/1-3/IO/)\n"
).

-type stream_handle() :: {stream_handle, binary()}.

-type read_response() :: {read_response,
        gleam@option:option(boolean()),
        binary(),
        boolean()}.

-type resolve_blob_response() :: {resolve_blob_response, binary()}.

-file("src\\chrobot_extra\\protocol\\io.gleam", 28).
?DOC(false).
-spec encode__stream_handle(stream_handle()) -> gleam@json:json().
encode__stream_handle(Value__) ->
    case Value__ of
        {stream_handle, Inner_value__} ->
            gleam@json:string(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\io.gleam", 35).
?DOC(false).
-spec decode__stream_handle() -> gleam@dynamic@decode:decoder(stream_handle()).
decode__stream_handle() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({stream_handle, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\io.gleam", 56).
?DOC(false).
-spec decode__read_response() -> gleam@dynamic@decode:decoder(read_response()).
decode__read_response() ->
    begin
        gleam@dynamic@decode:optional_field(
            <<"base64Encoded"/utf8>>,
            none,
            gleam@dynamic@decode:optional(
                {decoder, fun gleam@dynamic@decode:decode_bool/1}
            ),
            fun(Base64_encoded) ->
                gleam@dynamic@decode:field(
                    <<"data"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Data) ->
                        gleam@dynamic@decode:field(
                            <<"eof"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_bool/1},
                            fun(Eof) ->
                                gleam@dynamic@decode:success(
                                    {read_response, Base64_encoded, Data, Eof}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\io.gleam", 84).
?DOC(false).
-spec decode__resolve_blob_response() -> gleam@dynamic@decode:decoder(resolve_blob_response()).
decode__resolve_blob_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"uuid"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Uuid) ->
                gleam@dynamic@decode:success({resolve_blob_response, Uuid})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\io.gleam", 99).
?DOC(
    " Close the stream, discard any temporary backing storage.\n"
    " \n"
    " Parameters:  \n"
    "  - `handle` : Handle of the stream to close.\n"
    " \n"
    " Returns:\n"
).
-spec close(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UVG),
    stream_handle()
) -> UVG.
close(Callback__, Handle) ->
    Callback__(
        <<"IO.close"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"handle"/utf8>>, encode__stream_handle(Handle)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\io.gleam", 123).
?DOC(
    " Read a chunk of the stream\n"
    " \n"
    " Parameters:  \n"
    "  - `handle` : Handle of the stream to read.\n"
    "  - `offset` : Seek to the specified offset before reading (if not specified, proceed with offset\n"
    " following the last read). Some types of streams may only support sequential reads.\n"
    "  - `size` : Maximum number of bytes to read (left upon the agent discretion if not specified).\n"
    " \n"
    " Returns:  \n"
    "  - `base64_encoded` : Set if the data is base64-encoded\n"
    "  - `data` : Data that were read.\n"
    "  - `eof` : Set if the end-of-file condition occurred while reading.\n"
).
-spec read(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    stream_handle(),
    gleam@option:option(integer()),
    gleam@option:option(integer())
) -> {ok, read_response()} | {error, chrobot_extra@chrome:request_error()}.
read(Callback__, Handle, Offset, Size) ->
    gleam@result:'try'(
        Callback__(
            <<"IO.read"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"handle"/utf8>>,
                                encode__stream_handle(Handle)}],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Offset,
                            fun(Inner_value__) ->
                                {<<"offset"/utf8>>,
                                    gleam@json:int(Inner_value__)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Size,
                            fun(Inner_value__@1) ->
                                {<<"size"/utf8>>,
                                    gleam@json:int(Inner_value__@1)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@2 = gleam@dynamic@decode:run(
                Result__,
                decode__read_response()
            ),
            gleam@result:replace_error(_pipe@2, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\io.gleam", 156).
?DOC(
    " Return UUID of Blob object specified by a remote object id.\n"
    " \n"
    " Parameters:  \n"
    "  - `object_id` : Object id of a Blob object wrapper.\n"
    " \n"
    " Returns:  \n"
    "  - `uuid` : UUID of the specified Blob.\n"
).
-spec resolve_blob(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    chrobot_extra@protocol@runtime:remote_object_id()
) -> {ok, resolve_blob_response()} |
    {error, chrobot_extra@chrome:request_error()}.
resolve_blob(Callback__, Object_id) ->
    gleam@result:'try'(
        Callback__(
            <<"IO.resolveBlob"/utf8>>,
            {some,
                gleam@json:object(
                    [{<<"objectId"/utf8>>,
                            chrobot_extra@protocol@runtime:encode__remote_object_id(
                                Object_id
                            )}]
                )}
        ),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__resolve_blob_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).
