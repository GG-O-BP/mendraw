-record(resource_timing, {
    request_time :: float(),
    proxy_start :: float(),
    proxy_end :: float(),
    dns_start :: float(),
    dns_end :: float(),
    connect_start :: float(),
    connect_end :: float(),
    ssl_start :: float(),
    ssl_end :: float(),
    send_start :: float(),
    send_end :: float(),
    receive_headers_end :: float()
}).
