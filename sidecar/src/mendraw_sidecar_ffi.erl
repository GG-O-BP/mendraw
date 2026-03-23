-module(mendraw_sidecar_ffi).
-export([get_arguments/0, ensure_apps_started/0, kill_zombie_chrome/0]).

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

%% chrobot_extra가 Windows에서 WebSocket 트랜스포트 사용 시 gun 필요.
%% HTTP 서버 모드에서는 mist가 알아서 시작하지만,
%% marketplace TUI 모드에서는 명시적 시작 필요.
ensure_apps_started() ->
    {ok, _} = application:ensure_all_started(gun),
    {ok, _} = application:ensure_all_started(inets),
    {ok, _} = application:ensure_all_started(ssl),
    nil.

%% chrobot-ws-profile lockfile을 잡고 있는 좀비 Chrome 강제 종료
kill_zombie_chrome() ->
    case os:type() of
        {win32, _} ->
            os:cmd("cmd /c \"taskkill /F /IM chrome.exe\" 2>nul"),
            timer:sleep(1000);
        _ ->
            os:cmd("pkill -f chrobot-ws-profile 2>/dev/null"),
            timer:sleep(500)
    end,
    nil.

