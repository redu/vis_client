require 'vis_client/version'
require 'vis_client/errors'
require 'vis_client/config'
require 'vis_client/adapter'

module VisClient

  def self.configure(&block)
    yield(config) if block_given?
  end

  def self.config
    @config ||= Config.new
  end

  def self.notify_post(params, action)
    @adapter ||= Adapter.new
    @adapter.send_request(params, action)
    @adapter
  end

end
