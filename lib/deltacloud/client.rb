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

  def self.Client(url, api_user, api_password, opts={})
    Client::Connection.new({
      :url => url,
      :api_user => api_user,
      :api_password => api_password
    }.merge(opts))
  end
end
