-module(mendraw_sidecar@http_utils).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\mendraw_sidecar\\http_utils.gleam").
-export([json_response/2, read_body/1, error_response/1]).

-file("src\\mendraw_sidecar\\http_utils.gleam", 10).
-spec json_response(integer(), gleam@json:json()) -> gleam@http@response:response(mist:response_data()).
json_response(Status, Body) ->
    _pipe = gleam@http@response:new(Status),
    _pipe@1 = gleam@http@response:set_body(
        _pipe,
        {bytes, gleam_stdlib:wrap_list(gleam@json:to_string(Body))}
    ),
    gleam@http@response:set_header(
        _pipe@1,
        <<"content-type"/utf8>>,
        <<"application/json"/utf8>>
    ).

-file("src\\mendraw_sidecar\\http_utils.gleam", 16).
-spec read_body(gleam@http@request:request(mist@internal@http:connection())) -> {ok,
        binary()} |
    {error, gleam@http@response:response(mist:response_data())}.
read_body(Req) ->
    case mist:read_body(Req, 1048576) of
        {ok, Req_with_body} ->
            case gleam@bit_array:to_string(erlang:element(4, Req_with_body)) of
                {ok, Str} ->
                    {ok, Str};

                {error, _} ->
                    {error,
                        json_response(
                            400,
                            gleam@json:object(
                                [{<<"error"/utf8>>,
                                        gleam@json:string(<<"잘못된 요청 본문"/utf8>>)}]
                            )
                        )}
            end;

        {error, _} ->
            {error,
                json_response(
                    400,
                    gleam@json:object(
                        [{<<"error"/utf8>>,
                                gleam@json:string(<<"요청 본문 읽기 실패"/utf8>>)}]
                    )
                )}
    end.

-file("src\\mendraw_sidecar\\http_utils.gleam", 38).
-spec error_response(binary()) -> gleam@http@response:response(mist:response_data()).
error_response(Message) ->
    json_response(
        500,
        gleam@json:object(
            [{<<"ok"/utf8>>, gleam@json:bool(false)},
                {<<"error"/utf8>>, gleam@json:string(Message)}]
        )
    ).
