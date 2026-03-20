-module(chrobot_extra@protocol@input).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\protocol\\input.gleam").
-export([encode__touch_point/1, decode__touch_point/0, encode__mouse_button/1, decode__mouse_button/0, encode__time_since_epoch/1, decode__time_since_epoch/0, encode__dispatch_key_event_type/1, dispatch_key_event/15, decode__dispatch_key_event_type/0, encode__dispatch_mouse_event_type/1, decode__dispatch_mouse_event_type/0, encode__dispatch_mouse_event_pointer_type/1, dispatch_mouse_event/14, decode__dispatch_mouse_event_pointer_type/0, encode__dispatch_touch_event_type/1, dispatch_touch_event/5, decode__dispatch_touch_event_type/0, cancel_dragging/1, set_ignore_input_events/2]).
-export_type([touch_point/0, mouse_button/0, time_since_epoch/0, dispatch_key_event_type/0, dispatch_mouse_event_type/0, dispatch_mouse_event_pointer_type/0, dispatch_touch_event_type/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " > ⚙️  This module was generated from the Chrome DevTools Protocol version **1.3**\n"
    " ## Input Domain  \n"
    "\n"
    " This protocol domain has no description.  \n"
    "\n"
    " [📖   View this domain on the DevTools Protocol API Docs](https://chromedevtools.github.io/devtools-protocol/1-3/Input/)\n"
).

-type touch_point() :: {touch_point,
        float(),
        float(),
        gleam@option:option(float()),
        gleam@option:option(float()),
        gleam@option:option(float()),
        gleam@option:option(float()),
        gleam@option:option(float()),
        gleam@option:option(float()),
        gleam@option:option(float())}.

-type mouse_button() :: mouse_button_none |
    mouse_button_left |
    mouse_button_middle |
    mouse_button_right |
    mouse_button_back |
    mouse_button_forward.

-type time_since_epoch() :: {time_since_epoch, float()}.

-type dispatch_key_event_type() :: dispatch_key_event_type_key_down |
    dispatch_key_event_type_key_up |
    dispatch_key_event_type_raw_key_down |
    dispatch_key_event_type_char.

-type dispatch_mouse_event_type() :: dispatch_mouse_event_type_mouse_pressed |
    dispatch_mouse_event_type_mouse_released |
    dispatch_mouse_event_type_mouse_moved |
    dispatch_mouse_event_type_mouse_wheel.

-type dispatch_mouse_event_pointer_type() :: dispatch_mouse_event_pointer_type_mouse |
    dispatch_mouse_event_pointer_type_pen.

-type dispatch_touch_event_type() :: dispatch_touch_event_type_touch_start |
    dispatch_touch_event_type_touch_end |
    dispatch_touch_event_type_touch_move |
    dispatch_touch_event_type_touch_cancel.

-file("src\\chrobot_extra\\protocol\\input.gleam", 43).
?DOC(false).
-spec encode__touch_point(touch_point()) -> gleam@json:json().
encode__touch_point(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"x"/utf8>>,
                    gleam@json:float(erlang:element(2, Value__))},
                {<<"y"/utf8>>, gleam@json:float(erlang:element(3, Value__))}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(4, Value__),
                fun(Inner_value__) ->
                    {<<"radiusX"/utf8>>, gleam@json:float(Inner_value__)}
                end
            ),
            _pipe@2 = chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(5, Value__),
                fun(Inner_value__@1) ->
                    {<<"radiusY"/utf8>>, gleam@json:float(Inner_value__@1)}
                end
            ),
            _pipe@3 = chrobot_extra@internal@utils:add_optional(
                _pipe@2,
                erlang:element(6, Value__),
                fun(Inner_value__@2) ->
                    {<<"rotationAngle"/utf8>>,
                        gleam@json:float(Inner_value__@2)}
                end
            ),
            _pipe@4 = chrobot_extra@internal@utils:add_optional(
                _pipe@3,
                erlang:element(7, Value__),
                fun(Inner_value__@3) ->
                    {<<"force"/utf8>>, gleam@json:float(Inner_value__@3)}
                end
            ),
            _pipe@5 = chrobot_extra@internal@utils:add_optional(
                _pipe@4,
                erlang:element(8, Value__),
                fun(Inner_value__@4) ->
                    {<<"tiltX"/utf8>>, gleam@json:float(Inner_value__@4)}
                end
            ),
            _pipe@6 = chrobot_extra@internal@utils:add_optional(
                _pipe@5,
                erlang:element(9, Value__),
                fun(Inner_value__@5) ->
                    {<<"tiltY"/utf8>>, gleam@json:float(Inner_value__@5)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@6,
                erlang:element(10, Value__),
                fun(Inner_value__@6) ->
                    {<<"id"/utf8>>, gleam@json:float(Inner_value__@6)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\input.gleam", 74).
?DOC(false).
-spec decode__touch_point() -> gleam@dynamic@decode:decoder(touch_point()).
decode__touch_point() ->
    begin
        gleam@dynamic@decode:field(
            <<"x"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_float/1},
            fun(X) ->
                gleam@dynamic@decode:field(
                    <<"y"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_float/1},
                    fun(Y) ->
                        gleam@dynamic@decode:optional_field(
                            <<"radiusX"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                {decoder,
                                    fun gleam@dynamic@decode:decode_float/1}
                            ),
                            fun(Radius_x) ->
                                gleam@dynamic@decode:optional_field(
                                    <<"radiusY"/utf8>>,
                                    none,
                                    gleam@dynamic@decode:optional(
                                        {decoder,
                                            fun gleam@dynamic@decode:decode_float/1}
                                    ),
                                    fun(Radius_y) ->
                                        gleam@dynamic@decode:optional_field(
                                            <<"rotationAngle"/utf8>>,
                                            none,
                                            gleam@dynamic@decode:optional(
                                                {decoder,
                                                    fun gleam@dynamic@decode:decode_float/1}
                                            ),
                                            fun(Rotation_angle) ->
                                                gleam@dynamic@decode:optional_field(
                                                    <<"force"/utf8>>,
                                                    none,
                                                    gleam@dynamic@decode:optional(
                                                        {decoder,
                                                            fun gleam@dynamic@decode:decode_float/1}
                                                    ),
                                                    fun(Force) ->
                                                        gleam@dynamic@decode:optional_field(
                                                            <<"tiltX"/utf8>>,
                                                            none,
                                                            gleam@dynamic@decode:optional(
                                                                {decoder,
                                                                    fun gleam@dynamic@decode:decode_float/1}
                                                            ),
                                                            fun(Tilt_x) ->
                                                                gleam@dynamic@decode:optional_field(
                                                                    <<"tiltY"/utf8>>,
                                                                    none,
                                                                    gleam@dynamic@decode:optional(
                                                                        {decoder,
                                                                            fun gleam@dynamic@decode:decode_float/1}
                                                                    ),
                                                                    fun(Tilt_y) ->
                                                                        gleam@dynamic@decode:optional_field(
                                                                            <<"id"/utf8>>,
                                                                            none,
                                                                            gleam@dynamic@decode:optional(
                                                                                {decoder,
                                                                                    fun gleam@dynamic@decode:decode_float/1}
                                                                            ),
                                                                            fun(
                                                                                Id
                                                                            ) ->
                                                                                gleam@dynamic@decode:success(
                                                                                    {touch_point,
                                                                                        X,
                                                                                        Y,
                                                                                        Radius_x,
                                                                                        Radius_y,
                                                                                        Rotation_angle,
                                                                                        Force,
                                                                                        Tilt_x,
                                                                                        Tilt_y,
                                                                                        Id}
                                                                                )
                                                                            end
                                                                        )
                                                                    end
                                                                )
                                                            end
                                                        )
                                                    end
                                                )
                                            end
                                        )
                                    end
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\input.gleam", 138).
?DOC(false).
-spec encode__mouse_button(mouse_button()) -> gleam@json:json().
encode__mouse_button(Value__) ->
    _pipe = case Value__ of
        mouse_button_none ->
            <<"none"/utf8>>;

        mouse_button_left ->
            <<"left"/utf8>>;

        mouse_button_middle ->
            <<"middle"/utf8>>;

        mouse_button_right ->
            <<"right"/utf8>>;

        mouse_button_back ->
            <<"back"/utf8>>;

        mouse_button_forward ->
            <<"forward"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\input.gleam", 151).
?DOC(false).
-spec decode__mouse_button() -> gleam@dynamic@decode:decoder(mouse_button()).
decode__mouse_button() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"none"/utf8>> ->
                        gleam@dynamic@decode:success(mouse_button_none);

                    <<"left"/utf8>> ->
                        gleam@dynamic@decode:success(mouse_button_left);

                    <<"middle"/utf8>> ->
                        gleam@dynamic@decode:success(mouse_button_middle);

                    <<"right"/utf8>> ->
                        gleam@dynamic@decode:success(mouse_button_right);

                    <<"back"/utf8>> ->
                        gleam@dynamic@decode:success(mouse_button_back);

                    <<"forward"/utf8>> ->
                        gleam@dynamic@decode:success(mouse_button_forward);

                    _ ->
                        gleam@dynamic@decode:failure(
                            mouse_button_none,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\input.gleam", 172).
?DOC(false).
-spec encode__time_since_epoch(time_since_epoch()) -> gleam@json:json().
encode__time_since_epoch(Value__) ->
    case Value__ of
        {time_since_epoch, Inner_value__} ->
            gleam@json:float(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\input.gleam", 179).
?DOC(false).
-spec decode__time_since_epoch() -> gleam@dynamic@decode:decoder(time_since_epoch()).
decode__time_since_epoch() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_float/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({time_since_epoch, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\input.gleam", 287).
?DOC(false).
-spec encode__dispatch_key_event_type(dispatch_key_event_type()) -> gleam@json:json().
encode__dispatch_key_event_type(Value__) ->
    _pipe = case Value__ of
        dispatch_key_event_type_key_down ->
            <<"keyDown"/utf8>>;

        dispatch_key_event_type_key_up ->
            <<"keyUp"/utf8>>;

        dispatch_key_event_type_raw_key_down ->
            <<"rawKeyDown"/utf8>>;

        dispatch_key_event_type_char ->
            <<"char"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\input.gleam", 211).
?DOC(
    " Dispatches a key event to the page.\n"
    " \n"
    " Parameters:  \n"
    "  - `type_` : Type of the key event.\n"
    "  - `modifiers` : Bit field representing pressed modifier keys. Alt=1, Ctrl=2, Meta/Command=4, Shift=8\n"
    " (default: 0).\n"
    "  - `timestamp` : Time at which the event occurred.\n"
    "  - `text` : Text as generated by processing a virtual key code with a keyboard layout. Not needed for\n"
    " for `keyUp` and `rawKeyDown` events (default: \"\")\n"
    "  - `unmodified_text` : Text that would have been generated by the keyboard if no modifiers were pressed (except for\n"
    " shift). Useful for shortcut (accelerator) key handling (default: \"\").\n"
    "  - `key_identifier` : Unique key identifier (e.g., 'U+0041') (default: \"\").\n"
    "  - `code` : Unique DOM defined string value for each physical key (e.g., 'KeyA') (default: \"\").\n"
    "  - `key` : Unique DOM defined string value describing the meaning of the key in the context of active\n"
    " modifiers, keyboard layout, etc (e.g., 'AltGr') (default: \"\").\n"
    "  - `windows_virtual_key_code` : Windows virtual key code (default: 0).\n"
    "  - `native_virtual_key_code` : Native virtual key code (default: 0).\n"
    "  - `auto_repeat` : Whether the event was generated from auto repeat (default: false).\n"
    "  - `is_keypad` : Whether the event was generated from the keypad (default: false).\n"
    "  - `is_system_key` : Whether the event was a system key event (default: false).\n"
    "  - `location` : Whether the event was from the left or right side of the keyboard. 1=Left, 2=Right (default:\n"
    " 0).\n"
    " \n"
    " Returns:\n"
).
-spec dispatch_key_event(
    fun((binary(), gleam@option:option(gleam@json:json())) -> LRZ),
    dispatch_key_event_type(),
    gleam@option:option(integer()),
    gleam@option:option(time_since_epoch()),
    gleam@option:option(binary()),
    gleam@option:option(binary()),
    gleam@option:option(binary()),
    gleam@option:option(binary()),
    gleam@option:option(binary()),
    gleam@option:option(integer()),
    gleam@option:option(integer()),
    gleam@option:option(boolean()),
    gleam@option:option(boolean()),
    gleam@option:option(boolean()),
    gleam@option:option(integer())
) -> LRZ.
dispatch_key_event(
    Callback__,
    Type_,
    Modifiers,
    Timestamp,
    Text,
    Unmodified_text,
    Key_identifier,
    Code,
    Key,
    Windows_virtual_key_code,
    Native_virtual_key_code,
    Auto_repeat,
    Is_keypad,
    Is_system_key,
    Location
) ->
    Callback__(
        <<"Input.dispatchKeyEvent"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [{<<"type"/utf8>>,
                            encode__dispatch_key_event_type(Type_)}],
                    _pipe@1 = chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Modifiers,
                        fun(Inner_value__) ->
                            {<<"modifiers"/utf8>>,
                                gleam@json:int(Inner_value__)}
                        end
                    ),
                    _pipe@2 = chrobot_extra@internal@utils:add_optional(
                        _pipe@1,
                        Timestamp,
                        fun(Inner_value__@1) ->
                            {<<"timestamp"/utf8>>,
                                encode__time_since_epoch(Inner_value__@1)}
                        end
                    ),
                    _pipe@3 = chrobot_extra@internal@utils:add_optional(
                        _pipe@2,
                        Text,
                        fun(Inner_value__@2) ->
                            {<<"text"/utf8>>,
                                gleam@json:string(Inner_value__@2)}
                        end
                    ),
                    _pipe@4 = chrobot_extra@internal@utils:add_optional(
                        _pipe@3,
                        Unmodified_text,
                        fun(Inner_value__@3) ->
                            {<<"unmodifiedText"/utf8>>,
                                gleam@json:string(Inner_value__@3)}
                        end
                    ),
                    _pipe@5 = chrobot_extra@internal@utils:add_optional(
                        _pipe@4,
                        Key_identifier,
                        fun(Inner_value__@4) ->
                            {<<"keyIdentifier"/utf8>>,
                                gleam@json:string(Inner_value__@4)}
                        end
                    ),
                    _pipe@6 = chrobot_extra@internal@utils:add_optional(
                        _pipe@5,
                        Code,
                        fun(Inner_value__@5) ->
                            {<<"code"/utf8>>,
                                gleam@json:string(Inner_value__@5)}
                        end
                    ),
                    _pipe@7 = chrobot_extra@internal@utils:add_optional(
                        _pipe@6,
                        Key,
                        fun(Inner_value__@6) ->
                            {<<"key"/utf8>>, gleam@json:string(Inner_value__@6)}
                        end
                    ),
                    _pipe@8 = chrobot_extra@internal@utils:add_optional(
                        _pipe@7,
                        Windows_virtual_key_code,
                        fun(Inner_value__@7) ->
                            {<<"windowsVirtualKeyCode"/utf8>>,
                                gleam@json:int(Inner_value__@7)}
                        end
                    ),
                    _pipe@9 = chrobot_extra@internal@utils:add_optional(
                        _pipe@8,
                        Native_virtual_key_code,
                        fun(Inner_value__@8) ->
                            {<<"nativeVirtualKeyCode"/utf8>>,
                                gleam@json:int(Inner_value__@8)}
                        end
                    ),
                    _pipe@10 = chrobot_extra@internal@utils:add_optional(
                        _pipe@9,
                        Auto_repeat,
                        fun(Inner_value__@9) ->
                            {<<"autoRepeat"/utf8>>,
                                gleam@json:bool(Inner_value__@9)}
                        end
                    ),
                    _pipe@11 = chrobot_extra@internal@utils:add_optional(
                        _pipe@10,
                        Is_keypad,
                        fun(Inner_value__@10) ->
                            {<<"isKeypad"/utf8>>,
                                gleam@json:bool(Inner_value__@10)}
                        end
                    ),
                    _pipe@12 = chrobot_extra@internal@utils:add_optional(
                        _pipe@11,
                        Is_system_key,
                        fun(Inner_value__@11) ->
                            {<<"isSystemKey"/utf8>>,
                                gleam@json:bool(Inner_value__@11)}
                        end
                    ),
                    chrobot_extra@internal@utils:add_optional(
                        _pipe@12,
                        Location,
                        fun(Inner_value__@12) ->
                            {<<"location"/utf8>>,
                                gleam@json:int(Inner_value__@12)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\input.gleam", 298).
?DOC(false).
-spec decode__dispatch_key_event_type() -> gleam@dynamic@decode:decoder(dispatch_key_event_type()).
decode__dispatch_key_event_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"keyDown"/utf8>> ->
                        gleam@dynamic@decode:success(
                            dispatch_key_event_type_key_down
                        );

                    <<"keyUp"/utf8>> ->
                        gleam@dynamic@decode:success(
                            dispatch_key_event_type_key_up
                        );

                    <<"rawKeyDown"/utf8>> ->
                        gleam@dynamic@decode:success(
                            dispatch_key_event_type_raw_key_down
                        );

                    <<"char"/utf8>> ->
                        gleam@dynamic@decode:success(
                            dispatch_key_event_type_char
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            dispatch_key_event_type_key_down,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\input.gleam", 404).
?DOC(false).
-spec encode__dispatch_mouse_event_type(dispatch_mouse_event_type()) -> gleam@json:json().
encode__dispatch_mouse_event_type(Value__) ->
    _pipe = case Value__ of
        dispatch_mouse_event_type_mouse_pressed ->
            <<"mousePressed"/utf8>>;

        dispatch_mouse_event_type_mouse_released ->
            <<"mouseReleased"/utf8>>;

        dispatch_mouse_event_type_mouse_moved ->
            <<"mouseMoved"/utf8>>;

        dispatch_mouse_event_type_mouse_wheel ->
            <<"mouseWheel"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\input.gleam", 415).
?DOC(false).
-spec decode__dispatch_mouse_event_type() -> gleam@dynamic@decode:decoder(dispatch_mouse_event_type()).
decode__dispatch_mouse_event_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"mousePressed"/utf8>> ->
                        gleam@dynamic@decode:success(
                            dispatch_mouse_event_type_mouse_pressed
                        );

                    <<"mouseReleased"/utf8>> ->
                        gleam@dynamic@decode:success(
                            dispatch_mouse_event_type_mouse_released
                        );

                    <<"mouseMoved"/utf8>> ->
                        gleam@dynamic@decode:success(
                            dispatch_mouse_event_type_mouse_moved
                        );

                    <<"mouseWheel"/utf8>> ->
                        gleam@dynamic@decode:success(
                            dispatch_mouse_event_type_mouse_wheel
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            dispatch_mouse_event_type_mouse_pressed,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\input.gleam", 440).
?DOC(false).
-spec encode__dispatch_mouse_event_pointer_type(
    dispatch_mouse_event_pointer_type()
) -> gleam@json:json().
encode__dispatch_mouse_event_pointer_type(Value__) ->
    _pipe = case Value__ of
        dispatch_mouse_event_pointer_type_mouse ->
            <<"mouse"/utf8>>;

        dispatch_mouse_event_pointer_type_pen ->
            <<"pen"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\input.gleam", 333).
?DOC(
    " Dispatches a mouse event to the page.\n"
    " \n"
    " Parameters:  \n"
    "  - `type_` : Type of the mouse event.\n"
    "  - `x` : X coordinate of the event relative to the main frame's viewport in CSS pixels.\n"
    "  - `y` : Y coordinate of the event relative to the main frame's viewport in CSS pixels. 0 refers to\n"
    " the top of the viewport and Y increases as it proceeds towards the bottom of the viewport.\n"
    "  - `modifiers` : Bit field representing pressed modifier keys. Alt=1, Ctrl=2, Meta/Command=4, Shift=8\n"
    " (default: 0).\n"
    "  - `timestamp` : Time at which the event occurred.\n"
    "  - `button` : Mouse button (default: \"none\").\n"
    "  - `buttons` : A number indicating which buttons are pressed on the mouse when a mouse event is triggered.\n"
    " Left=1, Right=2, Middle=4, Back=8, Forward=16, None=0.\n"
    "  - `click_count` : Number of times the mouse button was clicked (default: 0).\n"
    "  - `tilt_x` : The plane angle between the Y-Z plane and the plane containing both the stylus axis and the Y axis, in degrees of the range [-90,90], a positive tiltX is to the right (default: 0).\n"
    "  - `tilt_y` : The plane angle between the X-Z plane and the plane containing both the stylus axis and the X axis, in degrees of the range [-90,90], a positive tiltY is towards the user (default: 0).\n"
    "  - `delta_x` : X delta in CSS pixels for mouse wheel event (default: 0).\n"
    "  - `delta_y` : Y delta in CSS pixels for mouse wheel event (default: 0).\n"
    "  - `pointer_type` : Pointer type (default: \"mouse\").\n"
    " \n"
    " Returns:\n"
).
-spec dispatch_mouse_event(
    fun((binary(), gleam@option:option(gleam@json:json())) -> LTY),
    dispatch_mouse_event_type(),
    float(),
    float(),
    gleam@option:option(integer()),
    gleam@option:option(time_since_epoch()),
    gleam@option:option(mouse_button()),
    gleam@option:option(integer()),
    gleam@option:option(integer()),
    gleam@option:option(float()),
    gleam@option:option(float()),
    gleam@option:option(float()),
    gleam@option:option(float()),
    gleam@option:option(dispatch_mouse_event_pointer_type())
) -> LTY.
dispatch_mouse_event(
    Callback__,
    Type_,
    X,
    Y,
    Modifiers,
    Timestamp,
    Button,
    Buttons,
    Click_count,
    Tilt_x,
    Tilt_y,
    Delta_x,
    Delta_y,
    Pointer_type
) ->
    Callback__(
        <<"Input.dispatchMouseEvent"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [{<<"type"/utf8>>,
                            encode__dispatch_mouse_event_type(Type_)},
                        {<<"x"/utf8>>, gleam@json:float(X)},
                        {<<"y"/utf8>>, gleam@json:float(Y)}],
                    _pipe@1 = chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Modifiers,
                        fun(Inner_value__) ->
                            {<<"modifiers"/utf8>>,
                                gleam@json:int(Inner_value__)}
                        end
                    ),
                    _pipe@2 = chrobot_extra@internal@utils:add_optional(
                        _pipe@1,
                        Timestamp,
                        fun(Inner_value__@1) ->
                            {<<"timestamp"/utf8>>,
                                encode__time_since_epoch(Inner_value__@1)}
                        end
                    ),
                    _pipe@3 = chrobot_extra@internal@utils:add_optional(
                        _pipe@2,
                        Button,
                        fun(Inner_value__@2) ->
                            {<<"button"/utf8>>,
                                encode__mouse_button(Inner_value__@2)}
                        end
                    ),
                    _pipe@4 = chrobot_extra@internal@utils:add_optional(
                        _pipe@3,
                        Buttons,
                        fun(Inner_value__@3) ->
                            {<<"buttons"/utf8>>,
                                gleam@json:int(Inner_value__@3)}
                        end
                    ),
                    _pipe@5 = chrobot_extra@internal@utils:add_optional(
                        _pipe@4,
                        Click_count,
                        fun(Inner_value__@4) ->
                            {<<"clickCount"/utf8>>,
                                gleam@json:int(Inner_value__@4)}
                        end
                    ),
                    _pipe@6 = chrobot_extra@internal@utils:add_optional(
                        _pipe@5,
                        Tilt_x,
                        fun(Inner_value__@5) ->
                            {<<"tiltX"/utf8>>,
                                gleam@json:float(Inner_value__@5)}
                        end
                    ),
                    _pipe@7 = chrobot_extra@internal@utils:add_optional(
                        _pipe@6,
                        Tilt_y,
                        fun(Inner_value__@6) ->
                            {<<"tiltY"/utf8>>,
                                gleam@json:float(Inner_value__@6)}
                        end
                    ),
                    _pipe@8 = chrobot_extra@internal@utils:add_optional(
                        _pipe@7,
                        Delta_x,
                        fun(Inner_value__@7) ->
                            {<<"deltaX"/utf8>>,
                                gleam@json:float(Inner_value__@7)}
                        end
                    ),
                    _pipe@9 = chrobot_extra@internal@utils:add_optional(
                        _pipe@8,
                        Delta_y,
                        fun(Inner_value__@8) ->
                            {<<"deltaY"/utf8>>,
                                gleam@json:float(Inner_value__@8)}
                        end
                    ),
                    chrobot_extra@internal@utils:add_optional(
                        _pipe@9,
                        Pointer_type,
                        fun(Inner_value__@9) ->
                            {<<"pointerType"/utf8>>,
                                encode__dispatch_mouse_event_pointer_type(
                                    Inner_value__@9
                                )}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\input.gleam", 451).
?DOC(false).
-spec decode__dispatch_mouse_event_pointer_type() -> gleam@dynamic@decode:decoder(dispatch_mouse_event_pointer_type()).
decode__dispatch_mouse_event_pointer_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"mouse"/utf8>> ->
                        gleam@dynamic@decode:success(
                            dispatch_mouse_event_pointer_type_mouse
                        );

                    <<"pen"/utf8>> ->
                        gleam@dynamic@decode:success(
                            dispatch_mouse_event_pointer_type_pen
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            dispatch_mouse_event_pointer_type_mouse,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\input.gleam", 514).
?DOC(false).
-spec encode__dispatch_touch_event_type(dispatch_touch_event_type()) -> gleam@json:json().
encode__dispatch_touch_event_type(Value__) ->
    _pipe = case Value__ of
        dispatch_touch_event_type_touch_start ->
            <<"touchStart"/utf8>>;

        dispatch_touch_event_type_touch_end ->
            <<"touchEnd"/utf8>>;

        dispatch_touch_event_type_touch_move ->
            <<"touchMove"/utf8>>;

        dispatch_touch_event_type_touch_cancel ->
            <<"touchCancel"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\input.gleam", 480).
?DOC(
    " Dispatches a touch event to the page.\n"
    " \n"
    " Parameters:  \n"
    "  - `type_` : Type of the touch event. TouchEnd and TouchCancel must not contain any touch points, while\n"
    " TouchStart and TouchMove must contains at least one.\n"
    "  - `touch_points` : Active touch points on the touch device. One event per any changed point (compared to\n"
    " previous touch event in a sequence) is generated, emulating pressing/moving/releasing points\n"
    " one by one.\n"
    "  - `modifiers` : Bit field representing pressed modifier keys. Alt=1, Ctrl=2, Meta/Command=4, Shift=8\n"
    " (default: 0).\n"
    "  - `timestamp` : Time at which the event occurred.\n"
    " \n"
    " Returns:\n"
).
-spec dispatch_touch_event(
    fun((binary(), gleam@option:option(gleam@json:json())) -> LVF),
    dispatch_touch_event_type(),
    list(touch_point()),
    gleam@option:option(integer()),
    gleam@option:option(time_since_epoch())
) -> LVF.
dispatch_touch_event(Callback__, Type_, Touch_points, Modifiers, Timestamp) ->
    Callback__(
        <<"Input.dispatchTouchEvent"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [{<<"type"/utf8>>,
                            encode__dispatch_touch_event_type(Type_)},
                        {<<"touchPoints"/utf8>>,
                            gleam@json:array(
                                Touch_points,
                                fun encode__touch_point/1
                            )}],
                    _pipe@1 = chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Modifiers,
                        fun(Inner_value__) ->
                            {<<"modifiers"/utf8>>,
                                gleam@json:int(Inner_value__)}
                        end
                    ),
                    chrobot_extra@internal@utils:add_optional(
                        _pipe@1,
                        Timestamp,
                        fun(Inner_value__@1) ->
                            {<<"timestamp"/utf8>>,
                                encode__time_since_epoch(Inner_value__@1)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\input.gleam", 525).
?DOC(false).
-spec decode__dispatch_touch_event_type() -> gleam@dynamic@decode:decoder(dispatch_touch_event_type()).
decode__dispatch_touch_event_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"touchStart"/utf8>> ->
                        gleam@dynamic@decode:success(
                            dispatch_touch_event_type_touch_start
                        );

                    <<"touchEnd"/utf8>> ->
                        gleam@dynamic@decode:success(
                            dispatch_touch_event_type_touch_end
                        );

                    <<"touchMove"/utf8>> ->
                        gleam@dynamic@decode:success(
                            dispatch_touch_event_type_touch_move
                        );

                    <<"touchCancel"/utf8>> ->
                        gleam@dynamic@decode:success(
                            dispatch_touch_event_type_touch_cancel
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            dispatch_touch_event_type_touch_start,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\input.gleam", 541).
?DOC(" Cancels any active dragging in the page.\n").
-spec cancel_dragging(fun((binary(), gleam@option:option(any())) -> LVY)) -> LVY.
cancel_dragging(Callback__) ->
    Callback__(<<"Input.cancelDragging"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\input.gleam", 552).
?DOC(
    " Ignores input events (useful while auditing page).\n"
    " \n"
    " Parameters:  \n"
    "  - `ignore` : Ignores input events processing when set to true.\n"
    " \n"
    " Returns:\n"
).
-spec set_ignore_input_events(
    fun((binary(), gleam@option:option(gleam@json:json())) -> LWC),
    boolean()
) -> LWC.
set_ignore_input_events(Callback__, Ignore) ->
    Callback__(
        <<"Input.setIgnoreInputEvents"/utf8>>,
        {some,
            gleam@json:object([{<<"ignore"/utf8>>, gleam@json:bool(Ignore)}])}
    ).
