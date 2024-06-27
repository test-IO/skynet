# frozen_string_literal: true

# require_relative "../skynet"
require "httparty"
require "jwt"

module Skynet
  class Client
    include HTTParty

    headers "Content-Type" => "application/json"
    format :json

    raise_on [400, 401, 406, 422, 500]

    def initialize(secret: Skynet.config.secret, iss: Skynet.config.app_id)
      self.class.base_uri Skynet.config.base_uri
      self.class.headers "Authorization" => "jwt #{jwt_token(secret: secret, iss: iss)}"
    end

    def agent_session(agent_session_id)
      self.class.get("/agent_sessions/#{agent_session_id}", {})["agent_session"]
    end

    def upload(file)
      self.class.post("/uploads", body: {file: file})
    end

    def download(uuid)
      self.class.get("/uploads/#{uuid}")
    end

    def jwt_token(secret:, iss:, exp: 4.hours.from_now.to_i)
      payload = {iss: iss, exp: exp}
      header_fields = {alg: "HS256"}
      ::JWT.encode payload, secret, "HS256", header_fields
    end
  end
end
