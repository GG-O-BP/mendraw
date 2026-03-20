-module(chrobot_extra@protocol@page).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\protocol\\page.gleam").
-export([encode__frame_id/1, decode__frame_id/0, encode__frame/1, decode__frame/0, encode__frame_tree/1, decode__frame_tree/0, encode__script_identifier/1, decode__script_identifier/0, encode__transition_type/1, decode__transition_type/0, encode__navigation_entry/1, decode__navigation_entry/0, encode__dialog_type/1, decode__dialog_type/0, encode__app_manifest_error/1, decode__app_manifest_error/0, encode__layout_viewport/1, decode__layout_viewport/0, encode__visual_viewport/1, decode__visual_viewport/0, encode__viewport/1, decode__viewport/0, decode__add_script_to_evaluate_on_new_document_response/0, decode__capture_screenshot_response/0, decode__create_isolated_world_response/0, decode__get_app_manifest_response/0, decode__get_frame_tree_response/0, decode__get_layout_metrics_response/0, decode__get_navigation_history_response/0, decode__navigate_response/0, decode__print_to_pdf_response/0, add_script_to_evaluate_on_new_document/2, bring_to_front/1, encode__capture_screenshot_format/1, capture_screenshot/4, decode__capture_screenshot_format/0, create_isolated_world/4, disable/1, enable/1, get_app_manifest/2, get_frame_tree/1, get_layout_metrics/1, get_navigation_history/1, reset_navigation_history/1, handle_java_script_dialog/3, navigate/5, navigate_to_history_entry/2, print_to_pdf/15, reload/3, remove_script_to_evaluate_on_new_document/2, set_bypass_csp/2, set_document_content/3, set_lifecycle_events_enabled/2, stop_loading/1, close/1, set_intercept_file_chooser_dialog/2]).
-export_type([frame_id/0, frame/0, frame_tree/0, script_identifier/0, transition_type/0, navigation_entry/0, dialog_type/0, app_manifest_error/0, layout_viewport/0, visual_viewport/0, viewport/0, add_script_to_evaluate_on_new_document_response/0, capture_screenshot_response/0, create_isolated_world_response/0, get_app_manifest_response/0, get_frame_tree_response/0, get_layout_metrics_response/0, get_navigation_history_response/0, navigate_response/0, print_to_pdf_response/0, capture_screenshot_format/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " > ⚙️  This module was generated from the Chrome DevTools Protocol version **1.3**\n"
    " ## Page Domain  \n"
    "\n"
    " Actions and events related to the inspected page belong to the page domain.  \n"
    "\n"
    " [📖   View this domain on the DevTools Protocol API Docs](https://chromedevtools.github.io/devtools-protocol/1-3/Page/)\n"
).

-type frame_id() :: {frame_id, binary()}.

-type frame() :: {frame,
        frame_id(),
        gleam@option:option(frame_id()),
        chrobot_extra@protocol@network:loader_id(),
        gleam@option:option(binary()),
        binary(),
        binary(),
        binary()}.

-type frame_tree() :: {frame_tree,
        frame(),
        gleam@option:option(list(frame_tree()))}.

-type script_identifier() :: {script_identifier, binary()}.

-type transition_type() :: transition_type_link |
    transition_type_typed |
    transition_type_address_bar |
    transition_type_auto_bookmark |
    transition_type_auto_subframe |
    transition_type_manual_subframe |
    transition_type_generated |
    transition_type_auto_toplevel |
    transition_type_form_submit |
    transition_type_reload |
    transition_type_keyword |
    transition_type_keyword_generated |
    transition_type_other.

-type navigation_entry() :: {navigation_entry,
        integer(),
        binary(),
        binary(),
        binary(),
        transition_type()}.

-type dialog_type() :: dialog_type_alert |
    dialog_type_confirm |
    dialog_type_prompt |
    dialog_type_beforeunload.

-type app_manifest_error() :: {app_manifest_error,
        binary(),
        integer(),
        integer(),
        integer()}.

-type layout_viewport() :: {layout_viewport,
        integer(),
        integer(),
        integer(),
        integer()}.

-type visual_viewport() :: {visual_viewport,
        float(),
        float(),
        float(),
        float(),
        float(),
        float(),
        float(),
        gleam@option:option(float())}.

-type viewport() :: {viewport, float(), float(), float(), float(), float()}.

-type add_script_to_evaluate_on_new_document_response() :: {add_script_to_evaluate_on_new_document_response,
        script_identifier()}.

-type capture_screenshot_response() :: {capture_screenshot_response, binary()}.

-type create_isolated_world_response() :: {create_isolated_world_response,
        chrobot_extra@protocol@runtime:execution_context_id()}.

-type get_app_manifest_response() :: {get_app_manifest_response,
        binary(),
        list(app_manifest_error()),
        gleam@option:option(binary())}.

-type get_frame_tree_response() :: {get_frame_tree_response, frame_tree()}.

-type get_layout_metrics_response() :: {get_layout_metrics_response,
        layout_viewport(),
        visual_viewport(),
        chrobot_extra@protocol@dom:rect()}.

-type get_navigation_history_response() :: {get_navigation_history_response,
        integer(),
        list(navigation_entry())}.

-type navigate_response() :: {navigate_response,
        frame_id(),
        gleam@option:option(chrobot_extra@protocol@network:loader_id()),
        gleam@option:option(binary())}.

-type print_to_pdf_response() :: {print_to_pdf_response, binary()}.

-type capture_screenshot_format() :: capture_screenshot_format_jpeg |
    capture_screenshot_format_png |
    capture_screenshot_format_webp.

-file("src\\chrobot_extra\\protocol\\page.gleam", 29).
?DOC(false).
-spec encode__frame_id(frame_id()) -> gleam@json:json().
encode__frame_id(Value__) ->
    case Value__ of
        {frame_id, Inner_value__} ->
            gleam@json:string(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\page.gleam", 36).
?DOC(false).
-spec decode__frame_id() -> gleam@dynamic@decode:decoder(frame_id()).
decode__frame_id() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({frame_id, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\page.gleam", 64).
?DOC(false).
-spec encode__frame(frame()) -> gleam@json:json().
encode__frame(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"id"/utf8>>,
                    encode__frame_id(erlang:element(2, Value__))},
                {<<"loaderId"/utf8>>,
                    chrobot_extra@protocol@network:encode__loader_id(
                        erlang:element(4, Value__)
                    )},
                {<<"url"/utf8>>, gleam@json:string(erlang:element(6, Value__))},
                {<<"securityOrigin"/utf8>>,
                    gleam@json:string(erlang:element(7, Value__))},
                {<<"mimeType"/utf8>>,
                    gleam@json:string(erlang:element(8, Value__))}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(3, Value__),
                fun(Inner_value__) ->
                    {<<"parentId"/utf8>>, encode__frame_id(Inner_value__)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(5, Value__),
                fun(Inner_value__@1) ->
                    {<<"name"/utf8>>, gleam@json:string(Inner_value__@1)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 83).
?DOC(false).
-spec decode__frame() -> gleam@dynamic@decode:decoder(frame()).
decode__frame() ->
    begin
        gleam@dynamic@decode:field(
            <<"id"/utf8>>,
            decode__frame_id(),
            fun(Id) ->
                gleam@dynamic@decode:optional_field(
                    <<"parentId"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(decode__frame_id()),
                    fun(Parent_id) ->
                        gleam@dynamic@decode:field(
                            <<"loaderId"/utf8>>,
                            chrobot_extra@protocol@network:decode__loader_id(),
                            fun(Loader_id) ->
                                gleam@dynamic@decode:optional_field(
                                    <<"name"/utf8>>,
                                    none,
                                    gleam@dynamic@decode:optional(
                                        {decoder,
                                            fun gleam@dynamic@decode:decode_string/1}
                                    ),
                                    fun(Name) ->
                                        gleam@dynamic@decode:field(
                                            <<"url"/utf8>>,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_string/1},
                                            fun(Url) ->
                                                gleam@dynamic@decode:field(
                                                    <<"securityOrigin"/utf8>>,
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_string/1},
                                                    fun(Security_origin) ->
                                                        gleam@dynamic@decode:field(
                                                            <<"mimeType"/utf8>>,
                                                            {decoder,
                                                                fun gleam@dynamic@decode:decode_string/1},
                                                            fun(Mime_type) ->
                                                                gleam@dynamic@decode:success(
                                                                    {frame,
                                                                        Id,
                                                                        Parent_id,
                                                                        Loader_id,
                                                                        Name,
                                                                        Url,
                                                                        Security_origin,
                                                                        Mime_type}
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

-file("src\\chrobot_extra\\protocol\\page.gleam", 124).
?DOC(false).
-spec encode__frame_tree(frame_tree()) -> gleam@json:json().
encode__frame_tree(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"frame"/utf8>>,
                    encode__frame(erlang:element(2, Value__))}],
            chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(3, Value__),
                fun(Inner_value__) ->
                    {<<"childFrames"/utf8>>,
                        gleam@json:array(
                            Inner_value__,
                            fun encode__frame_tree/1
                        )}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 136).
?DOC(false).
-spec decode__frame_tree() -> gleam@dynamic@decode:decoder(frame_tree()).
decode__frame_tree() ->
    begin
        gleam@dynamic@decode:field(
            <<"frame"/utf8>>,
            decode__frame(),
            fun(Frame) ->
                gleam@dynamic@decode:optional_field(
                    <<"childFrames"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(
                        gleam@dynamic@decode:list(decode__frame_tree())
                    ),
                    fun(Child_frames) ->
                        gleam@dynamic@decode:success(
                            {frame_tree, Frame, Child_frames}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\page.gleam", 155).
?DOC(false).
-spec encode__script_identifier(script_identifier()) -> gleam@json:json().
encode__script_identifier(Value__) ->
    case Value__ of
        {script_identifier, Inner_value__} ->
            gleam@json:string(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\page.gleam", 162).
?DOC(false).
-spec decode__script_identifier() -> gleam@dynamic@decode:decoder(script_identifier()).
decode__script_identifier() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({script_identifier, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\page.gleam", 187).
?DOC(false).
-spec encode__transition_type(transition_type()) -> gleam@json:json().
encode__transition_type(Value__) ->
    _pipe = case Value__ of
        transition_type_link ->
            <<"link"/utf8>>;

        transition_type_typed ->
            <<"typed"/utf8>>;

        transition_type_address_bar ->
            <<"address_bar"/utf8>>;

        transition_type_auto_bookmark ->
            <<"auto_bookmark"/utf8>>;

        transition_type_auto_subframe ->
            <<"auto_subframe"/utf8>>;

        transition_type_manual_subframe ->
            <<"manual_subframe"/utf8>>;

        transition_type_generated ->
            <<"generated"/utf8>>;

        transition_type_auto_toplevel ->
            <<"auto_toplevel"/utf8>>;

        transition_type_form_submit ->
            <<"form_submit"/utf8>>;

        transition_type_reload ->
            <<"reload"/utf8>>;

        transition_type_keyword ->
            <<"keyword"/utf8>>;

        transition_type_keyword_generated ->
            <<"keyword_generated"/utf8>>;

        transition_type_other ->
            <<"other"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\page.gleam", 207).
?DOC(false).
-spec decode__transition_type() -> gleam@dynamic@decode:decoder(transition_type()).
decode__transition_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"link"/utf8>> ->
                        gleam@dynamic@decode:success(transition_type_link);

                    <<"typed"/utf8>> ->
                        gleam@dynamic@decode:success(transition_type_typed);

                    <<"address_bar"/utf8>> ->
                        gleam@dynamic@decode:success(
                            transition_type_address_bar
                        );

                    <<"auto_bookmark"/utf8>> ->
                        gleam@dynamic@decode:success(
                            transition_type_auto_bookmark
                        );

                    <<"auto_subframe"/utf8>> ->
                        gleam@dynamic@decode:success(
                            transition_type_auto_subframe
                        );

                    <<"manual_subframe"/utf8>> ->
                        gleam@dynamic@decode:success(
                            transition_type_manual_subframe
                        );

                    <<"generated"/utf8>> ->
                        gleam@dynamic@decode:success(transition_type_generated);

                    <<"auto_toplevel"/utf8>> ->
                        gleam@dynamic@decode:success(
                            transition_type_auto_toplevel
                        );

                    <<"form_submit"/utf8>> ->
                        gleam@dynamic@decode:success(
                            transition_type_form_submit
                        );

                    <<"reload"/utf8>> ->
                        gleam@dynamic@decode:success(transition_type_reload);

                    <<"keyword"/utf8>> ->
                        gleam@dynamic@decode:success(transition_type_keyword);

                    <<"keyword_generated"/utf8>> ->
                        gleam@dynamic@decode:success(
                            transition_type_keyword_generated
                        );

                    <<"other"/utf8>> ->
                        gleam@dynamic@decode:success(transition_type_other);

                    _ ->
                        gleam@dynamic@decode:failure(
                            transition_type_link,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\page.gleam", 246).
?DOC(false).
-spec encode__navigation_entry(navigation_entry()) -> gleam@json:json().
encode__navigation_entry(Value__) ->
    gleam@json:object(
        [{<<"id"/utf8>>, gleam@json:int(erlang:element(2, Value__))},
            {<<"url"/utf8>>, gleam@json:string(erlang:element(3, Value__))},
            {<<"userTypedURL"/utf8>>,
                gleam@json:string(erlang:element(4, Value__))},
            {<<"title"/utf8>>, gleam@json:string(erlang:element(5, Value__))},
            {<<"transitionType"/utf8>>,
                encode__transition_type(erlang:element(6, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 257).
?DOC(false).
-spec decode__navigation_entry() -> gleam@dynamic@decode:decoder(navigation_entry()).
decode__navigation_entry() ->
    begin
        gleam@dynamic@decode:field(
            <<"id"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) ->
                gleam@dynamic@decode:field(
                    <<"url"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Url) ->
                        gleam@dynamic@decode:field(
                            <<"userTypedURL"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(User_typed_url) ->
                                gleam@dynamic@decode:field(
                                    <<"title"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_string/1},
                                    fun(Title) ->
                                        gleam@dynamic@decode:field(
                                            <<"transitionType"/utf8>>,
                                            decode__transition_type(),
                                            fun(Transition_type) ->
                                                gleam@dynamic@decode:success(
                                                    {navigation_entry,
                                                        Id,
                                                        Url,
                                                        User_typed_url,
                                                        Title,
                                                        Transition_type}
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

-file("src\\chrobot_extra\\protocol\\page.gleam", 287).
?DOC(false).
-spec encode__dialog_type(dialog_type()) -> gleam@json:json().
encode__dialog_type(Value__) ->
    _pipe = case Value__ of
        dialog_type_alert ->
            <<"alert"/utf8>>;

        dialog_type_confirm ->
            <<"confirm"/utf8>>;

        dialog_type_prompt ->
            <<"prompt"/utf8>>;

        dialog_type_beforeunload ->
            <<"beforeunload"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\page.gleam", 298).
?DOC(false).
-spec decode__dialog_type() -> gleam@dynamic@decode:decoder(dialog_type()).
decode__dialog_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"alert"/utf8>> ->
                        gleam@dynamic@decode:success(dialog_type_alert);

                    <<"confirm"/utf8>> ->
                        gleam@dynamic@decode:success(dialog_type_confirm);

                    <<"prompt"/utf8>> ->
                        gleam@dynamic@decode:success(dialog_type_prompt);

                    <<"beforeunload"/utf8>> ->
                        gleam@dynamic@decode:success(dialog_type_beforeunload);

                    _ ->
                        gleam@dynamic@decode:failure(
                            dialog_type_alert,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\page.gleam", 326).
?DOC(false).
-spec encode__app_manifest_error(app_manifest_error()) -> gleam@json:json().
encode__app_manifest_error(Value__) ->
    gleam@json:object(
        [{<<"message"/utf8>>, gleam@json:string(erlang:element(2, Value__))},
            {<<"critical"/utf8>>, gleam@json:int(erlang:element(3, Value__))},
            {<<"line"/utf8>>, gleam@json:int(erlang:element(4, Value__))},
            {<<"column"/utf8>>, gleam@json:int(erlang:element(5, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 336).
?DOC(false).
-spec decode__app_manifest_error() -> gleam@dynamic@decode:decoder(app_manifest_error()).
decode__app_manifest_error() ->
    begin
        gleam@dynamic@decode:field(
            <<"message"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Message) ->
                gleam@dynamic@decode:field(
                    <<"critical"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_int/1},
                    fun(Critical) ->
                        gleam@dynamic@decode:field(
                            <<"line"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_int/1},
                            fun(Line) ->
                                gleam@dynamic@decode:field(
                                    <<"column"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_int/1},
                                    fun(Column) ->
                                        gleam@dynamic@decode:success(
                                            {app_manifest_error,
                                                Message,
                                                Critical,
                                                Line,
                                                Column}
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

-file("src\\chrobot_extra\\protocol\\page.gleam", 367).
?DOC(false).
-spec encode__layout_viewport(layout_viewport()) -> gleam@json:json().
encode__layout_viewport(Value__) ->
    gleam@json:object(
        [{<<"pageX"/utf8>>, gleam@json:int(erlang:element(2, Value__))},
            {<<"pageY"/utf8>>, gleam@json:int(erlang:element(3, Value__))},
            {<<"clientWidth"/utf8>>, gleam@json:int(erlang:element(4, Value__))},
            {<<"clientHeight"/utf8>>,
                gleam@json:int(erlang:element(5, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 377).
?DOC(false).
-spec decode__layout_viewport() -> gleam@dynamic@decode:decoder(layout_viewport()).
decode__layout_viewport() ->
    begin
        gleam@dynamic@decode:field(
            <<"pageX"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Page_x) ->
                gleam@dynamic@decode:field(
                    <<"pageY"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_int/1},
                    fun(Page_y) ->
                        gleam@dynamic@decode:field(
                            <<"clientWidth"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_int/1},
                            fun(Client_width) ->
                                gleam@dynamic@decode:field(
                                    <<"clientHeight"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_int/1},
                                    fun(Client_height) ->
                                        gleam@dynamic@decode:success(
                                            {layout_viewport,
                                                Page_x,
                                                Page_y,
                                                Client_width,
                                                Client_height}
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

-file("src\\chrobot_extra\\protocol\\page.gleam", 416).
?DOC(false).
-spec encode__visual_viewport(visual_viewport()) -> gleam@json:json().
encode__visual_viewport(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"offsetX"/utf8>>,
                    gleam@json:float(erlang:element(2, Value__))},
                {<<"offsetY"/utf8>>,
                    gleam@json:float(erlang:element(3, Value__))},
                {<<"pageX"/utf8>>, gleam@json:float(erlang:element(4, Value__))},
                {<<"pageY"/utf8>>, gleam@json:float(erlang:element(5, Value__))},
                {<<"clientWidth"/utf8>>,
                    gleam@json:float(erlang:element(6, Value__))},
                {<<"clientHeight"/utf8>>,
                    gleam@json:float(erlang:element(7, Value__))},
                {<<"scale"/utf8>>, gleam@json:float(erlang:element(8, Value__))}],
            chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(9, Value__),
                fun(Inner_value__) ->
                    {<<"zoom"/utf8>>, gleam@json:float(Inner_value__)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 434).
?DOC(false).
-spec decode__visual_viewport() -> gleam@dynamic@decode:decoder(visual_viewport()).
decode__visual_viewport() ->
    begin
        gleam@dynamic@decode:field(
            <<"offsetX"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_float/1},
            fun(Offset_x) ->
                gleam@dynamic@decode:field(
                    <<"offsetY"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_float/1},
                    fun(Offset_y) ->
                        gleam@dynamic@decode:field(
                            <<"pageX"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_float/1},
                            fun(Page_x) ->
                                gleam@dynamic@decode:field(
                                    <<"pageY"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_float/1},
                                    fun(Page_y) ->
                                        gleam@dynamic@decode:field(
                                            <<"clientWidth"/utf8>>,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_float/1},
                                            fun(Client_width) ->
                                                gleam@dynamic@decode:field(
                                                    <<"clientHeight"/utf8>>,
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_float/1},
                                                    fun(Client_height) ->
                                                        gleam@dynamic@decode:field(
                                                            <<"scale"/utf8>>,
                                                            {decoder,
                                                                fun gleam@dynamic@decode:decode_float/1},
                                                            fun(Scale) ->
                                                                gleam@dynamic@decode:optional_field(
                                                                    <<"zoom"/utf8>>,
                                                                    none,
                                                                    gleam@dynamic@decode:optional(
                                                                        {decoder,
                                                                            fun gleam@dynamic@decode:decode_float/1}
                                                                    ),
                                                                    fun(Zoom) ->
                                                                        gleam@dynamic@decode:success(
                                                                            {visual_viewport,
                                                                                Offset_x,
                                                                                Offset_y,
                                                                                Page_x,
                                                                                Page_y,
                                                                                Client_width,
                                                                                Client_height,
                                                                                Scale,
                                                                                Zoom}
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

-file("src\\chrobot_extra\\protocol\\page.gleam", 479).
?DOC(false).
-spec encode__viewport(viewport()) -> gleam@json:json().
encode__viewport(Value__) ->
    gleam@json:object(
        [{<<"x"/utf8>>, gleam@json:float(erlang:element(2, Value__))},
            {<<"y"/utf8>>, gleam@json:float(erlang:element(3, Value__))},
            {<<"width"/utf8>>, gleam@json:float(erlang:element(4, Value__))},
            {<<"height"/utf8>>, gleam@json:float(erlang:element(5, Value__))},
            {<<"scale"/utf8>>, gleam@json:float(erlang:element(6, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 490).
?DOC(false).
-spec decode__viewport() -> gleam@dynamic@decode:decoder(viewport()).
decode__viewport() ->
    begin
        gleam@dynamic@decode:field(
            <<"x"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_float/1},
            fun(X) ->
                gleam@dynamic@decode:field(
                    <<"y"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_float/1},
                    fun(Y) ->
                        gleam@dynamic@decode:field(
                            <<"width"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_float/1},
                            fun(Width) ->
                                gleam@dynamic@decode:field(
                                    <<"height"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_float/1},
                                    fun(Height) ->
                                        gleam@dynamic@decode:field(
                                            <<"scale"/utf8>>,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_float/1},
                                            fun(Scale) ->
                                                gleam@dynamic@decode:success(
                                                    {viewport,
                                                        X,
                                                        Y,
                                                        Width,
                                                        Height,
                                                        Scale}
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

-file("src\\chrobot_extra\\protocol\\page.gleam", 518).
?DOC(false).
-spec decode__add_script_to_evaluate_on_new_document_response() -> gleam@dynamic@decode:decoder(add_script_to_evaluate_on_new_document_response()).
decode__add_script_to_evaluate_on_new_document_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"identifier"/utf8>>,
            decode__script_identifier(),
            fun(Identifier) ->
                gleam@dynamic@decode:success(
                    {add_script_to_evaluate_on_new_document_response,
                        Identifier}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\page.gleam", 538).
?DOC(false).
-spec decode__capture_screenshot_response() -> gleam@dynamic@decode:decoder(capture_screenshot_response()).
decode__capture_screenshot_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"data"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Data) ->
                gleam@dynamic@decode:success(
                    {capture_screenshot_response, Data}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\page.gleam", 556).
?DOC(false).
-spec decode__create_isolated_world_response() -> gleam@dynamic@decode:decoder(create_isolated_world_response()).
decode__create_isolated_world_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"executionContextId"/utf8>>,
            chrobot_extra@protocol@runtime:decode__execution_context_id(),
            fun(Execution_context_id) ->
                gleam@dynamic@decode:success(
                    {create_isolated_world_response, Execution_context_id}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\page.gleam", 582).
?DOC(false).
-spec decode__get_app_manifest_response() -> gleam@dynamic@decode:decoder(get_app_manifest_response()).
decode__get_app_manifest_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"url"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Url) ->
                gleam@dynamic@decode:field(
                    <<"errors"/utf8>>,
                    gleam@dynamic@decode:list(decode__app_manifest_error()),
                    fun(Errors) ->
                        gleam@dynamic@decode:optional_field(
                            <<"data"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                {decoder,
                                    fun gleam@dynamic@decode:decode_string/1}
                            ),
                            fun(Data) ->
                                gleam@dynamic@decode:success(
                                    {get_app_manifest_response,
                                        Url,
                                        Errors,
                                        Data}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\page.gleam", 609).
?DOC(false).
-spec decode__get_frame_tree_response() -> gleam@dynamic@decode:decoder(get_frame_tree_response()).
decode__get_frame_tree_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"frameTree"/utf8>>,
            decode__frame_tree(),
            fun(Frame_tree) ->
                gleam@dynamic@decode:success(
                    {get_frame_tree_response, Frame_tree}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\page.gleam", 631).
?DOC(false).
-spec decode__get_layout_metrics_response() -> gleam@dynamic@decode:decoder(get_layout_metrics_response()).
decode__get_layout_metrics_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"cssLayoutViewport"/utf8>>,
            decode__layout_viewport(),
            fun(Css_layout_viewport) ->
                gleam@dynamic@decode:field(
                    <<"cssVisualViewport"/utf8>>,
                    decode__visual_viewport(),
                    fun(Css_visual_viewport) ->
                        gleam@dynamic@decode:field(
                            <<"cssContentSize"/utf8>>,
                            chrobot_extra@protocol@dom:decode__rect(),
                            fun(Css_content_size) ->
                                gleam@dynamic@decode:success(
                                    {get_layout_metrics_response,
                                        Css_layout_viewport,
                                        Css_visual_viewport,
                                        Css_content_size}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\page.gleam", 663).
?DOC(false).
-spec decode__get_navigation_history_response() -> gleam@dynamic@decode:decoder(get_navigation_history_response()).
decode__get_navigation_history_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"currentIndex"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Current_index) ->
                gleam@dynamic@decode:field(
                    <<"entries"/utf8>>,
                    gleam@dynamic@decode:list(decode__navigation_entry()),
                    fun(Entries) ->
                        gleam@dynamic@decode:success(
                            {get_navigation_history_response,
                                Current_index,
                                Entries}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\page.gleam", 693).
?DOC(false).
-spec decode__navigate_response() -> gleam@dynamic@decode:decoder(navigate_response()).
decode__navigate_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"frameId"/utf8>>,
            decode__frame_id(),
            fun(Frame_id) ->
                gleam@dynamic@decode:optional_field(
                    <<"loaderId"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(
                        chrobot_extra@protocol@network:decode__loader_id()
                    ),
                    fun(Loader_id) ->
                        gleam@dynamic@decode:optional_field(
                            <<"errorText"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                {decoder,
                                    fun gleam@dynamic@decode:decode_string/1}
                            ),
                            fun(Error_text) ->
                                gleam@dynamic@decode:success(
                                    {navigate_response,
                                        Frame_id,
                                        Loader_id,
                                        Error_text}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\page.gleam", 725).
?DOC(false).
-spec decode__print_to_pdf_response() -> gleam@dynamic@decode:decoder(print_to_pdf_response()).
decode__print_to_pdf_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"data"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Data) ->
                gleam@dynamic@decode:success({print_to_pdf_response, Data})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\page.gleam", 741).
?DOC(
    " Evaluates given script in every frame upon creation (before loading frame's scripts).\n"
    " \n"
    " Parameters:  \n"
    "  - `source`\n"
    " \n"
    " Returns:  \n"
    "  - `identifier` : Identifier of the added script.\n"
).
-spec add_script_to_evaluate_on_new_document(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    binary()
) -> {ok, add_script_to_evaluate_on_new_document_response()} |
    {error, chrobot_extra@chrome:request_error()}.
add_script_to_evaluate_on_new_document(Callback__, Source) ->
    gleam@result:'try'(
        Callback__(
            <<"Page.addScriptToEvaluateOnNewDocument"/utf8>>,
            {some,
                gleam@json:object(
                    [{<<"source"/utf8>>, gleam@json:string(Source)}]
                )}
        ),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__add_script_to_evaluate_on_new_document_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 760).
?DOC(" Brings page to front (activates tab).\n").
-spec bring_to_front(fun((binary(), gleam@option:option(any())) -> REA)) -> REA.
bring_to_front(Callback__) ->
    Callback__(<<"Page.bringToFront"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\page.gleam", 809).
?DOC(false).
-spec encode__capture_screenshot_format(capture_screenshot_format()) -> gleam@json:json().
encode__capture_screenshot_format(Value__) ->
    _pipe = case Value__ of
        capture_screenshot_format_jpeg ->
            <<"jpeg"/utf8>>;

        capture_screenshot_format_png ->
            <<"png"/utf8>>;

        capture_screenshot_format_webp ->
            <<"webp"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\page.gleam", 774).
?DOC(
    " Capture page screenshot.\n"
    " \n"
    " Parameters:  \n"
    "  - `format` : Image compression format (defaults to png).\n"
    "  - `quality` : Compression quality from range [0..100] (jpeg only).\n"
    "  - `clip` : Capture the screenshot of a given region only.\n"
    " \n"
    " Returns:  \n"
    "  - `data` : Base64-encoded image data. (Encoded as a base64 string when passed over JSON)\n"
).
-spec capture_screenshot(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    gleam@option:option(capture_screenshot_format()),
    gleam@option:option(integer()),
    gleam@option:option(viewport())
) -> {ok, capture_screenshot_response()} |
    {error, chrobot_extra@chrome:request_error()}.
capture_screenshot(Callback__, Format, Quality, Clip) ->
    gleam@result:'try'(
        Callback__(
            <<"Page.captureScreenshot"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Format,
                            fun(Inner_value__) ->
                                {<<"format"/utf8>>,
                                    encode__capture_screenshot_format(
                                        Inner_value__
                                    )}
                            end
                        ),
                        _pipe@2 = chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Quality,
                            fun(Inner_value__@1) ->
                                {<<"quality"/utf8>>,
                                    gleam@json:int(Inner_value__@1)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@2,
                            Clip,
                            fun(Inner_value__@2) ->
                                {<<"clip"/utf8>>,
                                    encode__viewport(Inner_value__@2)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@3 = gleam@dynamic@decode:run(
                Result__,
                decode__capture_screenshot_response()
            ),
            gleam@result:replace_error(_pipe@3, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 819).
?DOC(false).
-spec decode__capture_screenshot_format() -> gleam@dynamic@decode:decoder(capture_screenshot_format()).
decode__capture_screenshot_format() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"jpeg"/utf8>> ->
                        gleam@dynamic@decode:success(
                            capture_screenshot_format_jpeg
                        );

                    <<"png"/utf8>> ->
                        gleam@dynamic@decode:success(
                            capture_screenshot_format_png
                        );

                    <<"webp"/utf8>> ->
                        gleam@dynamic@decode:success(
                            capture_screenshot_format_webp
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            capture_screenshot_format_jpeg,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\page.gleam", 842).
?DOC(
    " Creates an isolated world for the given frame.\n"
    " \n"
    " Parameters:  \n"
    "  - `frame_id` : Id of the frame in which the isolated world should be created.\n"
    "  - `world_name` : An optional name which is reported in the Execution Context.\n"
    "  - `grant_univeral_access` : Whether or not universal access should be granted to the isolated world. This is a powerful\n"
    " option, use with caution.\n"
    " \n"
    " Returns:  \n"
    "  - `execution_context_id` : Execution context of the isolated world.\n"
).
-spec create_isolated_world(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    frame_id(),
    gleam@option:option(binary()),
    gleam@option:option(boolean())
) -> {ok, create_isolated_world_response()} |
    {error, chrobot_extra@chrome:request_error()}.
create_isolated_world(Callback__, Frame_id, World_name, Grant_univeral_access) ->
    gleam@result:'try'(
        Callback__(
            <<"Page.createIsolatedWorld"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"frameId"/utf8>>,
                                encode__frame_id(Frame_id)}],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            World_name,
                            fun(Inner_value__) ->
                                {<<"worldName"/utf8>>,
                                    gleam@json:string(Inner_value__)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Grant_univeral_access,
                            fun(Inner_value__@1) ->
                                {<<"grantUniveralAccess"/utf8>>,
                                    gleam@json:bool(Inner_value__@1)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@2 = gleam@dynamic@decode:run(
                Result__,
                decode__create_isolated_world_response()
            ),
            gleam@result:replace_error(_pipe@2, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 869).
?DOC(" Disables page domain notifications.\n").
-spec disable(fun((binary(), gleam@option:option(any())) -> RFX)) -> RFX.
disable(Callback__) ->
    Callback__(<<"Page.disable"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\page.gleam", 875).
?DOC(" Enables page domain notifications.\n").
-spec enable(fun((binary(), gleam@option:option(any())) -> RGB)) -> RGB.
enable(Callback__) ->
    Callback__(<<"Page.enable"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\page.gleam", 893).
?DOC(
    " Gets the processed manifest for this current document.\n"
    "   This API always waits for the manifest to be loaded.\n"
    "   If manifestId is provided, and it does not match the manifest of the\n"
    "     current document, this API errors out.\n"
    "   If there is not a loaded page, this API errors out immediately.\n"
    " \n"
    " Parameters:  \n"
    "  - `manifest_id`\n"
    " \n"
    " Returns:  \n"
    "  - `url` : Manifest location.\n"
    "  - `errors`\n"
    "  - `data` : Manifest content.\n"
).
-spec get_app_manifest(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    gleam@option:option(binary())
) -> {ok, get_app_manifest_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_app_manifest(Callback__, Manifest_id) ->
    gleam@result:'try'(
        Callback__(
            <<"Page.getAppManifest"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [],
                        chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Manifest_id,
                            fun(Inner_value__) ->
                                {<<"manifestId"/utf8>>,
                                    gleam@json:string(Inner_value__)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@1 = gleam@dynamic@decode:run(
                Result__,
                decode__get_app_manifest_response()
            ),
            gleam@result:replace_error(_pipe@1, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 914).
?DOC(
    " Returns present frame tree structure.\n"
    "  - `frame_tree` : Present frame tree structure.\n"
).
-spec get_frame_tree(
    fun((binary(), gleam@option:option(any())) -> {ok, gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()})
) -> {ok, get_frame_tree_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_frame_tree(Callback__) ->
    gleam@result:'try'(
        Callback__(<<"Page.getFrameTree"/utf8>>, none),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__get_frame_tree_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 926).
?DOC(
    " Returns metrics relating to the layouting of the page, such as viewport bounds/scale.\n"
    "  - `css_layout_viewport` : Metrics relating to the layout viewport in CSS pixels.\n"
    "  - `css_visual_viewport` : Metrics relating to the visual viewport in CSS pixels.\n"
    "  - `css_content_size` : Size of scrollable area in CSS pixels.\n"
).
-spec get_layout_metrics(
    fun((binary(), gleam@option:option(any())) -> {ok, gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()})
) -> {ok, get_layout_metrics_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_layout_metrics(Callback__) ->
    gleam@result:'try'(
        Callback__(<<"Page.getLayoutMetrics"/utf8>>, none),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__get_layout_metrics_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 937).
?DOC(
    " Returns navigation history for the current page.\n"
    "  - `current_index` : Index of the current navigation history entry.\n"
    "  - `entries` : Array of navigation history entries.\n"
).
-spec get_navigation_history(
    fun((binary(), gleam@option:option(any())) -> {ok, gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()})
) -> {ok, get_navigation_history_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_navigation_history(Callback__) ->
    gleam@result:'try'(
        Callback__(<<"Page.getNavigationHistory"/utf8>>, none),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__get_navigation_history_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 949).
?DOC(" Resets navigation history for the current page.\n").
-spec reset_navigation_history(
    fun((binary(), gleam@option:option(any())) -> RIE)
) -> RIE.
reset_navigation_history(Callback__) ->
    Callback__(<<"Page.resetNavigationHistory"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\page.gleam", 962).
?DOC(
    " Accepts or dismisses a JavaScript initiated dialog (alert, confirm, prompt, or onbeforeunload).\n"
    " \n"
    " Parameters:  \n"
    "  - `accept` : Whether to accept or dismiss the dialog.\n"
    "  - `prompt_text` : The text to enter into the dialog prompt before accepting. Used only if this is a prompt\n"
    " dialog.\n"
    " \n"
    " Returns:\n"
).
-spec handle_java_script_dialog(
    fun((binary(), gleam@option:option(gleam@json:json())) -> RII),
    boolean(),
    gleam@option:option(binary())
) -> RII.
handle_java_script_dialog(Callback__, Accept, Prompt_text) ->
    Callback__(
        <<"Page.handleJavaScriptDialog"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [{<<"accept"/utf8>>, gleam@json:bool(Accept)}],
                    chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Prompt_text,
                        fun(Inner_value__) ->
                            {<<"promptText"/utf8>>,
                                gleam@json:string(Inner_value__)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 994).
?DOC(
    " Navigates current page to the given URL.\n"
    " \n"
    " Parameters:  \n"
    "  - `url` : URL to navigate the page to.\n"
    "  - `referrer` : Referrer URL.\n"
    "  - `transition_type` : Intended transition type.\n"
    "  - `frame_id` : Frame id to navigate, if not specified navigates the top frame.\n"
    " \n"
    " Returns:  \n"
    "  - `frame_id` : Frame id that has navigated (or failed to navigate)\n"
    "  - `loader_id` : Loader identifier. This is omitted in case of same-document navigation,\n"
    " as the previously committed loaderId would not change.\n"
    "  - `error_text` : User friendly error message, present if and only if navigation has failed.\n"
).
-spec navigate(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    binary(),
    gleam@option:option(binary()),
    gleam@option:option(transition_type()),
    gleam@option:option(frame_id())
) -> {ok, navigate_response()} | {error, chrobot_extra@chrome:request_error()}.
navigate(Callback__, Url, Referrer, Transition_type, Frame_id) ->
    gleam@result:'try'(
        Callback__(
            <<"Page.navigate"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"url"/utf8>>, gleam@json:string(Url)}],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Referrer,
                            fun(Inner_value__) ->
                                {<<"referrer"/utf8>>,
                                    gleam@json:string(Inner_value__)}
                            end
                        ),
                        _pipe@2 = chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Transition_type,
                            fun(Inner_value__@1) ->
                                {<<"transitionType"/utf8>>,
                                    encode__transition_type(Inner_value__@1)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@2,
                            Frame_id,
                            fun(Inner_value__@2) ->
                                {<<"frameId"/utf8>>,
                                    encode__frame_id(Inner_value__@2)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@3 = gleam@dynamic@decode:run(
                Result__,
                decode__navigate_response()
            ),
            gleam@result:replace_error(_pipe@3, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 1030).
?DOC(
    " Navigates current page to the given history entry.\n"
    " \n"
    " Parameters:  \n"
    "  - `entry_id` : Unique id of the entry to navigate to.\n"
    " \n"
    " Returns:\n"
).
-spec navigate_to_history_entry(
    fun((binary(), gleam@option:option(gleam@json:json())) -> RJI),
    integer()
) -> RJI.
navigate_to_history_entry(Callback__, Entry_id) ->
    Callback__(
        <<"Page.navigateToHistoryEntry"/utf8>>,
        {some,
            gleam@json:object([{<<"entryId"/utf8>>, gleam@json:int(Entry_id)}])}
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 1078).
?DOC(
    " Print page as PDF.\n"
    " \n"
    " Parameters:  \n"
    "  - `landscape` : Paper orientation. Defaults to false.\n"
    "  - `display_header_footer` : Display header and footer. Defaults to false.\n"
    "  - `print_background` : Print background graphics. Defaults to false.\n"
    "  - `scale` : Scale of the webpage rendering. Defaults to 1.\n"
    "  - `paper_width` : Paper width in inches. Defaults to 8.5 inches.\n"
    "  - `paper_height` : Paper height in inches. Defaults to 11 inches.\n"
    "  - `margin_top` : Top margin in inches. Defaults to 1cm (~0.4 inches).\n"
    "  - `margin_bottom` : Bottom margin in inches. Defaults to 1cm (~0.4 inches).\n"
    "  - `margin_left` : Left margin in inches. Defaults to 1cm (~0.4 inches).\n"
    "  - `margin_right` : Right margin in inches. Defaults to 1cm (~0.4 inches).\n"
    "  - `page_ranges` : Paper ranges to print, one based, e.g., '1-5, 8, 11-13'. Pages are\n"
    " printed in the document order, not in the order specified, and no\n"
    " more than once.\n"
    " Defaults to empty string, which implies the entire document is printed.\n"
    " The page numbers are quietly capped to actual page count of the\n"
    " document, and ranges beyond the end of the document are ignored.\n"
    " If this results in no pages to print, an error is reported.\n"
    " It is an error to specify a range with start greater than end.\n"
    "  - `header_template` : HTML template for the print header. Should be valid HTML markup with following\n"
    " classes used to inject printing values into them:\n"
    " - `date`: formatted print date\n"
    " - `title`: document title\n"
    " - `url`: document location\n"
    " - `pageNumber`: current page number\n"
    " - `totalPages`: total pages in the document\n"
    " \n"
    " For example, `<span class=title></span>` would generate span containing the title.\n"
    "  - `footer_template` : HTML template for the print footer. Should use the same format as the `headerTemplate`.\n"
    "  - `prefer_css_page_size` : Whether or not to prefer page size as defined by css. Defaults to false,\n"
    " in which case the content will be scaled to fit the paper size.\n"
    " \n"
    " Returns:  \n"
    "  - `data` : Base64-encoded pdf data. Empty if |returnAsStream| is specified. (Encoded as a base64 string when passed over JSON)\n"
).
-spec print_to_pdf(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    gleam@option:option(boolean()),
    gleam@option:option(boolean()),
    gleam@option:option(boolean()),
    gleam@option:option(float()),
    gleam@option:option(float()),
    gleam@option:option(float()),
    gleam@option:option(float()),
    gleam@option:option(float()),
    gleam@option:option(float()),
    gleam@option:option(float()),
    gleam@option:option(binary()),
    gleam@option:option(binary()),
    gleam@option:option(binary()),
    gleam@option:option(boolean())
) -> {ok, print_to_pdf_response()} |
    {error, chrobot_extra@chrome:request_error()}.
print_to_pdf(
    Callback__,
    Landscape,
    Display_header_footer,
    Print_background,
    Scale,
    Paper_width,
    Paper_height,
    Margin_top,
    Margin_bottom,
    Margin_left,
    Margin_right,
    Page_ranges,
    Header_template,
    Footer_template,
    Prefer_css_page_size
) ->
    gleam@result:'try'(
        Callback__(
            <<"Page.printToPDF"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Landscape,
                            fun(Inner_value__) ->
                                {<<"landscape"/utf8>>,
                                    gleam@json:bool(Inner_value__)}
                            end
                        ),
                        _pipe@2 = chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Display_header_footer,
                            fun(Inner_value__@1) ->
                                {<<"displayHeaderFooter"/utf8>>,
                                    gleam@json:bool(Inner_value__@1)}
                            end
                        ),
                        _pipe@3 = chrobot_extra@internal@utils:add_optional(
                            _pipe@2,
                            Print_background,
                            fun(Inner_value__@2) ->
                                {<<"printBackground"/utf8>>,
                                    gleam@json:bool(Inner_value__@2)}
                            end
                        ),
                        _pipe@4 = chrobot_extra@internal@utils:add_optional(
                            _pipe@3,
                            Scale,
                            fun(Inner_value__@3) ->
                                {<<"scale"/utf8>>,
                                    gleam@json:float(Inner_value__@3)}
                            end
                        ),
                        _pipe@5 = chrobot_extra@internal@utils:add_optional(
                            _pipe@4,
                            Paper_width,
                            fun(Inner_value__@4) ->
                                {<<"paperWidth"/utf8>>,
                                    gleam@json:float(Inner_value__@4)}
                            end
                        ),
                        _pipe@6 = chrobot_extra@internal@utils:add_optional(
                            _pipe@5,
                            Paper_height,
                            fun(Inner_value__@5) ->
                                {<<"paperHeight"/utf8>>,
                                    gleam@json:float(Inner_value__@5)}
                            end
                        ),
                        _pipe@7 = chrobot_extra@internal@utils:add_optional(
                            _pipe@6,
                            Margin_top,
                            fun(Inner_value__@6) ->
                                {<<"marginTop"/utf8>>,
                                    gleam@json:float(Inner_value__@6)}
                            end
                        ),
                        _pipe@8 = chrobot_extra@internal@utils:add_optional(
                            _pipe@7,
                            Margin_bottom,
                            fun(Inner_value__@7) ->
                                {<<"marginBottom"/utf8>>,
                                    gleam@json:float(Inner_value__@7)}
                            end
                        ),
                        _pipe@9 = chrobot_extra@internal@utils:add_optional(
                            _pipe@8,
                            Margin_left,
                            fun(Inner_value__@8) ->
                                {<<"marginLeft"/utf8>>,
                                    gleam@json:float(Inner_value__@8)}
                            end
                        ),
                        _pipe@10 = chrobot_extra@internal@utils:add_optional(
                            _pipe@9,
                            Margin_right,
                            fun(Inner_value__@9) ->
                                {<<"marginRight"/utf8>>,
                                    gleam@json:float(Inner_value__@9)}
                            end
                        ),
                        _pipe@11 = chrobot_extra@internal@utils:add_optional(
                            _pipe@10,
                            Page_ranges,
                            fun(Inner_value__@10) ->
                                {<<"pageRanges"/utf8>>,
                                    gleam@json:string(Inner_value__@10)}
                            end
                        ),
                        _pipe@12 = chrobot_extra@internal@utils:add_optional(
                            _pipe@11,
                            Header_template,
                            fun(Inner_value__@11) ->
                                {<<"headerTemplate"/utf8>>,
                                    gleam@json:string(Inner_value__@11)}
                            end
                        ),
                        _pipe@13 = chrobot_extra@internal@utils:add_optional(
                            _pipe@12,
                            Footer_template,
                            fun(Inner_value__@12) ->
                                {<<"footerTemplate"/utf8>>,
                                    gleam@json:string(Inner_value__@12)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@13,
                            Prefer_css_page_size,
                            fun(Inner_value__@13) ->
                                {<<"preferCSSPageSize"/utf8>>,
                                    gleam@json:bool(Inner_value__@13)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@14 = gleam@dynamic@decode:run(
                Result__,
                decode__print_to_pdf_response()
            ),
            gleam@result:replace_error(_pipe@14, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 1157).
?DOC(
    " Reloads given page optionally ignoring the cache.\n"
    " \n"
    " Parameters:  \n"
    "  - `ignore_cache` : If true, browser cache is ignored (as if the user pressed Shift+refresh).\n"
    "  - `script_to_evaluate_on_load` : If set, the script will be injected into all frames of the inspected page after reload.\n"
    " Argument will be ignored if reloading dataURL origin.\n"
    " \n"
    " Returns:\n"
).
-spec reload(
    fun((binary(), gleam@option:option(gleam@json:json())) -> RLC),
    gleam@option:option(boolean()),
    gleam@option:option(binary())
) -> RLC.
reload(Callback__, Ignore_cache, Script_to_evaluate_on_load) ->
    Callback__(
        <<"Page.reload"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [],
                    _pipe@1 = chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Ignore_cache,
                        fun(Inner_value__) ->
                            {<<"ignoreCache"/utf8>>,
                                gleam@json:bool(Inner_value__)}
                        end
                    ),
                    chrobot_extra@internal@utils:add_optional(
                        _pipe@1,
                        Script_to_evaluate_on_load,
                        fun(Inner_value__@1) ->
                            {<<"scriptToEvaluateOnLoad"/utf8>>,
                                gleam@json:string(Inner_value__@1)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 1183).
?DOC(
    " Removes given script from the list.\n"
    " \n"
    " Parameters:  \n"
    "  - `identifier`\n"
    " \n"
    " Returns:\n"
).
-spec remove_script_to_evaluate_on_new_document(
    fun((binary(), gleam@option:option(gleam@json:json())) -> RLL),
    script_identifier()
) -> RLL.
remove_script_to_evaluate_on_new_document(Callback__, Identifier) ->
    Callback__(
        <<"Page.removeScriptToEvaluateOnNewDocument"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"identifier"/utf8>>, encode__script_identifier(Identifier)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 1204).
?DOC(
    " Enable page Content Security Policy by-passing.\n"
    " \n"
    " Parameters:  \n"
    "  - `enabled` : Whether to bypass page CSP.\n"
    " \n"
    " Returns:\n"
).
-spec set_bypass_csp(
    fun((binary(), gleam@option:option(gleam@json:json())) -> RLQ),
    boolean()
) -> RLQ.
set_bypass_csp(Callback__, Enabled) ->
    Callback__(
        <<"Page.setBypassCSP"/utf8>>,
        {some,
            gleam@json:object([{<<"enabled"/utf8>>, gleam@json:bool(Enabled)}])}
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 1223).
?DOC(
    " Sets given markup as the document's HTML.\n"
    " \n"
    " Parameters:  \n"
    "  - `frame_id` : Frame id to set HTML for.\n"
    "  - `html` : HTML content to set.\n"
    " \n"
    " Returns:\n"
).
-spec set_document_content(
    fun((binary(), gleam@option:option(gleam@json:json())) -> RLV),
    frame_id(),
    binary()
) -> RLV.
set_document_content(Callback__, Frame_id, Html) ->
    Callback__(
        <<"Page.setDocumentContent"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"frameId"/utf8>>, encode__frame_id(Frame_id)},
                    {<<"html"/utf8>>, gleam@json:string(Html)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 1246).
?DOC(
    " Controls whether page will emit lifecycle events.\n"
    " \n"
    " Parameters:  \n"
    "  - `enabled` : If true, starts emitting lifecycle events.\n"
    " \n"
    " Returns:\n"
).
-spec set_lifecycle_events_enabled(
    fun((binary(), gleam@option:option(gleam@json:json())) -> RMA),
    boolean()
) -> RMA.
set_lifecycle_events_enabled(Callback__, Enabled) ->
    Callback__(
        <<"Page.setLifecycleEventsEnabled"/utf8>>,
        {some,
            gleam@json:object([{<<"enabled"/utf8>>, gleam@json:bool(Enabled)}])}
    ).

-file("src\\chrobot_extra\\protocol\\page.gleam", 1259).
?DOC(" Force the page stop all navigations and pending resource fetches.\n").
-spec stop_loading(fun((binary(), gleam@option:option(any())) -> RMF)) -> RMF.
stop_loading(Callback__) ->
    Callback__(<<"Page.stopLoading"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\page.gleam", 1265).
?DOC(" Tries to close page, running its beforeunload hooks, if any.\n").
-spec close(fun((binary(), gleam@option:option(any())) -> RMJ)) -> RMJ.
close(Callback__) ->
    Callback__(<<"Page.close"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\page.gleam", 1278).
?DOC(
    " Intercept file chooser requests and transfer control to protocol clients.\n"
    " When file chooser interception is enabled, native file chooser dialog is not shown.\n"
    " Instead, a protocol event `Page.fileChooserOpened` is emitted.\n"
    " \n"
    " Parameters:  \n"
    "  - `enabled`\n"
    " \n"
    " Returns:\n"
).
-spec set_intercept_file_chooser_dialog(
    fun((binary(), gleam@option:option(gleam@json:json())) -> RMN),
    boolean()
) -> RMN.
set_intercept_file_chooser_dialog(Callback__, Enabled) ->
    Callback__(
        <<"Page.setInterceptFileChooserDialog"/utf8>>,
        {some,
            gleam@json:object([{<<"enabled"/utf8>>, gleam@json:bool(Enabled)}])}
    ).
