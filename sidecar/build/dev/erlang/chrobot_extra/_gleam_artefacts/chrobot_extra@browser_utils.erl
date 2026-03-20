-module(chrobot_extra@browser_utils).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\browser_utils.gleam").
-export([get_url/1, wait_for_url/3, is_visible/2, await_visible/3]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " Utility functions for common browser automation tasks.\n"
    " Provides URL waiting and element visibility checking capabilities.\n"
).

-file("src\\chrobot_extra\\browser_utils.gleam", 11).
?DOC(" Get the current page URL.\n").
-spec get_url(chrobot_extra:page()) -> {ok, binary()} |
    {error, chrobot_extra@chrome:request_error()}.
get_url(Page) ->
    _pipe = chrobot_extra:eval_to_value(Page, <<"window.location.href"/utf8>>),
    chrobot_extra:as_value(
        _pipe,
        {decoder, fun gleam@dynamic@decode:decode_string/1}
    ).

-file("src\\chrobot_extra\\browser_utils.gleam", 24).
?DOC(
    " Wait until the page URL matches the given predicate.\n"
    " The timeout is specified in milliseconds.\n"
    "\n"
    " ## Example\n"
    " ```gleam\n"
    " // Wait up to 5 minutes for URL to change away from login page\n"
    " wait_for_url(page, matching: fn(url) { !string.contains(url, \"login\") }, time_out: 300_000)\n"
    " ```\n"
).
-spec wait_for_url(
    chrobot_extra:page(),
    fun((binary()) -> boolean()),
    integer()
) -> {ok, binary()} | {error, chrobot_extra@chrome:request_error()}.
wait_for_url(Page, Predicate, Timeout) ->
    chrobot_extra:poll(
        fun() ->
            gleam@result:'try'(get_url(Page), fun(Url) -> case Predicate(Url) of
                        true ->
                            {ok, Url};

                        false ->
                            {error, not_found_error}
                    end end)
        end,
        Timeout
    ).

-file("src\\chrobot_extra\\browser_utils.gleam", 43).
?DOC(
    " Check if an element matching the CSS selector is visible on the page.\n"
    " Returns True if the element exists in the DOM and is visually visible.\n"
).
-spec is_visible(chrobot_extra:page(), binary()) -> {ok, boolean()} |
    {error, chrobot_extra@chrome:request_error()}.
is_visible(Page, Selector) ->
    Escaped_selector = gleam@string:replace(
        Selector,
        <<"\\"/utf8>>,
        <<"\\\\"/utf8>>
    ),
    Escaped_selector@1 = gleam@string:replace(
        Escaped_selector,
        <<"\""/utf8>>,
        <<"\\\""/utf8>>
    ),
    Js = <<<<"(function() {
  var el = document.querySelector(\""/utf8,
            Escaped_selector@1/binary>>/binary,
        "\");
  if (!el) return false;
  var style = window.getComputedStyle(el);
  if (style.display === 'none' || style.visibility === 'hidden' || style.opacity === '0') return false;
  return el.offsetParent !== null || el.offsetWidth > 0 || el.offsetHeight > 0;
})()"/utf8>>,
    _pipe = chrobot_extra:eval_to_value(Page, Js),
    chrobot_extra:as_value(
        _pipe,
        {decoder, fun gleam@dynamic@decode:decode_bool/1}
    ).

-file("src\\chrobot_extra\\browser_utils.gleam", 67).
?DOC(
    " Wait until an element matching the CSS selector becomes visible.\n"
    " The timeout is specified in milliseconds.\n"
    "\n"
    " ## Example\n"
    " ```gleam\n"
    " await_visible(page, selector: \"#my-element\", time_out: 10_000)\n"
    " ```\n"
).
-spec await_visible(chrobot_extra:page(), binary(), integer()) -> {ok,
        boolean()} |
    {error, chrobot_extra@chrome:request_error()}.
await_visible(Page, Selector, Timeout) ->
    chrobot_extra:poll(
        fun() ->
            gleam@result:'try'(
                is_visible(Page, Selector),
                fun(Visible) -> case Visible of
                        true ->
                            {ok, true};

                        false ->
                            {error, not_found_error}
                    end end
            )
        end,
        Timeout
    ).
