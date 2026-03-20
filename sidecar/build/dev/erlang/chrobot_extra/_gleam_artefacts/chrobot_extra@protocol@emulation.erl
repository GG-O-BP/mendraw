-module(chrobot_extra@protocol@emulation).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\protocol\\emulation.gleam").
-export([encode__screen_orientation_type/1, decode__screen_orientation_type/0, encode__screen_orientation/1, decode__screen_orientation/0, encode__display_feature_orientation/1, decode__display_feature_orientation/0, encode__display_feature/1, decode__display_feature/0, encode__device_posture_type/1, decode__device_posture_type/0, encode__device_posture/1, decode__device_posture/0, encode__media_feature/1, decode__media_feature/0, clear_device_metrics_override/1, clear_geolocation_override/1, set_cpu_throttling_rate/2, set_default_background_color_override/2, set_device_metrics_override/6, set_emulated_media/3, encode__set_emulated_vision_deficiency_type/1, set_emulated_vision_deficiency/2, decode__set_emulated_vision_deficiency_type/0, set_geolocation_override/4, set_idle_override/3, clear_idle_override/1, set_script_execution_disabled/2, set_touch_emulation_enabled/3, set_timezone_override/2, set_user_agent_override/4]).
-export_type([screen_orientation/0, screen_orientation_type/0, display_feature/0, display_feature_orientation/0, device_posture/0, device_posture_type/0, media_feature/0, set_emulated_vision_deficiency_type/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " > ⚙️  This module was generated from the Chrome DevTools Protocol version **1.3**\n"
    " ## Emulation Domain  \n"
    "\n"
    " This domain emulates different environments for the page.  \n"
    "\n"
    " [📖   View this domain on the DevTools Protocol API Docs](https://chromedevtools.github.io/devtools-protocol/1-3/Emulation/)\n"
).

-type screen_orientation() :: {screen_orientation,
        screen_orientation_type(),
        integer()}.

-type screen_orientation_type() :: screen_orientation_type_portrait_primary |
    screen_orientation_type_portrait_secondary |
    screen_orientation_type_landscape_primary |
    screen_orientation_type_landscape_secondary.

-type display_feature() :: {display_feature,
        display_feature_orientation(),
        integer(),
        integer()}.

-type display_feature_orientation() :: display_feature_orientation_vertical |
    display_feature_orientation_horizontal.

-type device_posture() :: {device_posture, device_posture_type()}.

-type device_posture_type() :: device_posture_type_continuous |
    device_posture_type_folded.

-type media_feature() :: {media_feature, binary(), binary()}.

-type set_emulated_vision_deficiency_type() :: set_emulated_vision_deficiency_type_none |
    set_emulated_vision_deficiency_type_blurred_vision |
    set_emulated_vision_deficiency_type_reduced_contrast |
    set_emulated_vision_deficiency_type_achromatopsia |
    set_emulated_vision_deficiency_type_deuteranopia |
    set_emulated_vision_deficiency_type_protanopia |
    set_emulated_vision_deficiency_type_tritanopia.

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 39).
?DOC(false).
-spec encode__screen_orientation_type(screen_orientation_type()) -> gleam@json:json().
encode__screen_orientation_type(Value__) ->
    _pipe = case Value__ of
        screen_orientation_type_portrait_primary ->
            <<"portraitPrimary"/utf8>>;

        screen_orientation_type_portrait_secondary ->
            <<"portraitSecondary"/utf8>>;

        screen_orientation_type_landscape_primary ->
            <<"landscapePrimary"/utf8>>;

        screen_orientation_type_landscape_secondary ->
            <<"landscapeSecondary"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 50).
?DOC(false).
-spec decode__screen_orientation_type() -> gleam@dynamic@decode:decoder(screen_orientation_type()).
decode__screen_orientation_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"portraitPrimary"/utf8>> ->
                        gleam@dynamic@decode:success(
                            screen_orientation_type_portrait_primary
                        );

                    <<"portraitSecondary"/utf8>> ->
                        gleam@dynamic@decode:success(
                            screen_orientation_type_portrait_secondary
                        );

                    <<"landscapePrimary"/utf8>> ->
                        gleam@dynamic@decode:success(
                            screen_orientation_type_landscape_primary
                        );

                    <<"landscapeSecondary"/utf8>> ->
                        gleam@dynamic@decode:success(
                            screen_orientation_type_landscape_secondary
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            screen_orientation_type_portrait_primary,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 71).
?DOC(false).
-spec encode__screen_orientation(screen_orientation()) -> gleam@json:json().
encode__screen_orientation(Value__) ->
    gleam@json:object(
        [{<<"type"/utf8>>,
                encode__screen_orientation_type(erlang:element(2, Value__))},
            {<<"angle"/utf8>>, gleam@json:int(erlang:element(3, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 79).
?DOC(false).
-spec decode__screen_orientation() -> gleam@dynamic@decode:decoder(screen_orientation()).
decode__screen_orientation() ->
    begin
        gleam@dynamic@decode:field(
            <<"type"/utf8>>,
            decode__screen_orientation_type(),
            fun(Type_) ->
                gleam@dynamic@decode:field(
                    <<"angle"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_int/1},
                    fun(Angle) ->
                        gleam@dynamic@decode:success(
                            {screen_orientation, Type_, Angle}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 110).
?DOC(false).
-spec encode__display_feature_orientation(display_feature_orientation()) -> gleam@json:json().
encode__display_feature_orientation(Value__) ->
    _pipe = case Value__ of
        display_feature_orientation_vertical ->
            <<"vertical"/utf8>>;

        display_feature_orientation_horizontal ->
            <<"horizontal"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 119).
?DOC(false).
-spec decode__display_feature_orientation() -> gleam@dynamic@decode:decoder(display_feature_orientation()).
decode__display_feature_orientation() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"vertical"/utf8>> ->
                        gleam@dynamic@decode:success(
                            display_feature_orientation_vertical
                        );

                    <<"horizontal"/utf8>> ->
                        gleam@dynamic@decode:success(
                            display_feature_orientation_horizontal
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            display_feature_orientation_vertical,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 132).
?DOC(false).
-spec encode__display_feature(display_feature()) -> gleam@json:json().
encode__display_feature(Value__) ->
    gleam@json:object(
        [{<<"orientation"/utf8>>,
                encode__display_feature_orientation(erlang:element(2, Value__))},
            {<<"offset"/utf8>>, gleam@json:int(erlang:element(3, Value__))},
            {<<"maskLength"/utf8>>, gleam@json:int(erlang:element(4, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 141).
?DOC(false).
-spec decode__display_feature() -> gleam@dynamic@decode:decoder(display_feature()).
decode__display_feature() ->
    begin
        gleam@dynamic@decode:field(
            <<"orientation"/utf8>>,
            decode__display_feature_orientation(),
            fun(Orientation) ->
                gleam@dynamic@decode:field(
                    <<"offset"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_int/1},
                    fun(Offset) ->
                        gleam@dynamic@decode:field(
                            <<"maskLength"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_int/1},
                            fun(Mask_length) ->
                                gleam@dynamic@decode:success(
                                    {display_feature,
                                        Orientation,
                                        Offset,
                                        Mask_length}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 173).
?DOC(false).
-spec encode__device_posture_type(device_posture_type()) -> gleam@json:json().
encode__device_posture_type(Value__) ->
    _pipe = case Value__ of
        device_posture_type_continuous ->
            <<"continuous"/utf8>>;

        device_posture_type_folded ->
            <<"folded"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 182).
?DOC(false).
-spec decode__device_posture_type() -> gleam@dynamic@decode:decoder(device_posture_type()).
decode__device_posture_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"continuous"/utf8>> ->
                        gleam@dynamic@decode:success(
                            device_posture_type_continuous
                        );

                    <<"folded"/utf8>> ->
                        gleam@dynamic@decode:success(device_posture_type_folded);

                    _ ->
                        gleam@dynamic@decode:failure(
                            device_posture_type_continuous,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 194).
?DOC(false).
-spec encode__device_posture(device_posture()) -> gleam@json:json().
encode__device_posture(Value__) ->
    gleam@json:object(
        [{<<"type"/utf8>>,
                encode__device_posture_type(erlang:element(2, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 201).
?DOC(false).
-spec decode__device_posture() -> gleam@dynamic@decode:decoder(device_posture()).
decode__device_posture() ->
    begin
        gleam@dynamic@decode:field(
            <<"type"/utf8>>,
            decode__device_posture_type(),
            fun(Type_) ->
                gleam@dynamic@decode:success({device_posture, Type_})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 214).
?DOC(false).
-spec encode__media_feature(media_feature()) -> gleam@json:json().
encode__media_feature(Value__) ->
    gleam@json:object(
        [{<<"name"/utf8>>, gleam@json:string(erlang:element(2, Value__))},
            {<<"value"/utf8>>, gleam@json:string(erlang:element(3, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 222).
?DOC(false).
-spec decode__media_feature() -> gleam@dynamic@decode:decoder(media_feature()).
decode__media_feature() ->
    begin
        gleam@dynamic@decode:field(
            <<"name"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Name) ->
                gleam@dynamic@decode:field(
                    <<"value"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Value) ->
                        gleam@dynamic@decode:success(
                            {media_feature, Name, Value}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 233).
?DOC(" Clears the overridden device metrics.\n").
-spec clear_device_metrics_override(
    fun((binary(), gleam@option:option(any())) -> UPW)
) -> UPW.
clear_device_metrics_override(Callback__) ->
    Callback__(<<"Emulation.clearDeviceMetricsOverride"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 239).
?DOC(" Clears the overridden Geolocation Position and Error.\n").
-spec clear_geolocation_override(
    fun((binary(), gleam@option:option(any())) -> UQA)
) -> UQA.
clear_geolocation_override(Callback__) ->
    Callback__(<<"Emulation.clearGeolocationOverride"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 250).
?DOC(
    " Enables CPU throttling to emulate slow CPUs.\n"
    " \n"
    " Parameters:  \n"
    "  - `rate` : Throttling rate as a slowdown factor (1 is no throttle, 2 is 2x slowdown, etc).\n"
    " \n"
    " Returns:\n"
).
-spec set_cpu_throttling_rate(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UQE),
    float()
) -> UQE.
set_cpu_throttling_rate(Callback__, Rate) ->
    Callback__(
        <<"Emulation.setCPUThrottlingRate"/utf8>>,
        {some, gleam@json:object([{<<"rate"/utf8>>, gleam@json:float(Rate)}])}
    ).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 270).
?DOC(
    " Sets or clears an override of the default background color of the frame. This override is used\n"
    " if the content does not specify one.\n"
    " \n"
    " Parameters:  \n"
    "  - `color` : RGBA of the default background color. If not specified, any existing override will be\n"
    " cleared.\n"
    " \n"
    " Returns:\n"
).
-spec set_default_background_color_override(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UQJ),
    gleam@option:option(chrobot_extra@protocol@dom:r_g_b_a())
) -> UQJ.
set_default_background_color_override(Callback__, Color) ->
    Callback__(
        <<"Emulation.setDefaultBackgroundColorOverride"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [],
                    chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Color,
                        fun(Inner_value__) ->
                            {<<"color"/utf8>>,
                                chrobot_extra@protocol@dom:encode__rgba(
                                    Inner_value__
                                )}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 299).
?DOC(
    " Overrides the values of device screen dimensions (window.screen.width, window.screen.height,\n"
    " window.innerWidth, window.innerHeight, and \"device-width\"/\"device-height\"-related CSS media\n"
    " query results).\n"
    " \n"
    " Parameters:  \n"
    "  - `width` : Overriding width value in pixels (minimum 0, maximum 10000000). 0 disables the override.\n"
    "  - `height` : Overriding height value in pixels (minimum 0, maximum 10000000). 0 disables the override.\n"
    "  - `device_scale_factor` : Overriding device scale factor value. 0 disables the override.\n"
    "  - `mobile` : Whether to emulate mobile device. This includes viewport meta tag, overlay scrollbars, text\n"
    " autosizing and more.\n"
    "  - `screen_orientation` : Screen orientation override.\n"
    " \n"
    " Returns:\n"
).
-spec set_device_metrics_override(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UQQ),
    integer(),
    integer(),
    float(),
    boolean(),
    gleam@option:option(screen_orientation())
) -> UQQ.
set_device_metrics_override(
    Callback__,
    Width,
    Height,
    Device_scale_factor,
    Mobile,
    Screen_orientation
) ->
    Callback__(
        <<"Emulation.setDeviceMetricsOverride"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [{<<"width"/utf8>>, gleam@json:int(Width)},
                        {<<"height"/utf8>>, gleam@json:int(Height)},
                        {<<"deviceScaleFactor"/utf8>>,
                            gleam@json:float(Device_scale_factor)},
                        {<<"mobile"/utf8>>, gleam@json:bool(Mobile)}],
                    chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Screen_orientation,
                        fun(Inner_value__) ->
                            {<<"screenOrientation"/utf8>>,
                                encode__screen_orientation(Inner_value__)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 331).
?DOC(
    " Emulates the given media type or media feature for CSS media queries.\n"
    " \n"
    " Parameters:  \n"
    "  - `media` : Media type to emulate. Empty string disables the override.\n"
    "  - `features` : Media features to emulate.\n"
    " \n"
    " Returns:\n"
).
-spec set_emulated_media(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UQX),
    gleam@option:option(binary()),
    gleam@option:option(list(media_feature()))
) -> UQX.
set_emulated_media(Callback__, Media, Features) ->
    Callback__(
        <<"Emulation.setEmulatedMedia"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [],
                    _pipe@1 = chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Media,
                        fun(Inner_value__) ->
                            {<<"media"/utf8>>, gleam@json:string(Inner_value__)}
                        end
                    ),
                    chrobot_extra@internal@utils:add_optional(
                        _pipe@1,
                        Features,
                        fun(Inner_value__@1) ->
                            {<<"features"/utf8>>,
                                gleam@json:array(
                                    Inner_value__@1,
                                    fun encode__media_feature/1
                                )}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 385).
?DOC(false).
-spec encode__set_emulated_vision_deficiency_type(
    set_emulated_vision_deficiency_type()
) -> gleam@json:json().
encode__set_emulated_vision_deficiency_type(Value__) ->
    _pipe = case Value__ of
        set_emulated_vision_deficiency_type_none ->
            <<"none"/utf8>>;

        set_emulated_vision_deficiency_type_blurred_vision ->
            <<"blurredVision"/utf8>>;

        set_emulated_vision_deficiency_type_reduced_contrast ->
            <<"reducedContrast"/utf8>>;

        set_emulated_vision_deficiency_type_achromatopsia ->
            <<"achromatopsia"/utf8>>;

        set_emulated_vision_deficiency_type_deuteranopia ->
            <<"deuteranopia"/utf8>>;

        set_emulated_vision_deficiency_type_protanopia ->
            <<"protanopia"/utf8>>;

        set_emulated_vision_deficiency_type_tritanopia ->
            <<"tritanopia"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 358).
?DOC(
    " Emulates the given vision deficiency.\n"
    " \n"
    " Parameters:  \n"
    "  - `type_` : Vision deficiency to emulate. Order: best-effort emulations come first, followed by any\n"
    " physiologically accurate emulations for medically recognized color vision deficiencies.\n"
    " \n"
    " Returns:\n"
).
-spec set_emulated_vision_deficiency(
    fun((binary(), gleam@option:option(gleam@json:json())) -> URI),
    set_emulated_vision_deficiency_type()
) -> URI.
set_emulated_vision_deficiency(Callback__, Type_) ->
    Callback__(
        <<"Emulation.setEmulatedVisionDeficiency"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"type"/utf8>>,
                        encode__set_emulated_vision_deficiency_type(Type_)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 401).
?DOC(false).
-spec decode__set_emulated_vision_deficiency_type() -> gleam@dynamic@decode:decoder(set_emulated_vision_deficiency_type()).
decode__set_emulated_vision_deficiency_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"none"/utf8>> ->
                        gleam@dynamic@decode:success(
                            set_emulated_vision_deficiency_type_none
                        );

                    <<"blurredVision"/utf8>> ->
                        gleam@dynamic@decode:success(
                            set_emulated_vision_deficiency_type_blurred_vision
                        );

                    <<"reducedContrast"/utf8>> ->
                        gleam@dynamic@decode:success(
                            set_emulated_vision_deficiency_type_reduced_contrast
                        );

                    <<"achromatopsia"/utf8>> ->
                        gleam@dynamic@decode:success(
                            set_emulated_vision_deficiency_type_achromatopsia
                        );

                    <<"deuteranopia"/utf8>> ->
                        gleam@dynamic@decode:success(
                            set_emulated_vision_deficiency_type_deuteranopia
                        );

                    <<"protanopia"/utf8>> ->
                        gleam@dynamic@decode:success(
                            set_emulated_vision_deficiency_type_protanopia
                        );

                    <<"tritanopia"/utf8>> ->
                        gleam@dynamic@decode:success(
                            set_emulated_vision_deficiency_type_tritanopia
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            set_emulated_vision_deficiency_type_none,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 435).
?DOC(
    " Overrides the Geolocation Position or Error. Omitting any of the parameters emulates position\n"
    " unavailable.\n"
    " \n"
    " Parameters:  \n"
    "  - `latitude` : Mock latitude\n"
    "  - `longitude` : Mock longitude\n"
    "  - `accuracy` : Mock accuracy\n"
    " \n"
    " Returns:\n"
).
-spec set_geolocation_override(
    fun((binary(), gleam@option:option(gleam@json:json())) -> URZ),
    gleam@option:option(float()),
    gleam@option:option(float()),
    gleam@option:option(float())
) -> URZ.
set_geolocation_override(Callback__, Latitude, Longitude, Accuracy) ->
    Callback__(
        <<"Emulation.setGeolocationOverride"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [],
                    _pipe@1 = chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Latitude,
                        fun(Inner_value__) ->
                            {<<"latitude"/utf8>>,
                                gleam@json:float(Inner_value__)}
                        end
                    ),
                    _pipe@2 = chrobot_extra@internal@utils:add_optional(
                        _pipe@1,
                        Longitude,
                        fun(Inner_value__@1) ->
                            {<<"longitude"/utf8>>,
                                gleam@json:float(Inner_value__@1)}
                        end
                    ),
                    chrobot_extra@internal@utils:add_optional(
                        _pipe@2,
                        Accuracy,
                        fun(Inner_value__@2) ->
                            {<<"accuracy"/utf8>>,
                                gleam@json:float(Inner_value__@2)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 466).
?DOC(
    " Overrides the Idle state.\n"
    " \n"
    " Parameters:  \n"
    "  - `is_user_active` : Mock isUserActive\n"
    "  - `is_screen_unlocked` : Mock isScreenUnlocked\n"
    " \n"
    " Returns:\n"
).
-spec set_idle_override(
    fun((binary(), gleam@option:option(gleam@json:json())) -> USK),
    boolean(),
    boolean()
) -> USK.
set_idle_override(Callback__, Is_user_active, Is_screen_unlocked) ->
    Callback__(
        <<"Emulation.setIdleOverride"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"isUserActive"/utf8>>, gleam@json:bool(Is_user_active)},
                    {<<"isScreenUnlocked"/utf8>>,
                        gleam@json:bool(Is_screen_unlocked)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 484).
?DOC(" Clears Idle state overrides.\n").
-spec clear_idle_override(fun((binary(), gleam@option:option(any())) -> USP)) -> USP.
clear_idle_override(Callback__) ->
    Callback__(<<"Emulation.clearIdleOverride"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 495).
?DOC(
    " Switches script execution in the page.\n"
    " \n"
    " Parameters:  \n"
    "  - `value` : Whether script execution should be disabled in the page.\n"
    " \n"
    " Returns:\n"
).
-spec set_script_execution_disabled(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UST),
    boolean()
) -> UST.
set_script_execution_disabled(Callback__, Value) ->
    Callback__(
        <<"Emulation.setScriptExecutionDisabled"/utf8>>,
        {some, gleam@json:object([{<<"value"/utf8>>, gleam@json:bool(Value)}])}
    ).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 514).
?DOC(
    " Enables touch on platforms which do not support them.\n"
    " \n"
    " Parameters:  \n"
    "  - `enabled` : Whether the touch event emulation should be enabled.\n"
    "  - `max_touch_points` : Maximum touch points supported. Defaults to one.\n"
    " \n"
    " Returns:\n"
).
-spec set_touch_emulation_enabled(
    fun((binary(), gleam@option:option(gleam@json:json())) -> USY),
    boolean(),
    gleam@option:option(integer())
) -> USY.
set_touch_emulation_enabled(Callback__, Enabled, Max_touch_points) ->
    Callback__(
        <<"Emulation.setTouchEmulationEnabled"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [{<<"enabled"/utf8>>, gleam@json:bool(Enabled)}],
                    chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Max_touch_points,
                        fun(Inner_value__) ->
                            {<<"maxTouchPoints"/utf8>>,
                                gleam@json:int(Inner_value__)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 541).
?DOC(
    " Overrides default host system timezone with the specified one.\n"
    " \n"
    " Parameters:  \n"
    "  - `timezone_id` : The timezone identifier. List of supported timezones:\n"
    " https://source.chromium.org/chromium/chromium/deps/icu.git/+/faee8bc70570192d82d2978a71e2a615788597d1:source/data/misc/metaZones.txt\n"
    " If empty, disables the override and restores default host system timezone.\n"
    " \n"
    " Returns:\n"
).
-spec set_timezone_override(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UTF),
    binary()
) -> UTF.
set_timezone_override(Callback__, Timezone_id) ->
    Callback__(
        <<"Emulation.setTimezoneOverride"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"timezoneId"/utf8>>, gleam@json:string(Timezone_id)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\emulation.gleam", 562).
?DOC(
    " Allows overriding user agent with the given string.\n"
    " `userAgentMetadata` must be set for Client Hint headers to be sent.\n"
    " \n"
    " Parameters:  \n"
    "  - `user_agent` : User agent to use.\n"
    "  - `accept_language` : Browser language to emulate.\n"
    "  - `platform` : The platform navigator.platform should return.\n"
    " \n"
    " Returns:\n"
).
-spec set_user_agent_override(
    fun((binary(), gleam@option:option(gleam@json:json())) -> UTK),
    binary(),
    gleam@option:option(binary()),
    gleam@option:option(binary())
) -> UTK.
set_user_agent_override(Callback__, User_agent, Accept_language, Platform) ->
    Callback__(
        <<"Emulation.setUserAgentOverride"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [{<<"userAgent"/utf8>>,
                            gleam@json:string(User_agent)}],
                    _pipe@1 = chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Accept_language,
                        fun(Inner_value__) ->
                            {<<"acceptLanguage"/utf8>>,
                                gleam@json:string(Inner_value__)}
                        end
                    ),
                    chrobot_extra@internal@utils:add_optional(
                        _pipe@1,
                        Platform,
                        fun(Inner_value__@1) ->
                            {<<"platform"/utf8>>,
                                gleam@json:string(Inner_value__@1)}
                        end
                    )
                end
            )}
    ).
