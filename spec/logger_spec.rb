RSpec.describe Skynet::Logger do
  class Logger
    def publish(event, info)
      { event: event, info: info }
    end
  end

  before do
    Skynet.configure do |config|
      config.logger = Logger.new
      config.stream_key = "stream-key"
    end
  end

  let(:instance) { described_class.new("agent-session-id") }
  let(:session_id) { "session-id" }
  let(:info) { { key: "value" } }
  describe "#start" do
    it "logs a start event" do
      instance.start
    end
  end

  describe "#finish" do
    it "logs a finish event" do
      instance.finish
    end
  end

  describe "#info" do
    it "logs an info event" do
      instance.info("info", session_id: session_id , info: info)
    end
  end

  describe "#error" do
    it "logs an error event" do
      instance.error("error", session_id: session_id , info: info)
    end
  end

  describe "#debug" do
    it "logs a debug event" do
      instance.debug("debug", session_id: session_id , info: info)
    end
  end
end
