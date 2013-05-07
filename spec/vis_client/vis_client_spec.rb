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
      let(:notifier_builder) { double(NotifierBuilder) }

      before do
        notifier_builder.stub(:build)
      end

      context "with one element" do
        let(:args) { Thing.new(:statusable_type => "human") }

        it "should instantiate NotifierBuilder with [args]" do
          NotifierBuilder.should_receive(:new).with(resource, type, [args]).
            and_return(notifier_builder)
          VisClient.notify_delayed(resource, type, args)
        end

        it "should invoke NotifierBuilder#build without args" do
          NotifierBuilder.stub(:new).and_return(notifier_builder)

          notifier_builder.should_receive(:build).with(no_args())
          VisClient.notify_delayed(resource, type, args)
        end
      end

      context "with many elements" do
        let(:args) do
          [Thing.new(:statusable_type => "human"),
           Thing.new(:statusable_type => "animal"),
           Thing.new(:statusable_type => "saiyan")]
        end

        it "should instantiate NotifierBuilder with args" do
          NotifierBuilder.should_receive(:new).with(resource, type, args).
            and_return(notifier_builder)
          VisClient.notify_delayed(resource, type, args)
        end

        it "should invoke NotifierBuilder#build without args" do
          NotifierBuilder.stub(:new).and_return(notifier_builder)

          notifier_builder.should_receive(:build).with(no_args())
          VisClient.notify_delayed(resource, type, args)
        end
      end
    end
  end
end
