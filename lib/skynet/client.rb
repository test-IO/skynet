# frozen_string_literal: true

module Skynet
  class Client
    include HTTParty
    base_uri ::Skynet.config.base_uri

    headers "Content-Type" => "application/json"
    format :json

    raise_on [400, 401, 406, 422, 500]

    def initialize(agent_session_id: nil, secret: ::Skynet.config.secret, iss: ::Skynet.config.app_id)
      self.class.headers "Authorization" => "jwt #{jwt_token(secret:, iss:)}" if secret.present? && iss.present?
      @agent_session_id = agent_session_id
    end

    def agent_session
      self.class.get("/agent_sessions/#{@agent_session_id}", {})["agent_session"]
    end

    def upload(file)
      self.class.post("/uploads", body: { file: file })
    end

    def download(uuid)
      self.class.get("/uploads/#{uuid}")
    end

    def jwt_token(secret:, iss:, exp: 4.hours.from_now.to_i)
      payload = { iss:, exp: }
      header_fields = { alg: "HS256" }
      JWT.encode payload, secret, "HS256", header_fields
    end
  end
end
