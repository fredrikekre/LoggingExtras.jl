struct FailsafeLogger{L <: AbstractLogger} <: AbstractLogger
    logger::L
end
function handle_message(logger::FailsafeLogger, args...; kwargs...)
    try
        handle_message(logger.logger, args...; kwargs...)
    catch err
        try
            # The logger is dead... long live stderr!
            io = IOBuffer()
            print(io, "ERROR: FailsafeLogger: error when handling message:\n")
            showerror(io, err, catch_backtrace())
            write(stderr, take!(io))
        catch err
            # Give up...
        end
    end
end
shouldlog(logger::FailsafeLogger, args...) = shouldlog(logger.logger, args...)
min_enabled_level(logger::FailsafeLogger) = min_enabled_level(logger.logger)
catch_exceptions(logger::FailsafeLogger) = true
