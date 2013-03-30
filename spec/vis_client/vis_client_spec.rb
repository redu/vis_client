require "spec_helper"
require "ruby-debug"

module VisClient
  describe VisClient do
    context "when configuring elments" do
      let(:endpoint) { "http://localhost:4000" }

      before do
        VisClient.configure do |c|
          c.deliver_notifications = false
          c.endpoint = endpoint
          c.logger = String.new
        end
      end

      it "should have different endpoint" do
        VisClient.config.endpoint.should == endpoint
      end

      it "shouldn't deliver notifications" do
        VisClient.config.deliver_notifications.should == false
      end

      it "should log in STDERR" do
        VisClient.config.logger.should be_a_kind_of(String)
      end
    end

    context "#notify_delayed" do
      let(:resource) { "/hierarchy_notifications.json" }
      let(:type) { "enrollment" }
      let(:args) do
        [Thing.new("human"), Thing.new("animal"), Thing.new("saiyan")]
      end

      before do
        @notifier = double(Notifier)
        @notifier.stub(:build)
      end


      it "should instantiate Notifier" do
        Notifier.should_receive(:new).with(resource, type, args).
          and_return(@notifier)
        VisClient.notify_delayed(resource, type, args)
      end

      it "should call build method from Notifier" do
        Notifier.any_instance.
          should_receive(:build)
        VisClient.notify_delayed(resource, type, args)
      end
    end
  end
end
