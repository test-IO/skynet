# frozen_string_literal: true

module Skynet
  class Configuration
    attr_accessor :base_uri, :app_id, :secret

    def initialize
    end

    def base_uri(uri)
      @base_uri = uri
    end

    def app_id(id)
      @app_id = id
    end

    def secret(secret)
      @secret = secret
    end
  end
end
