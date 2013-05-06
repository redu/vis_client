module VisClient
  class NotifierBuilder < Struct.new(:resource, :type, :args)
    def build
      if should_create_notifier_now?
        create_notifier_now
      else
        create_notifier_async
      end
    end

    private

    def should_create_notifier_now?
      qtt = args.is_a?(ActiveRecord::Relation) ? args.count : args.length

      qtt == 1 || type =~ /remove.*/
    end

    def create_notifier_async
      job = NotifierBuilderJob.new(resource, type, args)

      queue = Queue.new
      queue.enqueue(job)
    end

    def create_notifier_now
      notifier = Notifier.new(resource, type, args)
      notifier.build
    end
  end
end
