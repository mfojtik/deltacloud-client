module Deltacloud::Client
  module Methods
    module BackwardCompatibility

      # Backward compatibility methods provides fallback for the
      # old deltacloud-client gem.
      #
      #
      def api_host
        connection.url_prefix.host
      end

      def api_port
        connection.url_prefix.port
      end

      def connect(&block)
        yield self.clone
      end

      def with_config(opts, &block)
        api_instance = use(
          opts[:driver],
          opts[:username],
          opts[:password],
          opts[:provider]
        )
        yield api_instance if block_given?
        api_instance
      end

      def use_driver(new_driver, opts={})
        with_config(opts.merge(:driver => new_driver))
      end

      alias_method :"use_config!", :use_driver

      def discovered?
        true unless entrypoint.nil?
      end

      module ClassMethods

        def valid_credentials?(api_user, api_password, api_url, opts={})
          args = {
            :api_user => api_user,
            :api_password => api_password,
            :url => api_url
          }
          args.merge!(:providers => opts[:provider]) if opts[:provider]
          Deltacloud::Client::Connection.new(args).valid_credentials?
        end

      end

    end
  end
end
