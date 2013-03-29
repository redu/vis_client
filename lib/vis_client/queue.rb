module VisClient
  class Queue
    DEFAULT_QUEUE = "vis"
    attr_accessor :default_queue

    def initialize(default_queue = nil)
      @default_queue = default_queue || DEFAULT_QUEUE
    end

    def enqueue(job)
      args = [job]
      args << { :queue => default_queue } if default_queue

      Delayed::Job.enqueue(*args)
    end
  end
end
