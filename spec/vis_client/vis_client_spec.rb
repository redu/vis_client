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

    context "when calling notify_post" do
      let(:params) { {:test => "test" } }
      let(:action) { "/hierarchy_notifications.json" }

      it "should call send_request method from Adapter" do
        Adapter.any_instance.
          should_receive(:send_request).with(params, action)
        VisClient.notify_post(params, action)
      end
    end
  end
end
