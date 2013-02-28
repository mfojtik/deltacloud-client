module Deltacloud
  class ErrorResponse < Faraday::Response::Middleware

      # This method tries to parse the error XML from Deltacloud API
      # In case there is no error returned in body, it will try to use
      # the generic error reporting.
      #
      # - klass -> Deltacloud::Client::+Class+
      # - message -> Exception message (overiden by error body message if
      #              present)
      # - error_body -> Deltacloud XML error representation
      #
      def client_error(klass, message, error_body=nil)
        args = {
          :message => message
        }
        if error_body and (err = error_body.to_xml.root)
          args.merge!(:original_error => err.to_s)
          if backtrace = err.at('/error/backtrace')
            args.merge!(:server_backtrace => backtrace.text)
          end
          if message = err.at('/error/message')
            args.merge!(:message => message.text.strip)
          end
          if backend = err.at('/error/backend')
            args.merge!(
              :driver => backend['driver'],
              :provider => backend['provider']
            )
          end
          if state = err['status']
            args.merge!(:status => state)
          end
        end
        klass.new(args)
      end

      def call(env)
        @app.call(env).on_complete do |e|
          klass = Deltacloud::Client
          case e[:status].to_s
          when '401'
            raise client_error(klass::AuthenticationError, 'Invalid :api_user or :api_password')
          when '405'
            raise client_error(klass::InvalidState, 'Resource state does not permit this action', e[:body])
          when /40\d/
            raise client_error(klass::ClientFailure, '', e[:body])
          when '500'
            raise client_error(klass::ServerError, '', e[:body])
          when '502'
            raise client_error(klass::BackendError, '', e[:body])
          when '501'
            raise client_error(klass::NotSupported, '', e[:body])
          end
        end
      end
  end
end
