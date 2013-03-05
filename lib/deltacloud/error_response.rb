module Deltacloud
  class ErrorResponse < Faraday::Response::Middleware

    include Deltacloud::Client::Helpers::Model

    # This method tries to parse the error XML from Deltacloud API
    # In case there is no error returned in body, it will try to use
    # the generic error reporting.
    #
    # - klass -> Deltacloud::Client::+Class+
    # - message -> Exception message (overiden by error body message if
    #              present)
    # - error -> Deltacloud XML error representation
    #
    def client_error(name, error, message=nil)
      args = {
        :message => message,
        :status => error ? error[:status] : '500'
      }
      # If Deltacloud API send error in response body, parse it.
      # Otherwise, when DC API send just plain text error, use
      # it as exception message.
      # If DC API does not send anything back, then fallback to
      # the 'message' attribute.
      #
      if error and !error[:body].empty?
        if xml_error?(error)
          args.merge! parse_error(error[:body].to_xml.root)
        else
          args[:message] = error[:body]
        end
      end
      error(name).new(args)
    end

    def call(env)
      @app.call(env).on_complete do |e|
        case e[:status].to_s
        when '401'
          raise client_error(:authentication_error, e, 'Invalid :api_user or :api_password')
        when '405'
          raise client_error(
            :invalid_state, e, 'Resource state does not permit this action'
          )
        when '404'
          raise client_error(:not_found, e, 'Object not found')
        when /40\d/
          raise client_error(:client_failure, e)
        when '500'
          raise client_error(:server_error, e)
        when '502'
          raise client_error(:backend_error, e)
        when '501'
          raise client_error(:not_supported, e)
        end
      end
    end

    private

    def xml_error?(error)
      error[:body].to_xml.root && error[:body].to_xml.root.name == 'error'
    end

    # Parse the Deltacloud API error body to Hash
    #
    def parse_error(body)
      args = {}
      args[:original_error] = body.to_s
      args[:server_backtrace] = body.text_at('backtrace')
      args[:message] ||= body.text_at('message')
      args[:driver] = body.attr_at('backend', 'driver')
      args[:provider] = body.attr_at('backend', 'provider')
      args
    end
  end
end
