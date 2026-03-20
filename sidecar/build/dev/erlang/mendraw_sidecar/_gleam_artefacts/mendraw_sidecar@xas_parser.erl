-module(mendraw_sidecar@xas_parser).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\mendraw_sidecar\\xas_parser.gleam").
-export([parse_xas_body/1, encode_version/1]).
-export_type([xas_version/0]).

-type xas_version() :: {xas_version, binary(), boolean(), binary(), binary()}.

-file("src\\mendraw_sidecar\\xas_parser.gleam", 54).
-spec extract_version(gleam@dynamic:dynamic_()) -> gleam@dynamic@decode:decoder({ok,
        xas_version()} |
    {error, nil}).
extract_version(Attrs) ->
    case gleam@dynamic@decode:run(
        Attrs,
        gleam@dynamic@decode:at(
            [<<"S3ObjectId"/utf8>>, <<"value"/utf8>>],
            {decoder, fun gleam@dynamic@decode:decode_string/1}
        )
    ) of
        {error, _} ->
            gleam@dynamic@decode:success({error, nil});

        {ok, S3_id} ->
            React = begin
                _pipe = gleam@dynamic@decode:run(
                    Attrs,
                    gleam@dynamic@decode:at(
                        [<<"IsReactClientReady"/utf8>>, <<"value"/utf8>>],
                        {decoder, fun gleam@dynamic@decode:decode_bool/1}
                    )
                ),
                gleam@result:unwrap(_pipe, false)
            end,
            Date = begin
                _pipe@1 = gleam@dynamic@decode:run(
                    Attrs,
                    gleam@dynamic@decode:at(
                        [<<"PublishDate"/utf8>>, <<"value"/utf8>>],
                        {decoder, fun gleam@dynamic@decode:decode_string/1}
                    )
                ),
                gleam@result:unwrap(_pipe@1, <<""/utf8>>)
            end,
            Ver = begin
                _pipe@2 = gleam@dynamic@decode:run(
                    Attrs,
                    gleam@dynamic@decode:at(
                        [<<"DisplayVersionNumber"/utf8>>, <<"value"/utf8>>],
                        {decoder, fun gleam@dynamic@decode:decode_string/1}
                    )
                ),
                gleam@result:unwrap(_pipe@2, <<""/utf8>>)
            end,
            gleam@dynamic@decode:success(
                {ok, {xas_version, S3_id, React, Date, Ver}}
            )
    end.

-file("src\\mendraw_sidecar\\xas_parser.gleam", 35).
-spec decode_maybe_version() -> gleam@dynamic@decode:decoder({ok, xas_version()} |
    {error, nil}).
decode_maybe_version() ->
    gleam@dynamic@decode:field(
        <<"objectType"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_string/1},
        fun(Object_type) -> case Object_type of
                <<"AppStore.Version"/utf8>> ->
                    gleam@dynamic@decode:optional_field(
                        <<"attributes"/utf8>>,
                        none,
                        gleam@dynamic@decode:optional(
                            {decoder, fun gleam@dynamic@decode:decode_dynamic/1}
                        ),
                        fun(Attrs_opt) -> case Attrs_opt of
                                none ->
                                    gleam@dynamic@decode:success({error, nil});

                                {some, Attrs} ->
                                    extract_version(Attrs)
                            end end
                    );

                _ ->
                    gleam@dynamic@decode:success({error, nil})
            end end
    ).

-file("src\\mendraw_sidecar\\xas_parser.gleam", 27).
-spec decode_xas_response() -> gleam@dynamic@decode:decoder(list(xas_version())).
decode_xas_response() ->
    gleam@dynamic@decode:field(
        <<"objects"/utf8>>,
        gleam@dynamic@decode:list(decode_maybe_version()),
        fun(Objects) ->
            gleam@dynamic@decode:success(
                gleam@list:filter_map(Objects, fun(X) -> X end)
            )
        end
    ).

-file("src\\mendraw_sidecar\\xas_parser.gleam", 20).
-spec parse_xas_body(binary()) -> list(xas_version()).
parse_xas_body(Body) ->
    case gleam@json:parse(Body, decode_xas_response()) of
        {ok, Versions} ->
            Versions;

        {error, _} ->
            []
    end.

-file("src\\mendraw_sidecar\\xas_parser.gleam", 93).
-spec encode_version(xas_version()) -> gleam@json:json().
encode_version(V) ->
    gleam@json:object(
        [{<<"s3ObjectId"/utf8>>, gleam@json:string(erlang:element(2, V))},
            {<<"reactReady"/utf8>>, gleam@json:bool(erlang:element(3, V))},
            {<<"publishDate"/utf8>>, gleam@json:string(erlang:element(4, V))},
            {<<"versionNumber"/utf8>>, gleam@json:string(erlang:element(5, V))}]
    ).
