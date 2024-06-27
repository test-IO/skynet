# frozen_string_literal: true

module Skynet
  class Logger
    def initialize(agent_session_id, session_id: nil)
      @session_id = session_id
      @agent_session_id = agent_session_id
      @logger = Skynet.config.logger || RedisStream.default_logger
      @stream_key = Skynet.config.stream_key || RedisStream.config.stream_key
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
      @logger.publish(event, {
        service: @stream_key,
        session: session_id,
        agent_session_id: @agent_session_id,
        info: info
      })
    end
  end
end
