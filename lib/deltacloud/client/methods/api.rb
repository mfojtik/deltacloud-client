module Deltacloud::Client
  module Methods
    module Api

      # The current version of Deltacloud API
      #
      def version
        entrypoint.to_xml.root['version']
      end

      alias_method :api_version, :version

      # The current driver the @connection is using
      #
      def current_driver
        entrypoint.to_xml.root['driver']
      end

      alias_method :api_driver,   :current_driver
      alias_method :driver_name,  :current_driver

      # The current provider the @connection is using
      #
      def current_provider
        entrypoint.to_xml.root['provider']
      end

      # List of the currently supported collections by @connection
      #
      def supported_collections
        entrypoint.to_xml.root.xpath('link').map { |l| l['rel'] }
      end

      alias_method :entrypoints, :supported_collections

      # Syntax sugar for +supported_collections+
      # Return 'true' if the collection is supported by current API entrypoint
      #
      def support?(collection)
        supported_collections.include? collection.to_s
      end

      # Syntax sugar for Method modules, where you can 'require' the support
      # for the given collection before you execute API call
      #
      # Raise +NotSupported+ exception if the given +collection+ is not
      # supported
      #
      def must_support!(collection)
        unless support?(collection)
          raise Deltacloud::Client::NotSupported.new("Collection '#{collection}' not supported by current API endpoint.")
        end
      end

      # +Hash+ of all features supported by current connection
      #
      def features
        entrypoint.to_xml.root.xpath('link/feature').inject(Hash.new(Array.new)) do |result, feature|
          result[feature.parent['rel']] += [feature['name']]
          result
        end
      end

      # Check if the current collection support given feature for given
      # collection
      #
      def feature?(collection_name, feature_name)
        features[collection_name.to_s].include?(feature_name.to_s)
      end

    end
  end
end
