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
    require_relative './client/methods/instance'

    # Deltacloud models
    require_relative './client/models/base'
    require_relative './client/models/instance_address'
    require_relative './client/models/instance'

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
