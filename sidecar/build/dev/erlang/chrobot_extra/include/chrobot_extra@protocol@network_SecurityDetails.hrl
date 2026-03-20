-record(security_details, {
    protocol :: binary(),
    key_exchange :: binary(),
    key_exchange_group :: gleam@option:option(binary()),
    cipher :: binary(),
    mac :: gleam@option:option(binary()),
    certificate_id :: chrobot_extra@protocol@security:certificate_id(),
    subject_name :: binary(),
    san_list :: list(binary()),
    issuer :: binary(),
    valid_from :: chrobot_extra@protocol@network:time_since_epoch(),
    valid_to :: chrobot_extra@protocol@network:time_since_epoch(),
    signed_certificate_timestamp_list :: list(chrobot_extra@protocol@network:signed_certificate_timestamp()),
    certificate_transparency_compliance :: chrobot_extra@protocol@network:certificate_transparency_compliance(),
    server_signature_algorithm :: gleam@option:option(integer()),
    encrypted_client_hello :: boolean()
}).
