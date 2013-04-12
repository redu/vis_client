module VisClient
  class NotificationBuilder
    REP_SUFFIX = "VisRepresenter"

    def build(type, object)
      representer = get_representer_from_object(object)
      object = object.extend(representer)
      Notification.new(:type => type, :payload => object.to_hash)
    end

    private

    def get_representer_from_object(object)
      Vis.const_get(object.class.name + REP_SUFFIX)
    end
  end
end
