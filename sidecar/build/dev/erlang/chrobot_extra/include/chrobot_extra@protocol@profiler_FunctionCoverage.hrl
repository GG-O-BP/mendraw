-record(function_coverage, {
    function_name :: binary(),
    ranges :: list(chrobot_extra@protocol@profiler:coverage_range()),
    is_block_coverage :: boolean()
}).
