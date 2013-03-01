module Deltacloud::Client

  class Driver < Base

    attr_reader :providers

    # Syntax sugar for returning provider from Driver
    # instance:
    #
    # client.driver(:ec2)['us-west-1'] # => List of endpoints
    #
    # - provider_id -> Provider ID, like 'us-west-1'
    #
    def [](provider_id)
      @providers ||= []
      prov = @providers.find { |p| p.name == provider_id }
      prov.instance_variable_set('@client', @client)
      prov
    end

    def self.parse(r)
      {
        :name => text_at(r, :name),
        :providers => r.xpath('provider').map { |p| Provider.parse(p) }
      }
    end

    class Provider

      attr_reader :name
      attr_reader :entrypoints

      def initialize(name, entrypoints=[])
        @name = name
        @entrypoints = entrypoints
      end

      # Syntax sugar for retrieving list of endpoints available for the
      # provider
      #
      # - entrypoint_id -> Entrypoint ID, like 's3'
      #
      def [](entrypoint_id)
        @entrypoints ||= []
        ent_point = @entrypoints.find { |name, _| name == entrypoint_id }
        ent_point ? ent_point.last : nil
      end

      # Method to check if given credentials can be used to authorize
      # connection to current provider:
      #
      # client.driver(:ec2)['us-west-1'].valid_credentials? 'user', 'password'
      #
      # - api_user -> API key
      # - api_password -> API secret
      #
      def valid_credentials?(api_user, api_password)
        unless @client
          raise Deltacloud::Client::Error.new('Please use driver("ec2")[API_PROVIDER].valid_credentials?')
        end
        @client.use(@client.current_driver, api_user, api_password, @name).valid_credentials?
      end

      def self.parse(p)
        new(
          p['id'],
          p.xpath('entrypoint').inject({}) { |r, e| r[e['kind']] = e.text.strip; r }
        )
      end
    end

  end
end
