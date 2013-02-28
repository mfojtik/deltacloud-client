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

      def api_path
        connection.url_prefix.path
      end

      alias_method :path,         :api_path

      def connect(&block)
        yield self
      end

      def with_config(opts, &block)
        warn "The Client#with_config is obsoleted. Use the Client#driver instead."
        api_instance = api_instance.driver(opts[:driver], opts[:username], opts[:password], opts[:provider])
        yield api_instance if block_given?
        api_instance
      end

      def use_driver(new_driver, opts={})
        warn "The Client#use_driver is obsoleted. Use the Client#driver instead."
        driver(new_driver, opts[:username], opts[:password], opts[:provider])
      end

      alias_method :"use_config!", :use_driver
    end
  end
end
