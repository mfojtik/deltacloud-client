module Deltacloud::Client
  class Connection

    attr_reader :connection
    attr_reader :request_driver
    attr_reader :request_provider
    attr_reader :entrypoint

    include Deltacloud::Client::Methods::Api
    include Deltacloud::Client::Methods::BackwardCompatibility
    include Deltacloud::Client::Methods::Instance

    def initialize(opts={})
      @request_driver = opts[:driver]
      @request_provider = opts[:provider]
      @connection = Faraday.new(:url => opts[:url]) do |f|
        f.request :url_encoded
        f.adapter  Faraday.default_adapter
        f.headers = default_request_headers
        f.basic_auth opts[:api_user], opts[:api_password]
        f.use Deltacloud::ErrorResponse
      end
      cache_entrypoint!
    end

    # Change the current driver and return copy of the client
    # This allows chained calls like: client.driver(:ec2).instances
    #
    # - driver_id -> The new driver id (:mock, :ec2, :rhevm, ...)
    # - api_user -> API user name
    # - api_password -> API password
    # - api_provider -> API provider (aka API_PROVIDER string)
    #
    def driver(driver_id, api_user, api_password, api_provider=nil, &block)
      new_client = self.class.new(
        :url => @connection.url_prefix.to_s,
        :api_user => api_user,
        :api_password => api_password,
        :provider => api_provider,
        :driver => driver_id
      )
      new_client.cache_entrypoint!
      yield new_client if block_given?
      new_client
    end

    # Change the current API_PROVIDER and return copy of the client
    # This allows chained calls like: client.provider('us').instances
    #
    # - provider_id -> API provider (aka API_PROVIDER)
    #
    def provider(provider_id)
      new_connection = @connection.clone
      new_connection.headers['X-Deltacloud-Provider'] = provider_id
      new_connection.cache_entrypoint!
      new_connection
    end

    # Cache the API entrypoint (/api) for the current connection,
    # so we don't need to query /api everytime we ask if certain
    # collection/operation is supported
    #
    def cache_entrypoint!
      @entrypoint ||= connection.get(path).body
    end

    private

    def default_request_headers
      headers = { 'Accept' => 'application/xml' }
      if request_driver
        headers.merge!( 'X-Deltacloud-Driver' => @request_driver.to_s )
      end
      if request_provider
        headers.merge!( 'X-Deltacloud-Provider' => @request_provider.to_s )
      end
      headers
    end

  end

end
