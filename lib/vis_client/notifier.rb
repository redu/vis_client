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
      notification_builder = NotificationBuilder.new

      @args.each do |object|
        notification = notification_builder.build(type, object)

        job = Job.new(notification.to_json, resource)
        queue.enqueue(job)
      end
    end
  end
end
