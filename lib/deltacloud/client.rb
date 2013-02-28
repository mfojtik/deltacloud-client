module Deltacloud
  module Client
    require 'nokogiri'
    require 'faraday'

    # Used for development ;-)
    require 'pry' rescue nil

    # Core extensions
    require_relative './core_ext/string'
    require_relative './core_ext/nil'

    # Faraday Middleware
    require_relative './error_response'

    # Errors && Helpers
    require_relative './client/base_error'
    require_relative './client/helpers/xml_helper'

    # Deltacloud API methods
    require_relative './client/methods/api'
    require_relative './client/methods/backward_compatiblity'

    # Extend Client module with methods that existed in old client
    # and we want to keep them.
    # Deprecation warnings should be provided to users if they use something
    # from these modules.
    #
    extend Deltacloud::Client::Methods::BackwardCompatibility::ClassMethods

    require_relative './client/methods/realm'
    require_relative './client/methods/instance'
    require_relative './client/methods/instance_state'

    # Deltacloud models
    require_relative './client/models/base'
    require_relative './client/models/realm'
    require_relative './client/models/instance_address'
    require_relative './client/models/instance'
    require_relative './client/models/instance_state'

    require_relative './client/connection'

    VERSION = '0.0.1'
  end

  def self.Client(url, api_user, api_password)
    Client::Connection.new(
      :url => url,
      :api_user => api_user,
      :api_password => api_password
    )
  end
end
