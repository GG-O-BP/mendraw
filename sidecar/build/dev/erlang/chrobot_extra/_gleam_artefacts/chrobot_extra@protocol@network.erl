-module(chrobot_extra@protocol@network).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\protocol\\network.gleam").
-export([encode__resource_type/1, decode__resource_type/0, encode__loader_id/1, decode__loader_id/0, encode__request_id/1, decode__request_id/0, encode__interception_id/1, decode__interception_id/0, encode__error_reason/1, decode__error_reason/0, encode__time_since_epoch/1, decode__time_since_epoch/0, encode__monotonic_time/1, decode__monotonic_time/0, encode__headers/1, decode__headers/0, encode__connection_type/1, decode__connection_type/0, encode__cookie_same_site/1, decode__cookie_same_site/0, encode__resource_timing/1, decode__resource_timing/0, encode__resource_priority/1, decode__resource_priority/0, encode__post_data_entry/1, decode__post_data_entry/0, encode__request_referrer_policy/1, decode__request_referrer_policy/0, encode__request/1, decode__request/0, encode__signed_certificate_timestamp/1, decode__signed_certificate_timestamp/0, encode__certificate_transparency_compliance/1, encode__security_details/1, decode__certificate_transparency_compliance/0, decode__security_details/0, encode__blocked_reason/1, decode__blocked_reason/0, encode__cors_error/1, decode__cors_error/0, encode__cors_error_status/1, decode__cors_error_status/0, encode__service_worker_response_source/1, decode__service_worker_response_source/0, encode__service_worker_router_source/1, decode__service_worker_router_source/0, encode__response/1, decode__response/0, encode__web_socket_request/1, decode__web_socket_request/0, encode__web_socket_response/1, decode__web_socket_response/0, encode__web_socket_frame/1, decode__web_socket_frame/0, encode__cached_resource/1, decode__cached_resource/0, encode__initiator_type/1, decode__initiator_type/0, encode__initiator/1, decode__initiator/0, encode__cookie/1, decode__cookie/0, encode__cookie_param/1, decode__cookie_param/0, decode__get_cookies_response/0, decode__get_response_body_response/0, decode__get_request_post_data_response/0, clear_browser_cache/1, clear_browser_cookies/1, delete_cookies/6, disable/1, emulate_network_conditions/6, enable/2, get_cookies/2, get_response_body/2, get_request_post_data/2, set_bypass_service_worker/2, set_cache_disabled/2, set_cookie/10, set_cookies/2, set_extra_http_headers/2, set_user_agent_override/4]).
-export_type([resource_type/0, loader_id/0, request_id/0, interception_id/0, error_reason/0, time_since_epoch/0, monotonic_time/0, headers/0, connection_type/0, cookie_same_site/0, resource_timing/0, resource_priority/0, post_data_entry/0, request/0, request_referrer_policy/0, signed_certificate_timestamp/0, security_details/0, certificate_transparency_compliance/0, blocked_reason/0, cors_error/0, cors_error_status/0, service_worker_response_source/0, service_worker_router_source/0, response/0, web_socket_request/0, web_socket_response/0, web_socket_frame/0, cached_resource/0, initiator/0, initiator_type/0, cookie/0, cookie_param/0, get_cookies_response/0, get_response_body_response/0, get_request_post_data_response/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " > ⚙️  This module was generated from the Chrome DevTools Protocol version **1.3**\n"
    " ## Network Domain  \n"
    "\n"
    " Network domain allows tracking network activities of the page. It exposes information about http,\n"
    " file, data and other requests and responses, their headers, bodies, timing, etc.  \n"
    "\n"
    " [📖   View this domain on the DevTools Protocol API Docs](https://chromedevtools.github.io/devtools-protocol/1-3/Network/)\n"
).

-type resource_type() :: resource_type_document |
    resource_type_stylesheet |
    resource_type_image |
    resource_type_media |
    resource_type_font |
    resource_type_script |
    resource_type_text_track |
    resource_type_xhr |
    resource_type_fetch |
    resource_type_prefetch |
    resource_type_event_source |
    resource_type_web_socket |
    resource_type_manifest |
    resource_type_signed_exchange |
    resource_type_ping |
    resource_type_csp_violation_report |
    resource_type_preflight |
    resource_type_other.

-type loader_id() :: {loader_id, binary()}.

-type request_id() :: {request_id, binary()}.

-type interception_id() :: {interception_id, binary()}.

-type error_reason() :: error_reason_failed |
    error_reason_aborted |
    error_reason_timed_out |
    error_reason_access_denied |
    error_reason_connection_closed |
    error_reason_connection_reset |
    error_reason_connection_refused |
    error_reason_connection_aborted |
    error_reason_connection_failed |
    error_reason_name_not_resolved |
    error_reason_internet_disconnected |
    error_reason_address_unreachable |
    error_reason_blocked_by_client |
    error_reason_blocked_by_response.

-type time_since_epoch() :: {time_since_epoch, float()}.

-type monotonic_time() :: {monotonic_time, float()}.

-type headers() :: {headers, gleam@dict:dict(binary(), binary())}.

-type connection_type() :: connection_type_none |
    connection_type_cellular2g |
    connection_type_cellular3g |
    connection_type_cellular4g |
    connection_type_bluetooth |
    connection_type_ethernet |
    connection_type_wifi |
    connection_type_wimax |
    connection_type_other.

-type cookie_same_site() :: cookie_same_site_strict |
    cookie_same_site_lax |
    cookie_same_site_none.

-type resource_timing() :: {resource_timing,
        float(),
        float(),
        float(),
        float(),
        float(),
        float(),
        float(),
        float(),
        float(),
        float(),
        float(),
        float()}.

-type resource_priority() :: resource_priority_very_low |
    resource_priority_low |
    resource_priority_medium |
    resource_priority_high |
    resource_priority_very_high.

-type post_data_entry() :: {post_data_entry, gleam@option:option(binary())}.

-type request() :: {request,
        binary(),
        gleam@option:option(binary()),
        binary(),
        headers(),
        gleam@option:option(boolean()),
        gleam@option:option(chrobot_extra@protocol@security:mixed_content_type()),
        resource_priority(),
        request_referrer_policy(),
        gleam@option:option(boolean())}.

-type request_referrer_policy() :: request_referrer_policy_unsafe_url |
    request_referrer_policy_no_referrer_when_downgrade |
    request_referrer_policy_no_referrer |
    request_referrer_policy_origin |
    request_referrer_policy_origin_when_cross_origin |
    request_referrer_policy_same_origin |
    request_referrer_policy_strict_origin |
    request_referrer_policy_strict_origin_when_cross_origin.

-type signed_certificate_timestamp() :: {signed_certificate_timestamp,
        binary(),
        binary(),
        binary(),
        binary(),
        float(),
        binary(),
        binary(),
        binary()}.

-type security_details() :: {security_details,
        binary(),
        binary(),
        gleam@option:option(binary()),
        binary(),
        gleam@option:option(binary()),
        chrobot_extra@protocol@security:certificate_id(),
        binary(),
        list(binary()),
        binary(),
        time_since_epoch(),
        time_since_epoch(),
        list(signed_certificate_timestamp()),
        certificate_transparency_compliance(),
        gleam@option:option(integer()),
        boolean()}.

-type certificate_transparency_compliance() :: certificate_transparency_compliance_unknown |
    certificate_transparency_compliance_not_compliant |
    certificate_transparency_compliance_compliant.

-type blocked_reason() :: blocked_reason_other |
    blocked_reason_csp |
    blocked_reason_mixed_content |
    blocked_reason_origin |
    blocked_reason_inspector |
    blocked_reason_subresource_filter |
    blocked_reason_content_type |
    blocked_reason_coep_frame_resource_needs_coep_header |
    blocked_reason_coop_sandboxed_iframe_cannot_navigate_to_coop_page |
    blocked_reason_corp_not_same_origin |
    blocked_reason_corp_not_same_origin_after_defaulted_to_same_origin_by_coep |
    blocked_reason_corp_not_same_site.

-type cors_error() :: cors_error_disallowed_by_mode |
    cors_error_invalid_response |
    cors_error_wildcard_origin_not_allowed |
    cors_error_missing_allow_origin_header |
    cors_error_multiple_allow_origin_values |
    cors_error_invalid_allow_origin_value |
    cors_error_allow_origin_mismatch |
    cors_error_invalid_allow_credentials |
    cors_error_cors_disabled_scheme |
    cors_error_preflight_invalid_status |
    cors_error_preflight_disallowed_redirect |
    cors_error_preflight_wildcard_origin_not_allowed |
    cors_error_preflight_missing_allow_origin_header |
    cors_error_preflight_multiple_allow_origin_values |
    cors_error_preflight_invalid_allow_origin_value |
    cors_error_preflight_allow_origin_mismatch |
    cors_error_preflight_invalid_allow_credentials |
    cors_error_preflight_missing_allow_external |
    cors_error_preflight_invalid_allow_external |
    cors_error_preflight_missing_allow_private_network |
    cors_error_preflight_invalid_allow_private_network |
    cors_error_invalid_allow_methods_preflight_response |
    cors_error_invalid_allow_headers_preflight_response |
    cors_error_method_disallowed_by_preflight_response |
    cors_error_header_disallowed_by_preflight_response |
    cors_error_redirect_contains_credentials |
    cors_error_insecure_private_network |
    cors_error_invalid_private_network_access |
    cors_error_unexpected_private_network_access |
    cors_error_no_cors_redirect_mode_not_follow |
    cors_error_preflight_missing_private_network_access_id |
    cors_error_preflight_missing_private_network_access_name |
    cors_error_private_network_access_permission_unavailable |
    cors_error_private_network_access_permission_denied.

-type cors_error_status() :: {cors_error_status, cors_error(), binary()}.

-type service_worker_response_source() :: service_worker_response_source_cache_storage |
    service_worker_response_source_http_cache |
    service_worker_response_source_fallback_code |
    service_worker_response_source_network.

-type service_worker_router_source() :: service_worker_router_source_network |
    service_worker_router_source_cache |
    service_worker_router_source_fetch_event |
    service_worker_router_source_race_network_and_fetch_handler.

-type response() :: {response,
        binary(),
        integer(),
        binary(),
        headers(),
        binary(),
        binary(),
        gleam@option:option(headers()),
        boolean(),
        float(),
        gleam@option:option(binary()),
        gleam@option:option(integer()),
        gleam@option:option(boolean()),
        gleam@option:option(boolean()),
        gleam@option:option(boolean()),
        gleam@option:option(boolean()),
        float(),
        gleam@option:option(resource_timing()),
        gleam@option:option(service_worker_response_source()),
        gleam@option:option(time_since_epoch()),
        gleam@option:option(binary()),
        gleam@option:option(binary()),
        chrobot_extra@protocol@security:security_state(),
        gleam@option:option(security_details())}.

-type web_socket_request() :: {web_socket_request, headers()}.

-type web_socket_response() :: {web_socket_response,
        integer(),
        binary(),
        headers(),
        gleam@option:option(binary()),
        gleam@option:option(headers()),
        gleam@option:option(binary())}.

-type web_socket_frame() :: {web_socket_frame, float(), boolean(), binary()}.

-type cached_resource() :: {cached_resource,
        binary(),
        resource_type(),
        gleam@option:option(response()),
        float()}.

-type initiator() :: {initiator,
        initiator_type(),
        gleam@option:option(chrobot_extra@protocol@runtime:stack_trace()),
        gleam@option:option(binary()),
        gleam@option:option(float()),
        gleam@option:option(float()),
        gleam@option:option(request_id())}.

-type initiator_type() :: initiator_type_parser |
    initiator_type_script |
    initiator_type_preload |
    initiator_type_signed_exchange |
    initiator_type_preflight |
    initiator_type_other.

-type cookie() :: {cookie,
        binary(),
        binary(),
        binary(),
        binary(),
        float(),
        integer(),
        boolean(),
        boolean(),
        boolean(),
        gleam@option:option(cookie_same_site())}.

-type cookie_param() :: {cookie_param,
        binary(),
        binary(),
        gleam@option:option(binary()),
        gleam@option:option(binary()),
        gleam@option:option(binary()),
        gleam@option:option(boolean()),
        gleam@option:option(boolean()),
        gleam@option:option(cookie_same_site()),
        gleam@option:option(time_since_epoch())}.

-type get_cookies_response() :: {get_cookies_response, list(cookie())}.

-type get_response_body_response() :: {get_response_body_response,
        binary(),
        boolean()}.

-type get_request_post_data_response() :: {get_request_post_data_response,
        binary()}.

-file("src\\chrobot_extra\\protocol\\network.gleam", 48).
?DOC(false).
-spec encode__resource_type(resource_type()) -> gleam@json:json().
encode__resource_type(Value__) ->
    _pipe = case Value__ of
        resource_type_document ->
            <<"Document"/utf8>>;

        resource_type_stylesheet ->
            <<"Stylesheet"/utf8>>;

        resource_type_image ->
            <<"Image"/utf8>>;

        resource_type_media ->
            <<"Media"/utf8>>;

        resource_type_font ->
            <<"Font"/utf8>>;

        resource_type_script ->
            <<"Script"/utf8>>;

        resource_type_text_track ->
            <<"TextTrack"/utf8>>;

        resource_type_xhr ->
            <<"XHR"/utf8>>;

        resource_type_fetch ->
            <<"Fetch"/utf8>>;

        resource_type_prefetch ->
            <<"Prefetch"/utf8>>;

        resource_type_event_source ->
            <<"EventSource"/utf8>>;

        resource_type_web_socket ->
            <<"WebSocket"/utf8>>;

        resource_type_manifest ->
            <<"Manifest"/utf8>>;

        resource_type_signed_exchange ->
            <<"SignedExchange"/utf8>>;

        resource_type_ping ->
            <<"Ping"/utf8>>;

        resource_type_csp_violation_report ->
            <<"CSPViolationReport"/utf8>>;

        resource_type_preflight ->
            <<"Preflight"/utf8>>;

        resource_type_other ->
            <<"Other"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\network.gleam", 73).
?DOC(false).
-spec decode__resource_type() -> gleam@dynamic@decode:decoder(resource_type()).
decode__resource_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"Document"/utf8>> ->
                        gleam@dynamic@decode:success(resource_type_document);

                    <<"Stylesheet"/utf8>> ->
                        gleam@dynamic@decode:success(resource_type_stylesheet);

                    <<"Image"/utf8>> ->
                        gleam@dynamic@decode:success(resource_type_image);

                    <<"Media"/utf8>> ->
                        gleam@dynamic@decode:success(resource_type_media);

                    <<"Font"/utf8>> ->
                        gleam@dynamic@decode:success(resource_type_font);

                    <<"Script"/utf8>> ->
                        gleam@dynamic@decode:success(resource_type_script);

                    <<"TextTrack"/utf8>> ->
                        gleam@dynamic@decode:success(resource_type_text_track);

                    <<"XHR"/utf8>> ->
                        gleam@dynamic@decode:success(resource_type_xhr);

                    <<"Fetch"/utf8>> ->
                        gleam@dynamic@decode:success(resource_type_fetch);

                    <<"Prefetch"/utf8>> ->
                        gleam@dynamic@decode:success(resource_type_prefetch);

                    <<"EventSource"/utf8>> ->
                        gleam@dynamic@decode:success(resource_type_event_source);

                    <<"WebSocket"/utf8>> ->
                        gleam@dynamic@decode:success(resource_type_web_socket);

                    <<"Manifest"/utf8>> ->
                        gleam@dynamic@decode:success(resource_type_manifest);

                    <<"SignedExchange"/utf8>> ->
                        gleam@dynamic@decode:success(
                            resource_type_signed_exchange
                        );

                    <<"Ping"/utf8>> ->
                        gleam@dynamic@decode:success(resource_type_ping);

                    <<"CSPViolationReport"/utf8>> ->
                        gleam@dynamic@decode:success(
                            resource_type_csp_violation_report
                        );

                    <<"Preflight"/utf8>> ->
                        gleam@dynamic@decode:success(resource_type_preflight);

                    <<"Other"/utf8>> ->
                        gleam@dynamic@decode:success(resource_type_other);

                    _ ->
                        gleam@dynamic@decode:failure(
                            resource_type_document,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 106).
?DOC(false).
-spec encode__loader_id(loader_id()) -> gleam@json:json().
encode__loader_id(Value__) ->
    case Value__ of
        {loader_id, Inner_value__} ->
            gleam@json:string(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 113).
?DOC(false).
-spec decode__loader_id() -> gleam@dynamic@decode:decoder(loader_id()).
decode__loader_id() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({loader_id, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 126).
?DOC(false).
-spec encode__request_id(request_id()) -> gleam@json:json().
encode__request_id(Value__) ->
    case Value__ of
        {request_id, Inner_value__} ->
            gleam@json:string(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 133).
?DOC(false).
-spec decode__request_id() -> gleam@dynamic@decode:decoder(request_id()).
decode__request_id() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({request_id, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 146).
?DOC(false).
-spec encode__interception_id(interception_id()) -> gleam@json:json().
encode__interception_id(Value__) ->
    case Value__ of
        {interception_id, Inner_value__} ->
            gleam@json:string(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 153).
?DOC(false).
-spec decode__interception_id() -> gleam@dynamic@decode:decoder(interception_id()).
decode__interception_id() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({interception_id, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 179).
?DOC(false).
-spec encode__error_reason(error_reason()) -> gleam@json:json().
encode__error_reason(Value__) ->
    _pipe = case Value__ of
        error_reason_failed ->
            <<"Failed"/utf8>>;

        error_reason_aborted ->
            <<"Aborted"/utf8>>;

        error_reason_timed_out ->
            <<"TimedOut"/utf8>>;

        error_reason_access_denied ->
            <<"AccessDenied"/utf8>>;

        error_reason_connection_closed ->
            <<"ConnectionClosed"/utf8>>;

        error_reason_connection_reset ->
            <<"ConnectionReset"/utf8>>;

        error_reason_connection_refused ->
            <<"ConnectionRefused"/utf8>>;

        error_reason_connection_aborted ->
            <<"ConnectionAborted"/utf8>>;

        error_reason_connection_failed ->
            <<"ConnectionFailed"/utf8>>;

        error_reason_name_not_resolved ->
            <<"NameNotResolved"/utf8>>;

        error_reason_internet_disconnected ->
            <<"InternetDisconnected"/utf8>>;

        error_reason_address_unreachable ->
            <<"AddressUnreachable"/utf8>>;

        error_reason_blocked_by_client ->
            <<"BlockedByClient"/utf8>>;

        error_reason_blocked_by_response ->
            <<"BlockedByResponse"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\network.gleam", 200).
?DOC(false).
-spec decode__error_reason() -> gleam@dynamic@decode:decoder(error_reason()).
decode__error_reason() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"Failed"/utf8>> ->
                        gleam@dynamic@decode:success(error_reason_failed);

                    <<"Aborted"/utf8>> ->
                        gleam@dynamic@decode:success(error_reason_aborted);

                    <<"TimedOut"/utf8>> ->
                        gleam@dynamic@decode:success(error_reason_timed_out);

                    <<"AccessDenied"/utf8>> ->
                        gleam@dynamic@decode:success(error_reason_access_denied);

                    <<"ConnectionClosed"/utf8>> ->
                        gleam@dynamic@decode:success(
                            error_reason_connection_closed
                        );

                    <<"ConnectionReset"/utf8>> ->
                        gleam@dynamic@decode:success(
                            error_reason_connection_reset
                        );

                    <<"ConnectionRefused"/utf8>> ->
                        gleam@dynamic@decode:success(
                            error_reason_connection_refused
                        );

                    <<"ConnectionAborted"/utf8>> ->
                        gleam@dynamic@decode:success(
                            error_reason_connection_aborted
                        );

                    <<"ConnectionFailed"/utf8>> ->
                        gleam@dynamic@decode:success(
                            error_reason_connection_failed
                        );

                    <<"NameNotResolved"/utf8>> ->
                        gleam@dynamic@decode:success(
                            error_reason_name_not_resolved
                        );

                    <<"InternetDisconnected"/utf8>> ->
                        gleam@dynamic@decode:success(
                            error_reason_internet_disconnected
                        );

                    <<"AddressUnreachable"/utf8>> ->
                        gleam@dynamic@decode:success(
                            error_reason_address_unreachable
                        );

                    <<"BlockedByClient"/utf8>> ->
                        gleam@dynamic@decode:success(
                            error_reason_blocked_by_client
                        );

                    <<"BlockedByResponse"/utf8>> ->
                        gleam@dynamic@decode:success(
                            error_reason_blocked_by_response
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            error_reason_failed,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 229).
?DOC(false).
-spec encode__time_since_epoch(time_since_epoch()) -> gleam@json:json().
encode__time_since_epoch(Value__) ->
    case Value__ of
        {time_since_epoch, Inner_value__} ->
            gleam@json:float(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 236).
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

-file("src\\chrobot_extra\\protocol\\network.gleam", 249).
?DOC(false).
-spec encode__monotonic_time(monotonic_time()) -> gleam@json:json().
encode__monotonic_time(Value__) ->
    case Value__ of
        {monotonic_time, Inner_value__} ->
            gleam@json:float(Inner_value__)
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 256).
?DOC(false).
-spec decode__monotonic_time() -> gleam@dynamic@decode:decoder(monotonic_time()).
decode__monotonic_time() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_float/1},
            fun(Value__) ->
                gleam@dynamic@decode:success({monotonic_time, Value__})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 269).
?DOC(false).
-spec encode__headers(headers()) -> gleam@json:json().
encode__headers(Value__) ->
    case Value__ of
        {headers, Inner_value__} ->
            _pipe = maps:to_list(Inner_value__),
            _pipe@1 = gleam@list:map(
                _pipe,
                fun(I) ->
                    {erlang:element(1, I),
                        gleam@json:string(erlang:element(2, I))}
                end
            ),
            gleam@json:object(_pipe@1)
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 279).
?DOC(false).
-spec decode__headers() -> gleam@dynamic@decode:decoder(headers()).
decode__headers() ->
    begin
        gleam@dynamic@decode:then(
            gleam@dynamic@decode:dict(
                {decoder, fun gleam@dynamic@decode:decode_string/1},
                {decoder, fun gleam@dynamic@decode:decode_string/1}
            ),
            fun(Value__) -> gleam@dynamic@decode:success({headers, Value__}) end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 300).
?DOC(false).
-spec encode__connection_type(connection_type()) -> gleam@json:json().
encode__connection_type(Value__) ->
    _pipe = case Value__ of
        connection_type_none ->
            <<"none"/utf8>>;

        connection_type_cellular2g ->
            <<"cellular2g"/utf8>>;

        connection_type_cellular3g ->
            <<"cellular3g"/utf8>>;

        connection_type_cellular4g ->
            <<"cellular4g"/utf8>>;

        connection_type_bluetooth ->
            <<"bluetooth"/utf8>>;

        connection_type_ethernet ->
            <<"ethernet"/utf8>>;

        connection_type_wifi ->
            <<"wifi"/utf8>>;

        connection_type_wimax ->
            <<"wimax"/utf8>>;

        connection_type_other ->
            <<"other"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\network.gleam", 316).
?DOC(false).
-spec decode__connection_type() -> gleam@dynamic@decode:decoder(connection_type()).
decode__connection_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"none"/utf8>> ->
                        gleam@dynamic@decode:success(connection_type_none);

                    <<"cellular2g"/utf8>> ->
                        gleam@dynamic@decode:success(connection_type_cellular2g);

                    <<"cellular3g"/utf8>> ->
                        gleam@dynamic@decode:success(connection_type_cellular3g);

                    <<"cellular4g"/utf8>> ->
                        gleam@dynamic@decode:success(connection_type_cellular4g);

                    <<"bluetooth"/utf8>> ->
                        gleam@dynamic@decode:success(connection_type_bluetooth);

                    <<"ethernet"/utf8>> ->
                        gleam@dynamic@decode:success(connection_type_ethernet);

                    <<"wifi"/utf8>> ->
                        gleam@dynamic@decode:success(connection_type_wifi);

                    <<"wimax"/utf8>> ->
                        gleam@dynamic@decode:success(connection_type_wimax);

                    <<"other"/utf8>> ->
                        gleam@dynamic@decode:success(connection_type_other);

                    _ ->
                        gleam@dynamic@decode:failure(
                            connection_type_none,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 343).
?DOC(false).
-spec encode__cookie_same_site(cookie_same_site()) -> gleam@json:json().
encode__cookie_same_site(Value__) ->
    _pipe = case Value__ of
        cookie_same_site_strict ->
            <<"Strict"/utf8>>;

        cookie_same_site_lax ->
            <<"Lax"/utf8>>;

        cookie_same_site_none ->
            <<"None"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\network.gleam", 353).
?DOC(false).
-spec decode__cookie_same_site() -> gleam@dynamic@decode:decoder(cookie_same_site()).
decode__cookie_same_site() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"Strict"/utf8>> ->
                        gleam@dynamic@decode:success(cookie_same_site_strict);

                    <<"Lax"/utf8>> ->
                        gleam@dynamic@decode:success(cookie_same_site_lax);

                    <<"None"/utf8>> ->
                        gleam@dynamic@decode:success(cookie_same_site_none);

                    _ ->
                        gleam@dynamic@decode:failure(
                            cookie_same_site_strict,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 397).
?DOC(false).
-spec encode__resource_timing(resource_timing()) -> gleam@json:json().
encode__resource_timing(Value__) ->
    gleam@json:object(
        [{<<"requestTime"/utf8>>, gleam@json:float(erlang:element(2, Value__))},
            {<<"proxyStart"/utf8>>,
                gleam@json:float(erlang:element(3, Value__))},
            {<<"proxyEnd"/utf8>>, gleam@json:float(erlang:element(4, Value__))},
            {<<"dnsStart"/utf8>>, gleam@json:float(erlang:element(5, Value__))},
            {<<"dnsEnd"/utf8>>, gleam@json:float(erlang:element(6, Value__))},
            {<<"connectStart"/utf8>>,
                gleam@json:float(erlang:element(7, Value__))},
            {<<"connectEnd"/utf8>>,
                gleam@json:float(erlang:element(8, Value__))},
            {<<"sslStart"/utf8>>, gleam@json:float(erlang:element(9, Value__))},
            {<<"sslEnd"/utf8>>, gleam@json:float(erlang:element(10, Value__))},
            {<<"sendStart"/utf8>>,
                gleam@json:float(erlang:element(11, Value__))},
            {<<"sendEnd"/utf8>>, gleam@json:float(erlang:element(12, Value__))},
            {<<"receiveHeadersEnd"/utf8>>,
                gleam@json:float(erlang:element(13, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 415).
?DOC(false).
-spec decode__resource_timing() -> gleam@dynamic@decode:decoder(resource_timing()).
decode__resource_timing() ->
    begin
        gleam@dynamic@decode:field(
            <<"requestTime"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_float/1},
            fun(Request_time) ->
                gleam@dynamic@decode:field(
                    <<"proxyStart"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_float/1},
                    fun(Proxy_start) ->
                        gleam@dynamic@decode:field(
                            <<"proxyEnd"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_float/1},
                            fun(Proxy_end) ->
                                gleam@dynamic@decode:field(
                                    <<"dnsStart"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_float/1},
                                    fun(Dns_start) ->
                                        gleam@dynamic@decode:field(
                                            <<"dnsEnd"/utf8>>,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_float/1},
                                            fun(Dns_end) ->
                                                gleam@dynamic@decode:field(
                                                    <<"connectStart"/utf8>>,
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_float/1},
                                                    fun(Connect_start) ->
                                                        gleam@dynamic@decode:field(
                                                            <<"connectEnd"/utf8>>,
                                                            {decoder,
                                                                fun gleam@dynamic@decode:decode_float/1},
                                                            fun(Connect_end) ->
                                                                gleam@dynamic@decode:field(
                                                                    <<"sslStart"/utf8>>,
                                                                    {decoder,
                                                                        fun gleam@dynamic@decode:decode_float/1},
                                                                    fun(
                                                                        Ssl_start
                                                                    ) ->
                                                                        gleam@dynamic@decode:field(
                                                                            <<"sslEnd"/utf8>>,
                                                                            {decoder,
                                                                                fun gleam@dynamic@decode:decode_float/1},
                                                                            fun(
                                                                                Ssl_end
                                                                            ) ->
                                                                                gleam@dynamic@decode:field(
                                                                                    <<"sendStart"/utf8>>,
                                                                                    {decoder,
                                                                                        fun gleam@dynamic@decode:decode_float/1},
                                                                                    fun(
                                                                                        Send_start
                                                                                    ) ->
                                                                                        gleam@dynamic@decode:field(
                                                                                            <<"sendEnd"/utf8>>,
                                                                                            {decoder,
                                                                                                fun gleam@dynamic@decode:decode_float/1},
                                                                                            fun(
                                                                                                Send_end
                                                                                            ) ->
                                                                                                gleam@dynamic@decode:field(
                                                                                                    <<"receiveHeadersEnd"/utf8>>,
                                                                                                    {decoder,
                                                                                                        fun gleam@dynamic@decode:decode_float/1},
                                                                                                    fun(
                                                                                                        Receive_headers_end
                                                                                                    ) ->
                                                                                                        gleam@dynamic@decode:success(
                                                                                                            {resource_timing,
                                                                                                                Request_time,
                                                                                                                Proxy_start,
                                                                                                                Proxy_end,
                                                                                                                Dns_start,
                                                                                                                Dns_end,
                                                                                                                Connect_start,
                                                                                                                Connect_end,
                                                                                                                Ssl_start,
                                                                                                                Ssl_end,
                                                                                                                Send_start,
                                                                                                                Send_end,
                                                                                                                Receive_headers_end}
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

-file("src\\chrobot_extra\\protocol\\network.gleam", 457).
?DOC(false).
-spec encode__resource_priority(resource_priority()) -> gleam@json:json().
encode__resource_priority(Value__) ->
    _pipe = case Value__ of
        resource_priority_very_low ->
            <<"VeryLow"/utf8>>;

        resource_priority_low ->
            <<"Low"/utf8>>;

        resource_priority_medium ->
            <<"Medium"/utf8>>;

        resource_priority_high ->
            <<"High"/utf8>>;

        resource_priority_very_high ->
            <<"VeryHigh"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\network.gleam", 469).
?DOC(false).
-spec decode__resource_priority() -> gleam@dynamic@decode:decoder(resource_priority()).
decode__resource_priority() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"VeryLow"/utf8>> ->
                        gleam@dynamic@decode:success(resource_priority_very_low);

                    <<"Low"/utf8>> ->
                        gleam@dynamic@decode:success(resource_priority_low);

                    <<"Medium"/utf8>> ->
                        gleam@dynamic@decode:success(resource_priority_medium);

                    <<"High"/utf8>> ->
                        gleam@dynamic@decode:success(resource_priority_high);

                    <<"VeryHigh"/utf8>> ->
                        gleam@dynamic@decode:success(
                            resource_priority_very_high
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            resource_priority_very_low,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 489).
?DOC(false).
-spec encode__post_data_entry(post_data_entry()) -> gleam@json:json().
encode__post_data_entry(Value__) ->
    gleam@json:object(
        begin
            _pipe = [],
            chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(2, Value__),
                fun(Inner_value__) ->
                    {<<"bytes"/utf8>>, gleam@json:string(Inner_value__)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 499).
?DOC(false).
-spec decode__post_data_entry() -> gleam@dynamic@decode:decoder(post_data_entry()).
decode__post_data_entry() ->
    begin
        gleam@dynamic@decode:optional_field(
            <<"bytes"/utf8>>,
            none,
            gleam@dynamic@decode:optional(
                {decoder, fun gleam@dynamic@decode:decode_string/1}
            ),
            fun(Bytes) ->
                gleam@dynamic@decode:success({post_data_entry, Bytes})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 549).
?DOC(false).
-spec encode__request_referrer_policy(request_referrer_policy()) -> gleam@json:json().
encode__request_referrer_policy(Value__) ->
    _pipe = case Value__ of
        request_referrer_policy_unsafe_url ->
            <<"unsafe-url"/utf8>>;

        request_referrer_policy_no_referrer_when_downgrade ->
            <<"no-referrer-when-downgrade"/utf8>>;

        request_referrer_policy_no_referrer ->
            <<"no-referrer"/utf8>>;

        request_referrer_policy_origin ->
            <<"origin"/utf8>>;

        request_referrer_policy_origin_when_cross_origin ->
            <<"origin-when-cross-origin"/utf8>>;

        request_referrer_policy_same_origin ->
            <<"same-origin"/utf8>>;

        request_referrer_policy_strict_origin ->
            <<"strict-origin"/utf8>>;

        request_referrer_policy_strict_origin_when_cross_origin ->
            <<"strict-origin-when-cross-origin"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\network.gleam", 565).
?DOC(false).
-spec decode__request_referrer_policy() -> gleam@dynamic@decode:decoder(request_referrer_policy()).
decode__request_referrer_policy() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"unsafe-url"/utf8>> ->
                        gleam@dynamic@decode:success(
                            request_referrer_policy_unsafe_url
                        );

                    <<"no-referrer-when-downgrade"/utf8>> ->
                        gleam@dynamic@decode:success(
                            request_referrer_policy_no_referrer_when_downgrade
                        );

                    <<"no-referrer"/utf8>> ->
                        gleam@dynamic@decode:success(
                            request_referrer_policy_no_referrer
                        );

                    <<"origin"/utf8>> ->
                        gleam@dynamic@decode:success(
                            request_referrer_policy_origin
                        );

                    <<"origin-when-cross-origin"/utf8>> ->
                        gleam@dynamic@decode:success(
                            request_referrer_policy_origin_when_cross_origin
                        );

                    <<"same-origin"/utf8>> ->
                        gleam@dynamic@decode:success(
                            request_referrer_policy_same_origin
                        );

                    <<"strict-origin"/utf8>> ->
                        gleam@dynamic@decode:success(
                            request_referrer_policy_strict_origin
                        );

                    <<"strict-origin-when-cross-origin"/utf8>> ->
                        gleam@dynamic@decode:success(
                            request_referrer_policy_strict_origin_when_cross_origin
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            request_referrer_policy_unsafe_url,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 586).
?DOC(false).
-spec encode__request(request()) -> gleam@json:json().
encode__request(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"url"/utf8>>,
                    gleam@json:string(erlang:element(2, Value__))},
                {<<"method"/utf8>>,
                    gleam@json:string(erlang:element(4, Value__))},
                {<<"headers"/utf8>>,
                    encode__headers(erlang:element(5, Value__))},
                {<<"initialPriority"/utf8>>,
                    encode__resource_priority(erlang:element(8, Value__))},
                {<<"referrerPolicy"/utf8>>,
                    encode__request_referrer_policy(erlang:element(9, Value__))}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(3, Value__),
                fun(Inner_value__) ->
                    {<<"urlFragment"/utf8>>, gleam@json:string(Inner_value__)}
                end
            ),
            _pipe@2 = chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(6, Value__),
                fun(Inner_value__@1) ->
                    {<<"hasPostData"/utf8>>, gleam@json:bool(Inner_value__@1)}
                end
            ),
            _pipe@3 = chrobot_extra@internal@utils:add_optional(
                _pipe@2,
                erlang:element(7, Value__),
                fun(Inner_value__@2) ->
                    {<<"mixedContentType"/utf8>>,
                        chrobot_extra@protocol@security:encode__mixed_content_type(
                            Inner_value__@2
                        )}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@3,
                erlang:element(10, Value__),
                fun(Inner_value__@3) ->
                    {<<"isLinkPreload"/utf8>>, gleam@json:bool(Inner_value__@3)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 614).
?DOC(false).
-spec decode__request() -> gleam@dynamic@decode:decoder(request()).
decode__request() ->
    begin
        gleam@dynamic@decode:field(
            <<"url"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Url) ->
                gleam@dynamic@decode:optional_field(
                    <<"urlFragment"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(
                        {decoder, fun gleam@dynamic@decode:decode_string/1}
                    ),
                    fun(Url_fragment) ->
                        gleam@dynamic@decode:field(
                            <<"method"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Method) ->
                                gleam@dynamic@decode:field(
                                    <<"headers"/utf8>>,
                                    decode__headers(),
                                    fun(Headers) ->
                                        gleam@dynamic@decode:optional_field(
                                            <<"hasPostData"/utf8>>,
                                            none,
                                            gleam@dynamic@decode:optional(
                                                {decoder,
                                                    fun gleam@dynamic@decode:decode_bool/1}
                                            ),
                                            fun(Has_post_data) ->
                                                gleam@dynamic@decode:optional_field(
                                                    <<"mixedContentType"/utf8>>,
                                                    none,
                                                    gleam@dynamic@decode:optional(
                                                        chrobot_extra@protocol@security:decode__mixed_content_type(
                                                            
                                                        )
                                                    ),
                                                    fun(Mixed_content_type) ->
                                                        gleam@dynamic@decode:field(
                                                            <<"initialPriority"/utf8>>,
                                                            decode__resource_priority(
                                                                
                                                            ),
                                                            fun(
                                                                Initial_priority
                                                            ) ->
                                                                gleam@dynamic@decode:field(
                                                                    <<"referrerPolicy"/utf8>>,
                                                                    decode__request_referrer_policy(
                                                                        
                                                                    ),
                                                                    fun(
                                                                        Referrer_policy
                                                                    ) ->
                                                                        gleam@dynamic@decode:optional_field(
                                                                            <<"isLinkPreload"/utf8>>,
                                                                            none,
                                                                            gleam@dynamic@decode:optional(
                                                                                {decoder,
                                                                                    fun gleam@dynamic@decode:decode_bool/1}
                                                                            ),
                                                                            fun(
                                                                                Is_link_preload
                                                                            ) ->
                                                                                gleam@dynamic@decode:success(
                                                                                    {request,
                                                                                        Url,
                                                                                        Url_fragment,
                                                                                        Method,
                                                                                        Headers,
                                                                                        Has_post_data,
                                                                                        Mixed_content_type,
                                                                                        Initial_priority,
                                                                                        Referrer_policy,
                                                                                        Is_link_preload}
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

-file("src\\chrobot_extra\\protocol\\network.gleam", 686).
?DOC(false).
-spec encode__signed_certificate_timestamp(signed_certificate_timestamp()) -> gleam@json:json().
encode__signed_certificate_timestamp(Value__) ->
    gleam@json:object(
        [{<<"status"/utf8>>, gleam@json:string(erlang:element(2, Value__))},
            {<<"origin"/utf8>>, gleam@json:string(erlang:element(3, Value__))},
            {<<"logDescription"/utf8>>,
                gleam@json:string(erlang:element(4, Value__))},
            {<<"logId"/utf8>>, gleam@json:string(erlang:element(5, Value__))},
            {<<"timestamp"/utf8>>, gleam@json:float(erlang:element(6, Value__))},
            {<<"hashAlgorithm"/utf8>>,
                gleam@json:string(erlang:element(7, Value__))},
            {<<"signatureAlgorithm"/utf8>>,
                gleam@json:string(erlang:element(8, Value__))},
            {<<"signatureData"/utf8>>,
                gleam@json:string(erlang:element(9, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 700).
?DOC(false).
-spec decode__signed_certificate_timestamp() -> gleam@dynamic@decode:decoder(signed_certificate_timestamp()).
decode__signed_certificate_timestamp() ->
    begin
        gleam@dynamic@decode:field(
            <<"status"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Status) ->
                gleam@dynamic@decode:field(
                    <<"origin"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Origin) ->
                        gleam@dynamic@decode:field(
                            <<"logDescription"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Log_description) ->
                                gleam@dynamic@decode:field(
                                    <<"logId"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_string/1},
                                    fun(Log_id) ->
                                        gleam@dynamic@decode:field(
                                            <<"timestamp"/utf8>>,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_float/1},
                                            fun(Timestamp) ->
                                                gleam@dynamic@decode:field(
                                                    <<"hashAlgorithm"/utf8>>,
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_string/1},
                                                    fun(Hash_algorithm) ->
                                                        gleam@dynamic@decode:field(
                                                            <<"signatureAlgorithm"/utf8>>,
                                                            {decoder,
                                                                fun gleam@dynamic@decode:decode_string/1},
                                                            fun(
                                                                Signature_algorithm
                                                            ) ->
                                                                gleam@dynamic@decode:field(
                                                                    <<"signatureData"/utf8>>,
                                                                    {decoder,
                                                                        fun gleam@dynamic@decode:decode_string/1},
                                                                    fun(
                                                                        Signature_data
                                                                    ) ->
                                                                        gleam@dynamic@decode:success(
                                                                            {signed_certificate_timestamp,
                                                                                Status,
                                                                                Origin,
                                                                                Log_description,
                                                                                Log_id,
                                                                                Timestamp,
                                                                                Hash_algorithm,
                                                                                Signature_algorithm,
                                                                                Signature_data}
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

-file("src\\chrobot_extra\\protocol\\network.gleam", 876).
?DOC(false).
-spec encode__certificate_transparency_compliance(
    certificate_transparency_compliance()
) -> gleam@json:json().
encode__certificate_transparency_compliance(Value__) ->
    _pipe = case Value__ of
        certificate_transparency_compliance_unknown ->
            <<"unknown"/utf8>>;

        certificate_transparency_compliance_not_compliant ->
            <<"not-compliant"/utf8>>;

        certificate_transparency_compliance_compliant ->
            <<"compliant"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\network.gleam", 763).
?DOC(false).
-spec encode__security_details(security_details()) -> gleam@json:json().
encode__security_details(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"protocol"/utf8>>,
                    gleam@json:string(erlang:element(2, Value__))},
                {<<"keyExchange"/utf8>>,
                    gleam@json:string(erlang:element(3, Value__))},
                {<<"cipher"/utf8>>,
                    gleam@json:string(erlang:element(5, Value__))},
                {<<"certificateId"/utf8>>,
                    chrobot_extra@protocol@security:encode__certificate_id(
                        erlang:element(7, Value__)
                    )},
                {<<"subjectName"/utf8>>,
                    gleam@json:string(erlang:element(8, Value__))},
                {<<"sanList"/utf8>>,
                    gleam@json:array(
                        erlang:element(9, Value__),
                        fun gleam@json:string/1
                    )},
                {<<"issuer"/utf8>>,
                    gleam@json:string(erlang:element(10, Value__))},
                {<<"validFrom"/utf8>>,
                    encode__time_since_epoch(erlang:element(11, Value__))},
                {<<"validTo"/utf8>>,
                    encode__time_since_epoch(erlang:element(12, Value__))},
                {<<"signedCertificateTimestampList"/utf8>>,
                    gleam@json:array(
                        erlang:element(13, Value__),
                        fun encode__signed_certificate_timestamp/1
                    )},
                {<<"certificateTransparencyCompliance"/utf8>>,
                    encode__certificate_transparency_compliance(
                        erlang:element(14, Value__)
                    )},
                {<<"encryptedClientHello"/utf8>>,
                    gleam@json:bool(erlang:element(16, Value__))}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(4, Value__),
                fun(Inner_value__) ->
                    {<<"keyExchangeGroup"/utf8>>,
                        gleam@json:string(Inner_value__)}
                end
            ),
            _pipe@2 = chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(6, Value__),
                fun(Inner_value__@1) ->
                    {<<"mac"/utf8>>, gleam@json:string(Inner_value__@1)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@2,
                erlang:element(15, Value__),
                fun(Inner_value__@2) ->
                    {<<"serverSignatureAlgorithm"/utf8>>,
                        gleam@json:int(Inner_value__@2)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 888).
?DOC(false).
-spec decode__certificate_transparency_compliance() -> gleam@dynamic@decode:decoder(certificate_transparency_compliance()).
decode__certificate_transparency_compliance() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"unknown"/utf8>> ->
                        gleam@dynamic@decode:success(
                            certificate_transparency_compliance_unknown
                        );

                    <<"not-compliant"/utf8>> ->
                        gleam@dynamic@decode:success(
                            certificate_transparency_compliance_not_compliant
                        );

                    <<"compliant"/utf8>> ->
                        gleam@dynamic@decode:success(
                            certificate_transparency_compliance_compliant
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            certificate_transparency_compliance_unknown,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 806).
?DOC(false).
-spec decode__security_details() -> gleam@dynamic@decode:decoder(security_details()).
decode__security_details() ->
    begin
        gleam@dynamic@decode:field(
            <<"protocol"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Protocol) ->
                gleam@dynamic@decode:field(
                    <<"keyExchange"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Key_exchange) ->
                        gleam@dynamic@decode:optional_field(
                            <<"keyExchangeGroup"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                {decoder,
                                    fun gleam@dynamic@decode:decode_string/1}
                            ),
                            fun(Key_exchange_group) ->
                                gleam@dynamic@decode:field(
                                    <<"cipher"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_string/1},
                                    fun(Cipher) ->
                                        gleam@dynamic@decode:optional_field(
                                            <<"mac"/utf8>>,
                                            none,
                                            gleam@dynamic@decode:optional(
                                                {decoder,
                                                    fun gleam@dynamic@decode:decode_string/1}
                                            ),
                                            fun(Mac) ->
                                                gleam@dynamic@decode:field(
                                                    <<"certificateId"/utf8>>,
                                                    chrobot_extra@protocol@security:decode__certificate_id(
                                                        
                                                    ),
                                                    fun(Certificate_id) ->
                                                        gleam@dynamic@decode:field(
                                                            <<"subjectName"/utf8>>,
                                                            {decoder,
                                                                fun gleam@dynamic@decode:decode_string/1},
                                                            fun(Subject_name) ->
                                                                gleam@dynamic@decode:field(
                                                                    <<"sanList"/utf8>>,
                                                                    gleam@dynamic@decode:list(
                                                                        {decoder,
                                                                            fun gleam@dynamic@decode:decode_string/1}
                                                                    ),
                                                                    fun(
                                                                        San_list
                                                                    ) ->
                                                                        gleam@dynamic@decode:field(
                                                                            <<"issuer"/utf8>>,
                                                                            {decoder,
                                                                                fun gleam@dynamic@decode:decode_string/1},
                                                                            fun(
                                                                                Issuer
                                                                            ) ->
                                                                                gleam@dynamic@decode:field(
                                                                                    <<"validFrom"/utf8>>,
                                                                                    decode__time_since_epoch(
                                                                                        
                                                                                    ),
                                                                                    fun(
                                                                                        Valid_from
                                                                                    ) ->
                                                                                        gleam@dynamic@decode:field(
                                                                                            <<"validTo"/utf8>>,
                                                                                            decode__time_since_epoch(
                                                                                                
                                                                                            ),
                                                                                            fun(
                                                                                                Valid_to
                                                                                            ) ->
                                                                                                gleam@dynamic@decode:field(
                                                                                                    <<"signedCertificateTimestampList"/utf8>>,
                                                                                                    gleam@dynamic@decode:list(
                                                                                                        decode__signed_certificate_timestamp(
                                                                                                            
                                                                                                        )
                                                                                                    ),
                                                                                                    fun(
                                                                                                        Signed_certificate_timestamp_list
                                                                                                    ) ->
                                                                                                        gleam@dynamic@decode:field(
                                                                                                            <<"certificateTransparencyCompliance"/utf8>>,
                                                                                                            decode__certificate_transparency_compliance(
                                                                                                                
                                                                                                            ),
                                                                                                            fun(
                                                                                                                Certificate_transparency_compliance
                                                                                                            ) ->
                                                                                                                gleam@dynamic@decode:optional_field(
                                                                                                                    <<"serverSignatureAlgorithm"/utf8>>,
                                                                                                                    none,
                                                                                                                    gleam@dynamic@decode:optional(
                                                                                                                        {decoder,
                                                                                                                            fun gleam@dynamic@decode:decode_int/1}
                                                                                                                    ),
                                                                                                                    fun(
                                                                                                                        Server_signature_algorithm
                                                                                                                    ) ->
                                                                                                                        gleam@dynamic@decode:field(
                                                                                                                            <<"encryptedClientHello"/utf8>>,
                                                                                                                            {decoder,
                                                                                                                                fun gleam@dynamic@decode:decode_bool/1},
                                                                                                                            fun(
                                                                                                                                Encrypted_client_hello
                                                                                                                            ) ->
                                                                                                                                gleam@dynamic@decode:success(
                                                                                                                                    {security_details,
                                                                                                                                        Protocol,
                                                                                                                                        Key_exchange,
                                                                                                                                        Key_exchange_group,
                                                                                                                                        Cipher,
                                                                                                                                        Mac,
                                                                                                                                        Certificate_id,
                                                                                                                                        Subject_name,
                                                                                                                                        San_list,
                                                                                                                                        Issuer,
                                                                                                                                        Valid_from,
                                                                                                                                        Valid_to,
                                                                                                                                        Signed_certificate_timestamp_list,
                                                                                                                                        Certificate_transparency_compliance,
                                                                                                                                        Server_signature_algorithm,
                                                                                                                                        Encrypted_client_hello}
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

-file("src\\chrobot_extra\\protocol\\network.gleam", 922).
?DOC(false).
-spec encode__blocked_reason(blocked_reason()) -> gleam@json:json().
encode__blocked_reason(Value__) ->
    _pipe = case Value__ of
        blocked_reason_other ->
            <<"other"/utf8>>;

        blocked_reason_csp ->
            <<"csp"/utf8>>;

        blocked_reason_mixed_content ->
            <<"mixed-content"/utf8>>;

        blocked_reason_origin ->
            <<"origin"/utf8>>;

        blocked_reason_inspector ->
            <<"inspector"/utf8>>;

        blocked_reason_subresource_filter ->
            <<"subresource-filter"/utf8>>;

        blocked_reason_content_type ->
            <<"content-type"/utf8>>;

        blocked_reason_coep_frame_resource_needs_coep_header ->
            <<"coep-frame-resource-needs-coep-header"/utf8>>;

        blocked_reason_coop_sandboxed_iframe_cannot_navigate_to_coop_page ->
            <<"coop-sandboxed-iframe-cannot-navigate-to-coop-page"/utf8>>;

        blocked_reason_corp_not_same_origin ->
            <<"corp-not-same-origin"/utf8>>;

        blocked_reason_corp_not_same_origin_after_defaulted_to_same_origin_by_coep ->
            <<"corp-not-same-origin-after-defaulted-to-same-origin-by-coep"/utf8>>;

        blocked_reason_corp_not_same_site ->
            <<"corp-not-same-site"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\network.gleam", 944).
?DOC(false).
-spec decode__blocked_reason() -> gleam@dynamic@decode:decoder(blocked_reason()).
decode__blocked_reason() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"other"/utf8>> ->
                        gleam@dynamic@decode:success(blocked_reason_other);

                    <<"csp"/utf8>> ->
                        gleam@dynamic@decode:success(blocked_reason_csp);

                    <<"mixed-content"/utf8>> ->
                        gleam@dynamic@decode:success(
                            blocked_reason_mixed_content
                        );

                    <<"origin"/utf8>> ->
                        gleam@dynamic@decode:success(blocked_reason_origin);

                    <<"inspector"/utf8>> ->
                        gleam@dynamic@decode:success(blocked_reason_inspector);

                    <<"subresource-filter"/utf8>> ->
                        gleam@dynamic@decode:success(
                            blocked_reason_subresource_filter
                        );

                    <<"content-type"/utf8>> ->
                        gleam@dynamic@decode:success(
                            blocked_reason_content_type
                        );

                    <<"coep-frame-resource-needs-coep-header"/utf8>> ->
                        gleam@dynamic@decode:success(
                            blocked_reason_coep_frame_resource_needs_coep_header
                        );

                    <<"coop-sandboxed-iframe-cannot-navigate-to-coop-page"/utf8>> ->
                        gleam@dynamic@decode:success(
                            blocked_reason_coop_sandboxed_iframe_cannot_navigate_to_coop_page
                        );

                    <<"corp-not-same-origin"/utf8>> ->
                        gleam@dynamic@decode:success(
                            blocked_reason_corp_not_same_origin
                        );

                    <<"corp-not-same-origin-after-defaulted-to-same-origin-by-coep"/utf8>> ->
                        gleam@dynamic@decode:success(
                            blocked_reason_corp_not_same_origin_after_defaulted_to_same_origin_by_coep
                        );

                    <<"corp-not-same-site"/utf8>> ->
                        gleam@dynamic@decode:success(
                            blocked_reason_corp_not_same_site
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            blocked_reason_other,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 1009).
?DOC(false).
-spec encode__cors_error(cors_error()) -> gleam@json:json().
encode__cors_error(Value__) ->
    _pipe = case Value__ of
        cors_error_disallowed_by_mode ->
            <<"DisallowedByMode"/utf8>>;

        cors_error_invalid_response ->
            <<"InvalidResponse"/utf8>>;

        cors_error_wildcard_origin_not_allowed ->
            <<"WildcardOriginNotAllowed"/utf8>>;

        cors_error_missing_allow_origin_header ->
            <<"MissingAllowOriginHeader"/utf8>>;

        cors_error_multiple_allow_origin_values ->
            <<"MultipleAllowOriginValues"/utf8>>;

        cors_error_invalid_allow_origin_value ->
            <<"InvalidAllowOriginValue"/utf8>>;

        cors_error_allow_origin_mismatch ->
            <<"AllowOriginMismatch"/utf8>>;

        cors_error_invalid_allow_credentials ->
            <<"InvalidAllowCredentials"/utf8>>;

        cors_error_cors_disabled_scheme ->
            <<"CorsDisabledScheme"/utf8>>;

        cors_error_preflight_invalid_status ->
            <<"PreflightInvalidStatus"/utf8>>;

        cors_error_preflight_disallowed_redirect ->
            <<"PreflightDisallowedRedirect"/utf8>>;

        cors_error_preflight_wildcard_origin_not_allowed ->
            <<"PreflightWildcardOriginNotAllowed"/utf8>>;

        cors_error_preflight_missing_allow_origin_header ->
            <<"PreflightMissingAllowOriginHeader"/utf8>>;

        cors_error_preflight_multiple_allow_origin_values ->
            <<"PreflightMultipleAllowOriginValues"/utf8>>;

        cors_error_preflight_invalid_allow_origin_value ->
            <<"PreflightInvalidAllowOriginValue"/utf8>>;

        cors_error_preflight_allow_origin_mismatch ->
            <<"PreflightAllowOriginMismatch"/utf8>>;

        cors_error_preflight_invalid_allow_credentials ->
            <<"PreflightInvalidAllowCredentials"/utf8>>;

        cors_error_preflight_missing_allow_external ->
            <<"PreflightMissingAllowExternal"/utf8>>;

        cors_error_preflight_invalid_allow_external ->
            <<"PreflightInvalidAllowExternal"/utf8>>;

        cors_error_preflight_missing_allow_private_network ->
            <<"PreflightMissingAllowPrivateNetwork"/utf8>>;

        cors_error_preflight_invalid_allow_private_network ->
            <<"PreflightInvalidAllowPrivateNetwork"/utf8>>;

        cors_error_invalid_allow_methods_preflight_response ->
            <<"InvalidAllowMethodsPreflightResponse"/utf8>>;

        cors_error_invalid_allow_headers_preflight_response ->
            <<"InvalidAllowHeadersPreflightResponse"/utf8>>;

        cors_error_method_disallowed_by_preflight_response ->
            <<"MethodDisallowedByPreflightResponse"/utf8>>;

        cors_error_header_disallowed_by_preflight_response ->
            <<"HeaderDisallowedByPreflightResponse"/utf8>>;

        cors_error_redirect_contains_credentials ->
            <<"RedirectContainsCredentials"/utf8>>;

        cors_error_insecure_private_network ->
            <<"InsecurePrivateNetwork"/utf8>>;

        cors_error_invalid_private_network_access ->
            <<"InvalidPrivateNetworkAccess"/utf8>>;

        cors_error_unexpected_private_network_access ->
            <<"UnexpectedPrivateNetworkAccess"/utf8>>;

        cors_error_no_cors_redirect_mode_not_follow ->
            <<"NoCorsRedirectModeNotFollow"/utf8>>;

        cors_error_preflight_missing_private_network_access_id ->
            <<"PreflightMissingPrivateNetworkAccessId"/utf8>>;

        cors_error_preflight_missing_private_network_access_name ->
            <<"PreflightMissingPrivateNetworkAccessName"/utf8>>;

        cors_error_private_network_access_permission_unavailable ->
            <<"PrivateNetworkAccessPermissionUnavailable"/utf8>>;

        cors_error_private_network_access_permission_denied ->
            <<"PrivateNetworkAccessPermissionDenied"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\network.gleam", 1065).
?DOC(false).
-spec decode__cors_error() -> gleam@dynamic@decode:decoder(cors_error()).
decode__cors_error() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"DisallowedByMode"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_disallowed_by_mode
                        );

                    <<"InvalidResponse"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_invalid_response
                        );

                    <<"WildcardOriginNotAllowed"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_wildcard_origin_not_allowed
                        );

                    <<"MissingAllowOriginHeader"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_missing_allow_origin_header
                        );

                    <<"MultipleAllowOriginValues"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_multiple_allow_origin_values
                        );

                    <<"InvalidAllowOriginValue"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_invalid_allow_origin_value
                        );

                    <<"AllowOriginMismatch"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_allow_origin_mismatch
                        );

                    <<"InvalidAllowCredentials"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_invalid_allow_credentials
                        );

                    <<"CorsDisabledScheme"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_cors_disabled_scheme
                        );

                    <<"PreflightInvalidStatus"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_preflight_invalid_status
                        );

                    <<"PreflightDisallowedRedirect"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_preflight_disallowed_redirect
                        );

                    <<"PreflightWildcardOriginNotAllowed"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_preflight_wildcard_origin_not_allowed
                        );

                    <<"PreflightMissingAllowOriginHeader"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_preflight_missing_allow_origin_header
                        );

                    <<"PreflightMultipleAllowOriginValues"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_preflight_multiple_allow_origin_values
                        );

                    <<"PreflightInvalidAllowOriginValue"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_preflight_invalid_allow_origin_value
                        );

                    <<"PreflightAllowOriginMismatch"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_preflight_allow_origin_mismatch
                        );

                    <<"PreflightInvalidAllowCredentials"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_preflight_invalid_allow_credentials
                        );

                    <<"PreflightMissingAllowExternal"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_preflight_missing_allow_external
                        );

                    <<"PreflightInvalidAllowExternal"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_preflight_invalid_allow_external
                        );

                    <<"PreflightMissingAllowPrivateNetwork"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_preflight_missing_allow_private_network
                        );

                    <<"PreflightInvalidAllowPrivateNetwork"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_preflight_invalid_allow_private_network
                        );

                    <<"InvalidAllowMethodsPreflightResponse"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_invalid_allow_methods_preflight_response
                        );

                    <<"InvalidAllowHeadersPreflightResponse"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_invalid_allow_headers_preflight_response
                        );

                    <<"MethodDisallowedByPreflightResponse"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_method_disallowed_by_preflight_response
                        );

                    <<"HeaderDisallowedByPreflightResponse"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_header_disallowed_by_preflight_response
                        );

                    <<"RedirectContainsCredentials"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_redirect_contains_credentials
                        );

                    <<"InsecurePrivateNetwork"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_insecure_private_network
                        );

                    <<"InvalidPrivateNetworkAccess"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_invalid_private_network_access
                        );

                    <<"UnexpectedPrivateNetworkAccess"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_unexpected_private_network_access
                        );

                    <<"NoCorsRedirectModeNotFollow"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_no_cors_redirect_mode_not_follow
                        );

                    <<"PreflightMissingPrivateNetworkAccessId"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_preflight_missing_private_network_access_id
                        );

                    <<"PreflightMissingPrivateNetworkAccessName"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_preflight_missing_private_network_access_name
                        );

                    <<"PrivateNetworkAccessPermissionUnavailable"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_private_network_access_permission_unavailable
                        );

                    <<"PrivateNetworkAccessPermissionDenied"/utf8>> ->
                        gleam@dynamic@decode:success(
                            cors_error_private_network_access_permission_denied
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            cors_error_disallowed_by_mode,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 1143).
?DOC(false).
-spec encode__cors_error_status(cors_error_status()) -> gleam@json:json().
encode__cors_error_status(Value__) ->
    gleam@json:object(
        [{<<"corsError"/utf8>>, encode__cors_error(erlang:element(2, Value__))},
            {<<"failedParameter"/utf8>>,
                gleam@json:string(erlang:element(3, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 1151).
?DOC(false).
-spec decode__cors_error_status() -> gleam@dynamic@decode:decoder(cors_error_status()).
decode__cors_error_status() ->
    begin
        gleam@dynamic@decode:field(
            <<"corsError"/utf8>>,
            decode__cors_error(),
            fun(Cors_error) ->
                gleam@dynamic@decode:field(
                    <<"failedParameter"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Failed_parameter) ->
                        gleam@dynamic@decode:success(
                            {cors_error_status, Cors_error, Failed_parameter}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 1172).
?DOC(false).
-spec encode__service_worker_response_source(service_worker_response_source()) -> gleam@json:json().
encode__service_worker_response_source(Value__) ->
    _pipe = case Value__ of
        service_worker_response_source_cache_storage ->
            <<"cache-storage"/utf8>>;

        service_worker_response_source_http_cache ->
            <<"http-cache"/utf8>>;

        service_worker_response_source_fallback_code ->
            <<"fallback-code"/utf8>>;

        service_worker_response_source_network ->
            <<"network"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\network.gleam", 1185).
?DOC(false).
-spec decode__service_worker_response_source() -> gleam@dynamic@decode:decoder(service_worker_response_source()).
decode__service_worker_response_source() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"cache-storage"/utf8>> ->
                        gleam@dynamic@decode:success(
                            service_worker_response_source_cache_storage
                        );

                    <<"http-cache"/utf8>> ->
                        gleam@dynamic@decode:success(
                            service_worker_response_source_http_cache
                        );

                    <<"fallback-code"/utf8>> ->
                        gleam@dynamic@decode:success(
                            service_worker_response_source_fallback_code
                        );

                    <<"network"/utf8>> ->
                        gleam@dynamic@decode:success(
                            service_worker_response_source_network
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            service_worker_response_source_cache_storage,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 1211).
?DOC(false).
-spec encode__service_worker_router_source(service_worker_router_source()) -> gleam@json:json().
encode__service_worker_router_source(Value__) ->
    _pipe = case Value__ of
        service_worker_router_source_network ->
            <<"network"/utf8>>;

        service_worker_router_source_cache ->
            <<"cache"/utf8>>;

        service_worker_router_source_fetch_event ->
            <<"fetch-event"/utf8>>;

        service_worker_router_source_race_network_and_fetch_handler ->
            <<"race-network-and-fetch-handler"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\network.gleam", 1223).
?DOC(false).
-spec decode__service_worker_router_source() -> gleam@dynamic@decode:decoder(service_worker_router_source()).
decode__service_worker_router_source() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"network"/utf8>> ->
                        gleam@dynamic@decode:success(
                            service_worker_router_source_network
                        );

                    <<"cache"/utf8>> ->
                        gleam@dynamic@decode:success(
                            service_worker_router_source_cache
                        );

                    <<"fetch-event"/utf8>> ->
                        gleam@dynamic@decode:success(
                            service_worker_router_source_fetch_event
                        );

                    <<"race-network-and-fetch-handler"/utf8>> ->
                        gleam@dynamic@decode:success(
                            service_worker_router_source_race_network_and_fetch_handler
                        );

                    _ ->
                        gleam@dynamic@decode:failure(
                            service_worker_router_source_network,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 1291).
?DOC(false).
-spec encode__response(response()) -> gleam@json:json().
encode__response(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"url"/utf8>>,
                    gleam@json:string(erlang:element(2, Value__))},
                {<<"status"/utf8>>, gleam@json:int(erlang:element(3, Value__))},
                {<<"statusText"/utf8>>,
                    gleam@json:string(erlang:element(4, Value__))},
                {<<"headers"/utf8>>,
                    encode__headers(erlang:element(5, Value__))},
                {<<"mimeType"/utf8>>,
                    gleam@json:string(erlang:element(6, Value__))},
                {<<"charset"/utf8>>,
                    gleam@json:string(erlang:element(7, Value__))},
                {<<"connectionReused"/utf8>>,
                    gleam@json:bool(erlang:element(9, Value__))},
                {<<"connectionId"/utf8>>,
                    gleam@json:float(erlang:element(10, Value__))},
                {<<"encodedDataLength"/utf8>>,
                    gleam@json:float(erlang:element(17, Value__))},
                {<<"securityState"/utf8>>,
                    chrobot_extra@protocol@security:encode__security_state(
                        erlang:element(23, Value__)
                    )}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(8, Value__),
                fun(Inner_value__) ->
                    {<<"requestHeaders"/utf8>>, encode__headers(Inner_value__)}
                end
            ),
            _pipe@2 = chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(11, Value__),
                fun(Inner_value__@1) ->
                    {<<"remoteIPAddress"/utf8>>,
                        gleam@json:string(Inner_value__@1)}
                end
            ),
            _pipe@3 = chrobot_extra@internal@utils:add_optional(
                _pipe@2,
                erlang:element(12, Value__),
                fun(Inner_value__@2) ->
                    {<<"remotePort"/utf8>>, gleam@json:int(Inner_value__@2)}
                end
            ),
            _pipe@4 = chrobot_extra@internal@utils:add_optional(
                _pipe@3,
                erlang:element(13, Value__),
                fun(Inner_value__@3) ->
                    {<<"fromDiskCache"/utf8>>, gleam@json:bool(Inner_value__@3)}
                end
            ),
            _pipe@5 = chrobot_extra@internal@utils:add_optional(
                _pipe@4,
                erlang:element(14, Value__),
                fun(Inner_value__@4) ->
                    {<<"fromServiceWorker"/utf8>>,
                        gleam@json:bool(Inner_value__@4)}
                end
            ),
            _pipe@6 = chrobot_extra@internal@utils:add_optional(
                _pipe@5,
                erlang:element(15, Value__),
                fun(Inner_value__@5) ->
                    {<<"fromPrefetchCache"/utf8>>,
                        gleam@json:bool(Inner_value__@5)}
                end
            ),
            _pipe@7 = chrobot_extra@internal@utils:add_optional(
                _pipe@6,
                erlang:element(16, Value__),
                fun(Inner_value__@6) ->
                    {<<"fromEarlyHints"/utf8>>,
                        gleam@json:bool(Inner_value__@6)}
                end
            ),
            _pipe@8 = chrobot_extra@internal@utils:add_optional(
                _pipe@7,
                erlang:element(18, Value__),
                fun(Inner_value__@7) ->
                    {<<"timing"/utf8>>,
                        encode__resource_timing(Inner_value__@7)}
                end
            ),
            _pipe@9 = chrobot_extra@internal@utils:add_optional(
                _pipe@8,
                erlang:element(19, Value__),
                fun(Inner_value__@8) ->
                    {<<"serviceWorkerResponseSource"/utf8>>,
                        encode__service_worker_response_source(Inner_value__@8)}
                end
            ),
            _pipe@10 = chrobot_extra@internal@utils:add_optional(
                _pipe@9,
                erlang:element(20, Value__),
                fun(Inner_value__@9) ->
                    {<<"responseTime"/utf8>>,
                        encode__time_since_epoch(Inner_value__@9)}
                end
            ),
            _pipe@11 = chrobot_extra@internal@utils:add_optional(
                _pipe@10,
                erlang:element(21, Value__),
                fun(Inner_value__@10) ->
                    {<<"cacheStorageCacheName"/utf8>>,
                        gleam@json:string(Inner_value__@10)}
                end
            ),
            _pipe@12 = chrobot_extra@internal@utils:add_optional(
                _pipe@11,
                erlang:element(22, Value__),
                fun(Inner_value__@11) ->
                    {<<"protocol"/utf8>>, gleam@json:string(Inner_value__@11)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@12,
                erlang:element(24, Value__),
                fun(Inner_value__@12) ->
                    {<<"securityDetails"/utf8>>,
                        encode__security_details(Inner_value__@12)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 1357).
?DOC(false).
-spec decode__response() -> gleam@dynamic@decode:decoder(response()).
decode__response() ->
    begin
        gleam@dynamic@decode:field(
            <<"url"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Url) ->
                gleam@dynamic@decode:field(
                    <<"status"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_int/1},
                    fun(Status) ->
                        gleam@dynamic@decode:field(
                            <<"statusText"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Status_text) ->
                                gleam@dynamic@decode:field(
                                    <<"headers"/utf8>>,
                                    decode__headers(),
                                    fun(Headers) ->
                                        gleam@dynamic@decode:field(
                                            <<"mimeType"/utf8>>,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_string/1},
                                            fun(Mime_type) ->
                                                gleam@dynamic@decode:field(
                                                    <<"charset"/utf8>>,
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_string/1},
                                                    fun(Charset) ->
                                                        gleam@dynamic@decode:optional_field(
                                                            <<"requestHeaders"/utf8>>,
                                                            none,
                                                            gleam@dynamic@decode:optional(
                                                                decode__headers(
                                                                    
                                                                )
                                                            ),
                                                            fun(Request_headers) ->
                                                                gleam@dynamic@decode:field(
                                                                    <<"connectionReused"/utf8>>,
                                                                    {decoder,
                                                                        fun gleam@dynamic@decode:decode_bool/1},
                                                                    fun(
                                                                        Connection_reused
                                                                    ) ->
                                                                        gleam@dynamic@decode:field(
                                                                            <<"connectionId"/utf8>>,
                                                                            {decoder,
                                                                                fun gleam@dynamic@decode:decode_float/1},
                                                                            fun(
                                                                                Connection_id
                                                                            ) ->
                                                                                gleam@dynamic@decode:optional_field(
                                                                                    <<"remoteIPAddress"/utf8>>,
                                                                                    none,
                                                                                    gleam@dynamic@decode:optional(
                                                                                        {decoder,
                                                                                            fun gleam@dynamic@decode:decode_string/1}
                                                                                    ),
                                                                                    fun(
                                                                                        Remote_ip_address
                                                                                    ) ->
                                                                                        gleam@dynamic@decode:optional_field(
                                                                                            <<"remotePort"/utf8>>,
                                                                                            none,
                                                                                            gleam@dynamic@decode:optional(
                                                                                                {decoder,
                                                                                                    fun gleam@dynamic@decode:decode_int/1}
                                                                                            ),
                                                                                            fun(
                                                                                                Remote_port
                                                                                            ) ->
                                                                                                gleam@dynamic@decode:optional_field(
                                                                                                    <<"fromDiskCache"/utf8>>,
                                                                                                    none,
                                                                                                    gleam@dynamic@decode:optional(
                                                                                                        {decoder,
                                                                                                            fun gleam@dynamic@decode:decode_bool/1}
                                                                                                    ),
                                                                                                    fun(
                                                                                                        From_disk_cache
                                                                                                    ) ->
                                                                                                        gleam@dynamic@decode:optional_field(
                                                                                                            <<"fromServiceWorker"/utf8>>,
                                                                                                            none,
                                                                                                            gleam@dynamic@decode:optional(
                                                                                                                {decoder,
                                                                                                                    fun gleam@dynamic@decode:decode_bool/1}
                                                                                                            ),
                                                                                                            fun(
                                                                                                                From_service_worker
                                                                                                            ) ->
                                                                                                                gleam@dynamic@decode:optional_field(
                                                                                                                    <<"fromPrefetchCache"/utf8>>,
                                                                                                                    none,
                                                                                                                    gleam@dynamic@decode:optional(
                                                                                                                        {decoder,
                                                                                                                            fun gleam@dynamic@decode:decode_bool/1}
                                                                                                                    ),
                                                                                                                    fun(
                                                                                                                        From_prefetch_cache
                                                                                                                    ) ->
                                                                                                                        gleam@dynamic@decode:optional_field(
                                                                                                                            <<"fromEarlyHints"/utf8>>,
                                                                                                                            none,
                                                                                                                            gleam@dynamic@decode:optional(
                                                                                                                                {decoder,
                                                                                                                                    fun gleam@dynamic@decode:decode_bool/1}
                                                                                                                            ),
                                                                                                                            fun(
                                                                                                                                From_early_hints
                                                                                                                            ) ->
                                                                                                                                gleam@dynamic@decode:field(
                                                                                                                                    <<"encodedDataLength"/utf8>>,
                                                                                                                                    {decoder,
                                                                                                                                        fun gleam@dynamic@decode:decode_float/1},
                                                                                                                                    fun(
                                                                                                                                        Encoded_data_length
                                                                                                                                    ) ->
                                                                                                                                        gleam@dynamic@decode:optional_field(
                                                                                                                                            <<"timing"/utf8>>,
                                                                                                                                            none,
                                                                                                                                            gleam@dynamic@decode:optional(
                                                                                                                                                decode__resource_timing(
                                                                                                                                                    
                                                                                                                                                )
                                                                                                                                            ),
                                                                                                                                            fun(
                                                                                                                                                Timing
                                                                                                                                            ) ->
                                                                                                                                                gleam@dynamic@decode:optional_field(
                                                                                                                                                    <<"serviceWorkerResponseSource"/utf8>>,
                                                                                                                                                    none,
                                                                                                                                                    gleam@dynamic@decode:optional(
                                                                                                                                                        decode__service_worker_response_source(
                                                                                                                                                            
                                                                                                                                                        )
                                                                                                                                                    ),
                                                                                                                                                    fun(
                                                                                                                                                        Service_worker_response_source
                                                                                                                                                    ) ->
                                                                                                                                                        gleam@dynamic@decode:optional_field(
                                                                                                                                                            <<"responseTime"/utf8>>,
                                                                                                                                                            none,
                                                                                                                                                            gleam@dynamic@decode:optional(
                                                                                                                                                                decode__time_since_epoch(
                                                                                                                                                                    
                                                                                                                                                                )
                                                                                                                                                            ),
                                                                                                                                                            fun(
                                                                                                                                                                Response_time
                                                                                                                                                            ) ->
                                                                                                                                                                gleam@dynamic@decode:optional_field(
                                                                                                                                                                    <<"cacheStorageCacheName"/utf8>>,
                                                                                                                                                                    none,
                                                                                                                                                                    gleam@dynamic@decode:optional(
                                                                                                                                                                        {decoder,
                                                                                                                                                                            fun gleam@dynamic@decode:decode_string/1}
                                                                                                                                                                    ),
                                                                                                                                                                    fun(
                                                                                                                                                                        Cache_storage_cache_name
                                                                                                                                                                    ) ->
                                                                                                                                                                        gleam@dynamic@decode:optional_field(
                                                                                                                                                                            <<"protocol"/utf8>>,
                                                                                                                                                                            none,
                                                                                                                                                                            gleam@dynamic@decode:optional(
                                                                                                                                                                                {decoder,
                                                                                                                                                                                    fun gleam@dynamic@decode:decode_string/1}
                                                                                                                                                                            ),
                                                                                                                                                                            fun(
                                                                                                                                                                                Protocol
                                                                                                                                                                            ) ->
                                                                                                                                                                                gleam@dynamic@decode:field(
                                                                                                                                                                                    <<"securityState"/utf8>>,
                                                                                                                                                                                    chrobot_extra@protocol@security:decode__security_state(
                                                                                                                                                                                        
                                                                                                                                                                                    ),
                                                                                                                                                                                    fun(
                                                                                                                                                                                        Security_state
                                                                                                                                                                                    ) ->
                                                                                                                                                                                        gleam@dynamic@decode:optional_field(
                                                                                                                                                                                            <<"securityDetails"/utf8>>,
                                                                                                                                                                                            none,
                                                                                                                                                                                            gleam@dynamic@decode:optional(
                                                                                                                                                                                                decode__security_details(
                                                                                                                                                                                                    
                                                                                                                                                                                                )
                                                                                                                                                                                            ),
                                                                                                                                                                                            fun(
                                                                                                                                                                                                Security_details
                                                                                                                                                                                            ) ->
                                                                                                                                                                                                gleam@dynamic@decode:success(
                                                                                                                                                                                                    {response,
                                                                                                                                                                                                        Url,
                                                                                                                                                                                                        Status,
                                                                                                                                                                                                        Status_text,
                                                                                                                                                                                                        Headers,
                                                                                                                                                                                                        Mime_type,
                                                                                                                                                                                                        Charset,
                                                                                                                                                                                                        Request_headers,
                                                                                                                                                                                                        Connection_reused,
                                                                                                                                                                                                        Connection_id,
                                                                                                                                                                                                        Remote_ip_address,
                                                                                                                                                                                                        Remote_port,
                                                                                                                                                                                                        From_disk_cache,
                                                                                                                                                                                                        From_service_worker,
                                                                                                                                                                                                        From_prefetch_cache,
                                                                                                                                                                                                        From_early_hints,
                                                                                                                                                                                                        Encoded_data_length,
                                                                                                                                                                                                        Timing,
                                                                                                                                                                                                        Service_worker_response_source,
                                                                                                                                                                                                        Response_time,
                                                                                                                                                                                                        Cache_storage_cache_name,
                                                                                                                                                                                                        Protocol,
                                                                                                                                                                                                        Security_state,
                                                                                                                                                                                                        Security_details}
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

-file("src\\chrobot_extra\\protocol\\network.gleam", 1475).
?DOC(false).
-spec encode__web_socket_request(web_socket_request()) -> gleam@json:json().
encode__web_socket_request(Value__) ->
    gleam@json:object(
        [{<<"headers"/utf8>>, encode__headers(erlang:element(2, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 1482).
?DOC(false).
-spec decode__web_socket_request() -> gleam@dynamic@decode:decoder(web_socket_request()).
decode__web_socket_request() ->
    begin
        gleam@dynamic@decode:field(
            <<"headers"/utf8>>,
            decode__headers(),
            fun(Headers) ->
                gleam@dynamic@decode:success({web_socket_request, Headers})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 1509).
?DOC(false).
-spec encode__web_socket_response(web_socket_response()) -> gleam@json:json().
encode__web_socket_response(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"status"/utf8>>,
                    gleam@json:int(erlang:element(2, Value__))},
                {<<"statusText"/utf8>>,
                    gleam@json:string(erlang:element(3, Value__))},
                {<<"headers"/utf8>>,
                    encode__headers(erlang:element(4, Value__))}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(5, Value__),
                fun(Inner_value__) ->
                    {<<"headersText"/utf8>>, gleam@json:string(Inner_value__)}
                end
            ),
            _pipe@2 = chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(6, Value__),
                fun(Inner_value__@1) ->
                    {<<"requestHeaders"/utf8>>,
                        encode__headers(Inner_value__@1)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@2,
                erlang:element(7, Value__),
                fun(Inner_value__@2) ->
                    {<<"requestHeadersText"/utf8>>,
                        gleam@json:string(Inner_value__@2)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 1529).
?DOC(false).
-spec decode__web_socket_response() -> gleam@dynamic@decode:decoder(web_socket_response()).
decode__web_socket_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"status"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Status) ->
                gleam@dynamic@decode:field(
                    <<"statusText"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Status_text) ->
                        gleam@dynamic@decode:field(
                            <<"headers"/utf8>>,
                            decode__headers(),
                            fun(Headers) ->
                                gleam@dynamic@decode:optional_field(
                                    <<"headersText"/utf8>>,
                                    none,
                                    gleam@dynamic@decode:optional(
                                        {decoder,
                                            fun gleam@dynamic@decode:decode_string/1}
                                    ),
                                    fun(Headers_text) ->
                                        gleam@dynamic@decode:optional_field(
                                            <<"requestHeaders"/utf8>>,
                                            none,
                                            gleam@dynamic@decode:optional(
                                                decode__headers()
                                            ),
                                            fun(Request_headers) ->
                                                gleam@dynamic@decode:optional_field(
                                                    <<"requestHeadersText"/utf8>>,
                                                    none,
                                                    gleam@dynamic@decode:optional(
                                                        {decoder,
                                                            fun gleam@dynamic@decode:decode_string/1}
                                                    ),
                                                    fun(Request_headers_text) ->
                                                        gleam@dynamic@decode:success(
                                                            {web_socket_response,
                                                                Status,
                                                                Status_text,
                                                                Headers,
                                                                Headers_text,
                                                                Request_headers,
                                                                Request_headers_text}
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

-file("src\\chrobot_extra\\protocol\\network.gleam", 1576).
?DOC(false).
-spec encode__web_socket_frame(web_socket_frame()) -> gleam@json:json().
encode__web_socket_frame(Value__) ->
    gleam@json:object(
        [{<<"opcode"/utf8>>, gleam@json:float(erlang:element(2, Value__))},
            {<<"mask"/utf8>>, gleam@json:bool(erlang:element(3, Value__))},
            {<<"payloadData"/utf8>>,
                gleam@json:string(erlang:element(4, Value__))}]
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 1585).
?DOC(false).
-spec decode__web_socket_frame() -> gleam@dynamic@decode:decoder(web_socket_frame()).
decode__web_socket_frame() ->
    begin
        gleam@dynamic@decode:field(
            <<"opcode"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_float/1},
            fun(Opcode) ->
                gleam@dynamic@decode:field(
                    <<"mask"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_bool/1},
                    fun(Mask) ->
                        gleam@dynamic@decode:field(
                            <<"payloadData"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Payload_data) ->
                                gleam@dynamic@decode:success(
                                    {web_socket_frame,
                                        Opcode,
                                        Mask,
                                        Payload_data}
                                )
                            end
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 1614).
?DOC(false).
-spec encode__cached_resource(cached_resource()) -> gleam@json:json().
encode__cached_resource(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"url"/utf8>>,
                    gleam@json:string(erlang:element(2, Value__))},
                {<<"type"/utf8>>,
                    encode__resource_type(erlang:element(3, Value__))},
                {<<"bodySize"/utf8>>,
                    gleam@json:float(erlang:element(5, Value__))}],
            chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(4, Value__),
                fun(Inner_value__) ->
                    {<<"response"/utf8>>, encode__response(Inner_value__)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 1628).
?DOC(false).
-spec decode__cached_resource() -> gleam@dynamic@decode:decoder(cached_resource()).
decode__cached_resource() ->
    begin
        gleam@dynamic@decode:field(
            <<"url"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Url) ->
                gleam@dynamic@decode:field(
                    <<"type"/utf8>>,
                    decode__resource_type(),
                    fun(Type_) ->
                        gleam@dynamic@decode:optional_field(
                            <<"response"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(decode__response()),
                            fun(Response) ->
                                gleam@dynamic@decode:field(
                                    <<"bodySize"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_float/1},
                                    fun(Body_size) ->
                                        gleam@dynamic@decode:success(
                                            {cached_resource,
                                                Url,
                                                Type_,
                                                Response,
                                                Body_size}
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

-file("src\\chrobot_extra\\protocol\\network.gleam", 1680).
?DOC(false).
-spec encode__initiator_type(initiator_type()) -> gleam@json:json().
encode__initiator_type(Value__) ->
    _pipe = case Value__ of
        initiator_type_parser ->
            <<"parser"/utf8>>;

        initiator_type_script ->
            <<"script"/utf8>>;

        initiator_type_preload ->
            <<"preload"/utf8>>;

        initiator_type_signed_exchange ->
            <<"SignedExchange"/utf8>>;

        initiator_type_preflight ->
            <<"preflight"/utf8>>;

        initiator_type_other ->
            <<"other"/utf8>>
    end,
    gleam@json:string(_pipe).

-file("src\\chrobot_extra\\protocol\\network.gleam", 1693).
?DOC(false).
-spec decode__initiator_type() -> gleam@dynamic@decode:decoder(initiator_type()).
decode__initiator_type() ->
    begin
        gleam@dynamic@decode:then(
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Value__) -> case Value__ of
                    <<"parser"/utf8>> ->
                        gleam@dynamic@decode:success(initiator_type_parser);

                    <<"script"/utf8>> ->
                        gleam@dynamic@decode:success(initiator_type_script);

                    <<"preload"/utf8>> ->
                        gleam@dynamic@decode:success(initiator_type_preload);

                    <<"SignedExchange"/utf8>> ->
                        gleam@dynamic@decode:success(
                            initiator_type_signed_exchange
                        );

                    <<"preflight"/utf8>> ->
                        gleam@dynamic@decode:success(initiator_type_preflight);

                    <<"other"/utf8>> ->
                        gleam@dynamic@decode:success(initiator_type_other);

                    _ ->
                        gleam@dynamic@decode:failure(
                            initiator_type_parser,
                            <<"valid enum property"/utf8>>
                        )
                end end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 1709).
?DOC(false).
-spec encode__initiator(initiator()) -> gleam@json:json().
encode__initiator(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"type"/utf8>>,
                    encode__initiator_type(erlang:element(2, Value__))}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(3, Value__),
                fun(Inner_value__) ->
                    {<<"stack"/utf8>>,
                        chrobot_extra@protocol@runtime:encode__stack_trace(
                            Inner_value__
                        )}
                end
            ),
            _pipe@2 = chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(4, Value__),
                fun(Inner_value__@1) ->
                    {<<"url"/utf8>>, gleam@json:string(Inner_value__@1)}
                end
            ),
            _pipe@3 = chrobot_extra@internal@utils:add_optional(
                _pipe@2,
                erlang:element(5, Value__),
                fun(Inner_value__@2) ->
                    {<<"lineNumber"/utf8>>, gleam@json:float(Inner_value__@2)}
                end
            ),
            _pipe@4 = chrobot_extra@internal@utils:add_optional(
                _pipe@3,
                erlang:element(6, Value__),
                fun(Inner_value__@3) ->
                    {<<"columnNumber"/utf8>>, gleam@json:float(Inner_value__@3)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@4,
                erlang:element(7, Value__),
                fun(Inner_value__@4) ->
                    {<<"requestId"/utf8>>, encode__request_id(Inner_value__@4)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 1733).
?DOC(false).
-spec decode__initiator() -> gleam@dynamic@decode:decoder(initiator()).
decode__initiator() ->
    begin
        gleam@dynamic@decode:field(
            <<"type"/utf8>>,
            decode__initiator_type(),
            fun(Type_) ->
                gleam@dynamic@decode:optional_field(
                    <<"stack"/utf8>>,
                    none,
                    gleam@dynamic@decode:optional(
                        chrobot_extra@protocol@runtime:decode__stack_trace()
                    ),
                    fun(Stack) ->
                        gleam@dynamic@decode:optional_field(
                            <<"url"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                {decoder,
                                    fun gleam@dynamic@decode:decode_string/1}
                            ),
                            fun(Url) ->
                                gleam@dynamic@decode:optional_field(
                                    <<"lineNumber"/utf8>>,
                                    none,
                                    gleam@dynamic@decode:optional(
                                        {decoder,
                                            fun gleam@dynamic@decode:decode_float/1}
                                    ),
                                    fun(Line_number) ->
                                        gleam@dynamic@decode:optional_field(
                                            <<"columnNumber"/utf8>>,
                                            none,
                                            gleam@dynamic@decode:optional(
                                                {decoder,
                                                    fun gleam@dynamic@decode:decode_float/1}
                                            ),
                                            fun(Column_number) ->
                                                gleam@dynamic@decode:optional_field(
                                                    <<"requestId"/utf8>>,
                                                    none,
                                                    gleam@dynamic@decode:optional(
                                                        decode__request_id()
                                                    ),
                                                    fun(Request_id) ->
                                                        gleam@dynamic@decode:success(
                                                            {initiator,
                                                                Type_,
                                                                Stack,
                                                                Url,
                                                                Line_number,
                                                                Column_number,
                                                                Request_id}
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

-file("src\\chrobot_extra\\protocol\\network.gleam", 1800).
?DOC(false).
-spec encode__cookie(cookie()) -> gleam@json:json().
encode__cookie(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"name"/utf8>>,
                    gleam@json:string(erlang:element(2, Value__))},
                {<<"value"/utf8>>,
                    gleam@json:string(erlang:element(3, Value__))},
                {<<"domain"/utf8>>,
                    gleam@json:string(erlang:element(4, Value__))},
                {<<"path"/utf8>>, gleam@json:string(erlang:element(5, Value__))},
                {<<"expires"/utf8>>,
                    gleam@json:float(erlang:element(6, Value__))},
                {<<"size"/utf8>>, gleam@json:int(erlang:element(7, Value__))},
                {<<"httpOnly"/utf8>>,
                    gleam@json:bool(erlang:element(8, Value__))},
                {<<"secure"/utf8>>, gleam@json:bool(erlang:element(9, Value__))},
                {<<"session"/utf8>>,
                    gleam@json:bool(erlang:element(10, Value__))}],
            chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(11, Value__),
                fun(Inner_value__) ->
                    {<<"sameSite"/utf8>>,
                        encode__cookie_same_site(Inner_value__)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 1820).
?DOC(false).
-spec decode__cookie() -> gleam@dynamic@decode:decoder(cookie()).
decode__cookie() ->
    begin
        gleam@dynamic@decode:field(
            <<"name"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Name) ->
                gleam@dynamic@decode:field(
                    <<"value"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Value) ->
                        gleam@dynamic@decode:field(
                            <<"domain"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Domain) ->
                                gleam@dynamic@decode:field(
                                    <<"path"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_string/1},
                                    fun(Path) ->
                                        gleam@dynamic@decode:field(
                                            <<"expires"/utf8>>,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_float/1},
                                            fun(Expires) ->
                                                gleam@dynamic@decode:field(
                                                    <<"size"/utf8>>,
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_int/1},
                                                    fun(Size) ->
                                                        gleam@dynamic@decode:field(
                                                            <<"httpOnly"/utf8>>,
                                                            {decoder,
                                                                fun gleam@dynamic@decode:decode_bool/1},
                                                            fun(Http_only) ->
                                                                gleam@dynamic@decode:field(
                                                                    <<"secure"/utf8>>,
                                                                    {decoder,
                                                                        fun gleam@dynamic@decode:decode_bool/1},
                                                                    fun(Secure) ->
                                                                        gleam@dynamic@decode:field(
                                                                            <<"session"/utf8>>,
                                                                            {decoder,
                                                                                fun gleam@dynamic@decode:decode_bool/1},
                                                                            fun(
                                                                                Session
                                                                            ) ->
                                                                                gleam@dynamic@decode:optional_field(
                                                                                    <<"sameSite"/utf8>>,
                                                                                    none,
                                                                                    gleam@dynamic@decode:optional(
                                                                                        decode__cookie_same_site(
                                                                                            
                                                                                        )
                                                                                    ),
                                                                                    fun(
                                                                                        Same_site
                                                                                    ) ->
                                                                                        gleam@dynamic@decode:success(
                                                                                            {cookie,
                                                                                                Name,
                                                                                                Value,
                                                                                                Domain,
                                                                                                Path,
                                                                                                Expires,
                                                                                                Size,
                                                                                                Http_only,
                                                                                                Secure,
                                                                                                Session,
                                                                                                Same_site}
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

-file("src\\chrobot_extra\\protocol\\network.gleam", 1878).
?DOC(false).
-spec encode__cookie_param(cookie_param()) -> gleam@json:json().
encode__cookie_param(Value__) ->
    gleam@json:object(
        begin
            _pipe = [{<<"name"/utf8>>,
                    gleam@json:string(erlang:element(2, Value__))},
                {<<"value"/utf8>>,
                    gleam@json:string(erlang:element(3, Value__))}],
            _pipe@1 = chrobot_extra@internal@utils:add_optional(
                _pipe,
                erlang:element(4, Value__),
                fun(Inner_value__) ->
                    {<<"url"/utf8>>, gleam@json:string(Inner_value__)}
                end
            ),
            _pipe@2 = chrobot_extra@internal@utils:add_optional(
                _pipe@1,
                erlang:element(5, Value__),
                fun(Inner_value__@1) ->
                    {<<"domain"/utf8>>, gleam@json:string(Inner_value__@1)}
                end
            ),
            _pipe@3 = chrobot_extra@internal@utils:add_optional(
                _pipe@2,
                erlang:element(6, Value__),
                fun(Inner_value__@2) ->
                    {<<"path"/utf8>>, gleam@json:string(Inner_value__@2)}
                end
            ),
            _pipe@4 = chrobot_extra@internal@utils:add_optional(
                _pipe@3,
                erlang:element(7, Value__),
                fun(Inner_value__@3) ->
                    {<<"secure"/utf8>>, gleam@json:bool(Inner_value__@3)}
                end
            ),
            _pipe@5 = chrobot_extra@internal@utils:add_optional(
                _pipe@4,
                erlang:element(8, Value__),
                fun(Inner_value__@4) ->
                    {<<"httpOnly"/utf8>>, gleam@json:bool(Inner_value__@4)}
                end
            ),
            _pipe@6 = chrobot_extra@internal@utils:add_optional(
                _pipe@5,
                erlang:element(9, Value__),
                fun(Inner_value__@5) ->
                    {<<"sameSite"/utf8>>,
                        encode__cookie_same_site(Inner_value__@5)}
                end
            ),
            chrobot_extra@internal@utils:add_optional(
                _pipe@6,
                erlang:element(10, Value__),
                fun(Inner_value__@6) ->
                    {<<"expires"/utf8>>,
                        encode__time_since_epoch(Inner_value__@6)}
                end
            )
        end
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 1909).
?DOC(false).
-spec decode__cookie_param() -> gleam@dynamic@decode:decoder(cookie_param()).
decode__cookie_param() ->
    begin
        gleam@dynamic@decode:field(
            <<"name"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Name) ->
                gleam@dynamic@decode:field(
                    <<"value"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Value) ->
                        gleam@dynamic@decode:optional_field(
                            <<"url"/utf8>>,
                            none,
                            gleam@dynamic@decode:optional(
                                {decoder,
                                    fun gleam@dynamic@decode:decode_string/1}
                            ),
                            fun(Url) ->
                                gleam@dynamic@decode:optional_field(
                                    <<"domain"/utf8>>,
                                    none,
                                    gleam@dynamic@decode:optional(
                                        {decoder,
                                            fun gleam@dynamic@decode:decode_string/1}
                                    ),
                                    fun(Domain) ->
                                        gleam@dynamic@decode:optional_field(
                                            <<"path"/utf8>>,
                                            none,
                                            gleam@dynamic@decode:optional(
                                                {decoder,
                                                    fun gleam@dynamic@decode:decode_string/1}
                                            ),
                                            fun(Path) ->
                                                gleam@dynamic@decode:optional_field(
                                                    <<"secure"/utf8>>,
                                                    none,
                                                    gleam@dynamic@decode:optional(
                                                        {decoder,
                                                            fun gleam@dynamic@decode:decode_bool/1}
                                                    ),
                                                    fun(Secure) ->
                                                        gleam@dynamic@decode:optional_field(
                                                            <<"httpOnly"/utf8>>,
                                                            none,
                                                            gleam@dynamic@decode:optional(
                                                                {decoder,
                                                                    fun gleam@dynamic@decode:decode_bool/1}
                                                            ),
                                                            fun(Http_only) ->
                                                                gleam@dynamic@decode:optional_field(
                                                                    <<"sameSite"/utf8>>,
                                                                    none,
                                                                    gleam@dynamic@decode:optional(
                                                                        decode__cookie_same_site(
                                                                            
                                                                        )
                                                                    ),
                                                                    fun(
                                                                        Same_site
                                                                    ) ->
                                                                        gleam@dynamic@decode:optional_field(
                                                                            <<"expires"/utf8>>,
                                                                            none,
                                                                            gleam@dynamic@decode:optional(
                                                                                decode__time_since_epoch(
                                                                                    
                                                                                )
                                                                            ),
                                                                            fun(
                                                                                Expires
                                                                            ) ->
                                                                                gleam@dynamic@decode:success(
                                                                                    {cookie_param,
                                                                                        Name,
                                                                                        Value,
                                                                                        Url,
                                                                                        Domain,
                                                                                        Path,
                                                                                        Secure,
                                                                                        Http_only,
                                                                                        Same_site,
                                                                                        Expires}
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

-file("src\\chrobot_extra\\protocol\\network.gleam", 1973).
?DOC(false).
-spec decode__get_cookies_response() -> gleam@dynamic@decode:decoder(get_cookies_response()).
decode__get_cookies_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"cookies"/utf8>>,
            gleam@dynamic@decode:list(decode__cookie()),
            fun(Cookies) ->
                gleam@dynamic@decode:success({get_cookies_response, Cookies})
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 1993).
?DOC(false).
-spec decode__get_response_body_response() -> gleam@dynamic@decode:decoder(get_response_body_response()).
decode__get_response_body_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"body"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Body) ->
                gleam@dynamic@decode:field(
                    <<"base64Encoded"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_bool/1},
                    fun(Base64_encoded) ->
                        gleam@dynamic@decode:success(
                            {get_response_body_response, Body, Base64_encoded}
                        )
                    end
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 2015).
?DOC(false).
-spec decode__get_request_post_data_response() -> gleam@dynamic@decode:decoder(get_request_post_data_response()).
decode__get_request_post_data_response() ->
    begin
        gleam@dynamic@decode:field(
            <<"postData"/utf8>>,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Post_data) ->
                gleam@dynamic@decode:success(
                    {get_request_post_data_response, Post_data}
                )
            end
        )
    end.

-file("src\\chrobot_extra\\protocol\\network.gleam", 2025).
?DOC(" Clears browser cache.\n").
-spec clear_browser_cache(fun((binary(), gleam@option:option(any())) -> QIV)) -> QIV.
clear_browser_cache(Callback__) ->
    Callback__(<<"Network.clearBrowserCache"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\network.gleam", 2031).
?DOC(" Clears browser cookies.\n").
-spec clear_browser_cookies(fun((binary(), gleam@option:option(any())) -> QIZ)) -> QIZ.
clear_browser_cookies(Callback__) ->
    Callback__(<<"Network.clearBrowserCookies"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\network.gleam", 2048).
?DOC(
    " Deletes browser cookies with matching name and url or domain/path/partitionKey pair.\n"
    " \n"
    " Parameters:  \n"
    "  - `name` : Name of the cookies to remove.\n"
    "  - `url` : If specified, deletes all the cookies with the given name where domain and path match\n"
    " provided URL.\n"
    "  - `domain` : If specified, deletes only cookies with the exact domain.\n"
    "  - `path` : If specified, deletes only cookies with the exact path.\n"
    "  - `partition_key` : If specified, deletes only cookies with the the given name and partitionKey where domain\n"
    " matches provided URL.\n"
    " \n"
    " Returns:\n"
).
-spec delete_cookies(
    fun((binary(), gleam@option:option(gleam@json:json())) -> QJD),
    binary(),
    gleam@option:option(binary()),
    gleam@option:option(binary()),
    gleam@option:option(binary()),
    gleam@option:option(binary())
) -> QJD.
delete_cookies(Callback__, Name, Url, Domain, Path, Partition_key) ->
    Callback__(
        <<"Network.deleteCookies"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [{<<"name"/utf8>>, gleam@json:string(Name)}],
                    _pipe@1 = chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Url,
                        fun(Inner_value__) ->
                            {<<"url"/utf8>>, gleam@json:string(Inner_value__)}
                        end
                    ),
                    _pipe@2 = chrobot_extra@internal@utils:add_optional(
                        _pipe@1,
                        Domain,
                        fun(Inner_value__@1) ->
                            {<<"domain"/utf8>>,
                                gleam@json:string(Inner_value__@1)}
                        end
                    ),
                    _pipe@3 = chrobot_extra@internal@utils:add_optional(
                        _pipe@2,
                        Path,
                        fun(Inner_value__@2) ->
                            {<<"path"/utf8>>,
                                gleam@json:string(Inner_value__@2)}
                        end
                    ),
                    chrobot_extra@internal@utils:add_optional(
                        _pipe@3,
                        Partition_key,
                        fun(Inner_value__@3) ->
                            {<<"partitionKey"/utf8>>,
                                gleam@json:string(Inner_value__@3)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 2080).
?DOC(" Disables network tracking, prevents network events from being sent to the client.\n").
-spec disable(fun((binary(), gleam@option:option(any())) -> QJQ)) -> QJQ.
disable(Callback__) ->
    Callback__(<<"Network.disable"/utf8>>, none).

-file("src\\chrobot_extra\\protocol\\network.gleam", 2095).
?DOC(
    " Activates emulation of network conditions.\n"
    " \n"
    " Parameters:  \n"
    "  - `offline` : True to emulate internet disconnection.\n"
    "  - `latency` : Minimum latency from request sent to response headers received (ms).\n"
    "  - `download_throughput` : Maximal aggregated download throughput (bytes/sec). -1 disables download throttling.\n"
    "  - `upload_throughput` : Maximal aggregated upload throughput (bytes/sec).  -1 disables upload throttling.\n"
    "  - `connection_type` : Connection type if known.\n"
    " \n"
    " Returns:\n"
).
-spec emulate_network_conditions(
    fun((binary(), gleam@option:option(gleam@json:json())) -> QJU),
    boolean(),
    float(),
    float(),
    float(),
    gleam@option:option(connection_type())
) -> QJU.
emulate_network_conditions(
    Callback__,
    Offline,
    Latency,
    Download_throughput,
    Upload_throughput,
    Connection_type
) ->
    Callback__(
        <<"Network.emulateNetworkConditions"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [{<<"offline"/utf8>>, gleam@json:bool(Offline)},
                        {<<"latency"/utf8>>, gleam@json:float(Latency)},
                        {<<"downloadThroughput"/utf8>>,
                            gleam@json:float(Download_throughput)},
                        {<<"uploadThroughput"/utf8>>,
                            gleam@json:float(Upload_throughput)}],
                    chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Connection_type,
                        fun(Inner_value__) ->
                            {<<"connectionType"/utf8>>,
                                encode__connection_type(Inner_value__)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 2126).
?DOC(
    " Enables network tracking, network events will now be delivered to the client.\n"
    " \n"
    " Parameters:  \n"
    "  - `max_post_data_size` : Longest post body size (in bytes) that would be included in requestWillBeSent notification\n"
    " \n"
    " Returns:\n"
).
-spec enable(
    fun((binary(), gleam@option:option(gleam@json:json())) -> QKB),
    gleam@option:option(integer())
) -> QKB.
enable(Callback__, Max_post_data_size) ->
    Callback__(
        <<"Network.enable"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [],
                    chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Max_post_data_size,
                        fun(Inner_value__) ->
                            {<<"maxPostDataSize"/utf8>>,
                                gleam@json:int(Inner_value__)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 2152).
?DOC(
    " Returns all browser cookies for the current URL. Depending on the backend support, will return\n"
    " detailed cookie information in the `cookies` field.\n"
    " \n"
    " Parameters:  \n"
    "  - `urls` : The list of URLs for which applicable cookies will be fetched.\n"
    " If not specified, it's assumed to be set to the list containing\n"
    " the URLs of the page and all of its subframes.\n"
    " \n"
    " Returns:  \n"
    "  - `cookies` : Array of cookie objects.\n"
).
-spec get_cookies(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    gleam@option:option(list(binary()))
) -> {ok, get_cookies_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_cookies(Callback__, Urls) ->
    gleam@result:'try'(
        Callback__(
            <<"Network.getCookies"/utf8>>,
            {some,
                gleam@json:object(
                    begin
                        _pipe = [],
                        chrobot_extra@internal@utils:add_optional(
                            _pipe,
                            Urls,
                            fun(Inner_value__) ->
                                {<<"urls"/utf8>>,
                                    gleam@json:array(
                                        Inner_value__,
                                        fun gleam@json:string/1
                                    )}
                            end
                        )
                    end
                )}
        ),
        fun(Result__) ->
            _pipe@1 = gleam@dynamic@decode:run(
                Result__,
                decode__get_cookies_response()
            ),
            gleam@result:replace_error(_pipe@1, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 2176).
?DOC(
    " Returns content served for the given request.\n"
    " \n"
    " Parameters:  \n"
    "  - `request_id` : Identifier of the network request to get content for.\n"
    " \n"
    " Returns:  \n"
    "  - `body` : Response body.\n"
    "  - `base64_encoded` : True, if content was sent as base64.\n"
).
-spec get_response_body(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    request_id()
) -> {ok, get_response_body_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_response_body(Callback__, Request_id) ->
    gleam@result:'try'(
        Callback__(
            <<"Network.getResponseBody"/utf8>>,
            {some,
                gleam@json:object(
                    [{<<"requestId"/utf8>>, encode__request_id(Request_id)}]
                )}
        ),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__get_response_body_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 2198).
?DOC(
    " Returns post data sent with the request. Returns an error when no data was sent with the request.\n"
    " \n"
    " Parameters:  \n"
    "  - `request_id` : Identifier of the network request to get content for.\n"
    " \n"
    " Returns:  \n"
    "  - `post_data` : Request body string, omitting files from multipart requests\n"
).
-spec get_request_post_data(
    fun((binary(), gleam@option:option(gleam@json:json())) -> {ok,
            gleam@dynamic:dynamic_()} |
        {error, chrobot_extra@chrome:request_error()}),
    request_id()
) -> {ok, get_request_post_data_response()} |
    {error, chrobot_extra@chrome:request_error()}.
get_request_post_data(Callback__, Request_id) ->
    gleam@result:'try'(
        Callback__(
            <<"Network.getRequestPostData"/utf8>>,
            {some,
                gleam@json:object(
                    [{<<"requestId"/utf8>>, encode__request_id(Request_id)}]
                )}
        ),
        fun(Result__) ->
            _pipe = gleam@dynamic@decode:run(
                Result__,
                decode__get_request_post_data_response()
            ),
            gleam@result:replace_error(_pipe, protocol_error)
        end
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 2219).
?DOC(
    " Toggles ignoring of service worker for each request.\n"
    " \n"
    " Parameters:  \n"
    "  - `bypass` : Bypass service worker and load from network.\n"
    " \n"
    " Returns:\n"
).
-spec set_bypass_service_worker(
    fun((binary(), gleam@option:option(gleam@json:json())) -> QLY),
    boolean()
) -> QLY.
set_bypass_service_worker(Callback__, Bypass) ->
    Callback__(
        <<"Network.setBypassServiceWorker"/utf8>>,
        {some,
            gleam@json:object([{<<"bypass"/utf8>>, gleam@json:bool(Bypass)}])}
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 2237).
?DOC(
    " Toggles ignoring cache for each request. If `true`, cache will not be used.\n"
    " \n"
    " Parameters:  \n"
    "  - `cache_disabled` : Cache disabled state.\n"
    " \n"
    " Returns:\n"
).
-spec set_cache_disabled(
    fun((binary(), gleam@option:option(gleam@json:json())) -> QMD),
    boolean()
) -> QMD.
set_cache_disabled(Callback__, Cache_disabled) ->
    Callback__(
        <<"Network.setCacheDisabled"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"cacheDisabled"/utf8>>, gleam@json:bool(Cache_disabled)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 2264).
?DOC(
    " Sets a cookie with the given cookie data; may overwrite equivalent cookies if they exist.\n"
    " \n"
    " Parameters:  \n"
    "  - `name` : Cookie name.\n"
    "  - `value` : Cookie value.\n"
    "  - `url` : The request-URI to associate with the setting of the cookie. This value can affect the\n"
    " default domain, path, source port, and source scheme values of the created cookie.\n"
    "  - `domain` : Cookie domain.\n"
    "  - `path` : Cookie path.\n"
    "  - `secure` : True if cookie is secure.\n"
    "  - `http_only` : True if cookie is http-only.\n"
    "  - `same_site` : Cookie SameSite type.\n"
    "  - `expires` : Cookie expiration date, session cookie if not set\n"
    " \n"
    " Returns:\n"
).
-spec set_cookie(
    fun((binary(), gleam@option:option(gleam@json:json())) -> QMI),
    binary(),
    binary(),
    gleam@option:option(binary()),
    gleam@option:option(binary()),
    gleam@option:option(binary()),
    gleam@option:option(boolean()),
    gleam@option:option(boolean()),
    gleam@option:option(cookie_same_site()),
    gleam@option:option(time_since_epoch())
) -> QMI.
set_cookie(
    Callback__,
    Name,
    Value,
    Url,
    Domain,
    Path,
    Secure,
    Http_only,
    Same_site,
    Expires
) ->
    Callback__(
        <<"Network.setCookie"/utf8>>,
        {some,
            gleam@json:object(
                begin
                    _pipe = [{<<"name"/utf8>>, gleam@json:string(Name)},
                        {<<"value"/utf8>>, gleam@json:string(Value)}],
                    _pipe@1 = chrobot_extra@internal@utils:add_optional(
                        _pipe,
                        Url,
                        fun(Inner_value__) ->
                            {<<"url"/utf8>>, gleam@json:string(Inner_value__)}
                        end
                    ),
                    _pipe@2 = chrobot_extra@internal@utils:add_optional(
                        _pipe@1,
                        Domain,
                        fun(Inner_value__@1) ->
                            {<<"domain"/utf8>>,
                                gleam@json:string(Inner_value__@1)}
                        end
                    ),
                    _pipe@3 = chrobot_extra@internal@utils:add_optional(
                        _pipe@2,
                        Path,
                        fun(Inner_value__@2) ->
                            {<<"path"/utf8>>,
                                gleam@json:string(Inner_value__@2)}
                        end
                    ),
                    _pipe@4 = chrobot_extra@internal@utils:add_optional(
                        _pipe@3,
                        Secure,
                        fun(Inner_value__@3) ->
                            {<<"secure"/utf8>>,
                                gleam@json:bool(Inner_value__@3)}
                        end
                    ),
                    _pipe@5 = chrobot_extra@internal@utils:add_optional(
                        _pipe@4,
                        Http_only,
                        fun(Inner_value__@4) ->
                            {<<"httpOnly"/utf8>>,
                                gleam@json:bool(Inner_value__@4)}
                        end
                    ),
                    _pipe@6 = chrobot_extra@internal@utils:add_optional(
                        _pipe@5,
                        Same_site,
                        fun(Inner_value__@5) ->
                            {<<"sameSite"/utf8>>,
                                encode__cookie_same_site(Inner_value__@5)}
                        end
                    ),
                    chrobot_extra@internal@utils:add_optional(
                        _pipe@6,
                        Expires,
                        fun(Inner_value__@6) ->
                            {<<"expires"/utf8>>,
                                encode__time_since_epoch(Inner_value__@6)}
                        end
                    )
                end
            )}
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 2315).
?DOC(
    " Sets given cookies.\n"
    " \n"
    " Parameters:  \n"
    "  - `cookies` : Cookies to be set.\n"
    " \n"
    " Returns:\n"
).
-spec set_cookies(
    fun((binary(), gleam@option:option(gleam@json:json())) -> QNB),
    list(cookie_param())
) -> QNB.
set_cookies(Callback__, Cookies) ->
    Callback__(
        <<"Network.setCookies"/utf8>>,
        {some,
            gleam@json:object(
                [{<<"cookies"/utf8>>,
                        gleam@json:array(Cookies, fun encode__cookie_param/1)}]
            )}
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 2333).
?DOC(
    " Specifies whether to always send extra HTTP headers with the requests from this page.\n"
    " \n"
    " Parameters:  \n"
    "  - `headers` : Map with extra HTTP headers.\n"
    " \n"
    " Returns:\n"
).
-spec set_extra_http_headers(
    fun((binary(), gleam@option:option(gleam@json:json())) -> QNH),
    headers()
) -> QNH.
set_extra_http_headers(Callback__, Headers) ->
    Callback__(
        <<"Network.setExtraHTTPHeaders"/utf8>>,
        {some,
            gleam@json:object([{<<"headers"/utf8>>, encode__headers(Headers)}])}
    ).

-file("src\\chrobot_extra\\protocol\\network.gleam", 2353).
?DOC(
    " Allows overriding user agent with the given string.\n"
    " \n"
    " Parameters:  \n"
    "  - `user_agent` : User agent to use.\n"
    "  - `accept_language` : Browser language to emulate.\n"
    "  - `platform` : The platform navigator.platform should return.\n"
    " \n"
    " Returns:\n"
).
-spec set_user_agent_override(
    fun((binary(), gleam@option:option(gleam@json:json())) -> QNM),
    binary(),
    gleam@option:option(binary()),
    gleam@option:option(binary())
) -> QNM.
set_user_agent_override(Callback__, User_agent, Accept_language, Platform) ->
    Callback__(
        <<"Network.setUserAgentOverride"/utf8>>,
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
