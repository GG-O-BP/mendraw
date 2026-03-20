-record(script_coverage, {
    script_id :: chrobot_extra@protocol@runtime:script_id(),
    url :: binary(),
    functions :: list(chrobot_extra@protocol@profiler:function_coverage())
}).
