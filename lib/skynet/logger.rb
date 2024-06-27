# frozen_string_literal: true

module Skynet
  class Logger
    def initialize(agent_session_id, session_id: nil)
      @session_id = session_id
      @agent_session_id = agent_session_id
    end

    def start(session_id: nil)
      info("started", session_id: session_id)
    end

    def finish(session_id: nil)
      info("finished", session_id: session_id)
    end

    def info(event, session_id: nil, info: {})
      log(event, session_id: session_id || @session_id, info: {level: :info}.merge(info))
    end

    def error(event, session_id: nil, info: {})
      log(event, session_id: session_id || @session_id, info: {level: :error}.merge(info))
    end

    def debug(event, session_id: nil, info: {})
      log(event, session_id: session_id || @session_id, info: {level: :debug}.merge(info))
    end

    private

    def log(event, session_id: nil, info: {})
      RedisStream.default_logger.publish(event, {
        service: RedisStream.config.stream_key,
        session: session_id,
        agent_session_id: @agent_session_id,
        info: info
      })
    end
  end
end
