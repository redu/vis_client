module VisClient
  class NotificationBuilder
    REP_SUFFIX = "VisRepresenter"
    attr_reader :type
    attr_accessor :object, :representer

    def initialize(object, type)
      @object = object
      @representer = get_representer_from_object
      @type = type
    end

    def build
      set_representer_type
      object.extend(representer)
      object
    end

    private

    def set_representer_type
      representer.type= type
    end

    def get_representer_from_object
      Object.const_get(object.class.name + REP_SUFFIX)
    end
  end
end
