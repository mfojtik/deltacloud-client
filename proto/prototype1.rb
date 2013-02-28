require 'faraday'
require 'nokogiri'
require 'pry'
require 'ostruct'

module Deltacloud
  module Client

    class BaseError < StandardError
      attr_reader :server_backtrace

      def initialize(opts={})
        @server_backtrace = opts[:server_backtrace]
        super(opts[:message])
      end
    end

    class AuthenticationError < BaseError; end
    class BackendError < BaseError; end
    class ServerError < BaseError; end
    class ClientError < BaseError; end
  end
end

module Faraday
  class Response::DeltacloudErrors < Response::Middleware
    begin
      def self.register_on_complete(env)
        client = Deltacloud::Client
        env[:response].on_complete do |finished_env|
          case finished_env[:status].to_s
          when '401'
            raise client::AuthenticationError.new(:message => 'Authentication Failed')
          when /40\d/
            msg = Nokogiri::XML(finished_env[:body]).root.at('/error/message').text
            raise client::ClientError.new(:message => msg)
          when 500
            error_body = Nokogiri::XML(finished_env[:body]).root
            msg = error_body.at('/error/message').text
            trace = error_body.at('/error/backtrace').text
            raise client::ServerError.new(:server_backtrace => trace, :message => msg)
          end
        end
      end
    rescue LoadError, NameError => e
      self.load_error = e
    end

    def initialize(app)
      super
      @parser = nil
    end
  end
end

module Deltacloud

  def self.Client(url, api_user, api_password)
    Client::Connection.new(
      :url => url,
      :api_user => api_user,
      :api_password => api_password
    )
  end

  module Client

    module XmlHelpers
      def attr_at(item, xpath, attr)
        (val = item.at(xpath)) ? val[attr.to_s.strip] : nil
      end

      def text_at(item, xpath)
        (val = item.at(xpath)) ? val.text.strip : nil
      end

      def xml_body(obj)
        case obj
          when Faraday::Response then obj.body
          when Nokogiri::XML::Element then obj.to_s
          else obj
        end
      end
    end

    module ClassMethods
      def class_for(item)
        class_name = item.name.split('::').last
        if Deltacloud::Client.const_defined? class_name
          Deltacloud::Client.const_get(class_name)
        else
          Deltacloud::Client.const_set(class_name, Class.new(item))
        end
      end
    end

    class BaseModel < OpenStruct
      extend XmlHelpers
      extend ClassMethods
      attr_reader :_id, :name, :description
    end

    module InstancesMethods

      include ClassMethods

      def instances(filter_opts={})
        class_for(Instance).from_collection(connection.get('/api/instances', filter_opts))
      end

      def instance(instance_id)
        class_for(Instance).convert(connection.get("/api/instances/#{instance_id}"))
      end

      class Instance < Deltacloud::Client::BaseModel

        attr_reader :state, :realm_id, :owner_id, :image_id
        attr_reader :public_addresses, :private_addresses
        attr_reader :hardware_profile_id

        def self.convert(obj)
          i = Nokogiri::XML(xml_body(obj)).root
          new(
            :_id => i['id'],
            :name => text_at(i, 'name'),
            :description => text_at(i, 'description'),
            :state => text_at(i, 'state'),
            :realm_id => attr_at(i, 'realm', :id),
            :owner_id => text_at(i, 'owner_id'),
            :image_id => attr_at(i, 'image', :id),
            :hardware_profile_id => attr_at(i, 'hardware_profile', :id),
            :public_addresses => class_for(InstanceAddress).convert(
              i.xpath('public_addresses/address')
            ),
            :private_addresses => class_for(InstanceAddress).convert(
              i.xpath('private_addresses/address')
            )
          )
        end

        def self.from_collection(response)
          Nokogiri::XML(response.body).xpath('/instances/instance').map do |inst|
            convert(inst)
          end
        end

        class InstanceAddress < OpenStruct
          attr_reader :type
          attr_reader :value

          def to_s; @value; end

          def self.convert(address_xml_block)
            address_xml_block.map do |addr|
              new(
                :type => addr['type'],
                :value => addr.text
              )
            end
          end
        end
      end

    end

    module ApiMethods

      def version
        Nokogiri::XML(connection.get('/api').body).root['version']
      end

      def current_driver
        Nokogiri::XML(connection.get('/api').body).root['driver']
      end

      def current_provider
        Nokogiri::XML(connection.get('/api').body).root['provider']
      end

      def supported_collections
        Nokogiri::XML(connection.get('/api').body).root.xpath('link').map do |l|
          l['rel']
        end
      end
    end

    class Connection

      attr_reader :connection
      attr_reader :request_driver
      attr_reader :request_provider

      include Deltacloud::Client::ApiMethods
      include Deltacloud::Client::InstancesMethods

      def initialize(opts={})
        @request_driver = opts[:driver]
        @request_provider = opts[:provider]
        @connection = Faraday.new(:url => opts[:url]) do |f|
          f.adapter  :net_http
          f.request  :url_encoded
          f.headers = default_request_headers
          f.basic_auth opts[:api_user], opts[:api_password]
          f.use Faraday::Response::DeltacloudErrors
        end
      end

      def driver(driver_id, api_user, api_password, api_provider=nil)
        self.class.new(
          :url => @connection.url_prefix.to_s,
          :api_user => api_user,
          :api_password => api_password,
          :provider => api_provider,
          :driver => driver_id
        )
      end

      def provider(provider_id)
        new_connection = @connection.clone
        new_connection.headers['X-Deltacloud-Provider'] = provider_id
        new_connection
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
end

API_URL = 'http://localhost:3002/api'

client = Deltacloud::Client(API_URL, 'mockuser', 'mockpassword')

mock_client = client.driver(:mock, 'mockuser', 'mockpassword', 'us')

p mock_client.version
p mock_client.current_driver
p mock_client.current_provider
p mock_client.supported_collections

#p mock_client.instances
#p mock_client.instance('inst1')

#mock_client.create_instance('img1', :hwp_id => 'm1-xlarge')
#mock_client.reboot_instance('inst1')
#mock_client.destroy_instance('inst1')
