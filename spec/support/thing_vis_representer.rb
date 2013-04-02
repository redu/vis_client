require 'roar/representer/json'
require 'roar/representer/feature/hypermedia'

module ThingVisRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia

  property :type
end
