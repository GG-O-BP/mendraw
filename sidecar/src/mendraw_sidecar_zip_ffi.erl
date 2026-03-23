-module(mendraw_sidecar_zip_ffi).
-export([unzip_to_memory/1]).

%% ZIP 바이너리를 메모리에 압축 해제
%% Returns: {ok, [{FileName :: binary(), Content :: binary()}]} | {error, Reason}
unzip_to_memory(ZipBinary) ->
    case zip:unzip(ZipBinary, [memory]) of
        {ok, Entries} ->
            BinEntries = [{unicode:characters_to_binary(F), C} || {F, C} <- Entries],
            {ok, BinEntries};
        {error, Reason} ->
            {error, unicode:characters_to_binary(io_lib:format("~p", [Reason]))}
    end.
