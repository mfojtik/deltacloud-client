module Faraday
  module MockSessionHelper
    def on_complete(&block)
      yield(self) if block_given?
      self
    end
    def [](prop)
      self.send(prop)
    end
  end

  class DeltacloudServer < Faraday::Middleware

    require 'rack/test'

    def deltacloud_server
      Deltacloud::configure do |server|
        server.root_url '/api'
        server.version Deltacloud::API_VERSION
        server.klass 'Deltacloud::API'
      end
      Deltacloud[:deltacloud]
    end

    def initialize(app, *args)
      deltacloud_server.require!
      @app = Rack::Test::Session.new(
        Rack::MockSession.new(Deltacloud::API)
      )
    end

    def call(env)
      result = @app.request(
        fix_api_path(env[:url].path),
        {
          'REQUEST_METHOD' => env[:method].to_s.upcase,
          'SCRIPT_NAME' => env[:url].path,
          'QUERY_STRING' => env[:url].query || '',
          'CONTENT_TYPE' => 'text/xml'
        }.merge(convert_headers(env[:request_headers]))
      )
      result.extend(Faraday::MockSessionHelper)
      result
    end

    # Convert original Faraday request headers to
    # the format that Rack::Request accept
    #
    def convert_headers(original_headers)
      original_headers.inject({}) { |r, v|
        r["HTTP_#{v[0].gsub('-', '_').upcase}"] = v[1]
        r
      }
    end

    # Remove the /api prefix from URL because MockSession
    # mount the app to /
    #
    def fix_api_path(path)
      path.gsub(/^\/api/,'')
    end
  end
end
