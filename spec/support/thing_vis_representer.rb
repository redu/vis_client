require 'roar/representer/json'
require 'roar/representer/feature/hypermedia'

module Vis
  module ThingVisRepresenter
    include Roar::Representer::JSON
    include Roar::Representer::Feature::Hypermedia

    property :statusable_type
  end
end
