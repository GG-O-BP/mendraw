-module(chrobot_extra@internal@keymap).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\internal\\keymap.gleam").
-export([get_key_data/1]).
-export_type([key_data/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-type key_data() :: {key_data,
        gleam@option:option(integer()),
        gleam@option:option(binary()),
        gleam@option:option(binary()),
        gleam@option:option(binary()),
        gleam@option:option(integer())}.

-file("src\\chrobot_extra\\internal\\keymap.gleam", 34).
?DOC(false).
-spec get_key_data(binary()) -> {ok, key_data()} | {error, nil}.
get_key_data(Input) ->
    case Input of
        <<"0"/utf8>> ->
            {ok,
                {key_data,
                    {some, 48},
                    {some, <<"Digit0"/utf8>>},
                    {some, <<"0"/utf8>>},
                    none,
                    none}};

        <<"1"/utf8>> ->
            {ok,
                {key_data,
                    {some, 49},
                    {some, <<"Digit1"/utf8>>},
                    {some, <<"1"/utf8>>},
                    none,
                    none}};

        <<"2"/utf8>> ->
            {ok,
                {key_data,
                    {some, 50},
                    {some, <<"Digit2"/utf8>>},
                    {some, <<"2"/utf8>>},
                    none,
                    none}};

        <<"3"/utf8>> ->
            {ok,
                {key_data,
                    {some, 51},
                    {some, <<"Digit3"/utf8>>},
                    {some, <<"3"/utf8>>},
                    none,
                    none}};

        <<"4"/utf8>> ->
            {ok,
                {key_data,
                    {some, 52},
                    {some, <<"Digit4"/utf8>>},
                    {some, <<"4"/utf8>>},
                    none,
                    none}};

        <<"5"/utf8>> ->
            {ok,
                {key_data,
                    {some, 53},
                    {some, <<"Digit5"/utf8>>},
                    {some, <<"5"/utf8>>},
                    none,
                    none}};

        <<"6"/utf8>> ->
            {ok,
                {key_data,
                    {some, 54},
                    {some, <<"Digit6"/utf8>>},
                    {some, <<"6"/utf8>>},
                    none,
                    none}};

        <<"7"/utf8>> ->
            {ok,
                {key_data,
                    {some, 55},
                    {some, <<"Digit7"/utf8>>},
                    {some, <<"7"/utf8>>},
                    none,
                    none}};

        <<"8"/utf8>> ->
            {ok,
                {key_data,
                    {some, 56},
                    {some, <<"Digit8"/utf8>>},
                    {some, <<"8"/utf8>>},
                    none,
                    none}};

        <<"9"/utf8>> ->
            {ok,
                {key_data,
                    {some, 57},
                    {some, <<"Digit9"/utf8>>},
                    {some, <<"9"/utf8>>},
                    none,
                    none}};

        <<"Power"/utf8>> ->
            {ok,
                {key_data,
                    none,
                    {some, <<"Power"/utf8>>},
                    {some, <<"Power"/utf8>>},
                    none,
                    none}};

        <<"Eject"/utf8>> ->
            {ok,
                {key_data,
                    none,
                    {some, <<"Eject"/utf8>>},
                    {some, <<"Eject"/utf8>>},
                    none,
                    none}};

        <<"Abort"/utf8>> ->
            {ok,
                {key_data,
                    {some, 3},
                    {some, <<"Abort"/utf8>>},
                    {some, <<"Cancel"/utf8>>},
                    none,
                    none}};

        <<"Help"/utf8>> ->
            {ok,
                {key_data,
                    {some, 6},
                    {some, <<"Help"/utf8>>},
                    {some, <<"Help"/utf8>>},
                    none,
                    none}};

        <<"Backspace"/utf8>> ->
            {ok,
                {key_data,
                    {some, 8},
                    {some, <<"Backspace"/utf8>>},
                    {some, <<"Backspace"/utf8>>},
                    none,
                    none}};

        <<"Tab"/utf8>> ->
            {ok,
                {key_data,
                    {some, 9},
                    {some, <<"Tab"/utf8>>},
                    {some, <<"Tab"/utf8>>},
                    none,
                    none}};

        <<"Numpad5"/utf8>> ->
            {ok,
                {key_data,
                    {some, 12},
                    {some, <<"Numpad5"/utf8>>},
                    {some, <<"Clear"/utf8>>},
                    none,
                    {some, 3}}};

        <<"NumpadEnter"/utf8>> ->
            {ok,
                {key_data,
                    {some, 13},
                    {some, <<"NumpadEnter"/utf8>>},
                    {some, <<"Enter"/utf8>>},
                    {some, <<"\r"/utf8>>},
                    {some, 3}}};

        <<"Enter"/utf8>> ->
            {ok,
                {key_data,
                    {some, 13},
                    {some, <<"Enter"/utf8>>},
                    {some, <<"Enter"/utf8>>},
                    {some, <<"\r"/utf8>>},
                    none}};

        <<"\r"/utf8>> ->
            {ok,
                {key_data,
                    {some, 13},
                    {some, <<"Enter"/utf8>>},
                    {some, <<"Enter"/utf8>>},
                    {some, <<"\r"/utf8>>},
                    none}};

        <<"\n"/utf8>> ->
            {ok,
                {key_data,
                    {some, 13},
                    {some, <<"Enter"/utf8>>},
                    {some, <<"Enter"/utf8>>},
                    {some, <<"\r"/utf8>>},
                    none}};

        <<"ShiftLeft"/utf8>> ->
            {ok,
                {key_data,
                    {some, 16},
                    {some, <<"ShiftLeft"/utf8>>},
                    {some, <<"Shift"/utf8>>},
                    none,
                    {some, 1}}};

        <<"ShiftRight"/utf8>> ->
            {ok,
                {key_data,
                    {some, 16},
                    {some, <<"ShiftRight"/utf8>>},
                    {some, <<"Shift"/utf8>>},
                    none,
                    {some, 2}}};

        <<"ControlLeft"/utf8>> ->
            {ok,
                {key_data,
                    {some, 17},
                    {some, <<"ControlLeft"/utf8>>},
                    {some, <<"Control"/utf8>>},
                    none,
                    {some, 1}}};

        <<"ControlRight"/utf8>> ->
            {ok,
                {key_data,
                    {some, 17},
                    {some, <<"ControlRight"/utf8>>},
                    {some, <<"Control"/utf8>>},
                    none,
                    {some, 2}}};

        <<"AltLeft"/utf8>> ->
            {ok,
                {key_data,
                    {some, 18},
                    {some, <<"AltLeft"/utf8>>},
                    {some, <<"Alt"/utf8>>},
                    none,
                    {some, 1}}};

        <<"AltRight"/utf8>> ->
            {ok,
                {key_data,
                    {some, 18},
                    {some, <<"AltRight"/utf8>>},
                    {some, <<"Alt"/utf8>>},
                    none,
                    {some, 2}}};

        <<"Pause"/utf8>> ->
            {ok,
                {key_data,
                    {some, 19},
                    {some, <<"Pause"/utf8>>},
                    {some, <<"Pause"/utf8>>},
                    none,
                    none}};

        <<"CapsLock"/utf8>> ->
            {ok,
                {key_data,
                    {some, 20},
                    {some, <<"CapsLock"/utf8>>},
                    {some, <<"CapsLock"/utf8>>},
                    none,
                    none}};

        <<"Escape"/utf8>> ->
            {ok,
                {key_data,
                    {some, 27},
                    {some, <<"Escape"/utf8>>},
                    {some, <<"Escape"/utf8>>},
                    none,
                    none}};

        <<"Convert"/utf8>> ->
            {ok,
                {key_data,
                    {some, 28},
                    {some, <<"Convert"/utf8>>},
                    {some, <<"Convert"/utf8>>},
                    none,
                    none}};

        <<"NonConvert"/utf8>> ->
            {ok,
                {key_data,
                    {some, 29},
                    {some, <<"NonConvert"/utf8>>},
                    {some, <<"NonConvert"/utf8>>},
                    none,
                    none}};

        <<"Space"/utf8>> ->
            {ok,
                {key_data,
                    {some, 32},
                    {some, <<"Space"/utf8>>},
                    {some, <<" "/utf8>>},
                    none,
                    none}};

        <<"Numpad9"/utf8>> ->
            {ok,
                {key_data,
                    {some, 33},
                    {some, <<"Numpad9"/utf8>>},
                    {some, <<"PageUp"/utf8>>},
                    none,
                    {some, 3}}};

        <<"PageUp"/utf8>> ->
            {ok,
                {key_data,
                    {some, 33},
                    {some, <<"PageUp"/utf8>>},
                    {some, <<"PageUp"/utf8>>},
                    none,
                    none}};

        <<"Numpad3"/utf8>> ->
            {ok,
                {key_data,
                    {some, 34},
                    {some, <<"Numpad3"/utf8>>},
                    {some, <<"PageDown"/utf8>>},
                    none,
                    {some, 3}}};

        <<"PageDown"/utf8>> ->
            {ok,
                {key_data,
                    {some, 34},
                    {some, <<"PageDown"/utf8>>},
                    {some, <<"PageDown"/utf8>>},
                    none,
                    none}};

        <<"End"/utf8>> ->
            {ok,
                {key_data,
                    {some, 35},
                    {some, <<"End"/utf8>>},
                    {some, <<"End"/utf8>>},
                    none,
                    none}};

        <<"Numpad1"/utf8>> ->
            {ok,
                {key_data,
                    {some, 35},
                    {some, <<"Numpad1"/utf8>>},
                    {some, <<"End"/utf8>>},
                    none,
                    {some, 3}}};

        <<"Home"/utf8>> ->
            {ok,
                {key_data,
                    {some, 36},
                    {some, <<"Home"/utf8>>},
                    {some, <<"Home"/utf8>>},
                    none,
                    none}};

        <<"Numpad7"/utf8>> ->
            {ok,
                {key_data,
                    {some, 36},
                    {some, <<"Numpad7"/utf8>>},
                    {some, <<"Home"/utf8>>},
                    none,
                    {some, 3}}};

        <<"ArrowLeft"/utf8>> ->
            {ok,
                {key_data,
                    {some, 37},
                    {some, <<"ArrowLeft"/utf8>>},
                    {some, <<"ArrowLeft"/utf8>>},
                    none,
                    none}};

        <<"Numpad4"/utf8>> ->
            {ok,
                {key_data,
                    {some, 37},
                    {some, <<"Numpad4"/utf8>>},
                    {some, <<"ArrowLeft"/utf8>>},
                    none,
                    {some, 3}}};

        <<"Numpad8"/utf8>> ->
            {ok,
                {key_data,
                    {some, 38},
                    {some, <<"Numpad8"/utf8>>},
                    {some, <<"ArrowUp"/utf8>>},
                    none,
                    {some, 3}}};

        <<"ArrowUp"/utf8>> ->
            {ok,
                {key_data,
                    {some, 38},
                    {some, <<"ArrowUp"/utf8>>},
                    {some, <<"ArrowUp"/utf8>>},
                    none,
                    none}};

        <<"ArrowRight"/utf8>> ->
            {ok,
                {key_data,
                    {some, 39},
                    {some, <<"ArrowRight"/utf8>>},
                    {some, <<"ArrowRight"/utf8>>},
                    none,
                    none}};

        <<"Numpad6"/utf8>> ->
            {ok,
                {key_data,
                    {some, 39},
                    {some, <<"Numpad6"/utf8>>},
                    {some, <<"ArrowRight"/utf8>>},
                    none,
                    {some, 3}}};

        <<"Numpad2"/utf8>> ->
            {ok,
                {key_data,
                    {some, 40},
                    {some, <<"Numpad2"/utf8>>},
                    {some, <<"ArrowDown"/utf8>>},
                    none,
                    {some, 3}}};

        <<"ArrowDown"/utf8>> ->
            {ok,
                {key_data,
                    {some, 40},
                    {some, <<"ArrowDown"/utf8>>},
                    {some, <<"ArrowDown"/utf8>>},
                    none,
                    none}};

        <<"Select"/utf8>> ->
            {ok,
                {key_data,
                    {some, 41},
                    {some, <<"Select"/utf8>>},
                    {some, <<"Select"/utf8>>},
                    none,
                    none}};

        <<"Open"/utf8>> ->
            {ok,
                {key_data,
                    {some, 43},
                    {some, <<"Open"/utf8>>},
                    {some, <<"Execute"/utf8>>},
                    none,
                    none}};

        <<"PrintScreen"/utf8>> ->
            {ok,
                {key_data,
                    {some, 44},
                    {some, <<"PrintScreen"/utf8>>},
                    {some, <<"PrintScreen"/utf8>>},
                    none,
                    none}};

        <<"Insert"/utf8>> ->
            {ok,
                {key_data,
                    {some, 45},
                    {some, <<"Insert"/utf8>>},
                    {some, <<"Insert"/utf8>>},
                    none,
                    none}};

        <<"Numpad0"/utf8>> ->
            {ok,
                {key_data,
                    {some, 45},
                    {some, <<"Numpad0"/utf8>>},
                    {some, <<"Insert"/utf8>>},
                    none,
                    {some, 3}}};

        <<"Delete"/utf8>> ->
            {ok,
                {key_data,
                    {some, 46},
                    {some, <<"Delete"/utf8>>},
                    {some, <<"Delete"/utf8>>},
                    none,
                    none}};

        <<"NumpadDecimal"/utf8>> ->
            {ok,
                {key_data,
                    {some, 46},
                    {some, <<"NumpadDecimal"/utf8>>},
                    {some, <<"\\u0000"/utf8>>},
                    none,
                    {some, 3}}};

        <<"Digit0"/utf8>> ->
            {ok,
                {key_data,
                    {some, 48},
                    {some, <<"Digit0"/utf8>>},
                    {some, <<"0"/utf8>>},
                    none,
                    none}};

        <<"Digit1"/utf8>> ->
            {ok,
                {key_data,
                    {some, 49},
                    {some, <<"Digit1"/utf8>>},
                    {some, <<"1"/utf8>>},
                    none,
                    none}};

        <<"Digit2"/utf8>> ->
            {ok,
                {key_data,
                    {some, 50},
                    {some, <<"Digit2"/utf8>>},
                    {some, <<"2"/utf8>>},
                    none,
                    none}};

        <<"Digit3"/utf8>> ->
            {ok,
                {key_data,
                    {some, 51},
                    {some, <<"Digit3"/utf8>>},
                    {some, <<"3"/utf8>>},
                    none,
                    none}};

        <<"Digit4"/utf8>> ->
            {ok,
                {key_data,
                    {some, 52},
                    {some, <<"Digit4"/utf8>>},
                    {some, <<"4"/utf8>>},
                    none,
                    none}};

        <<"Digit5"/utf8>> ->
            {ok,
                {key_data,
                    {some, 53},
                    {some, <<"Digit5"/utf8>>},
                    {some, <<"5"/utf8>>},
                    none,
                    none}};

        <<"Digit6"/utf8>> ->
            {ok,
                {key_data,
                    {some, 54},
                    {some, <<"Digit6"/utf8>>},
                    {some, <<"6"/utf8>>},
                    none,
                    none}};

        <<"Digit7"/utf8>> ->
            {ok,
                {key_data,
                    {some, 55},
                    {some, <<"Digit7"/utf8>>},
                    {some, <<"7"/utf8>>},
                    none,
                    none}};

        <<"Digit8"/utf8>> ->
            {ok,
                {key_data,
                    {some, 56},
                    {some, <<"Digit8"/utf8>>},
                    {some, <<"8"/utf8>>},
                    none,
                    none}};

        <<"Digit9"/utf8>> ->
            {ok,
                {key_data,
                    {some, 57},
                    {some, <<"Digit9"/utf8>>},
                    {some, <<"9"/utf8>>},
                    none,
                    none}};

        <<"KeyA"/utf8>> ->
            {ok,
                {key_data,
                    {some, 65},
                    {some, <<"KeyA"/utf8>>},
                    {some, <<"a"/utf8>>},
                    none,
                    none}};

        <<"KeyB"/utf8>> ->
            {ok,
                {key_data,
                    {some, 66},
                    {some, <<"KeyB"/utf8>>},
                    {some, <<"b"/utf8>>},
                    none,
                    none}};

        <<"KeyC"/utf8>> ->
            {ok,
                {key_data,
                    {some, 67},
                    {some, <<"KeyC"/utf8>>},
                    {some, <<"c"/utf8>>},
                    none,
                    none}};

        <<"KeyD"/utf8>> ->
            {ok,
                {key_data,
                    {some, 68},
                    {some, <<"KeyD"/utf8>>},
                    {some, <<"d"/utf8>>},
                    none,
                    none}};

        <<"KeyE"/utf8>> ->
            {ok,
                {key_data,
                    {some, 69},
                    {some, <<"KeyE"/utf8>>},
                    {some, <<"e"/utf8>>},
                    none,
                    none}};

        <<"KeyF"/utf8>> ->
            {ok,
                {key_data,
                    {some, 70},
                    {some, <<"KeyF"/utf8>>},
                    {some, <<"f"/utf8>>},
                    none,
                    none}};

        <<"KeyG"/utf8>> ->
            {ok,
                {key_data,
                    {some, 71},
                    {some, <<"KeyG"/utf8>>},
                    {some, <<"g"/utf8>>},
                    none,
                    none}};

        <<"KeyH"/utf8>> ->
            {ok,
                {key_data,
                    {some, 72},
                    {some, <<"KeyH"/utf8>>},
                    {some, <<"h"/utf8>>},
                    none,
                    none}};

        <<"KeyI"/utf8>> ->
            {ok,
                {key_data,
                    {some, 73},
                    {some, <<"KeyI"/utf8>>},
                    {some, <<"i"/utf8>>},
                    none,
                    none}};

        <<"KeyJ"/utf8>> ->
            {ok,
                {key_data,
                    {some, 74},
                    {some, <<"KeyJ"/utf8>>},
                    {some, <<"j"/utf8>>},
                    none,
                    none}};

        <<"KeyK"/utf8>> ->
            {ok,
                {key_data,
                    {some, 75},
                    {some, <<"KeyK"/utf8>>},
                    {some, <<"k"/utf8>>},
                    none,
                    none}};

        <<"KeyL"/utf8>> ->
            {ok,
                {key_data,
                    {some, 76},
                    {some, <<"KeyL"/utf8>>},
                    {some, <<"l"/utf8>>},
                    none,
                    none}};

        <<"KeyM"/utf8>> ->
            {ok,
                {key_data,
                    {some, 77},
                    {some, <<"KeyM"/utf8>>},
                    {some, <<"m"/utf8>>},
                    none,
                    none}};

        <<"KeyN"/utf8>> ->
            {ok,
                {key_data,
                    {some, 78},
                    {some, <<"KeyN"/utf8>>},
                    {some, <<"n"/utf8>>},
                    none,
                    none}};

        <<"KeyO"/utf8>> ->
            {ok,
                {key_data,
                    {some, 79},
                    {some, <<"KeyO"/utf8>>},
                    {some, <<"o"/utf8>>},
                    none,
                    none}};

        <<"KeyP"/utf8>> ->
            {ok,
                {key_data,
                    {some, 80},
                    {some, <<"KeyP"/utf8>>},
                    {some, <<"p"/utf8>>},
                    none,
                    none}};

        <<"KeyQ"/utf8>> ->
            {ok,
                {key_data,
                    {some, 81},
                    {some, <<"KeyQ"/utf8>>},
                    {some, <<"q"/utf8>>},
                    none,
                    none}};

        <<"KeyR"/utf8>> ->
            {ok,
                {key_data,
                    {some, 82},
                    {some, <<"KeyR"/utf8>>},
                    {some, <<"r"/utf8>>},
                    none,
                    none}};

        <<"KeyS"/utf8>> ->
            {ok,
                {key_data,
                    {some, 83},
                    {some, <<"KeyS"/utf8>>},
                    {some, <<"s"/utf8>>},
                    none,
                    none}};

        <<"KeyT"/utf8>> ->
            {ok,
                {key_data,
                    {some, 84},
                    {some, <<"KeyT"/utf8>>},
                    {some, <<"t"/utf8>>},
                    none,
                    none}};

        <<"KeyU"/utf8>> ->
            {ok,
                {key_data,
                    {some, 85},
                    {some, <<"KeyU"/utf8>>},
                    {some, <<"u"/utf8>>},
                    none,
                    none}};

        <<"KeyV"/utf8>> ->
            {ok,
                {key_data,
                    {some, 86},
                    {some, <<"KeyV"/utf8>>},
                    {some, <<"v"/utf8>>},
                    none,
                    none}};

        <<"KeyW"/utf8>> ->
            {ok,
                {key_data,
                    {some, 87},
                    {some, <<"KeyW"/utf8>>},
                    {some, <<"w"/utf8>>},
                    none,
                    none}};

        <<"KeyX"/utf8>> ->
            {ok,
                {key_data,
                    {some, 88},
                    {some, <<"KeyX"/utf8>>},
                    {some, <<"x"/utf8>>},
                    none,
                    none}};

        <<"KeyY"/utf8>> ->
            {ok,
                {key_data,
                    {some, 89},
                    {some, <<"KeyY"/utf8>>},
                    {some, <<"y"/utf8>>},
                    none,
                    none}};

        <<"KeyZ"/utf8>> ->
            {ok,
                {key_data,
                    {some, 90},
                    {some, <<"KeyZ"/utf8>>},
                    {some, <<"z"/utf8>>},
                    none,
                    none}};

        <<"MetaLeft"/utf8>> ->
            {ok,
                {key_data,
                    {some, 91},
                    {some, <<"MetaLeft"/utf8>>},
                    {some, <<"Meta"/utf8>>},
                    none,
                    {some, 1}}};

        <<"MetaRight"/utf8>> ->
            {ok,
                {key_data,
                    {some, 92},
                    {some, <<"MetaRight"/utf8>>},
                    {some, <<"Meta"/utf8>>},
                    none,
                    {some, 2}}};

        <<"ContextMenu"/utf8>> ->
            {ok,
                {key_data,
                    {some, 93},
                    {some, <<"ContextMenu"/utf8>>},
                    {some, <<"ContextMenu"/utf8>>},
                    none,
                    none}};

        <<"NumpadMultiply"/utf8>> ->
            {ok,
                {key_data,
                    {some, 106},
                    {some, <<"NumpadMultiply"/utf8>>},
                    {some, <<"*"/utf8>>},
                    none,
                    {some, 3}}};

        <<"NumpadAdd"/utf8>> ->
            {ok,
                {key_data,
                    {some, 107},
                    {some, <<"NumpadAdd"/utf8>>},
                    {some, <<"+"/utf8>>},
                    none,
                    {some, 3}}};

        <<"NumpadSubtract"/utf8>> ->
            {ok,
                {key_data,
                    {some, 109},
                    {some, <<"NumpadSubtract"/utf8>>},
                    {some, <<"-"/utf8>>},
                    none,
                    {some, 3}}};

        <<"NumpadDivide"/utf8>> ->
            {ok,
                {key_data,
                    {some, 111},
                    {some, <<"NumpadDivide"/utf8>>},
                    {some, <<"/"/utf8>>},
                    none,
                    {some, 3}}};

        <<"F1"/utf8>> ->
            {ok,
                {key_data,
                    {some, 112},
                    {some, <<"F1"/utf8>>},
                    {some, <<"F1"/utf8>>},
                    none,
                    none}};

        <<"F2"/utf8>> ->
            {ok,
                {key_data,
                    {some, 113},
                    {some, <<"F2"/utf8>>},
                    {some, <<"F2"/utf8>>},
                    none,
                    none}};

        <<"F3"/utf8>> ->
            {ok,
                {key_data,
                    {some, 114},
                    {some, <<"F3"/utf8>>},
                    {some, <<"F3"/utf8>>},
                    none,
                    none}};

        <<"F4"/utf8>> ->
            {ok,
                {key_data,
                    {some, 115},
                    {some, <<"F4"/utf8>>},
                    {some, <<"F4"/utf8>>},
                    none,
                    none}};

        <<"F5"/utf8>> ->
            {ok,
                {key_data,
                    {some, 116},
                    {some, <<"F5"/utf8>>},
                    {some, <<"F5"/utf8>>},
                    none,
                    none}};

        <<"F6"/utf8>> ->
            {ok,
                {key_data,
                    {some, 117},
                    {some, <<"F6"/utf8>>},
                    {some, <<"F6"/utf8>>},
                    none,
                    none}};

        <<"F7"/utf8>> ->
            {ok,
                {key_data,
                    {some, 118},
                    {some, <<"F7"/utf8>>},
                    {some, <<"F7"/utf8>>},
                    none,
                    none}};

        <<"F8"/utf8>> ->
            {ok,
                {key_data,
                    {some, 119},
                    {some, <<"F8"/utf8>>},
                    {some, <<"F8"/utf8>>},
                    none,
                    none}};

        <<"F9"/utf8>> ->
            {ok,
                {key_data,
                    {some, 120},
                    {some, <<"F9"/utf8>>},
                    {some, <<"F9"/utf8>>},
                    none,
                    none}};

        <<"F10"/utf8>> ->
            {ok,
                {key_data,
                    {some, 121},
                    {some, <<"F10"/utf8>>},
                    {some, <<"F10"/utf8>>},
                    none,
                    none}};

        <<"F11"/utf8>> ->
            {ok,
                {key_data,
                    {some, 122},
                    {some, <<"F11"/utf8>>},
                    {some, <<"F11"/utf8>>},
                    none,
                    none}};

        <<"F12"/utf8>> ->
            {ok,
                {key_data,
                    {some, 123},
                    {some, <<"F12"/utf8>>},
                    {some, <<"F12"/utf8>>},
                    none,
                    none}};

        <<"F13"/utf8>> ->
            {ok,
                {key_data,
                    {some, 124},
                    {some, <<"F13"/utf8>>},
                    {some, <<"F13"/utf8>>},
                    none,
                    none}};

        <<"F14"/utf8>> ->
            {ok,
                {key_data,
                    {some, 125},
                    {some, <<"F14"/utf8>>},
                    {some, <<"F14"/utf8>>},
                    none,
                    none}};

        <<"F15"/utf8>> ->
            {ok,
                {key_data,
                    {some, 126},
                    {some, <<"F15"/utf8>>},
                    {some, <<"F15"/utf8>>},
                    none,
                    none}};

        <<"F16"/utf8>> ->
            {ok,
                {key_data,
                    {some, 127},
                    {some, <<"F16"/utf8>>},
                    {some, <<"F16"/utf8>>},
                    none,
                    none}};

        <<"F17"/utf8>> ->
            {ok,
                {key_data,
                    {some, 128},
                    {some, <<"F17"/utf8>>},
                    {some, <<"F17"/utf8>>},
                    none,
                    none}};

        <<"F18"/utf8>> ->
            {ok,
                {key_data,
                    {some, 129},
                    {some, <<"F18"/utf8>>},
                    {some, <<"F18"/utf8>>},
                    none,
                    none}};

        <<"F19"/utf8>> ->
            {ok,
                {key_data,
                    {some, 130},
                    {some, <<"F19"/utf8>>},
                    {some, <<"F19"/utf8>>},
                    none,
                    none}};

        <<"F20"/utf8>> ->
            {ok,
                {key_data,
                    {some, 131},
                    {some, <<"F20"/utf8>>},
                    {some, <<"F20"/utf8>>},
                    none,
                    none}};

        <<"F21"/utf8>> ->
            {ok,
                {key_data,
                    {some, 132},
                    {some, <<"F21"/utf8>>},
                    {some, <<"F21"/utf8>>},
                    none,
                    none}};

        <<"F22"/utf8>> ->
            {ok,
                {key_data,
                    {some, 133},
                    {some, <<"F22"/utf8>>},
                    {some, <<"F22"/utf8>>},
                    none,
                    none}};

        <<"F23"/utf8>> ->
            {ok,
                {key_data,
                    {some, 134},
                    {some, <<"F23"/utf8>>},
                    {some, <<"F23"/utf8>>},
                    none,
                    none}};

        <<"F24"/utf8>> ->
            {ok,
                {key_data,
                    {some, 135},
                    {some, <<"F24"/utf8>>},
                    {some, <<"F24"/utf8>>},
                    none,
                    none}};

        <<"NumLock"/utf8>> ->
            {ok,
                {key_data,
                    {some, 144},
                    {some, <<"NumLock"/utf8>>},
                    {some, <<"NumLock"/utf8>>},
                    none,
                    none}};

        <<"ScrollLock"/utf8>> ->
            {ok,
                {key_data,
                    {some, 145},
                    {some, <<"ScrollLock"/utf8>>},
                    {some, <<"ScrollLock"/utf8>>},
                    none,
                    none}};

        <<"AudioVolumeMute"/utf8>> ->
            {ok,
                {key_data,
                    {some, 173},
                    {some, <<"AudioVolumeMute"/utf8>>},
                    {some, <<"AudioVolumeMute"/utf8>>},
                    none,
                    none}};

        <<"AudioVolumeDown"/utf8>> ->
            {ok,
                {key_data,
                    {some, 174},
                    {some, <<"AudioVolumeDown"/utf8>>},
                    {some, <<"AudioVolumeDown"/utf8>>},
                    none,
                    none}};

        <<"AudioVolumeUp"/utf8>> ->
            {ok,
                {key_data,
                    {some, 175},
                    {some, <<"AudioVolumeUp"/utf8>>},
                    {some, <<"AudioVolumeUp"/utf8>>},
                    none,
                    none}};

        <<"MediaTrackNext"/utf8>> ->
            {ok,
                {key_data,
                    {some, 176},
                    {some, <<"MediaTrackNext"/utf8>>},
                    {some, <<"MediaTrackNext"/utf8>>},
                    none,
                    none}};

        <<"MediaTrackPrevious"/utf8>> ->
            {ok,
                {key_data,
                    {some, 177},
                    {some, <<"MediaTrackPrevious"/utf8>>},
                    {some, <<"MediaTrackPrevious"/utf8>>},
                    none,
                    none}};

        <<"MediaStop"/utf8>> ->
            {ok,
                {key_data,
                    {some, 178},
                    {some, <<"MediaStop"/utf8>>},
                    {some, <<"MediaStop"/utf8>>},
                    none,
                    none}};

        <<"MediaPlayPause"/utf8>> ->
            {ok,
                {key_data,
                    {some, 179},
                    {some, <<"MediaPlayPause"/utf8>>},
                    {some, <<"MediaPlayPause"/utf8>>},
                    none,
                    none}};

        <<"Semicolon"/utf8>> ->
            {ok,
                {key_data,
                    {some, 186},
                    {some, <<"Semicolon"/utf8>>},
                    {some, <<";"/utf8>>},
                    none,
                    none}};

        <<"Equal"/utf8>> ->
            {ok,
                {key_data,
                    {some, 187},
                    {some, <<"Equal"/utf8>>},
                    {some, <<"="/utf8>>},
                    none,
                    none}};

        <<"NumpadEqual"/utf8>> ->
            {ok,
                {key_data,
                    {some, 187},
                    {some, <<"NumpadEqual"/utf8>>},
                    {some, <<"="/utf8>>},
                    none,
                    {some, 3}}};

        <<"Comma"/utf8>> ->
            {ok,
                {key_data,
                    {some, 188},
                    {some, <<"Comma"/utf8>>},
                    {some, <<","/utf8>>},
                    none,
                    none}};

        <<"Minus"/utf8>> ->
            {ok,
                {key_data,
                    {some, 189},
                    {some, <<"Minus"/utf8>>},
                    {some, <<"-"/utf8>>},
                    none,
                    none}};

        <<"Period"/utf8>> ->
            {ok,
                {key_data,
                    {some, 190},
                    {some, <<"Period"/utf8>>},
                    {some, <<"."/utf8>>},
                    none,
                    none}};

        <<"Slash"/utf8>> ->
            {ok,
                {key_data,
                    {some, 191},
                    {some, <<"Slash"/utf8>>},
                    {some, <<"/"/utf8>>},
                    none,
                    none}};

        <<"Backquote"/utf8>> ->
            {ok,
                {key_data,
                    {some, 192},
                    {some, <<"Backquote"/utf8>>},
                    {some, <<"`"/utf8>>},
                    none,
                    none}};

        <<"BracketLeft"/utf8>> ->
            {ok,
                {key_data,
                    {some, 219},
                    {some, <<"BracketLeft"/utf8>>},
                    {some, <<"["/utf8>>},
                    none,
                    none}};

        <<"Backslash"/utf8>> ->
            {ok,
                {key_data,
                    {some, 220},
                    {some, <<"Backslash"/utf8>>},
                    {some, <<"\\"/utf8>>},
                    none,
                    none}};

        <<"BracketRight"/utf8>> ->
            {ok,
                {key_data,
                    {some, 221},
                    {some, <<"BracketRight"/utf8>>},
                    {some, <<"]"/utf8>>},
                    none,
                    none}};

        <<"Quote"/utf8>> ->
            {ok,
                {key_data,
                    {some, 222},
                    {some, <<"Quote"/utf8>>},
                    {some, <<"'"/utf8>>},
                    none,
                    none}};

        <<"AltGraph"/utf8>> ->
            {ok,
                {key_data,
                    {some, 225},
                    {some, <<"AltGraph"/utf8>>},
                    {some, <<"AltGraph"/utf8>>},
                    none,
                    none}};

        <<"Props"/utf8>> ->
            {ok,
                {key_data,
                    {some, 247},
                    {some, <<"Props"/utf8>>},
                    {some, <<"CrSel"/utf8>>},
                    none,
                    none}};

        <<"Cancel"/utf8>> ->
            {ok,
                {key_data,
                    {some, 3},
                    {some, <<"Abort"/utf8>>},
                    {some, <<"Cancel"/utf8>>},
                    none,
                    none}};

        <<"Clear"/utf8>> ->
            {ok,
                {key_data,
                    {some, 12},
                    {some, <<"Numpad5"/utf8>>},
                    {some, <<"Clear"/utf8>>},
                    none,
                    {some, 3}}};

        <<"Shift"/utf8>> ->
            {ok,
                {key_data,
                    {some, 16},
                    {some, <<"ShiftLeft"/utf8>>},
                    {some, <<"Shift"/utf8>>},
                    none,
                    {some, 1}}};

        <<"Control"/utf8>> ->
            {ok,
                {key_data,
                    {some, 17},
                    {some, <<"ControlLeft"/utf8>>},
                    {some, <<"Control"/utf8>>},
                    none,
                    {some, 1}}};

        <<"Alt"/utf8>> ->
            {ok,
                {key_data,
                    {some, 18},
                    {some, <<"AltLeft"/utf8>>},
                    {some, <<"Alt"/utf8>>},
                    none,
                    {some, 1}}};

        <<"Accept"/utf8>> ->
            {ok,
                {key_data,
                    {some, 30},
                    none,
                    {some, <<"Accept"/utf8>>},
                    none,
                    none}};

        <<"ModeChange"/utf8>> ->
            {ok,
                {key_data,
                    {some, 31},
                    none,
                    {some, <<"ModeChange"/utf8>>},
                    none,
                    none}};

        <<" "/utf8>> ->
            {ok,
                {key_data,
                    {some, 32},
                    {some, <<"Space"/utf8>>},
                    {some, <<" "/utf8>>},
                    none,
                    none}};

        <<"Print"/utf8>> ->
            {ok,
                {key_data,
                    {some, 42},
                    none,
                    {some, <<"Print"/utf8>>},
                    none,
                    none}};

        <<"Execute"/utf8>> ->
            {ok,
                {key_data,
                    {some, 43},
                    {some, <<"Open"/utf8>>},
                    {some, <<"Execute"/utf8>>},
                    none,
                    none}};

        <<"\\u0000"/utf8>> ->
            {ok,
                {key_data,
                    {some, 46},
                    {some, <<"NumpadDecimal"/utf8>>},
                    {some, <<"\\u0000"/utf8>>},
                    none,
                    {some, 3}}};

        <<"a"/utf8>> ->
            {ok,
                {key_data,
                    {some, 65},
                    {some, <<"KeyA"/utf8>>},
                    {some, <<"a"/utf8>>},
                    none,
                    none}};

        <<"b"/utf8>> ->
            {ok,
                {key_data,
                    {some, 66},
                    {some, <<"KeyB"/utf8>>},
                    {some, <<"b"/utf8>>},
                    none,
                    none}};

        <<"c"/utf8>> ->
            {ok,
                {key_data,
                    {some, 67},
                    {some, <<"KeyC"/utf8>>},
                    {some, <<"c"/utf8>>},
                    none,
                    none}};

        <<"d"/utf8>> ->
            {ok,
                {key_data,
                    {some, 68},
                    {some, <<"KeyD"/utf8>>},
                    {some, <<"d"/utf8>>},
                    none,
                    none}};

        <<"e"/utf8>> ->
            {ok,
                {key_data,
                    {some, 69},
                    {some, <<"KeyE"/utf8>>},
                    {some, <<"e"/utf8>>},
                    none,
                    none}};

        <<"f"/utf8>> ->
            {ok,
                {key_data,
                    {some, 70},
                    {some, <<"KeyF"/utf8>>},
                    {some, <<"f"/utf8>>},
                    none,
                    none}};

        <<"g"/utf8>> ->
            {ok,
                {key_data,
                    {some, 71},
                    {some, <<"KeyG"/utf8>>},
                    {some, <<"g"/utf8>>},
                    none,
                    none}};

        <<"h"/utf8>> ->
            {ok,
                {key_data,
                    {some, 72},
                    {some, <<"KeyH"/utf8>>},
                    {some, <<"h"/utf8>>},
                    none,
                    none}};

        <<"i"/utf8>> ->
            {ok,
                {key_data,
                    {some, 73},
                    {some, <<"KeyI"/utf8>>},
                    {some, <<"i"/utf8>>},
                    none,
                    none}};

        <<"j"/utf8>> ->
            {ok,
                {key_data,
                    {some, 74},
                    {some, <<"KeyJ"/utf8>>},
                    {some, <<"j"/utf8>>},
                    none,
                    none}};

        <<"k"/utf8>> ->
            {ok,
                {key_data,
                    {some, 75},
                    {some, <<"KeyK"/utf8>>},
                    {some, <<"k"/utf8>>},
                    none,
                    none}};

        <<"l"/utf8>> ->
            {ok,
                {key_data,
                    {some, 76},
                    {some, <<"KeyL"/utf8>>},
                    {some, <<"l"/utf8>>},
                    none,
                    none}};

        <<"m"/utf8>> ->
            {ok,
                {key_data,
                    {some, 77},
                    {some, <<"KeyM"/utf8>>},
                    {some, <<"m"/utf8>>},
                    none,
                    none}};

        <<"n"/utf8>> ->
            {ok,
                {key_data,
                    {some, 78},
                    {some, <<"KeyN"/utf8>>},
                    {some, <<"n"/utf8>>},
                    none,
                    none}};

        <<"o"/utf8>> ->
            {ok,
                {key_data,
                    {some, 79},
                    {some, <<"KeyO"/utf8>>},
                    {some, <<"o"/utf8>>},
                    none,
                    none}};

        <<"p"/utf8>> ->
            {ok,
                {key_data,
                    {some, 80},
                    {some, <<"KeyP"/utf8>>},
                    {some, <<"p"/utf8>>},
                    none,
                    none}};

        <<"q"/utf8>> ->
            {ok,
                {key_data,
                    {some, 81},
                    {some, <<"KeyQ"/utf8>>},
                    {some, <<"q"/utf8>>},
                    none,
                    none}};

        <<"r"/utf8>> ->
            {ok,
                {key_data,
                    {some, 82},
                    {some, <<"KeyR"/utf8>>},
                    {some, <<"r"/utf8>>},
                    none,
                    none}};

        <<"s"/utf8>> ->
            {ok,
                {key_data,
                    {some, 83},
                    {some, <<"KeyS"/utf8>>},
                    {some, <<"s"/utf8>>},
                    none,
                    none}};

        <<"t"/utf8>> ->
            {ok,
                {key_data,
                    {some, 84},
                    {some, <<"KeyT"/utf8>>},
                    {some, <<"t"/utf8>>},
                    none,
                    none}};

        <<"u"/utf8>> ->
            {ok,
                {key_data,
                    {some, 85},
                    {some, <<"KeyU"/utf8>>},
                    {some, <<"u"/utf8>>},
                    none,
                    none}};

        <<"v"/utf8>> ->
            {ok,
                {key_data,
                    {some, 86},
                    {some, <<"KeyV"/utf8>>},
                    {some, <<"v"/utf8>>},
                    none,
                    none}};

        <<"w"/utf8>> ->
            {ok,
                {key_data,
                    {some, 87},
                    {some, <<"KeyW"/utf8>>},
                    {some, <<"w"/utf8>>},
                    none,
                    none}};

        <<"x"/utf8>> ->
            {ok,
                {key_data,
                    {some, 88},
                    {some, <<"KeyX"/utf8>>},
                    {some, <<"x"/utf8>>},
                    none,
                    none}};

        <<"y"/utf8>> ->
            {ok,
                {key_data,
                    {some, 89},
                    {some, <<"KeyY"/utf8>>},
                    {some, <<"y"/utf8>>},
                    none,
                    none}};

        <<"z"/utf8>> ->
            {ok,
                {key_data,
                    {some, 90},
                    {some, <<"KeyZ"/utf8>>},
                    {some, <<"z"/utf8>>},
                    none,
                    none}};

        <<"Meta"/utf8>> ->
            {ok,
                {key_data,
                    {some, 91},
                    {some, <<"MetaLeft"/utf8>>},
                    {some, <<"Meta"/utf8>>},
                    none,
                    {some, 1}}};

        <<"*"/utf8>> ->
            {ok,
                {key_data,
                    {some, 106},
                    {some, <<"NumpadMultiply"/utf8>>},
                    {some, <<"*"/utf8>>},
                    none,
                    {some, 3}}};

        <<"+"/utf8>> ->
            {ok,
                {key_data,
                    {some, 107},
                    {some, <<"NumpadAdd"/utf8>>},
                    {some, <<"+"/utf8>>},
                    none,
                    {some, 3}}};

        <<"-"/utf8>> ->
            {ok,
                {key_data,
                    {some, 109},
                    {some, <<"NumpadSubtract"/utf8>>},
                    {some, <<"-"/utf8>>},
                    none,
                    {some, 3}}};

        <<"/"/utf8>> ->
            {ok,
                {key_data,
                    {some, 111},
                    {some, <<"NumpadDivide"/utf8>>},
                    {some, <<"/"/utf8>>},
                    none,
                    {some, 3}}};

        <<";"/utf8>> ->
            {ok,
                {key_data,
                    {some, 186},
                    {some, <<"Semicolon"/utf8>>},
                    {some, <<";"/utf8>>},
                    none,
                    none}};

        <<"="/utf8>> ->
            {ok,
                {key_data,
                    {some, 187},
                    {some, <<"Equal"/utf8>>},
                    {some, <<"="/utf8>>},
                    none,
                    none}};

        <<","/utf8>> ->
            {ok,
                {key_data,
                    {some, 188},
                    {some, <<"Comma"/utf8>>},
                    {some, <<","/utf8>>},
                    none,
                    none}};

        <<"."/utf8>> ->
            {ok,
                {key_data,
                    {some, 190},
                    {some, <<"Period"/utf8>>},
                    {some, <<"."/utf8>>},
                    none,
                    none}};

        <<"`"/utf8>> ->
            {ok,
                {key_data,
                    {some, 192},
                    {some, <<"Backquote"/utf8>>},
                    {some, <<"`"/utf8>>},
                    none,
                    none}};

        <<"["/utf8>> ->
            {ok,
                {key_data,
                    {some, 219},
                    {some, <<"BracketLeft"/utf8>>},
                    {some, <<"["/utf8>>},
                    none,
                    none}};

        <<"\\"/utf8>> ->
            {ok,
                {key_data,
                    {some, 220},
                    {some, <<"Backslash"/utf8>>},
                    {some, <<"\\"/utf8>>},
                    none,
                    none}};

        <<"]"/utf8>> ->
            {ok,
                {key_data,
                    {some, 221},
                    {some, <<"BracketRight"/utf8>>},
                    {some, <<"]"/utf8>>},
                    none,
                    none}};

        <<"'"/utf8>> ->
            {ok,
                {key_data,
                    {some, 222},
                    {some, <<"Quote"/utf8>>},
                    {some, <<"'"/utf8>>},
                    none,
                    none}};

        <<"Attn"/utf8>> ->
            {ok,
                {key_data,
                    {some, 246},
                    none,
                    {some, <<"Attn"/utf8>>},
                    none,
                    none}};

        <<"CrSel"/utf8>> ->
            {ok,
                {key_data,
                    {some, 247},
                    {some, <<"Props"/utf8>>},
                    {some, <<"CrSel"/utf8>>},
                    none,
                    none}};

        <<"ExSel"/utf8>> ->
            {ok,
                {key_data,
                    {some, 248},
                    none,
                    {some, <<"ExSel"/utf8>>},
                    none,
                    none}};

        <<"EraseEof"/utf8>> ->
            {ok,
                {key_data,
                    {some, 249},
                    none,
                    {some, <<"EraseEof"/utf8>>},
                    none,
                    none}};

        <<"Play"/utf8>> ->
            {ok,
                {key_data,
                    {some, 250},
                    none,
                    {some, <<"Play"/utf8>>},
                    none,
                    none}};

        <<"ZoomOut"/utf8>> ->
            {ok,
                {key_data,
                    {some, 251},
                    none,
                    {some, <<"ZoomOut"/utf8>>},
                    none,
                    none}};

        <<")"/utf8>> ->
            {ok,
                {key_data,
                    {some, 48},
                    {some, <<"Digit0"/utf8>>},
                    {some, <<")"/utf8>>},
                    none,
                    none}};

        <<"!"/utf8>> ->
            {ok,
                {key_data,
                    {some, 49},
                    {some, <<"Digit1"/utf8>>},
                    {some, <<"!"/utf8>>},
                    none,
                    none}};

        <<"@"/utf8>> ->
            {ok,
                {key_data,
                    {some, 50},
                    {some, <<"Digit2"/utf8>>},
                    {some, <<"@"/utf8>>},
                    none,
                    none}};

        <<"#"/utf8>> ->
            {ok,
                {key_data,
                    {some, 51},
                    {some, <<"Digit3"/utf8>>},
                    {some, <<"#"/utf8>>},
                    none,
                    none}};

        <<"$"/utf8>> ->
            {ok,
                {key_data,
                    {some, 52},
                    {some, <<"Digit4"/utf8>>},
                    {some, <<"$"/utf8>>},
                    none,
                    none}};

        <<"%"/utf8>> ->
            {ok,
                {key_data,
                    {some, 53},
                    {some, <<"Digit5"/utf8>>},
                    {some, <<"%"/utf8>>},
                    none,
                    none}};

        <<"^"/utf8>> ->
            {ok,
                {key_data,
                    {some, 54},
                    {some, <<"Digit6"/utf8>>},
                    {some, <<"^"/utf8>>},
                    none,
                    none}};

        <<"&"/utf8>> ->
            {ok,
                {key_data,
                    {some, 55},
                    {some, <<"Digit7"/utf8>>},
                    {some, <<"&"/utf8>>},
                    none,
                    none}};

        <<"("/utf8>> ->
            {ok,
                {key_data,
                    {some, 57},
                    {some, <<"Digit9"/utf8>>},
                    {some, <<"("/utf8>>},
                    none,
                    none}};

        <<"A"/utf8>> ->
            {ok,
                {key_data,
                    {some, 65},
                    {some, <<"KeyA"/utf8>>},
                    {some, <<"A"/utf8>>},
                    none,
                    none}};

        <<"B"/utf8>> ->
            {ok,
                {key_data,
                    {some, 66},
                    {some, <<"KeyB"/utf8>>},
                    {some, <<"B"/utf8>>},
                    none,
                    none}};

        <<"C"/utf8>> ->
            {ok,
                {key_data,
                    {some, 67},
                    {some, <<"KeyC"/utf8>>},
                    {some, <<"C"/utf8>>},
                    none,
                    none}};

        <<"D"/utf8>> ->
            {ok,
                {key_data,
                    {some, 68},
                    {some, <<"KeyD"/utf8>>},
                    {some, <<"D"/utf8>>},
                    none,
                    none}};

        <<"E"/utf8>> ->
            {ok,
                {key_data,
                    {some, 69},
                    {some, <<"KeyE"/utf8>>},
                    {some, <<"E"/utf8>>},
                    none,
                    none}};

        <<"F"/utf8>> ->
            {ok,
                {key_data,
                    {some, 70},
                    {some, <<"KeyF"/utf8>>},
                    {some, <<"F"/utf8>>},
                    none,
                    none}};

        <<"G"/utf8>> ->
            {ok,
                {key_data,
                    {some, 71},
                    {some, <<"KeyG"/utf8>>},
                    {some, <<"G"/utf8>>},
                    none,
                    none}};

        <<"H"/utf8>> ->
            {ok,
                {key_data,
                    {some, 72},
                    {some, <<"KeyH"/utf8>>},
                    {some, <<"H"/utf8>>},
                    none,
                    none}};

        <<"I"/utf8>> ->
            {ok,
                {key_data,
                    {some, 73},
                    {some, <<"KeyI"/utf8>>},
                    {some, <<"I"/utf8>>},
                    none,
                    none}};

        <<"J"/utf8>> ->
            {ok,
                {key_data,
                    {some, 74},
                    {some, <<"KeyJ"/utf8>>},
                    {some, <<"J"/utf8>>},
                    none,
                    none}};

        <<"K"/utf8>> ->
            {ok,
                {key_data,
                    {some, 75},
                    {some, <<"KeyK"/utf8>>},
                    {some, <<"K"/utf8>>},
                    none,
                    none}};

        <<"L"/utf8>> ->
            {ok,
                {key_data,
                    {some, 76},
                    {some, <<"KeyL"/utf8>>},
                    {some, <<"L"/utf8>>},
                    none,
                    none}};

        <<"M"/utf8>> ->
            {ok,
                {key_data,
                    {some, 77},
                    {some, <<"KeyM"/utf8>>},
                    {some, <<"M"/utf8>>},
                    none,
                    none}};

        <<"N"/utf8>> ->
            {ok,
                {key_data,
                    {some, 78},
                    {some, <<"KeyN"/utf8>>},
                    {some, <<"N"/utf8>>},
                    none,
                    none}};

        <<"O"/utf8>> ->
            {ok,
                {key_data,
                    {some, 79},
                    {some, <<"KeyO"/utf8>>},
                    {some, <<"O"/utf8>>},
                    none,
                    none}};

        <<"P"/utf8>> ->
            {ok,
                {key_data,
                    {some, 80},
                    {some, <<"KeyP"/utf8>>},
                    {some, <<"P"/utf8>>},
                    none,
                    none}};

        <<"Q"/utf8>> ->
            {ok,
                {key_data,
                    {some, 81},
                    {some, <<"KeyQ"/utf8>>},
                    {some, <<"Q"/utf8>>},
                    none,
                    none}};

        <<"R"/utf8>> ->
            {ok,
                {key_data,
                    {some, 82},
                    {some, <<"KeyR"/utf8>>},
                    {some, <<"R"/utf8>>},
                    none,
                    none}};

        <<"S"/utf8>> ->
            {ok,
                {key_data,
                    {some, 83},
                    {some, <<"KeyS"/utf8>>},
                    {some, <<"S"/utf8>>},
                    none,
                    none}};

        <<"T"/utf8>> ->
            {ok,
                {key_data,
                    {some, 84},
                    {some, <<"KeyT"/utf8>>},
                    {some, <<"T"/utf8>>},
                    none,
                    none}};

        <<"U"/utf8>> ->
            {ok,
                {key_data,
                    {some, 85},
                    {some, <<"KeyU"/utf8>>},
                    {some, <<"U"/utf8>>},
                    none,
                    none}};

        <<"V"/utf8>> ->
            {ok,
                {key_data,
                    {some, 86},
                    {some, <<"KeyV"/utf8>>},
                    {some, <<"V"/utf8>>},
                    none,
                    none}};

        <<"W"/utf8>> ->
            {ok,
                {key_data,
                    {some, 87},
                    {some, <<"KeyW"/utf8>>},
                    {some, <<"W"/utf8>>},
                    none,
                    none}};

        <<"X"/utf8>> ->
            {ok,
                {key_data,
                    {some, 88},
                    {some, <<"KeyX"/utf8>>},
                    {some, <<"X"/utf8>>},
                    none,
                    none}};

        <<"Y"/utf8>> ->
            {ok,
                {key_data,
                    {some, 89},
                    {some, <<"KeyY"/utf8>>},
                    {some, <<"Y"/utf8>>},
                    none,
                    none}};

        <<"Z"/utf8>> ->
            {ok,
                {key_data,
                    {some, 90},
                    {some, <<"KeyZ"/utf8>>},
                    {some, <<"Z"/utf8>>},
                    none,
                    none}};

        <<":"/utf8>> ->
            {ok,
                {key_data,
                    {some, 186},
                    {some, <<"Semicolon"/utf8>>},
                    {some, <<":"/utf8>>},
                    none,
                    none}};

        <<"<"/utf8>> ->
            {ok,
                {key_data,
                    {some, 188},
                    {some, <<"Comma"/utf8>>},
                    {some, <<"<"/utf8>>},
                    none,
                    none}};

        <<"_"/utf8>> ->
            {ok,
                {key_data,
                    {some, 189},
                    {some, <<"Minus"/utf8>>},
                    {some, <<"_"/utf8>>},
                    none,
                    none}};

        <<">"/utf8>> ->
            {ok,
                {key_data,
                    {some, 190},
                    {some, <<"Period"/utf8>>},
                    {some, <<">"/utf8>>},
                    none,
                    none}};

        <<"?"/utf8>> ->
            {ok,
                {key_data,
                    {some, 191},
                    {some, <<"Slash"/utf8>>},
                    {some, <<"?"/utf8>>},
                    none,
                    none}};

        <<"~"/utf8>> ->
            {ok,
                {key_data,
                    {some, 192},
                    {some, <<"Backquote"/utf8>>},
                    {some, <<"~"/utf8>>},
                    none,
                    none}};

        <<"{"/utf8>> ->
            {ok,
                {key_data,
                    {some, 219},
                    {some, <<"BracketLeft"/utf8>>},
                    {some, <<"{"/utf8>>},
                    none,
                    none}};

        <<"|"/utf8>> ->
            {ok,
                {key_data,
                    {some, 220},
                    {some, <<"Backslash"/utf8>>},
                    {some, <<"|"/utf8>>},
                    none,
                    none}};

        <<"}"/utf8>> ->
            {ok,
                {key_data,
                    {some, 221},
                    {some, <<"BracketRight"/utf8>>},
                    {some, <<"}"/utf8>>},
                    none,
                    none}};

        <<"\""/utf8>> ->
            {ok,
                {key_data,
                    {some, 222},
                    {some, <<"Quote"/utf8>>},
                    {some, <<"\""/utf8>>},
                    none,
                    none}};

        <<"SoftLeft"/utf8>> ->
            {ok,
                {key_data,
                    none,
                    {some, <<"SoftLeft"/utf8>>},
                    {some, <<"SoftLeft"/utf8>>},
                    none,
                    {some, 4}}};

        <<"SoftRight"/utf8>> ->
            {ok,
                {key_data,
                    none,
                    {some, <<"SoftRight"/utf8>>},
                    {some, <<"SoftRight"/utf8>>},
                    none,
                    {some, 4}}};

        <<"Camera"/utf8>> ->
            {ok,
                {key_data,
                    {some, 44},
                    {some, <<"Camera"/utf8>>},
                    {some, <<"Camera"/utf8>>},
                    none,
                    {some, 4}}};

        <<"Call"/utf8>> ->
            {ok,
                {key_data,
                    none,
                    {some, <<"Call"/utf8>>},
                    {some, <<"Call"/utf8>>},
                    none,
                    {some, 4}}};

        <<"EndCall"/utf8>> ->
            {ok,
                {key_data,
                    {some, 95},
                    {some, <<"EndCall"/utf8>>},
                    {some, <<"EndCall"/utf8>>},
                    none,
                    {some, 4}}};

        <<"VolumeDown"/utf8>> ->
            {ok,
                {key_data,
                    {some, 182},
                    {some, <<"VolumeDown"/utf8>>},
                    {some, <<"VolumeDown"/utf8>>},
                    none,
                    {some, 4}}};

        <<"VolumeUp"/utf8>> ->
            {ok,
                {key_data,
                    {some, 183},
                    {some, <<"VolumeUp"/utf8>>},
                    {some, <<"VolumeUp"/utf8>>},
                    none,
                    {some, 4}}};

        _ ->
            {error, nil}
    end.
