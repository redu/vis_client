require 'roar/representer/json'
require 'roar/representer/feature/hypermedia'

module ThingVisRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia

  property :type
  @@type = nil

  def type
    @@type
  end

  def self.type=(type)
    @@type = type
  end
end
