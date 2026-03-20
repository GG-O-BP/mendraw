-module(chrobot_extra@internal@os).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\internal\\os.gleam").
-export([family/0]).
-export_type([os_family/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-type os_family() :: darwin | linux | windows_nt | free_bsd | other.

-file("src\\chrobot_extra\\internal\\os.gleam", 11).
?DOC(false).
-spec family() -> os_family().
family() ->
    case chrobot_extra_ffi:get_os_type() of
        {<<"unix"/utf8>>, <<"darwin"/utf8>>} ->
            darwin;

        {<<"unix"/utf8>>, <<"linux"/utf8>>} ->
            linux;

        {<<"unix"/utf8>>, <<"freebsd"/utf8>>} ->
            free_bsd;

        {<<"win32"/utf8>>, _} ->
            windows_nt;

        _ ->
            other
    end.
