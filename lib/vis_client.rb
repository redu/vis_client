require 'vis_client/version'
require 'vis_client/errors'
require 'vis_client/config'
require 'vis_client/adapter'
require 'vis_client/notification_builder'
require 'vis_client/job'
require 'vis_client/queue'
require 'vis_client/notifier'

module VisClient

  def self.configure(&block)
    yield(config) if block_given?
  end

  def self.config
    @config ||= Config.new
  end

  def self.notify_delayed(resource, type, *args)
    notifier = Notifier.new(resource, type, *args)
    notifier.build
    notifier
  end

end
