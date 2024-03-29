module Deltacloud
  module Client
    require 'require_relative' if RUBY_VERSION < '1.9'
    require 'ostruct'
    require 'nokogiri'
    require 'faraday'

    # Core extensions
    require_relative './core_ext'

    # Errors && Helpers
    require_relative './client/helpers/model_helper'
    require_relative './client/helpers/xml_helper'
    require_relative './client/helpers/property_helper'

    # Exceptions goes here
    require_relative './client/base_error'

    # Faraday Middleware for Deltacloud errors
    require_relative './error_response'

    # Deltacloud API methods
    require_relative './client/methods/api'
    require_relative './client/methods/backward_compatiblity'

    # Extend Client module with methods that existed in old client
    # and we want to keep them.
    # Deprecation warnings should be provided to users if they use something
    # from these modules.
    #
    extend Deltacloud::Client::Methods::BackwardCompatibility::ClassMethods

    # Deltacloud methods
    require_relative './client/methods'

    # Deltacloud models
    require_relative './client/models'

    require_relative './client/connection'

    VERSION = '1.1.2'

    # Check if the connection to Deltacloud API is valid
    #
    def self.valid_connection?(api_url)
      begin
        Deltacloud::Client(api_url, '', '') && true
      rescue Faraday::Error::ConnectionFailed
        false
      rescue Deltacloud::Client::AuthenticationError
        false
      end
    end

  end

  # Require the Deltacloud::API Rack middleware if available and
  # setup a 'fake' Deltacloud API server. Then mock all requests to this
  # 'fake' Deltacloud API server.
  #
  # - driver -> Deltacloud API driver to use
  # - api_user -> Deltacloud API username (eg. API key)
  # - api_password -> Deltacloud API password (eg. API secret)
  # - api_provider -> Deltacloud API provider to use (eg. vsphere.host.com)
  #
  def self.Connect(driver, api_user, api_password, api_provider=nil)
    if require_deltacloud
      Client('http://localhost:3001/api', api_user, api_password, :driver => driver, :provider => api_provider,
        :use_server => true)
    else
      warn '[WARNING] To use Driver() method, you need to install `rack-test` and `deltacloud-core` gems.'
      false
    end
  end

  def self.require_deltacloud
    begin
      require 'deltacloud_rack'
      require_relative './server'
      true
    rescue LoadError
      false
    end
  end

  # Syntax sugar for Deltacloud::Client::Connection#new
  #
  # - url -> Deltacloud API url (eg. http://localhost:3001/api)
  # - api_user -> Deltacloud API username (eg. API key)
  # - api_password -> Deltacloud API password (eg. API secret)
  # - opts
  #   :provider -> Deltacloud API provider to use (eg. vsphere.host.com)
  #
  def self.Client(url, api_user, api_password, opts={})
    Client::Connection.new({
      :url => url,
      :api_user => api_user,
      :api_password => api_password
    }.merge(opts))
  end
end
