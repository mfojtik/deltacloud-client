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
    # - error_body -> Deltacloud XML error representation
    #
    def client_error(klass, message, error=nil)
      args = {
        :message => message,
        :original_error => error ? error[:body] : {},
      }
      args.merge! parse_deltacloud_error(args[:original_error])
      klass.new(args)
    end

    # Parse the Deltacloud API error body to Hash
    #
    def parse_deltacloud_error(error_response)
      body = error_response[:body] || ''
      return {} if body.empty?
      return {} if body.to_xml.root.name != 'error'

      body = body.to_xml
      args = {}

      if backtrace = body.at('/error/backtrace')
        args.merge!(:server_backtrace => backtrace.text)
      end

      if message = body.at('/error/message')
        args.merge!(:message => message.text.strip)
      else
        args.merge!(:message => error_response[:status])
      end

      if backend = body.at('/error/backend')
        args.merge!(
          :driver => backend['driver'],
          :provider => backend['provider']
        )
      end

      if state = body['status']
        args.merge!(:status => state)
      end

      args
    end

    def call(env)
      @app.call(env).on_complete do |e|
        case e[:status].to_s
        when '401'
          raise client_error(
            error(:authentication_error),
            'Invalid :api_user or :api_password'
          )
        when '405'
          raise client_error(
            error(:invalid_state),
            'Resource state does not permit this action',
            e
          )
        when /40\d/
          raise client_error(error(:client_failure), '',  e)
        when '500'
          raise client_error(error(:server_error), '',  e)
        when '502'
          raise client_error(error(:backend_error), '', e)
        when '501'
          raise client_error(error(:not_supported), '', e)
        end
      end
    end
  end
end
