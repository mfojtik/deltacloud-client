module Deltacloud
  module Client
    require 'nokogiri'
    require 'faraday'

    # Used for development ;-)
    require 'pry' rescue nil

    # Core extensions
    require_relative './core_ext/string'
    require_relative './core_ext/fixnum'
    require_relative './core_ext/nil'

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

    require_relative './client/methods/driver'
    require_relative './client/methods/realm'
    require_relative './client/methods/hardware_profile'
    require_relative './client/methods/image'
    require_relative './client/methods/instance'
    require_relative './client/methods/instance_state'
    require_relative './client/methods/storage_volume'

    # Deltacloud models
    require_relative './client/models/base'
    require_relative './client/models/driver'
    require_relative './client/models/realm'
    require_relative './client/models/hardware_profile'
    require_relative './client/models/image'
    require_relative './client/models/instance_address'
    require_relative './client/models/instance'
    require_relative './client/models/instance_state'
    require_relative './client/models/storage_volume'

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
