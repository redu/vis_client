require "spec_helper"

module VisClient
  describe NotificationBuilder do
    let(:type) { "ximbica" }
    let(:object) { Thing.new("Saiyan") }

    subject { NotificationBuilder.new }

    context "after build" do
      it "should return a Notification" do
        subject.build(type, object).should be_an_instance_of Notification
      end

      it "should initialize a Notification with rights args" do
        Notification.should_receive(:new).
          with(:type => type, :payload => object.to_hash)
        subject.build(type, object)
      end
    end
  end
end
