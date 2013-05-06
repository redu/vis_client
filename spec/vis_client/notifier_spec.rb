require 'spec_helper'

module VisClient
  describe Notifier do
    let(:resource) { "/hierarchy_notifications.json" }
    let(:type) { "ximbica" }
    let(:args) do
      [Thing.new(:statusable_type => "human"),
       Thing.new(:statusable_type => "animal"),
       Thing.new(:statusable_type => "saiyan")]
    end

    before do
      Queue.any_instance.stub(:enqueue).and_return(true)
    end

    subject { Notifier.new(resource, type, args) }

    it "should create NotificationBuilder" do
      notification_builder = double(NotificationBuilder)
      notification_builder.stub(:build)

      NotificationBuilder.should_receive(:new).and_return(notification_builder)
      subject.build
    end

    it "should build objects with notifications builder" do
      notification_builder = double(NotificationBuilder)
      NotificationBuilder.stub(:new).and_return(notification_builder)

      notification_builder.should_receive(:build).
        exactly(args.size).times
      subject.build
    end

    it "should create a job for each element in args array" do
      args.each do |object|
        noti = NotificationBuilder.new.build(type, object)
        Job.should_receive(:new).with(noti.to_json, resource)
      end

      subject.build
    end

    it "should enqueue for delayed job all the jobs" do
      Queue.any_instance.should_receive(:enqueue).
        exactly(args.size).times
      subject.build
    end
  end
end
