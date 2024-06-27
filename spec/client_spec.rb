RSpec.describe Skynet::Client do
  before do
    Skynet.configure do |config|
      config.secret = "secret"
      config.app_id = "app_id"
      config.base_uri= "https://www.skynet.com"
    end
  end

  describe "#agent_session" do
    let(:agent_session_id) { SecureRandom.uuid }
    let(:response_api) do
      {
        agent_session: {
          id: agent_session_id,
          test_cycle: {
            id: SecureRandom.uuid,
            url: "https://www.example.com"
          }
        }
      }
    end

    it "finds an agent session" do
      stub_api = stub_request(:get, "https://www.skynet.com/agent_sessions/#{agent_session_id}")
        .to_return(status: 200, body: response_api.to_json)

      response = described_class.new.agent_session(agent_session_id)

      expect(stub_api).to have_been_requested
      expect(response["id"]).to eq(agent_session_id)
      expect(response["test_cycle"]["url"]).to eq("https://www.example.com")
    end
  end

  describe "#upload" do
    it "uploads a file" do
      file_id = rand(9999)
      file = File.new("spec/fixtures/file.txt")
      stub_api = stub_request(:post, "https://www.skynet.com/uploads")
        .to_return(status: 200, body: { file: { id: file_id }}.to_json)

      response = described_class.new.upload(file)

      expect(stub_api).to have_been_requested
      expect(response["file"]["id"]).to eq(file_id)
    end
  end
end
