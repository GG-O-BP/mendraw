-module(mendraw_sidecar).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\mendraw_sidecar.gleam").
-export([main/0]).
-export_type([charlist/0]).

-type charlist() :: any().

-file("src\\mendraw_sidecar.gleam", 29).
-spec get_plain_arguments() -> list(binary()).
get_plain_arguments() ->
    _pipe = init:get_plain_arguments(),
    gleam@list:filter_map(
        _pipe,
        fun(Charlist) -> case unicode:characters_to_binary(Charlist) of
                {ok, S} ->
                    {ok, S};

                {error, _} ->
                    {error, nil}
            end end
    ).

-file("src\\mendraw_sidecar.gleam", 12).
-spec main() -> nil.
main() ->
    Port = case get_plain_arguments() of
        [Port_str | _] ->
            _pipe = gleam_stdlib:parse_int(Port_str),
            gleam@result:unwrap(_pipe, 0);

        _ ->
            0
    end,
    case begin
        _pipe@1 = mendraw_sidecar@router:handler(),
        _pipe@2 = mist:new(_pipe@1),
        _pipe@3 = mist:port(_pipe@2, Port),
        mist:start(_pipe@3)
    end of
        {ok, _} -> nil;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"mendraw_sidecar"/utf8>>,
                        function => <<"main"/utf8>>,
                        line => 18,
                        value => _assert_fail,
                        start => 437,
                        'end' => 533,
                        pattern_start => 448,
                        pattern_end => 453})
    end,
    gleam_stdlib:println(
        <<"SIDECAR_PORT="/utf8, (erlang:integer_to_binary(Port))/binary>>
    ),
    gleam_erlang_ffi:sleep_forever().
