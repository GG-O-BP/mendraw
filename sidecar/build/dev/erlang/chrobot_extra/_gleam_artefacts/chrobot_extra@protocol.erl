-module(chrobot_extra@protocol).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src\\chrobot_extra\\protocol.gleam").
-export([version/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " > ⚙️  This module was generated from the Chrome DevTools Protocol version **1.3**\n"
    " For reference: [See the DevTools Protocol API Docs](https://chromedevtools.github.io/devtools-protocol/1-3/)\n"
    " \n"
    " This is the protocol definition entrypoint, it contains an overview of the protocol structure,\n"
    " and a function to retrieve the version of the protocol used to generate the current bindings.\n"
    " The protocol version is also displayed in the box above, which appears on every generated module.\n"
    " \n"
    " ## ⚠️ Really Important Notes\n"
    " \n"
    " 1) It's best never to work with the DOM domain for automation,\n"
    " [an explanation of why can be found here](https://github.com/puppeteer/puppeteer/pull/71#issuecomment-314599749).\n"
    " Instead, to automate DOM interaction, JavaScript can be injected using the Runtime domain.\n"
    " \n"
    " 2) Unfortunately, I haven't found a good way to map dynamic properties to gleam attributes bidirectionally.\n"
    " **This means all dynamic values you supply to commands will be silently dropped**!\n"
    " It's important to realize this to avoid confusion, for example in `runtime.call_function_on`\n"
    " you may want to supply arguments which can be any value, but it won't work.\n"
    " The only path to do that as far as I can tell, is write the protocol call logic yourself,\n"
    " perhaps taking the codegen code as a basis.\n"
    " Check the `call_custom_function_on` function from `chrobot` which does this for the mentioned function\n"
    " \n"
    " ## Structure\n"
    " \n"
    " Each domain in the protocol is represented as a module under `protocol/`.\n"
    " \n"
    " In general, the bindings are generated through codegen, directly from the JSON protocol schema [published here](https://github.com/ChromeDevTools/devtools-protocol),\n"
    " however there are some little adjustments that needed to be made, to make the protocol schema usable, mainly due to\n"
    " what I believe are minor bugs in the protocol.\n"
    " To see these changes, check the `apply_protocol_patches` function in `chrobot/internal/generate_bindings`.\n"
    " \n"
    " Domains may depend on the types of other domains, these dependencies are mirrored in the generated bindings where possible.\n"
    " In some case, type references to other modules have been replaced by the respective inner type, because the references would\n"
    " create a circular dependency.\n"
    " \n"
    " ## Types\n"
    " \n"
    " The generated bindings include a mirror of the type defitions of each type in the protocol spec,\n"
    " alongside with an `encode__` function to encode the type into JSON in order to send it to the browser\n"
    " and a `decode__` function in order to decode the type out of a payload sent from the browser. Encoders and\n"
    " decoders are marked internal and should be used through command functions which are described below.\n"
    " \n"
    " Notes:\n"
    " - Some object properties in the protocol have the type `any`, in this case the value is considered as dynamic\n"
    " by decoders, and encoders will not encode it, setting it to `null` instead in the payload\n"
    " - Object types that don't specify any properties are treated as a `Dict(String,String)`\n"
    " \n"
    " Additional type definitions and encoders / decoders are generated,\n"
    " for any enumerable property in the protocol, as well as the return values of commands.\n"
    " These special type definitions are marked with a comment to indicate\n"
    " the fact that they are not part of the protocol spec, but rather generated dynamically to support the bindings.\n"
    " \n"
    " \n"
    " ## Commands\n"
    " \n"
    " A function is generated for each command, named after the command (in snake case).\n"
    " The function handles both encoding the parameters to sent to the browser via the protocol, and decoding the response.\n"
    " A `ProtocolError` error is returned if the decoding fails, this would mean there is a bug in the protocol\n"
    " or the generated bindings.\n"
    " \n"
    " The first parameter to the command function is always a `callback` of the form\n"
    " \n"
    " ```gleam\n"
    " fn(method: String, parameters: Option(Json)) -> Result(Dynamic, RequestError)\n"
    " ```\n"
    " \n"
    " By using this callback you can take advantage of the generated protocol encoders/decoders\n"
    " while also passing in your browser subject to direct the command to, and passing along additional\n"
    " arguments, like the `sessionId` which is required for some operations.\n"
    " \n"
    " \n"
    " ## Events\n"
    " \n"
    " Events are not implemented yet!\n"
    " \n"
    " \n"
    " \n"
).

-file("src\\chrobot_extra\\protocol.gleam", 88).
?DOC(" Get the protocol version as a tuple of major and minor version\n").
-spec version() -> {binary(), binary()}.
version() ->
    {<<"1"/utf8>>, <<"3"/utf8>>}.
