module VisClient
  class Notifier
    attr_accessor :resource, :type, :args

    def initialize(resource, type, args)
      @resource = resource
      @type = type
      @args = args
    end

    def build
      @args = @args.flatten
      queue = Queue.new

      @args.each do |object|
        notification_builder = NotificationBuilder.new(object, type)
        object = notification_builder.build

        job = Job.new(object.to_json, resource)
        queue.enqueue(job)
      end
    end
  end
end
