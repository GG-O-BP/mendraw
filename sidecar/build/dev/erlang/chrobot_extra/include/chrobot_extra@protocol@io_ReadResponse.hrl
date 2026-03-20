-record(read_response, {
    base64_encoded :: gleam@option:option(boolean()),
    data :: binary(),
    eof :: boolean()
}).
