require 'spec_helper'

module VisClient
  shared_examples "use Notifier" do
    it "should instantiate Notifier with args" do
      Notifier.should_receive(:new).with(resource, type, args).
          and_return(notifier)
      subject.build
    end

    it "should invoke Notifier#build" do
      Notifier.stub(:new).and_return(notifier)
      notifier.should_receive(:build).with(no_args())
      subject.build
    end
  end

  describe NotifierBuilder do
    describe "#build" do
      before(:all) do
        Delayed::Worker.delay_jobs = true
      end

      after(:all) do
        Delayed::Worker.delay_jobs = false
      end

      subject { NotifierBuilder.new(resource, type, args) }
      let(:resource) { "/hierarchy_notifications.json" }
      let(:type) { "enrollment" }

      context "with type related to removal" do
        let(:type) { "remove_enrollment" }

        let(:args) { [Thing.new("human"), Thing.new("bike")] }
        let(:notifier) { double(Notifier) }

        before do
          notifier.stub(:build)
        end

        include_examples 'use Notifier'
      end

      context "with one element" do
        let(:args) { [Thing.new("human")] }
        let(:notifier) { double(Notifier) }

        before do
          notifier.stub(:build)
        end

        include_examples 'use Notifier'
      end

      context "with many elements" do
        let(:notifier_builder_job) { double(NotifierBuilderJob) }
        let(:queue) { double(Queue) }

        before do
          notifier_builder_job.stub(:perform)
          queue.stub(:enqueue)
        end

        context "in an Array" do
          let(:args) do
            [Thing.new("human"), Thing.new("animal"), Thing.new("saiyan")]
          end

          it "should instantiate NotifierBuilderJob with args" do
            NotifierBuilderJob.should_receive(:new).with(resource, type, args).
              and_return(notifier_builder_job)
            subject.build
          end

          it "should instantiate Queue" do
            Queue.should_receive(:new).and_return(queue)
            subject.build
          end

          it "should invoke Queue#enqueue with notifier_builder_job" do
            NotifierBuilderJob.stub(:new).and_return(notifier_builder_job)
            Queue.stub(:new).and_return(queue)

            queue.should_receive(:enqueue).with(notifier_builder_job)
            subject.build
          end
        end

        context "with an ActiveRecord::Relation" do
          let!(:things) do
            %w(human animal saiyan).each do |name|
              Thing.create(:statusable_type => name)
            end
          end
          let(:args) { Thing.limit(3) }

          it "should not query the DB to get the instances" do
            NotifierBuilderJob.stub(:new).and_return(notifier_builder_job)

            args.should_not_receive(:length)
            args.should_receive(:count)
            subject.build
          end
        end
      end
    end
  end
end
