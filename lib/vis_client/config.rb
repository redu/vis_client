require 'configurable'
require 'logger'

module VisClient
  class Config
    include Configurable

    # Logger used by vis_client. Default: STDOUT
    config :logger, Logger.new(STDOUT)

    # Deliver the notifications to the vis Server. Default: true
    config :deliver_notifications, true

    config :endpoint, "http://vis.redu.com.br/"
  end
end
