module VisClient
  class Notification
    attr_reader :type, :payload

    def initialize(attr={})
      @type = attr[:type]
      @payload = attr[:payload]

      self.extend(NotificationRepresenter)
    end

    def method_missing(meth, *args, &block)
      self.payload.fetch(meth.to_s, nil)
    end
  end
end
