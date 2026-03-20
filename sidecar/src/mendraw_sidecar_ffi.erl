-module(mendraw_sidecar_ffi).
-export([get_arguments/0]).

%% init:get_plain_arguments()는 gleam run에서는 charlist,
%% escript에서는 binary를 반환할 수 있음. 양쪽 모두 처리.
get_arguments() ->
    [to_binary(A) || A <- init:get_plain_arguments()].

to_binary(A) when is_binary(A) -> A;
to_binary(A) when is_list(A) ->
    case unicode:characters_to_binary(A) of
        Bin when is_binary(Bin) -> Bin;
        _ -> <<>>
    end;
to_binary(_) -> <<>>.
