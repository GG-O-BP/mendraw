-record(signed_certificate_timestamp, {
    status :: binary(),
    origin :: binary(),
    log_description :: binary(),
    log_id :: binary(),
    timestamp :: float(),
    hash_algorithm :: binary(),
    signature_algorithm :: binary(),
    signature_data :: binary()
}).
