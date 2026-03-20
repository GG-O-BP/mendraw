-record(web_socket_frame, {
    opcode :: float(),
    mask :: boolean(),
    payload_data :: binary()
}).
