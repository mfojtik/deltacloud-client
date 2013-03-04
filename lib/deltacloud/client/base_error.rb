module Deltacloud::Client

  # Reporting internal client errors
  #
  class Error < StandardError; end

  # Reporting XML deserialization errors
  #
  class InvalidXMLError < StandardError; end

  class BaseError < StandardError
    attr_reader :server_backtrace
    attr_reader :driver
    attr_reader :provider
    attr_reader :status

    def initialize(opts={})
      if opts.is_a? Hash
        @server_backtrace = opts[:server_backtrace]
        @driver = opts[:driver]
        @provider = opts[:provider]
        @status = opts[:status]
        @original_error = opts[:original_error]
        super(opts[:message])
      else
        super(opts)
      end
    end

    # Return the original XML error message received from Deltacloud API
    def original_error
      @original_error
    end

    # If the Deltacloud API server error response contain backtrace from
    # server,then make this backtrace available as part of this exception
    # backtrace
    #
    def set_backtrace(backtrace)
      return super(backtrace) if @server_backtrace.nil?
      super([
        backtrace[0..3],
        "=== Server backtrace ===",
        @server_backtrace.split[0..10],
      ].flatten)
    end

  end

  # Report 401 errors
  class AuthenticationError < BaseError; end

  # Report 502 errors (back-end cloud provider encounter error)
  class BackendError < BaseError; end

  # Report 5xx errors (error on Deltacloud API server)
  class ServerError < BaseError; end

  # Report 501 errors (collection or operation is not supported)
  class NotSupported < ServerError; end

  # Report 4xx failures (client failures)
  class ClientFailure < BaseError; end

  # Report 405 failures (resource state does not permit the requested operation)
  class InvalidState < ClientFailure; end

  # Report this when client do Image#launch using incompatible HWP
  class IncompatibleHardwareProfile < ClientFailure; end
end
