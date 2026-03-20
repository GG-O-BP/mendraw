-module(mendraw_sidecar@router).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\mendraw_sidecar\\router.gleam").
-export([handler/0]).

-file("src\\mendraw_sidecar\\router.gleam", 27).
-spec handle_health() -> gleam@http@response:response(mist:response_data()).
handle_health() ->
    mendraw_sidecar@http_utils:json_response(
        200,
        gleam@json:object(
            [{<<"status"/utf8>>, gleam@json:string(<<"ok"/utf8>>)}]
        )
    ).

-file("src\\mendraw_sidecar\\router.gleam", 49).
-spec not_found() -> gleam@http@response:response(mist:response_data()).
not_found() ->
    mendraw_sidecar@http_utils:json_response(
        404,
        gleam@json:object(
            [{<<"error"/utf8>>, gleam@json:string(<<"not found"/utf8>>)}]
        )
    ).

-file("src\\mendraw_sidecar\\router.gleam", 34).
-spec handle_shutdown() -> gleam@http@response:response(mist:response_data()).
handle_shutdown() ->
    Resp = mendraw_sidecar@http_utils:json_response(
        200,
        gleam@json:object(
            [{<<"status"/utf8>>, gleam@json:string(<<"shutting_down"/utf8>>)}]
        )
    ),
    _ = erlang:spawn(
        fun() ->
            gleam_erlang_ffi:sleep(200),
            init:stop()
        end
    ),
    Resp.

-file("src\\mendraw_sidecar\\router.gleam", 14).
-spec handler() -> fun((gleam@http@request:request(mist@internal@http:connection())) -> gleam@http@response:response(mist:response_data())).
handler() ->
    fun(Req) ->
        case {gleam@http@request:path_segments(Req), erlang:element(2, Req)} of
            {[<<"health"/utf8>>], get} ->
                handle_health();

            {[<<"shutdown"/utf8>>], post} ->
                handle_shutdown();

            {[<<"session"/utf8>>, <<"ensure"/utf8>>], post} ->
                mendraw_sidecar@session_handler:handle(Req);

            {[<<"versions"/utf8>>, <<"all"/utf8>>], post} ->
                mendraw_sidecar@version_handler:handle_all(Req);

            {[<<"versions"/utf8>>, <<"single"/utf8>>], post} ->
                mendraw_sidecar@version_handler:handle_single(Req);

            {_, _} ->
                not_found()
        end
    end.
