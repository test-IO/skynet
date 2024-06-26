# Skynet

This gem likely doesn't concern you. Move along.

## No, it *does* concern me

Ok, here is what you need to know:

The `redis_stream` gem (from https://github.com/test-IO/redis_stream) needs to be installed, so make sure it is added to your Gemfile.

RedisStream needs to be configured (probably in your initializer).

You configure this gem like so:

```ruby
Skynet.configure do |config|
  config.base_uri = "https..."
  config.app_id = "..."
  config.secret = "..."
end
```

Now you have two classes available to you:

### Skynet::Client

Usage:

```ruby
client = Skynet::Client.new(agent_session_id: "...")

# get the agent session
session = client.agent_session

# upload a file
client.upload(file)

# download a file
file = client.download(uuid)
```

### Skynet::Logger

Usage:

```ruby
logger = Skynet::Logger.new(agent_session_id: "...", session_id: SecureRandom.uuid)
logger.start    # shortcut to publish started event
logger.finish   # shortcut to publish finished event
logger.info("something_happened", info: {})
logger.debug("something_happened", info: {})
logger.error("something_happened", info: {})
```

In some cases, like when you are using acidic_job, you will need to persist a session_id and pass it to each logger call like so:

```ruby
@session_id = SecureRandom.uuid # store this in your persisted attributes

logger = Skynet::Logger.new(agent_session_id: "...")

logger.start(session_id: @session_id)    # shortcut to publish started event
logger.finish(session_id: @session_id)   # shortcut to publish finished event
logger.info("something_happened", session_id: @session_id, info: {})
logger.debug("something_happened", session_id: @session_id, info: {})
logger.error("something_happened", session_id: @session_id, info: {})
```
