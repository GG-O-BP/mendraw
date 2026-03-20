-module(chrobot_extra@protocol@dom).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\protocol\\dom.gleam").
-export([encode__node_id/1, decode__node_id/0, encode__backend_node_id/1, decode__backend_node_id/0, encode__backend_node/1, decode__backend_node/0, encode__pseudo_type/1, decode__pseudo_type/0, encode__shadow_root_type/1, decode__shadow_root_type/0, encode__compatibility_mode/1, decode__compatibility_mode/0, encode__physical_axes/1, decode__physical_axes/0, encode__logical_axes/1, decode__logical_axes/0, encode__scroll_orientation/1, decode__scroll_orientation/0, encode__node/1, decode__node/0, encode__rgba/1, decode__rgba/0, encode__quad/1, decode__quad/0, encode__shape_outside_info/1, encode__box_model/1, decode__shape_outside_info/0, decode__box_model/0, encode__rect/1, decode__rect/0, encode__css_computed_style_property/1, decode__css_computed_style_property/0, decode__describe_node_response/0, decode__get_attributes_response/0, decode__get_box_model_response/0, decode__get_document_response/0, decode__get_node_for_location_response/0, decode__get_outer_html_response/0, decode__move_to_response/0, decode__query_selector_response/0, decode__query_selector_all_response/0, decode__request_node_response/0, decode__resolve_node_response/0, decode__set_node_name_response/0, describe_node/6, scroll_into_view_if_needed/5, disable/1, enable/1, focus/4, get_attributes/2, get_box_model/4, get_document/3, get_node_for_location/5, get_outer_html/4, hide_highlight/1, highlight_node/1, highlight_rect/1, move_to/4, query_selector/3, query_selector_all/3, remove_attribute/3, remove_node/2, request_child_nodes/4, request_node/2, resolve_node/5, set_attribute_value/4, set_attributes_as_text/4, set_file_input_files/5, set_node_name/3, set_node_value/3, set_outer_html/3]).
-export_type([node_id/0, backend_node_id/0, backend_node/0, pseudo_type/0, shadow_root_type/0, compatibility_mode/0, physical_axes/0, logical_axes/0, scroll_orientation/0, node_/0, r_g_b_a/0, quad/0, box_model/0, shape_outside_info/0, rect/0, c_s_s_computed_style_property/0, describe_node_response/0, get_attributes_response/0, get_box_model_response/0, get_document_response/0, get_node_for_location_response/0, get_outer_html_response/0, move_to_response/0, query_selector_response/0, query_selector_all_response/0, request_node_response/0, resolve_node_response/0, set_node_name_response/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " > ⚙️  This module was generated from the Chrome DevTools Protocol version **1.3**\n"
    " ## DOM Domain  \n"
    "\n"
    " This domain exposes DOM read/write operations. Each DOM Node is represented with its mirror object\n"
    " that has an `id`. This `id` can be used to get additional information on the Node, resolve it into\n"
    " the JavaScript object wrapper, etc. It is important that client receives DOM events only for the\n"
    " nodes that are known to the client. Backend keeps track of the nodes that were sent to the client\n"
    " and never sends the same node twice. It is client's responsibility to collect information about\n"
    " the nodes that were sent to the client. Note that `iframe` owner elements will return\n"
    " corresponding document elements as their child nodes.  \n"
    "\n"
    " [📖   View this domain on the DevTools Protocol API Docs](https://chromedevtools.github.io/devtools-protocol/1-3/DOM/)\n"
).

-type node_id() :: {node_id, integer()}.

-type backend_node_id() :: {backend_node_id, integer()}.

-type backend_node() :: {backend_node, integer(), binary(), backend_node_id()}.

-type pseudo_type() :: pseudo_type_first_line |
    pseudo_type_first_letter |
    pseudo_type_before |
    pseudo_type_after |
    pseudo_type_marker |
    pseudo_type_backdrop |
    pseudo_type_selection |
    pseudo_type_target_text |
    pseudo_type_spelling_error |
    pseudo_type_grammar_error |
    pseudo_type_highlight |
    pseudo_type_first_line_inherited |
    pseudo_type_scroll_marker |
    pseudo_type_scroll_markers |
    pseudo_type_scrollbar |
    pseudo_type_scrollbar_thumb |
    pseudo_type_scrollbar_button |
    pseudo_type_scrollbar_track |
    pseudo_type_scrollbar_track_piece |
    pseudo_type_scrollbar_corner |
    pseudo_type_resizer |
    pseudo_type_input_list_button |
    pseudo_type_view_transition |
    pseudo_type_view_transition_group |
    pseudo_type_view_transition_image_pair |
    pseudo_type_view_transition_old |
    pseudo_type_view_transition_new.

-type shadow_root_type() :: shadow_root_type_user_agent |
    shadow_root_type_open |
    shadow_root_type_closed.

-type compatibility_mode() :: compatibility_mode_quirks_mode |
    compatibility_mode_limited_quirks_mode |
    compatibility_mode_no_quirks_mode.

-type physical_axes() :: physical_axes_horizontal |
    physical_axes_vertical |
    physical_axes_both.

-type logical_axes() :: logical_axes_inline |
    logical_axes_block |
    logical_axes_both.

-type scroll_orientation() :: scroll_orientation_horizontal |
    scroll_orientation_vertical.

-type node_() :: {node,
        node_id(),
        gleam@option:option(node_id()),
        backend_node_id(),
        integer(),
        binary(),
        binary(),
        binary(),
        gleam@option:option(integer()),
        gleam@option:option(list(node_())),
        gleam@option:option(list(binary())),
        gleam@option:option(binary()),
        gleam@option:option(binary()),
        gleam@option:option(binary()),
        gleam@option:option(binary()),
        gleam@option:option(binary()),
        gleam@option:option(binary()),
        gleam@option:option(binary()),
        gleam@option:option(binary()),
        gleam@option:option(pseudo_type()),
        gleam@option:option(binary()),
        gleam@option:option(shadow_root_type()),
        gleam@option:option(binary()),
        gleam@option:option(node_()),
        gleam@option:option(list(node_())),
        gleam@option:option(node_()),
        gleam@option:option(list(node_())),
        gleam@option:option(list(backend_node())),
        gleam@option:option(boolean()),
        gleam@option:option(compatibility_mode()),
        gleam@option:option(backend_node())}.

-type r_g_b_a() :: {r_g_b_a,
        integer(),
        integer(),
        integer(),
        gleam@option:option(float())}.

-type quad() :: {quad, list(float())}.

-type box_model() :: {box_model,
        quad(),
        quad(),
        quad(),
        quad(),
        integer(),
        integer(),
        gleam@option:option(shape_outside_info())}.

-type shape_outside_info() :: {shape_outside_info,
        quad(),
        list(gleam@dynamic:dynamic_()),
        list(gleam@dynamic:dynamic_())}.

-type rect() :: {rect, float(), float(), float(), float()}.

-type c_s_s_computed_style_property() :: {c_s_s_computed_style_property,
        binary(),
        binary()}.

-type describe_node_response() :: {describe_node_response, node_()}.

-type get_attributes_response() :: {get_attributes_response, list(binary())}.

-type get_box_model_response() :: {get_box_model_response, box_model()}.

-type get_document_response() :: {get_document_response, node_()}.

-type get_node_for_location_response() :: {get_node_for_location_response,
        backend_node_id(),
        binary(),
        gleam@option:option(node_id())}.

-type get_outer_html_response() :: {get_outer_html_response, binary()}.

-type move_to_response() :: {move_to_response, node_id()}.

-type query_selector_response() :: {query_selector_response, node_id()}.

-type query_selector_all_response() :: {query_selector_all_response,
        list(node_id())}.

-type request_node_response() :: {request_node_response, node_id()}.

-type resolve_node_response() :: {resolve_node_response,
        chrobot_extra@protocol@runtime:remote_object()}.

-type set_node_name_response() :: {set_node_name_response, node_id()}.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 34).
?DOC(false).
-spec encode__node_id(node_id()) -> gleam@json:json().
encode__node_id(Value__) ->
    case Value__ of
        {node_id, Inner_value__} ->
            gleam@json:int(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 41).
?DOC(false).
-spec decode__node_id() -> gleam@dynamic@decode:decoder(node_id()).
decode__node_id() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Value__) -> gleam@dynamic@decode:success({node_id, Value__}) end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 55).
?DOC(false).
-spec encode__backend_node_id(backend_node_id()) -> gleam@json:json().
encode__backend_node_id(Value__) ->
    case Value__ of
        {backend_node_id, Inner_value__} ->
            gleam@json:int(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 62).
?DOC(false).
-spec decode__backend_node_id() -> gleam@dynamic@decode:decoder(backend_node_id()).
decode__backend_node_id() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({backend_node_id, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 81).
?DOC(false).
-spec encode__backend_node(backend_node()) -> gleam@json:json().
encode__backend_node(Value__) ->
    gleam@json:object(
        [{<<"nodeType"/utf8>>, gleam@json:int(erlang:element(2, Value__))},
            {<<"nodeName"/utf8>>, gleam@json:string(erlang:element(3, Value__))},
            {<<"backendNodeId"/utf8>>,
                encode__backend_node_id(erlang:element(4, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 90).
?DOC(false).
-spec decode__backend_node() -> gleam@dynamic@decode:decoder(backend_node()).
decode__backend_node() ->
    begin
        gleam@dynamic@decode:field(
            <<"nodeType"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Node_type) ->
                gleam@dynamic@decode:field(
                    <<"nodeName"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Node_name) ->
                        gleam@dynamic@decode:field(
                            <<"backendNodeId"/utf8>>,
                            decode__backend_node_id(),
                            fun(Backend_node_id) ->
                                gleam@dynamic@decode:success(
                                    {backend_node,
                                        Node_type,
                                        Node_name,
                                        Backend_node_id}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 139).
?DOC(false).
-spec encode__pseudo_type(pseudo_type()) -> gleam@json:json().
encode__pseudo_type(Value__) ->
    _pipe = case Value__ of
        pseudo_type_first_line ->
            <<"first-line"/utf8>>;

        pseudo_type_first_letter ->
            <<"first-letter"/utf8>>;

        pseudo_type_before ->
            <<"before"/utf8>>;

        pseudo_type_after ->
            <<"after"/utf8>>;

        pseudo_type_marker ->
            <<"marker"/utf8>>;

        pseudo_type_backdrop ->
            <<"backdrop"/utf8>>;

        pseudo_type_selection ->
            <<"selection"/utf8>>;

        pseudo_type_target_text ->
            <<"target-text"/utf8>>;

        pseudo_type_spelling_error ->
            <<"spelling-error"/utf8>>;

        pseudo_type_grammar_error ->
            <<"grammar-error"/utf8>>;

        pseudo_type_highlight ->
            <<"highlight"/utf8>>;

        pseudo_type_first_line_inherited ->
            <<"first-line-inherited"/utf8>>;

        pseudo_type_scroll_marker ->
            <<"scroll-marker"/utf8>>;

        pseudo_type_scroll_markers ->
            <<"scroll-markers"/utf8>>;

        pseudo_type_scrollbar ->
            <<"scrollbar"/utf8>>;

        pseudo_type_scrollbar_thumb ->
            <<"scrollbar-thumb"/utf8>>;

        pseudo_type_scrollbar_button ->
            <<"scrollbar-button"/utf8>>;

        pseudo_type_scrollbar_track ->
            <<"scrollbar-track"/utf8>>;

        pseudo_type_scrollbar_track_piece ->
            <<"scrollbar-track-piece"/utf8>>;

        pseudo_type_scrollbar_corner ->
            <<"scrollbar-corner"/utf8>>;

        pseudo_type_resizer ->
            <<"resizer"/utf8>>;

        pseudo_type_input_list_button ->
            <<"input-list-button"/utf8>>;

        pseudo_type_view_transition ->
            <<"view-transition"/utf8>>;

        pseudo_type_view_transition_group ->
            <<"view-transition-group"/utf8>>;

        pseudo_type_view_transition_image_pair ->
            <<"view-transition-image-pair"/utf8>>;

        pseudo_type_view_transition_old ->
            <<"view-transition-old"/utf8>>;

        pseudo_type_view_transition_new ->
            <<"view-transition-new"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 173).
?DOC(false).
-spec decode__pseudo_type() -> gleam@dynamic@decode:decoder(pseudo_type()).
decode__pseudo_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"first-line"/utf8>> ->
                        gleam@dynamic@decode:success(pseudo_type_first_line);

                    <<"first-letter"/utf8>> ->
                        gleam@dynamic@decode:success(pseudo_type_first_letter);

                    <<"before"/utf8>> ->
                        gleam@dynamic@decode:success(pseudo_type_before);

                    <<"after"/utf8>> ->
                        gleam@dynamic@decode:success(pseudo_type_after);

                    <<"marker"/utf8>> ->
                        gleam@dynamic@decode:success(pseudo_type_marker);

                    <<"backdrop"/utf8>> ->
                        gleam@dynamic@decode:success(pseudo_type_backdrop);

                    <<"selection"/utf8>> ->
                        gleam@dynamic@decode:success(pseudo_type_selection);

                    <<"target-text"/utf8>> ->
                        gleam@dynamic@decode:success(pseudo_type_target_text);

                    <<"spelling-error"/utf8>> ->
                        gleam@dynamic@decode:success(pseudo_type_spelling_error);

                    <<"grammar-error"/utf8>> ->
                        gleam@dynamic@decode:success(pseudo_type_grammar_error);

                    <<"highlight"/utf8>> ->
                        gleam@dynamic@decode:success(pseudo_type_highlight);

                    <<"first-line-inherited"/utf8>> ->
                        gleam@dynamic@decode:success(
                            pseudo_type_first_line_inherited
                        );

                    <<"scroll-marker"/utf8>> ->
                        gleam@dynamic@decode:success(pseudo_type_scroll_marker);

                    <<"scroll-markers"/utf8>> ->
                        gleam@dynamic@decode:success(pseudo_type_scroll_markers);

                    <<"scrollbar"/utf8>> ->
                        gleam@dynamic@decode:success(pseudo_type_scrollbar);

                    <<"scrollbar-thumb"/utf8>> ->
                        gleam@dynamic@decode:success(
                            pseudo_type_scrollbar_thumb
                        );

                    <<"scrollbar-button"/utf8>> ->
                        gleam@dynamic@decode:success(
                            pseudo_type_scrollbar_button
                        );

                    <<"scrollbar-track"/utf8>> ->
                        gleam@dynamic@decode:success(
                            pseudo_type_scrollbar_track
                        );

                    <<"scrollbar-track-piece"/utf8>> ->
                        gleam@dynamic@decode:success(
                            pseudo_type_scrollbar_track_piece
                        );

                    <<"scrollbar-corner"/utf8>> ->
                        gleam@dynamic@decode:success(
                            pseudo_type_scrollbar_corner
                        );

                    <<"resizer"/utf8>> ->
                        gleam@dynamic@decode:success(pseudo_type_resizer);

                    <<"input-list-button"/utf8>> ->
                        gleam@dynamic@decode:success(
                            pseudo_type_input_list_button
                        );

                    <<"view-transition"/utf8>> ->
                        gleam@dynamic@decode:success(
                            pseudo_type_view_transition
                        );

                    <<"view-transition-group"/utf8>> ->
                        gleam@dynamic@decode:success(
                            pseudo_type_view_transition_group
                        );

                    <<"view-transition-image-pair"/utf8>> ->
                        gleam@dynamic@decode:success(
                            pseudo_type_view_transition_image_pair
                        );

                    <<"view-transition-old"/utf8>> ->
                        gleam@dynamic@decode:success(
                            pseudo_type_view_transition_old
                        );

                    <<"view-transition-new"/utf8>> ->
                        gleam@dynamic@decode:success(
                            pseudo_type_view_transition_new
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            pseudo_type_first_line,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 218).
?DOC(false).
-spec encode__shadow_root_type(shadow_root_type()) -> gleam@json:json().
encode__shadow_root_type(Value__) ->
    _pipe = case Value__ of
        shadow_root_type_user_agent ->
            <<"user-agent"/utf8>>;

        shadow_root_type_open ->
            <<"open"/utf8>>;

        shadow_root_type_closed ->
            <<"closed"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 228).
?DOC(false).
-spec decode__shadow_root_type() -> gleam@dynamic@decode:decoder(shadow_root_type()).
decode__shadow_root_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"user-agent"/utf8>> ->
                        gleam@dynamic@decode:success(
                            shadow_root_type_user_agent
                        );

                    <<"open"/utf8>> ->
                        gleam@dynamic@decode:success(shadow_root_type_open);

                    <<"closed"/utf8>> ->
                        gleam@dynamic@decode:success(shadow_root_type_closed);

                    _ ->
                        gleam@dynamic@decode:failure(
                            shadow_root_type_user_agent,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 248).
?DOC(false).
-spec encode__compatibility_mode(compatibility_mode()) -> gleam@json:json().
encode__compatibility_mode(Value__) ->
    _pipe = case Value__ of
        compatibility_mode_quirks_mode ->
            <<"QuirksMode"/utf8>>;

        compatibility_mode_limited_quirks_mode ->
            <<"LimitedQuirksMode"/utf8>>;

        compatibility_mode_no_quirks_mode ->
            <<"NoQuirksMode"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 258).
?DOC(false).
-spec decode__compatibility_mode() -> gleam@dynamic@decode:decoder(compatibility_mode()).
decode__compatibility_mode() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"QuirksMode"/utf8>> ->
                        gleam@dynamic@decode:success(
                            compatibility_mode_quirks_mode
                        );

                    <<"LimitedQuirksMode"/utf8>> ->
                        gleam@dynamic@decode:success(
                            compatibility_mode_limited_quirks_mode
                        );

                    <<"NoQuirksMode"/utf8>> ->
                        gleam@dynamic@decode:success(
                            compatibility_mode_no_quirks_mode
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            compatibility_mode_quirks_mode,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 278).
?DOC(false).
-spec encode__physical_axes(physical_axes()) -> gleam@json:json().
encode__physical_axes(Value__) ->
    _pipe = case Value__ of
        physical_axes_horizontal ->
            <<"Horizontal"/utf8>>;

        physical_axes_vertical ->
            <<"Vertical"/utf8>>;

        physical_axes_both ->
            <<"Both"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 288).
?DOC(false).
-spec decode__physical_axes() -> gleam@dynamic@decode:decoder(physical_axes()).
decode__physical_axes() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"Horizontal"/utf8>> ->
                        gleam@dynamic@decode:success(physical_axes_horizontal);

                    <<"Vertical"/utf8>> ->
                        gleam@dynamic@decode:success(physical_axes_vertical);

                    <<"Both"/utf8>> ->
                        gleam@dynamic@decode:success(physical_axes_both);

                    _ ->
                        gleam@dynamic@decode:failure(
                            physical_axes_horizontal,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 308).
?DOC(false).
-spec encode__logical_axes(logical_axes()) -> gleam@json:json().
encode__logical_axes(Value__) ->
    _pipe = case Value__ of
        logical_axes_inline ->
            <<"Inline"/utf8>>;

        logical_axes_block ->
            <<"Block"/utf8>>;

        logical_axes_both ->
            <<"Both"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 318).
?DOC(false).
-spec decode__logical_axes() -> gleam@dynamic@decode:decoder(logical_axes()).
decode__logical_axes() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"Inline"/utf8>> ->
                        gleam@dynamic@decode:success(logical_axes_inline);

                    <<"Block"/utf8>> ->
                        gleam@dynamic@decode:success(logical_axes_block);

                    <<"Both"/utf8>> ->
                        gleam@dynamic@decode:success(logical_axes_both);

                    _ ->
                        gleam@dynamic@decode:failure(
                            logical_axes_inline,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 337).
?DOC(false).
-spec encode__scroll_orientation(scroll_orientation()) -> gleam@json:json().
encode__scroll_orientation(Value__) ->
    _pipe = case Value__ of
        scroll_orientation_horizontal ->
            <<"horizontal"/utf8>>;

        scroll_orientation_vertical ->
            <<"vertical"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 346).
?DOC(false).
-spec decode__scroll_orientation() -> gleam@dynamic@decode:decoder(scroll_orientation()).
decode__scroll_orientation() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"horizontal"/utf8>> ->
                        gleam@dynamic@decode:success(
                            scroll_orientation_horizontal
                        );

                    <<"vertical"/utf8>> ->
                        gleam@dynamic@decode:success(
                            scroll_orientation_vertical
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            scroll_orientation_horizontal,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 426).
?DOC(false).
-spec encode__node(node_()) -> gleam@json:json().
encode__node(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"nodeId"/utf8>>,
                    encode__node_id(erlang:element(2, Value__))},
                {<<"backendNodeId"/utf8>>,
                    encode__backend_node_id(erlang:element(4, Value__))},
                {<<"nodeType"/utf8>>,
                    gleam@json:int(erlang:element(5, Value__))},
                {<<"nodeName"/utf8>>,
                    gleam@json:string(erlang:element(6, Value__))},
                {<<"localName"/utf8>>,
                    gleam@json:string(erlang:element(7, Value__))},
                {<<"nodeValue"/utf8>>,
                    gleam@json:string(erlang:element(8, Value__))}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(3, Value__),
                fun(Inner_value__) ->
                    {<<"parentId"/utf8>>, encode__node_id(Inner_value__)}
                end
            ),
            _pipe@2 = chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(9, Value__),
                fun(Inner_value__@1) ->
                    {<<"childNodeCount"/utf8>>, gleam@json:int(Inner_value__@1)}
                end
            ),
            _pipe@3 = chrobot_extra@internal@utils:add_optional(
                _pipe@2,
                erlang:element(10, Value__),
                fun(Inner_value__@2) ->
                    {<<"children"/utf8>>,
                        gleam@json:array(Inner_value__@2, fun encode__node/1)}
                end
            ),
            _pipe@4 = chrobot_extra@internal@utils:add_optional(
                _pipe@3,
                erlang:element(11, Value__),
                fun(Inner_value__@3) ->
                    {<<"attributes"/utf8>>,
                        gleam@json:array(
                            Inner_value__@3,
                            fun gleam@json:string/1
                        )}
                end
            ),
            _pipe@5 = chrobot_extra@internal@utils:add_optional(
                _pipe@4,
                erlang:element(12, Value__),
                fun(Inner_value__@4) ->
                    {<<"documentURL"/utf8>>, gleam@json:string(Inner_value__@4)}
                end
            ),
            _pipe@6 = chrobot_extra@internal@utils:add_optional(
                _pipe@5,
                erlang:element(13, Value__),
                fun(Inner_value__@5) ->
                    {<<"baseURL"/utf8>>, gleam@json:string(Inner_value__@5)}
                end
            ),
            _pipe@7 = chrobot_extra@internal@utils:add_optional(
                _pipe@6,
                erlang:element(14, Value__),
                fun(Inner_value__@6) ->
                    {<<"publicId"/utf8>>, gleam@json:string(Inner_value__@6)}
                end
            ),
            _pipe@8 = chrobot_extra@internal@utils:add_optional(
                _pipe@7,
                erlang:element(15, Value__),
                fun(Inner_value__@7) ->
                    {<<"systemId"/utf8>>, gleam@json:string(Inner_value__@7)}
                end
            ),
            _pipe@9 = chrobot_extra@internal@utils:add_optional(
                _pipe@8,
                erlang:element(16, Value__),
                fun(Inner_value__@8) ->
                    {<<"internalSubset"/utf8>>,
                        gleam@json:string(Inner_value__@8)}
                end
            ),
            _pipe@10 = chrobot_extra@internal@utils:add_optional(
                _pipe@9,
                erlang:element(17, Value__),
                fun(Inner_value__@9) ->
                    {<<"xmlVersion"/utf8>>, gleam@json:string(Inner_value__@9)}
                end
            ),
            _pipe@11 = chrobot_extra@internal@utils:add_optional(
                _pipe@10,
                erlang:element(18, Value__),
                fun(Inner_value__@10) ->
                    {<<"name"/utf8>>, gleam@json:string(Inner_value__@10)}
                end
            ),
            _pipe@12 = chrobot_extra@internal@utils:add_optional(
                _pipe@11,
                erlang:element(19, Value__),
                fun(Inner_value__@11) ->
                    {<<"value"/utf8>>, gleam@json:string(Inner_value__@11)}
                end
            ),
            _pipe@13 = chrobot_extra@internal@utils:add_optional(
                _pipe@12,
                erlang:element(20, Value__),
                fun(Inner_value__@12) ->
                    {<<"pseudoType"/utf8>>,
                        encode__pseudo_type(Inner_value__@12)}
                end
            ),
            _pipe@14 = chrobot_extra@internal@utils:add_optional(
                _pipe@13,
                erlang:element(21, Value__),
                fun(Inner_value__@13) ->
                    {<<"pseudoIdentifier"/utf8>>,
                        gleam@json:string(Inner_value__@13)}
                end
            ),
            _pipe@15 = chrobot_extra@internal@utils:add_optional(
                _pipe@14,
                erlang:element(22, Value__),
                fun(Inner_value__@14) ->
                    {<<"shadowRootType"/utf8>>,
                        encode__shadow_root_type(Inner_value__@14)}
                end
            ),
            _pipe@16 = chrobot_extra@internal@utils:add_optional(
                _pipe@15,
                erlang:element(23, Value__),
                fun(Inner_value__@15) ->
                    {<<"frameId"/utf8>>, gleam@json:string(Inner_value__@15)}
                end
            ),
            _pipe@17 = chrobot_extra@internal@utils:add_optional(
                _pipe@16,
                erlang:element(24, Value__),
                fun(Inner_value__@16) ->
                    {<<"contentDocument"/utf8>>, encode__node(Inner_value__@16)}
                end
            ),
            _pipe@18 = chrobot_extra@internal@utils:add_optional(
                _pipe@17,
                erlang:element(25, Value__),
                fun(Inner_value__@17) ->
                    {<<"shadowRoots"/utf8>>,
                        gleam@json:array(Inner_value__@17, fun encode__node/1)}
                end
            ),
            _pipe@19 = chrobot_extra@internal@utils:add_optional(
                _pipe@18,
                erlang:element(26, Value__),
                fun(Inner_value__@18) ->
                    {<<"templateContent"/utf8>>, encode__node(Inner_value__@18)}
                end
            ),
            _pipe@20 = chrobot_extra@internal@utils:add_optional(
                _pipe@19,
                erlang:element(27, Value__),
                fun(Inner_value__@19) ->
                    {<<"pseudoElements"/utf8>>,
                        gleam@json:array(Inner_value__@19, fun encode__node/1)}
                end
            ),
            _pipe@21 = chrobot_extra@internal@utils:add_optional(
                _pipe@20,
                erlang:element(28, Value__),
                fun(Inner_value__@20) ->
                    {<<"distributedNodes"/utf8>>,
                        gleam@json:array(
                            Inner_value__@20,
                            fun encode__backend_node/1
                        )}
                end
            ),
            _pipe@22 = chrobot_extra@internal@utils:add_optional(
                _pipe@21,
                erlang:element(29, Value__),
                fun(Inner_value__@21) ->
                    {<<"isSVG"/utf8>>, gleam@json:bool(Inner_value__@21)}
                end
            ),
            _pipe@23 = chrobot_extra@internal@utils:add_optional(
                _pipe@22,
                erlang:element(30, Value__),
                fun(Inner_value__@22) ->
                    {<<"compatibilityMode"/utf8>>,
                        encode__compatibility_mode(Inner_value__@22)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@23,
                erlang:element(31, Value__),
                fun(Inner_value__@23) ->
                    {<<"assignedSlot"/utf8>>,
                        encode__backend_node(Inner_value__@23)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 512).
?DOC(false).
-spec decode__node() -> gleam@dynamic@decode:decoder(node_()).
decode__node() ->
    begin
        gleam@dynamic@decode:field(
            <<"nodeId"/utf8>>,
            decode__node_id(),
            fun(Node_id) ->
                gleam@dynamic@decode:optional_field(
                    <<"parentId"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(decode__node_id()),
                    fun(Parent_id) ->
                        gleam@dynamic@decode:field(
                            <<"backendNodeId"/utf8>>,
                            decode__backend_node_id(),
                            fun(Backend_node_id) ->
                                gleam@dynamic@decode:field(
                                    <<"nodeType"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_int/1},
                                    fun(Node_type) ->
                                        gleam@dynamic@decode:field(
                                            <<"nodeName"/utf8>>,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_string/1},
                                            fun(Node_name) ->
                                                gleam@dynamic@decode:field(
                                                    <<"localName"/utf8>>,
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_string/1},
                                                    fun(Local_name) ->
                                                        gleam@dynamic@decode:field(
                                                            <<"nodeValue"/utf8>>,
                                                            {decoder,
                                                                fun gleam@dynamic@decode:decode_string/1},
                                                            fun(Node_value) ->
                                                                gleam@dynamic@decode:optional_field(
                                                                    <<"childNodeCount"/utf8>>,
                                                                    none,
                                                                    gleam@dynamic@decode:optional(
                                                                        {decoder,
                                                                            fun gleam@dynamic@decode:decode_int/1}
                                                                    ),
                                                                    fun(
                                                                        Child_node_count
                                                                    ) ->
                                                                        gleam@dynamic@decode:optional_field(
                                                                            <<"children"/utf8>>,
                                                                            none,
                                                                            gleam@dynamic@decode:optional(
                                                                                gleam@dynamic@decode:list(
                                                                                    decode__node(
                                                                                        
                                                                                    )
                                                                                )
                                                                            ),
                                                                            fun(
                                                                                Children
                                                                            ) ->
                                                                                gleam@dynamic@decode:optional_field(
                                                                                    <<"attributes"/utf8>>,
                                                                                    none,
                                                                                    gleam@dynamic@decode:optional(
                                                                                        gleam@dynamic@decode:list(
                                                                                            {decoder,
                                                                                                fun gleam@dynamic@decode:decode_string/1}
                                                                                        )
                                                                                    ),
                                                                                    fun(
                                                                                        Attributes
                                                                                    ) ->
                                                                                        gleam@dynamic@decode:optional_field(
                                                                                            <<"documentURL"/utf8>>,
                                                                                            none,
                                                                                            gleam@dynamic@decode:optional(
                                                                                                {decoder,
                                                                                                    fun gleam@dynamic@decode:decode_string/1}
                                                                                            ),
                                                                                            fun(
                                                                                                Document_url
                                                                                            ) ->
                                                                                                gleam@dynamic@decode:optional_field(
                                                                                                    <<"baseURL"/utf8>>,
                                                                                                    none,
                                                                                                    gleam@dynamic@decode:optional(
                                                                                                        {decoder,
                                                                                                            fun gleam@dynamic@decode:decode_string/1}
                                                                                                    ),
                                                                                                    fun(
                                                                                                        Base_url
                                                                                                    ) ->
                                                                                                        gleam@dynamic@decode:optional_field(
                                                                                                            <<"publicId"/utf8>>,
                                                                                                            none,
                                                                                                            gleam@dynamic@decode:optional(
                                                                                                                {decoder,
                                                                                                                    fun gleam@dynamic@decode:decode_string/1}
                                                                                                            ),
                                                                                                            fun(
                                                                                                                Public_id
                                                                                                            ) ->
                                                                                                                gleam@dynamic@decode:optional_field(
                                                                                                                    <<"systemId"/utf8>>,
                                                                                                                    none,
                                                                                                                    gleam@dynamic@decode:optional(
                                                                                                                        {decoder,
                                                                                                                            fun gleam@dynamic@decode:decode_string/1}
                                                                                                                    ),
                                                                                                                    fun(
                                                                                                                        System_id
                                                                                                                    ) ->
                                                                                                                        gleam@dynamic@decode:optional_field(
                                                                                                                            <<"internalSubset"/utf8>>,
                                                                                                                            none,
                                                                                                                            gleam@dynamic@decode:optional(
                                                                                                                                {decoder,
                                                                                                                                    fun gleam@dynamic@decode:decode_string/1}
                                                                                                                            ),
                                                                                                                            fun(
                                                                                                                                Internal_subset
                                                                                                                            ) ->
                                                                                                                                gleam@dynamic@decode:optional_field(
                                                                                                                                    <<"xmlVersion"/utf8>>,
                                                                                                                                    none,
                                                                                                                                    gleam@dynamic@decode:optional(
                                                                                                                                        {decoder,
                                                                                                                                            fun gleam@dynamic@decode:decode_string/1}
                                                                                                                                    ),
                                                                                                                                    fun(
                                                                                                                                        Xml_version
                                                                                                                                    ) ->
                                                                                                                                        gleam@dynamic@decode:optional_field(
                                                                                                                                            <<"name"/utf8>>,
                                                                                                                                            none,
                                                                                                                                            gleam@dynamic@decode:optional(
                                                                                                                                                {decoder,
                                                                                                                                                    fun gleam@dynamic@decode:decode_string/1}
                                                                                                                                            ),
                                                                                                                                            fun(
                                                                                                                                                Name
                                                                                                                                            ) ->
                                                                                                                                                gleam@dynamic@decode:optional_field(
                                                                                                                                                    <<"value"/utf8>>,
                                                                                                                                                    none,
                                                                                                                                                    gleam@dynamic@decode:optional(
                                                                                                                                                        {decoder,
                                                                                                                                                            fun gleam@dynamic@decode:decode_string/1}
                                                                                                                                                    ),
                                                                                                                                                    fun(
                                                                                                                                                        Value
                                                                                                                                                    ) ->
                                                                                                                                                        gleam@dynamic@decode:optional_field(
                                                                                                                                                            <<"pseudoType"/utf8>>,
                                                                                                                                                            none,
                                                                                                                                                            gleam@dynamic@decode:optional(
                                                                                                                                                                decode__pseudo_type(
                                                                                                                                                                    
                                                                                                                                                                )
                                                                                                                                                            ),
                                                                                                                                                            fun(
                                                                                                                                                                Pseudo_type
                                                                                                                                                            ) ->
                                                                                                                                                                gleam@dynamic@decode:optional_field(
                                                                                                                                                                    <<"pseudoIdentifier"/utf8>>,
                                                                                                                                                                    none,
                                                                                                                                                                    gleam@dynamic@decode:optional(
                                                                                                                                                                        {decoder,
                                                                                                                                                                            fun gleam@dynamic@decode:decode_string/1}
                                                                                                                                                                    ),
                                                                                                                                                                    fun(
                                                                                                                                                                        Pseudo_identifier
                                                                                                                                                                    ) ->
                                                                                                                                                                        gleam@dynamic@decode:optional_field(
                                                                                                                                                                            <<"shadowRootType"/utf8>>,
                                                                                                                                                                            none,
                                                                                                                                                                            gleam@dynamic@decode:optional(
                                                                                                                                                                                decode__shadow_root_type(
                                                                                                                                                                                    
                                                                                                                                                                                )
                                                                                                                                                                            ),
                                                                                                                                                                            fun(
                                                                                                                                                                                Shadow_root_type
                                                                                                                                                                            ) ->
                                                                                                                                                                                gleam@dynamic@decode:optional_field(
                                                                                                                                                                                    <<"frameId"/utf8>>,
                                                                                                                                                                                    none,
                                                                                                                                                                                    gleam@dynamic@decode:optional(
                                                                                                                                                                                        {decoder,
                                                                                                                                                                                            fun gleam@dynamic@decode:decode_string/1}
                                                                                                                                                                                    ),
                                                                                                                                                                                    fun(
                                                                                                                                                                                        Frame_id
                                                                                                                                                                                    ) ->
                                                                                                                                                                                        gleam@dynamic@decode:optional_field(
                                                                                                                                                                                            <<"contentDocument"/utf8>>,
                                                                                                                                                                                            none,
                                                                                                                                                                                            gleam@dynamic@decode:optional(
                                                                                                                                                                                                decode__node(
                                                                                                                                                                                                    
                                                                                                                                                                                                )
                                                                                                                                                                                            ),
                                                                                                                                                                                            fun(
                                                                                                                                                                                                Content_document
                                                                                                                                                                                            ) ->
                                                                                                                                                                                                gleam@dynamic@decode:optional_field(
                                                                                                                                                                                                    <<"shadowRoots"/utf8>>,
                                                                                                                                                                                                    none,
                                                                                                                                                                                                    gleam@dynamic@decode:optional(
                                                                                                                                                                                                        gleam@dynamic@decode:list(
                                                                                                                                                                                                            decode__node(
                                                                                                                                                                                                                
                                                                                                                                                                                                            )
                                                                                                                                                                                                        )
                                                                                                                                                                                                    ),
                                                                                                                                                                                                    fun(
                                                                                                                                                                                                        Shadow_roots
                                                                                                                                                                                                    ) ->
                                                                                                                                                                                                        gleam@dynamic@decode:optional_field(
                                                                                                                                                                                                            <<"templateContent"/utf8>>,
                                                                                                                                                                                                            none,
                                                                                                                                                                                                            gleam@dynamic@decode:optional(
                                                                                                                                                                                                                decode__node(
                                                                                                                                                                                                                    
                                                                                                                                                                                                                )
                                                                                                                                                                                                            ),
                                                                                                                                                                                                            fun(
                                                                                                                                                                                                                Template_content
                                                                                                                                                                                                            ) ->
                                                                                                                                                                                                                gleam@dynamic@decode:optional_field(
                                                                                                                                                                                                                    <<"pseudoElements"/utf8>>,
                                                                                                                                                                                                                    none,
                                                                                                                                                                                                                    gleam@dynamic@decode:optional(
                                                                                                                                                                                                                        gleam@dynamic@decode:list(
                                                                                                                                                                                                                            decode__node(
                                                                                                                                                                                                                                
                                                                                                                                                                                                                            )
                                                                                                                                                                                                                        )
                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                    fun(
                                                                                                                                                                                                                        Pseudo_elements
                                                                                                                                                                                                                    ) ->
                                                                                                                                                                                                                        gleam@dynamic@decode:optional_field(
                                                                                                                                                                                                                            <<"distributedNodes"/utf8>>,
                                                                                                                                                                                                                            none,
                                                                                                                                                                                                                            gleam@dynamic@decode:optional(
                                                                                                                                                                                                                                gleam@dynamic@decode:list(
                                                                                                                                                                                                                                    decode__backend_node(
                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                    )
                                                                                                                                                                                                                                )
                                                                                                                                                                                                                            ),
                                                                                                                                                                                                                            fun(
                                                                                                                                                                                                                                Distributed_nodes
                                                                                                                                                                                                                            ) ->
                                                                                                                                                                                                                                gleam@dynamic@decode:optional_field(
                                                                                                                                                                                                                                    <<"isSVG"/utf8>>,
                                                                                                                                                                                                                                    none,
                                                                                                                                                                                                                                    gleam@dynamic@decode:optional(
                                                                                                                                                                                                                                        {decoder,
                                                                                                                                                                                                                                            fun gleam@dynamic@decode:decode_bool/1}
                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                    fun(
                                                                                                                                                                                                                                        Is_svg
                                                                                                                                                                                                                                    ) ->
                                                                                                                                                                                                                                        gleam@dynamic@decode:optional_field(
                                                                                                                                                                                                                                            <<"compatibilityMode"/utf8>>,
                                                                                                                                                                                                                                            none,
                                                                                                                                                                                                                                            gleam@dynamic@decode:optional(
                                                                                                                                                                                                                                                decode__compatibility_mode(
                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                )
                                                                                                                                                                                                                                            ),
                                                                                                                                                                                                                                            fun(
                                                                                                                                                                                                                                                Compatibility_mode
                                                                                                                                                                                                                                            ) ->
                                                                                                                                                                                                                                                gleam@dynamic@decode:optional_field(
                                                                                                                                                                                                                                                    <<"assignedSlot"/utf8>>,
                                                                                                                                                                                                                                                    none,
                                                                                                                                                                                                                                                    gleam@dynamic@decode:optional(
                                                                                                                                                                                                                                                        decode__backend_node(
                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                        )
                                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                                    fun(
                                                                                                                                                                                                                                                        Assigned_slot
                                                                                                                                                                                                                                                    ) ->
                                                                                                                                                                                                                                                        gleam@dynamic@decode:success(
                                                                                                                                                                                                                                                            {node,
                                                                                                                                                                                                                                                                Node_id,
                                                                                                                                                                                                                                                                Parent_id,
                                                                                                                                                                                                                                                                Backend_node_id,
                                                                                                                                                                                                                                                                Node_type,
                                                                                                                                                                                                                                                                Node_name,
                                                                                                                                                                                                                                                                Local_name,
                                                                                                                                                                                                                                                                Node_value,
                                                                                                                                                                                                                                                                Child_node_count,
                                                                                                                                                                                                                                                                Children,
                                                                                                                                                                                                                                                                Attributes,
                                                                                                                                                                                                                                                                Document_url,
                                                                                                                                                                                                                                                                Base_url,
                                                                                                                                                                                                                                                                Public_id,
                                                                                                                                                                                                                                                                System_id,
                                                                                                                                                                                                                                                                Internal_subset,
                                                                                                                                                                                                                                                                Xml_version,
                                                                                                                                                                                                                                                                Name,
                                                                                                                                                                                                                                                                Value,
                                                                                                                                                                                                                                                                Pseudo_type,
                                                                                                                                                                                                                                                                Pseudo_identifier,
                                                                                                                                                                                                                                                                Shadow_root_type,
                                                                                                                                                                                                                                                                Frame_id,
                                                                                                                                                                                                                                                                Content_document,
                                                                                                                                                                                                                                                                Shadow_roots,
                                                                                                                                                                                                                                                                Template_content,
                                                                                                                                                                                                                                                                Pseudo_elements,
                                                                                                                                                                                                                                                                Distributed_nodes,
                                                                                                                                                                                                                                                                Is_svg,
                                                                                                                                                                                                                                                                Compatibility_mode,
                                                                                                                                                                                                                                                                Assigned_slot}
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
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 694).
?DOC(false).
-spec encode__rgba(r_g_b_a()) -> gleam@json:json().
encode__rgba(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"r"/utf8>>, gleam@json:int(erlang:element(2, Value__))},
                {<<"g"/utf8>>, gleam@json:int(erlang:element(3, Value__))},
                {<<"b"/utf8>>, gleam@json:int(erlang:element(4, Value__))}],
            chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(5, Value__),
                fun(Inner_value__) ->
                    {<<"a"/utf8>>, gleam@json:float(Inner_value__)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 708).
?DOC(false).
-spec decode__rgba() -> gleam@dynamic@decode:decoder(r_g_b_a()).
decode__rgba() ->
    begin
        gleam@dynamic@decode:field(
            <<"r"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(R) ->
                gleam@dynamic@decode:field(
                    <<"g"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_int/1},
                    fun(G) ->
                        gleam@dynamic@decode:field(
                            <<"b"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_int/1},
                            fun(B) ->
                                gleam@dynamic@decode:optional_field(
                                    <<"a"/utf8>>,
                                    none,
                                    gleam@dynamic@decode:optional(
                                        {decoder,
                                            fun gleam@dynamic@decode:decode_float/1}
                                    ),
                                    fun(A) ->
                                        gleam@dynamic@decode:success(
                                            {r_g_b_a, R, G, B, A}
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

-file("src\\chrobot_extra\\protocol\\dom.gleam", 729).
?DOC(false).
-spec encode__quad(quad()) -> gleam@json:json().
encode__quad(Value__) ->
    case Value__ of
        {quad, Inner_value__} ->
            gleam@json:array(Inner_value__, fun gleam@json:float/1)
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 736).
?DOC(false).
-spec decode__quad() -> gleam@dynamic@decode:decoder(quad()).
decode__quad() ->
    begin
        gleam@dynamic@decode:then(
            gleam@dynamic@decode:list(
                {decoder, fun gleam@dynamic@decode:decode_float/1}
            ),
            fun(Value__) -> gleam@dynamic@decode:success({quad, Value__}) end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 820).
?DOC(false).
-spec encode__shape_outside_info(shape_outside_info()) -> gleam@json:json().
encode__shape_outside_info(Value__) ->
    gleam@json:object(
        [{<<"bounds"/utf8>>, encode__quad(erlang:element(2, Value__))},
            {<<"shape"/utf8>>, gleam@json:null()},
            {<<"marginShape"/utf8>>, gleam@json:null()}]
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 764).
?DOC(false).
-spec encode__box_model(box_model()) -> gleam@json:json().
encode__box_model(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"content"/utf8>>,
                    encode__quad(erlang:element(2, Value__))},
                {<<"padding"/utf8>>, encode__quad(erlang:element(3, Value__))},
                {<<"border"/utf8>>, encode__quad(erlang:element(4, Value__))},
                {<<"margin"/utf8>>, encode__quad(erlang:element(5, Value__))},
                {<<"width"/utf8>>, gleam@json:int(erlang:element(6, Value__))},
                {<<"height"/utf8>>, gleam@json:int(erlang:element(7, Value__))}],
            chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(8, Value__),
                fun(Inner_value__) ->
                    {<<"shapeOutside"/utf8>>,
                        encode__shape_outside_info(Inner_value__)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 837).
?DOC(false).
-spec decode__shape_outside_info() -> gleam@dynamic@decode:decoder(shape_outside_info()).
decode__shape_outside_info() ->
    begin
        gleam@dynamic@decode:field(
            <<"bounds"/utf8>>,
            decode__quad(),
            fun(Bounds) ->
                gleam@dynamic@decode:field(
                    <<"shape"/utf8>>,
                    gleam@dynamic@decode:list(
                        {decoder, fun gleam@dynamic@decode:decode_dynamic/1}
                    ),
                    fun(Shape) ->
                        gleam@dynamic@decode:field(
                            <<"marginShape"/utf8>>,
                            gleam@dynamic@decode:list(
                                {decoder,
                                    fun gleam@dynamic@decode:decode_dynamic/1}
                            ),
                            fun(Margin_shape) ->
                                gleam@dynamic@decode:success(
                                    {shape_outside_info,
                                        Bounds,
                                        Shape,
                                        Margin_shape}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 781).
?DOC(false).
-spec decode__box_model() -> gleam@dynamic@decode:decoder(box_model()).
decode__box_model() ->
    begin
        gleam@dynamic@decode:field(
            <<"content"/utf8>>,
            decode__quad(),
            fun(Content) ->
                gleam@dynamic@decode:field(
                    <<"padding"/utf8>>,
                    decode__quad(),
                    fun(Padding) ->
                        gleam@dynamic@decode:field(
                            <<"border"/utf8>>,
                            decode__quad(),
                            fun(Border) ->
                                gleam@dynamic@decode:field(
                                    <<"margin"/utf8>>,
                                    decode__quad(),
                                    fun(Margin) ->
                                        gleam@dynamic@decode:field(
                                            <<"width"/utf8>>,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_int/1},
                                            fun(Width) ->
                                                gleam@dynamic@decode:field(
                                                    <<"height"/utf8>>,
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_int/1},
                                                    fun(Height) ->
                                                        gleam@dynamic@decode:optional_field(
                                                            <<"shapeOutside"/utf8>>,
                                                            none,
                                                            gleam@dynamic@decode:optional(
                                                                decode__shape_outside_info(
                                                                    
                                                                )
                                                            ),
                                                            fun(Shape_outside) ->
                                                                gleam@dynamic@decode:success(
                                                                    {box_model,
                                                                        Content,
                                                                        Padding,
                                                                        Border,
                                                                        Margin,
                                                                        Width,
                                                                        Height,
                                                                        Shape_outside}
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

-file("src\\chrobot_extra\\protocol\\dom.gleam", 866).
?DOC(false).
-spec encode__rect(rect()) -> gleam@json:json().
encode__rect(Value__) ->
    gleam@json:object(
        [{<<"x"/utf8>>, gleam@json:float(erlang:element(2, Value__))},
            {<<"y"/utf8>>, gleam@json:float(erlang:element(3, Value__))},
            {<<"width"/utf8>>, gleam@json:float(erlang:element(4, Value__))},
            {<<"height"/utf8>>, gleam@json:float(erlang:element(5, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 876).
?DOC(false).
-spec decode__rect() -> gleam@dynamic@decode:decoder(rect()).
decode__rect() ->
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
                                        gleam@dynamic@decode:success(
                                            {rect, X, Y, Width, Height}
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

-file("src\\chrobot_extra\\protocol\\dom.gleam", 897).
?DOC(false).
-spec encode__css_computed_style_property(c_s_s_computed_style_property()) -> gleam@json:json().
encode__css_computed_style_property(Value__) ->
    gleam@json:object(
        [{<<"name"/utf8>>, gleam@json:string(erlang:element(2, Value__))},
            {<<"value"/utf8>>, gleam@json:string(erlang:element(3, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 905).
?DOC(false).
-spec decode__css_computed_style_property() -> gleam@dynamic@decode:decoder(c_s_s_computed_style_property()).
decode__css_computed_style_property() ->
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
                            {c_s_s_computed_style_property, Name, Value}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 924).
?DOC(false).
-spec decode__describe_node_response() -> gleam@dynamic@decode:decoder(describe_node_response()).
decode__describe_node_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"node"/utf8>>,
            decode__node(),
            fun(Node) ->
                gleam@dynamic@decode:success({describe_node_response, Node})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 942).
?DOC(false).
-spec decode__get_attributes_response() -> gleam@dynamic@decode:decoder(get_attributes_response()).
decode__get_attributes_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"attributes"/utf8>>,
            gleam@dynamic@decode:list(
                {decoder, fun gleam@dynamic@decode:decode_string/1}
            ),
            fun(Attributes) ->
                gleam@dynamic@decode:success(
                    {get_attributes_response, Attributes}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 960).
?DOC(false).
-spec decode__get_box_model_response() -> gleam@dynamic@decode:decoder(get_box_model_response()).
decode__get_box_model_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"model"/utf8>>,
            decode__box_model(),
            fun(Model) ->
                gleam@dynamic@decode:success({get_box_model_response, Model})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 978).
?DOC(false).
-spec decode__get_document_response() -> gleam@dynamic@decode:decoder(get_document_response()).
decode__get_document_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"root"/utf8>>,
            decode__node(),
            fun(Root) ->
                gleam@dynamic@decode:success({get_document_response, Root})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1000).
?DOC(false).
-spec decode__get_node_for_location_response() -> gleam@dynamic@decode:decoder(get_node_for_location_response()).
decode__get_node_for_location_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"backendNodeId"/utf8>>,
            decode__backend_node_id(),
            fun(Backend_node_id) ->
                gleam@dynamic@decode:field(
                    <<"frameId"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Frame_id) ->
                        gleam@dynamic@decode:optional_field(
                            <<"nodeId"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(decode__node_id()),
                            fun(Node_id) ->
                                gleam@dynamic@decode:success(
                                    {get_node_for_location_response,
                                        Backend_node_id,
                                        Frame_id,
                                        Node_id}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1031).
?DOC(false).
-spec decode__get_outer_html_response() -> gleam@dynamic@decode:decoder(get_outer_html_response()).
decode__get_outer_html_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"outerHTML"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Outer_html) ->
                gleam@dynamic@decode:success(
                    {get_outer_html_response, Outer_html}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1049).
?DOC(false).
-spec decode__move_to_response() -> gleam@dynamic@decode:decoder(move_to_response()).
decode__move_to_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"nodeId"/utf8>>,
            decode__node_id(),
            fun(Node_id) ->
                gleam@dynamic@decode:success({move_to_response, Node_id})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1067).
?DOC(false).
-spec decode__query_selector_response() -> gleam@dynamic@decode:decoder(query_selector_response()).
decode__query_selector_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"nodeId"/utf8>>,
            decode__node_id(),
            fun(Node_id) ->
                gleam@dynamic@decode:success({query_selector_response, Node_id})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1085).
?DOC(false).
-spec decode__query_selector_all_response() -> gleam@dynamic@decode:decoder(query_selector_all_response()).
decode__query_selector_all_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"nodeIds"/utf8>>,
            gleam@dynamic@decode:list(decode__node_id()),
            fun(Node_ids) ->
                gleam@dynamic@decode:success(
                    {query_selector_all_response, Node_ids}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1103).
?DOC(false).
-spec decode__request_node_response() -> gleam@dynamic@decode:decoder(request_node_response()).
decode__request_node_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"nodeId"/utf8>>,
            decode__node_id(),
            fun(Node_id) ->
                gleam@dynamic@decode:success({request_node_response, Node_id})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1121).
?DOC(false).
-spec decode__resolve_node_response() -> gleam@dynamic@decode:decoder(resolve_node_response()).
decode__resolve_node_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"object"/utf8>>,
            chrobot_extra@protocol@runtime:decode__remote_object(),
            fun(Object) ->
                gleam@dynamic@decode:success({resolve_node_response, Object})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1139).
?DOC(false).
-spec decode__set_node_name_response() -> gleam@dynamic@decode:decoder(set_node_name_response()).
decode__set_node_name_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"nodeId"/utf8>>,
            decode__node_id(),
            fun(Node_id) ->
                gleam@dynamic@decode:success({set_node_name_response, Node_id})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1162).
?DOC(
    " Describes node given its id, does not require domain to be enabled. Does not start tracking any\n"
    " objects, can be used for automation.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Identifier of the node.\n"
    "  - `backend_node_id` : Identifier of the backend node.\n"
    "  - `object_id` : JavaScript object id of the node wrapper.\n"
    "  - `depth` : The maximum depth at which children should be retrieved, defaults to 1. Use -1 for the\n"
    " entire subtree or provide an integer larger than 0.\n"
    "  - `pierce` : Whether or not iframes and shadow roots should be traversed when returning the subtree\n"
    " (default is false).\n"
    " \n"
    " Returns:  \n"
    "  - `node` : Node description.\n"
).
-spec describe_node(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    gleam@option:option(node_id()),
    gleam@option:option(backend_node_id()),
    gleam@option:option(chrobot_extra@protocol@runtime:remote_object_id()),
    gleam@option:option(integer()),
    gleam@option:option(boolean())
) -> {ok, describe_node_response()} |
    {error, chrobot_extra@chrome:request_error()}.
describe_node(Callback__, Node_id, Backend_node_id, Object_id, Depth, Pierce) ->
    gleam@result:'try'(
        Callback__(
            <<"DOM.describeNode"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Node_id,
                            fun(Inner_value__) ->
                                {<<"nodeId"/utf8>>,
                                    encode__node_id(Inner_value__)}
                            end
                        ),
                        _pipe@2 = chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Backend_node_id,
                            fun(Inner_value__@1) ->
                                {<<"backendNodeId"/utf8>>,
                                    encode__backend_node_id(Inner_value__@1)}
                            end
                        ),
                        _pipe@3 = chrobot_extra@internal@utils:add_optional(
                            _pipe@2,
                            Object_id,
                            fun(Inner_value__@2) ->
                                {<<"objectId"/utf8>>,
                                    chrobot_extra@protocol@runtime:encode__remote_object_id(
                                        Inner_value__@2
                                    )}
                            end
                        ),
                        _pipe@4 = chrobot_extra@internal@utils:add_optional(
                            _pipe@3,
                            Depth,
                            fun(Inner_value__@3) ->
                                {<<"depth"/utf8>>,
                                    gleam@json:int(Inner_value__@3)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@4,
                            Pierce,
                            fun(Inner_value__@4) ->
                                {<<"pierce"/utf8>>,
                                    gleam@json:bool(Inner_value__@4)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@5 = gleam@dynamic@decode:run(
                Result__,
                decode__describe_node_response()
            ),
            gleam@result:replace_error(_pipe@5, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1209).
?DOC(
    " Scrolls the specified rect of the given node into view if not already visible.\n"
    " Note: exactly one between nodeId, backendNodeId and objectId should be passed\n"
    " to identify the node.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Identifier of the node.\n"
    "  - `backend_node_id` : Identifier of the backend node.\n"
    "  - `object_id` : JavaScript object id of the node wrapper.\n"
    "  - `rect` : The rect to be scrolled into view, relative to the node's border box, in CSS pixels.\n"
    " When omitted, center of the node will be used, similar to Element.scrollIntoView.\n"
    " \n"
    " Returns:\n"
).
-spec scroll_into_view_if_needed(
    fun((binary(), gleam@option:option(gleam@json:json())) -> OGV),
    gleam@option:option(node_id()),
    gleam@option:option(backend_node_id()),
    gleam@option:option(chrobot_extra@protocol@runtime:remote_object_id()),
    gleam@option:option(rect())
) -> OGV.
scroll_into_view_if_needed(
    Callback__,
    Node_id,
    Backend_node_id,
    Object_id,
    Rect
) ->
    Callback__(
        <<"DOM.scrollIntoViewIfNeeded"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [],
                    _pipe@1 = chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Node_id,
                        fun(Inner_value__) ->
                            {<<"nodeId"/utf8>>, encode__node_id(Inner_value__)}
                        end
                    ),
                    _pipe@2 = chrobot_extra@internal@utils:add_optional(
                        _pipe@1,
                        Backend_node_id,
                        fun(Inner_value__@1) ->
                            {<<"backendNodeId"/utf8>>,
                                encode__backend_node_id(Inner_value__@1)}
                        end
                    ),
                    _pipe@3 = chrobot_extra@internal@utils:add_optional(
                        _pipe@2,
                        Object_id,
                        fun(Inner_value__@2) ->
                            {<<"objectId"/utf8>>,
                                chrobot_extra@protocol@runtime:encode__remote_object_id(
                                    Inner_value__@2
                                )}
                        end
                    ),
                    chrobot_extra@internal@utils:add_optional(
                        _pipe@3,
                        Rect,
                        fun(Inner_value__@3) ->
                            {<<"rect"/utf8>>, encode__rect(Inner_value__@3)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1238).
?DOC(" Disables DOM agent for the given page.\n").
-spec disable(fun((binary(), gleam@option:option(any())) -> OHI)) -> OHI.
disable(Callback__) ->
    Callback__(<<"DOM.disable"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1248).
?DOC(
    " Enables DOM agent for the given page.\n"
    " \n"
    " Parameters:  \n"
    " \n"
    " Returns:\n"
).
-spec enable(fun((binary(), gleam@option:option(any())) -> OHM)) -> OHM.
enable(Callback__) ->
    Callback__(<<"DOM.enable"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1261).
?DOC(
    " Focuses the given element.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Identifier of the node.\n"
    "  - `backend_node_id` : Identifier of the backend node.\n"
    "  - `object_id` : JavaScript object id of the node wrapper.\n"
    " \n"
    " Returns:\n"
).
-spec focus(
    fun((binary(), gleam@option:option(gleam@json:json())) -> OHQ),
    gleam@option:option(node_id()),
    gleam@option:option(backend_node_id()),
    gleam@option:option(chrobot_extra@protocol@runtime:remote_object_id())
) -> OHQ.
focus(Callback__, Node_id, Backend_node_id, Object_id) ->
    Callback__(
        <<"DOM.focus"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [],
                    _pipe@1 = chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Node_id,
                        fun(Inner_value__) ->
                            {<<"nodeId"/utf8>>, encode__node_id(Inner_value__)}
                        end
                    ),
                    _pipe@2 = chrobot_extra@internal@utils:add_optional(
                        _pipe@1,
                        Backend_node_id,
                        fun(Inner_value__@1) ->
                            {<<"backendNodeId"/utf8>>,
                                encode__backend_node_id(Inner_value__@1)}
                        end
                    ),
                    chrobot_extra@internal@utils:add_optional(
                        _pipe@2,
                        Object_id,
                        fun(Inner_value__@2) ->
                            {<<"objectId"/utf8>>,
                                chrobot_extra@protocol@runtime:encode__remote_object_id(
                                    Inner_value__@2
                                )}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1292).
?DOC(
    " Returns attributes for the specified node.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Id of the node to retrieve attributes for.\n"
    " \n"
    " Returns:  \n"
    "  - `attributes` : An interleaved array of node attribute names and values.\n"
).
-spec get_attributes(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    node_id()
) -> {ok, get_attributes_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_attributes(Callback__, Node_id) ->
    gleam@result:'try'(
        Callback__(
            <<"DOM.getAttributes"/utf8>>,
            {some,
                gleam@json:object(
                    [{<<"nodeId"/utf8>>, encode__node_id(Node_id)}]
                )}
        ),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__get_attributes_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1316).
?DOC(
    " Returns boxes for the given node.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Identifier of the node.\n"
    "  - `backend_node_id` : Identifier of the backend node.\n"
    "  - `object_id` : JavaScript object id of the node wrapper.\n"
    " \n"
    " Returns:  \n"
    "  - `model` : Box model for the node.\n"
).
-spec get_box_model(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    gleam@option:option(node_id()),
    gleam@option:option(backend_node_id()),
    gleam@option:option(chrobot_extra@protocol@runtime:remote_object_id())
) -> {ok, get_box_model_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_box_model(Callback__, Node_id, Backend_node_id, Object_id) ->
    gleam@result:'try'(
        Callback__(
            <<"DOM.getBoxModel"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Node_id,
                            fun(Inner_value__) ->
                                {<<"nodeId"/utf8>>,
                                    encode__node_id(Inner_value__)}
                            end
                        ),
                        _pipe@2 = chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Backend_node_id,
                            fun(Inner_value__@1) ->
                                {<<"backendNodeId"/utf8>>,
                                    encode__backend_node_id(Inner_value__@1)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@2,
                            Object_id,
                            fun(Inner_value__@2) ->
                                {<<"objectId"/utf8>>,
                                    chrobot_extra@protocol@runtime:encode__remote_object_id(
                                        Inner_value__@2
                                    )}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@3 = gleam@dynamic@decode:run(
                Result__,
                decode__get_box_model_response()
            ),
            gleam@result:replace_error(_pipe@3, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1354).
?DOC(
    " Returns the root DOM node (and optionally the subtree) to the caller.\n"
    " Implicitly enables the DOM domain events for the current target.\n"
    " \n"
    " Parameters:  \n"
    "  - `depth` : The maximum depth at which children should be retrieved, defaults to 1. Use -1 for the\n"
    " entire subtree or provide an integer larger than 0.\n"
    "  - `pierce` : Whether or not iframes and shadow roots should be traversed when returning the subtree\n"
    " (default is false).\n"
    " \n"
    " Returns:  \n"
    "  - `root` : Resulting node.\n"
).
-spec get_document(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    gleam@option:option(integer()),
    gleam@option:option(boolean())
) -> {ok, get_document_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_document(Callback__, Depth, Pierce) ->
    gleam@result:'try'(
        Callback__(
            <<"DOM.getDocument"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Depth,
                            fun(Inner_value__) ->
                                {<<"depth"/utf8>>,
                                    gleam@json:int(Inner_value__)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Pierce,
                            fun(Inner_value__@1) ->
                                {<<"pierce"/utf8>>,
                                    gleam@json:bool(Inner_value__@1)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@2 = gleam@dynamic@decode:run(
                Result__,
                decode__get_document_response()
            ),
            gleam@result:replace_error(_pipe@2, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1390).
?DOC(
    " Returns node id at given location. Depending on whether DOM domain is enabled, nodeId is\n"
    " either returned or not.\n"
    " \n"
    " Parameters:  \n"
    "  - `x` : X coordinate.\n"
    "  - `y` : Y coordinate.\n"
    "  - `include_user_agent_shadow_dom` : False to skip to the nearest non-UA shadow root ancestor (default: false).\n"
    "  - `ignore_pointer_events_none` : Whether to ignore pointer-events: none on elements and hit test them.\n"
    " \n"
    " Returns:  \n"
    "  - `backend_node_id` : Resulting node.\n"
    "  - `frame_id` : Frame this node belongs to.\n"
    "  - `node_id` : Id of the node at given coordinates, only when enabled and requested document.\n"
).
-spec get_node_for_location(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    integer(),
    integer(),
    gleam@option:option(boolean()),
    gleam@option:option(boolean())
) -> {ok, get_node_for_location_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_node_for_location(
    Callback__,
    X,
    Y,
    Include_user_agent_shadow_dom,
    Ignore_pointer_events_none
) ->
    gleam@result:'try'(
        Callback__(
            <<"DOM.getNodeForLocation"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"x"/utf8>>, gleam@json:int(X)},
                            {<<"y"/utf8>>, gleam@json:int(Y)}],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Include_user_agent_shadow_dom,
                            fun(Inner_value__) ->
                                {<<"includeUserAgentShadowDOM"/utf8>>,
                                    gleam@json:bool(Inner_value__)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Ignore_pointer_events_none,
                            fun(Inner_value__@1) ->
                                {<<"ignorePointerEventsNone"/utf8>>,
                                    gleam@json:bool(Inner_value__@1)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@2 = gleam@dynamic@decode:run(
                Result__,
                decode__get_node_for_location_response()
            ),
            gleam@result:replace_error(_pipe@2, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1429).
?DOC(
    " Returns node's HTML markup.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Identifier of the node.\n"
    "  - `backend_node_id` : Identifier of the backend node.\n"
    "  - `object_id` : JavaScript object id of the node wrapper.\n"
    " \n"
    " Returns:  \n"
    "  - `outer_html` : Outer HTML markup.\n"
).
-spec get_outer_html(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    gleam@option:option(node_id()),
    gleam@option:option(backend_node_id()),
    gleam@option:option(chrobot_extra@protocol@runtime:remote_object_id())
) -> {ok, get_outer_html_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_outer_html(Callback__, Node_id, Backend_node_id, Object_id) ->
    gleam@result:'try'(
        Callback__(
            <<"DOM.getOuterHTML"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Node_id,
                            fun(Inner_value__) ->
                                {<<"nodeId"/utf8>>,
                                    encode__node_id(Inner_value__)}
                            end
                        ),
                        _pipe@2 = chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Backend_node_id,
                            fun(Inner_value__@1) ->
                                {<<"backendNodeId"/utf8>>,
                                    encode__backend_node_id(Inner_value__@1)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@2,
                            Object_id,
                            fun(Inner_value__@2) ->
                                {<<"objectId"/utf8>>,
                                    chrobot_extra@protocol@runtime:encode__remote_object_id(
                                        Inner_value__@2
                                    )}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@3 = gleam@dynamic@decode:run(
                Result__,
                decode__get_outer_html_response()
            ),
            gleam@result:replace_error(_pipe@3, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1457).
?DOC(" Hides any highlight.\n").
-spec hide_highlight(fun((binary(), gleam@option:option(any())) -> OLI)) -> OLI.
hide_highlight(Callback__) ->
    Callback__(<<"DOM.hideHighlight"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1463).
?DOC(" Highlights DOM node.\n").
-spec highlight_node(fun((binary(), gleam@option:option(any())) -> OLM)) -> OLM.
highlight_node(Callback__) ->
    Callback__(<<"DOM.highlightNode"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1469).
?DOC(" Highlights given rectangle.\n").
-spec highlight_rect(fun((binary(), gleam@option:option(any())) -> OLQ)) -> OLQ.
highlight_rect(Callback__) ->
    Callback__(<<"DOM.highlightRect"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1484).
?DOC(
    " Moves node into the new container, places it before the given anchor.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Id of the node to move.\n"
    "  - `target_node_id` : Id of the element to drop the moved node into.\n"
    "  - `insert_before_node_id` : Drop node before this one (if absent, the moved node becomes the last child of\n"
    " `targetNodeId`).\n"
    " \n"
    " Returns:  \n"
    "  - `node_id` : New id of the moved node.\n"
).
-spec move_to(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    node_id(),
    node_id(),
    gleam@option:option(node_id())
) -> {ok, move_to_response()} | {error, chrobot_extra@chrome:request_error()}.
move_to(Callback__, Node_id, Target_node_id, Insert_before_node_id) ->
    gleam@result:'try'(
        Callback__(
            <<"DOM.moveTo"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [{<<"nodeId"/utf8>>, encode__node_id(Node_id)},
                            {<<"targetNodeId"/utf8>>,
                                encode__node_id(Target_node_id)}],
                        chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Insert_before_node_id,
                            fun(Inner_value__) ->
                                {<<"insertBeforeNodeId"/utf8>>,
                                    encode__node_id(Inner_value__)}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@1 = gleam@dynamic@decode:run(
                Result__,
                decode__move_to_response()
            ),
            gleam@result:replace_error(_pipe@1, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1516).
?DOC(
    " Executes `querySelector` on a given node.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Id of the node to query upon.\n"
    "  - `selector` : Selector string.\n"
    " \n"
    " Returns:  \n"
    "  - `node_id` : Query selector result.\n"
).
-spec query_selector(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    node_id(),
    binary()
) -> {ok, query_selector_response()} |
    {error, chrobot_extra@chrome:request_error()}.
query_selector(Callback__, Node_id, Selector) ->
    gleam@result:'try'(
        Callback__(
            <<"DOM.querySelector"/utf8>>,
            {some,
                gleam@json:object(
                    [{<<"nodeId"/utf8>>, encode__node_id(Node_id)},
                        {<<"selector"/utf8>>, gleam@json:string(Selector)}]
                )}
        ),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__query_selector_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1544).
?DOC(
    " Executes `querySelectorAll` on a given node.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Id of the node to query upon.\n"
    "  - `selector` : Selector string.\n"
    " \n"
    " Returns:  \n"
    "  - `node_ids` : Query selector result.\n"
).
-spec query_selector_all(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    node_id(),
    binary()
) -> {ok, query_selector_all_response()} |
    {error, chrobot_extra@chrome:request_error()}.
query_selector_all(Callback__, Node_id, Selector) ->
    gleam@result:'try'(
        Callback__(
            <<"DOM.querySelectorAll"/utf8>>,
            {some,
                gleam@json:object(
                    [{<<"nodeId"/utf8>>, encode__node_id(Node_id)},
                        {<<"selector"/utf8>>, gleam@json:string(Selector)}]
                )}
        ),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__query_selector_all_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1571).
?DOC(
    " Removes attribute with given name from an element with given id.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Id of the element to remove attribute from.\n"
    "  - `name` : Name of the attribute to remove.\n"
    " \n"
    " Returns:\n"
).
-spec remove_attribute(
    fun((binary(), gleam@option:option(gleam@json:json())) -> ONJ),
    node_id(),
    binary()
) -> ONJ.
remove_attribute(Callback__, Node_id, Name) ->
    Callback__(
        <<"DOM.removeAttribute"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"nodeId"/utf8>>, encode__node_id(Node_id)},
                    {<<"name"/utf8>>, gleam@json:string(Name)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1590).
?DOC(
    " Removes node with given id.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Id of the node to remove.\n"
    " \n"
    " Returns:\n"
).
-spec remove_node(
    fun((binary(), gleam@option:option(gleam@json:json())) -> ONO),
    node_id()
) -> ONO.
remove_node(Callback__, Node_id) ->
    Callback__(
        <<"DOM.removeNode"/utf8>>,
        {some,
            gleam@json:object([{<<"nodeId"/utf8>>, encode__node_id(Node_id)}])}
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1614).
?DOC(
    " Requests that children of the node with given id are returned to the caller in form of\n"
    " `setChildNodes` events where not only immediate children are retrieved, but all children down to\n"
    " the specified depth.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Id of the node to get children for.\n"
    "  - `depth` : The maximum depth at which children should be retrieved, defaults to 1. Use -1 for the\n"
    " entire subtree or provide an integer larger than 0.\n"
    "  - `pierce` : Whether or not iframes and shadow roots should be traversed when returning the sub-tree\n"
    " (default is false).\n"
    " \n"
    " Returns:\n"
).
-spec request_child_nodes(
    fun((binary(), gleam@option:option(gleam@json:json())) -> ONT),
    node_id(),
    gleam@option:option(integer()),
    gleam@option:option(boolean())
) -> ONT.
request_child_nodes(Callback__, Node_id, Depth, Pierce) ->
    Callback__(
        <<"DOM.requestChildNodes"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [{<<"nodeId"/utf8>>, encode__node_id(Node_id)}],
                    _pipe@1 = chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Depth,
                        fun(Inner_value__) ->
                            {<<"depth"/utf8>>, gleam@json:int(Inner_value__)}
                        end
                    ),
                    chrobot_extra@internal@utils:add_optional(
                        _pipe@1,
                        Pierce,
                        fun(Inner_value__@1) ->
                            {<<"pierce"/utf8>>,
                                gleam@json:bool(Inner_value__@1)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1646).
?DOC(
    " Requests that the node is sent to the caller given the JavaScript node object reference. All\n"
    " nodes that form the path from the node to the root are also sent to the client as a series of\n"
    " `setChildNodes` notifications.\n"
    " \n"
    " Parameters:  \n"
    "  - `object_id` : JavaScript object id to convert into node.\n"
    " \n"
    " Returns:  \n"
    "  - `node_id` : Node id for given object.\n"
).
-spec request_node(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    chrobot_extra@protocol@runtime:remote_object_id()
) -> {ok, request_node_response()} |
    {error, chrobot_extra@chrome:request_error()}.
request_node(Callback__, Object_id) ->
    gleam@result:'try'(
        Callback__(
            <<"DOM.requestNode"/utf8>>,
            {some,
                gleam@json:object(
                    [{<<"objectId"/utf8>>,
                            chrobot_extra@protocol@runtime:encode__remote_object_id(
                                Object_id
                            )}]
                )}
        ),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__request_node_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1671).
?DOC(
    " Resolves the JavaScript node object for a given NodeId or BackendNodeId.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Id of the node to resolve.\n"
    "  - `backend_node_id` : Backend identifier of the node to resolve.\n"
    "  - `object_group` : Symbolic group name that can be used to release multiple objects.\n"
    "  - `execution_context_id` : Execution context in which to resolve the node.\n"
    " \n"
    " Returns:  \n"
    "  - `object` : JavaScript object wrapper for given node.\n"
).
-spec resolve_node(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    gleam@option:option(node_id()),
    gleam@option:option(backend_node_id()),
    gleam@option:option(binary()),
    gleam@option:option(chrobot_extra@protocol@runtime:execution_context_id())
) -> {ok, resolve_node_response()} |
    {error, chrobot_extra@chrome:request_error()}.
resolve_node(
    Callback__,
    Node_id,
    Backend_node_id,
    Object_group,
    Execution_context_id
) ->
    gleam@result:'try'(
        Callback__(
            <<"DOM.resolveNode"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [],
                        _pipe@1 = chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Node_id,
                            fun(Inner_value__) ->
                                {<<"nodeId"/utf8>>,
                                    encode__node_id(Inner_value__)}
                            end
                        ),
                        _pipe@2 = chrobot_extra@internal@utils:add_optional(
                            _pipe@1,
                            Backend_node_id,
                            fun(Inner_value__@1) ->
                                {<<"backendNodeId"/utf8>>,
                                    encode__backend_node_id(Inner_value__@1)}
                            end
                        ),
                        _pipe@3 = chrobot_extra@internal@utils:add_optional(
                            _pipe@2,
                            Object_group,
                            fun(Inner_value__@2) ->
                                {<<"objectGroup"/utf8>>,
                                    gleam@json:string(Inner_value__@2)}
                            end
                        ),
                        chrobot_extra@internal@utils:add_optional(
                            _pipe@3,
                            Execution_context_id,
                            fun(Inner_value__@3) ->
                                {<<"executionContextId"/utf8>>,
                                    chrobot_extra@protocol@runtime:encode__execution_context_id(
                                        Inner_value__@3
                                    )}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@4 = gleam@dynamic@decode:run(
                Result__,
                decode__resolve_node_response()
            ),
            gleam@result:replace_error(_pipe@4, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1715).
?DOC(
    " Sets attribute for an element with given id.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Id of the element to set attribute for.\n"
    "  - `name` : Attribute name.\n"
    "  - `value` : Attribute value.\n"
    " \n"
    " Returns:\n"
).
-spec set_attribute_value(
    fun((binary(), gleam@option:option(gleam@json:json())) -> OPK),
    node_id(),
    binary(),
    binary()
) -> OPK.
set_attribute_value(Callback__, Node_id, Name, Value) ->
    Callback__(
        <<"DOM.setAttributeValue"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"nodeId"/utf8>>, encode__node_id(Node_id)},
                    {<<"name"/utf8>>, gleam@json:string(Name)},
                    {<<"value"/utf8>>, gleam@json:string(Value)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1744).
?DOC(
    " Sets attributes on element with given id. This method is useful when user edits some existing\n"
    " attribute value and types in several attribute name/value pairs.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Id of the element to set attributes for.\n"
    "  - `text` : Text with a number of attributes. Will parse this text using HTML parser.\n"
    "  - `name` : Attribute name to replace with new attributes derived from text in case text parsed\n"
    " successfully.\n"
    " \n"
    " Returns:\n"
).
-spec set_attributes_as_text(
    fun((binary(), gleam@option:option(gleam@json:json())) -> OPP),
    node_id(),
    binary(),
    gleam@option:option(binary())
) -> OPP.
set_attributes_as_text(Callback__, Node_id, Text, Name) ->
    Callback__(
        <<"DOM.setAttributesAsText"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [{<<"nodeId"/utf8>>, encode__node_id(Node_id)},
                        {<<"text"/utf8>>, gleam@json:string(Text)}],
                    chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Name,
                        fun(Inner_value__) ->
                            {<<"name"/utf8>>, gleam@json:string(Inner_value__)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1774).
?DOC(
    " Sets files for the given file input element.\n"
    " \n"
    " Parameters:  \n"
    "  - `files` : Array of file paths to set.\n"
    "  - `node_id` : Identifier of the node.\n"
    "  - `backend_node_id` : Identifier of the backend node.\n"
    "  - `object_id` : JavaScript object id of the node wrapper.\n"
    " \n"
    " Returns:\n"
).
-spec set_file_input_files(
    fun((binary(), gleam@option:option(gleam@json:json())) -> OPW),
    list(binary()),
    gleam@option:option(node_id()),
    gleam@option:option(backend_node_id()),
    gleam@option:option(chrobot_extra@protocol@runtime:remote_object_id())
) -> OPW.
set_file_input_files(Callback__, Files, Node_id, Backend_node_id, Object_id) ->
    Callback__(
        <<"DOM.setFileInputFiles"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [{<<"files"/utf8>>,
                            gleam@json:array(Files, fun gleam@json:string/1)}],
                    _pipe@1 = chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Node_id,
                        fun(Inner_value__) ->
                            {<<"nodeId"/utf8>>, encode__node_id(Inner_value__)}
                        end
                    ),
                    _pipe@2 = chrobot_extra@internal@utils:add_optional(
                        _pipe@1,
                        Backend_node_id,
                        fun(Inner_value__@1) ->
                            {<<"backendNodeId"/utf8>>,
                                encode__backend_node_id(Inner_value__@1)}
                        end
                    ),
                    chrobot_extra@internal@utils:add_optional(
                        _pipe@2,
                        Object_id,
                        fun(Inner_value__@2) ->
                            {<<"objectId"/utf8>>,
                                chrobot_extra@protocol@runtime:encode__remote_object_id(
                                    Inner_value__@2
                                )}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1809).
?DOC(
    " Sets node name for a node with given id.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Id of the node to set name for.\n"
    "  - `name` : New node's name.\n"
    " \n"
    " Returns:  \n"
    "  - `node_id` : New node's id.\n"
).
-spec set_node_name(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    node_id(),
    binary()
) -> {ok, set_node_name_response()} |
    {error, chrobot_extra@chrome:request_error()}.
set_node_name(Callback__, Node_id, Name) ->
    gleam@result:'try'(
        Callback__(
            <<"DOM.setNodeName"/utf8>>,
            {some,
                gleam@json:object(
                    [{<<"nodeId"/utf8>>, encode__node_id(Node_id)},
                        {<<"name"/utf8>>, gleam@json:string(Name)}]
                )}
        ),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__set_node_name_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1832).
?DOC(
    " Sets node value for a node with given id.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Id of the node to set value for.\n"
    "  - `value` : New node's value.\n"
    " \n"
    " Returns:\n"
).
-spec set_node_value(
    fun((binary(), gleam@option:option(gleam@json:json())) -> OQV),
    node_id(),
    binary()
) -> OQV.
set_node_value(Callback__, Node_id, Value) ->
    Callback__(
        <<"DOM.setNodeValue"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"nodeId"/utf8>>, encode__node_id(Node_id)},
                    {<<"value"/utf8>>, gleam@json:string(Value)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\dom.gleam", 1852).
?DOC(
    " Sets node HTML markup, returns new node id.\n"
    " \n"
    " Parameters:  \n"
    "  - `node_id` : Id of the node to set markup for.\n"
    "  - `outer_html` : Outer HTML markup to set.\n"
    " \n"
    " Returns:\n"
).
-spec set_outer_html(
    fun((binary(), gleam@option:option(gleam@json:json())) -> ORA),
    node_id(),
    binary()
) -> ORA.
set_outer_html(Callback__, Node_id, Outer_html) ->
    Callback__(
        <<"DOM.setOuterHTML"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"nodeId"/utf8>>, encode__node_id(Node_id)},
                    {<<"outerHTML"/utf8>>, gleam@json:string(Outer_html)}]
            )}
    ).
