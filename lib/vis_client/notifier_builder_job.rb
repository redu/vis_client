module VisClient
  class NotifierBuilderJob
    attr_reader :resource, :type, :klass, :ids

    def initialize(resource, type, args)
      @resource = resource
      @type = type
      @klass, @ids = pluck_klass_and_ids(args)
    end

    def perform
      instances = klass.constantize.where(:id => ids)
      notifier = Notifier.new(resource, type, instances)
      notifier.build
    end

    private

    def pluck_klass_and_ids(instances)
      if instances.is_a? ActiveRecord::Relation
        [instances.klass.to_s, instances.values_of(:id)]
      else
        [instances.first.class.to_s, instances.map(&:id)]
      end
    end
  end
end
