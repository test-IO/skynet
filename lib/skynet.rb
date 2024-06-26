# frozen_string_literal: true

require_relative "skynet/version"
require_relative "skynet/configuration"
require_relative "skynet/client"
require_relative "skynet/logger"

module Skynet
  class Error < StandardError; end

  def self.configure
    yield config if block_given?
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.config
    configuration
  end
end
