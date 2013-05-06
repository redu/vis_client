require 'spec_helper'

module VisClient
  describe NotifierBuilderJob do
    subject { NotifierBuilderJob.new(resource, type, args) }

    let(:resource) { "/hierarchy_notifications.json" }
    let(:type) { "enrollment" }
    let(:args) do
      [Thing.create(:statusable_type => "human"),
       Thing.create(:statusable_type => "animal"),
       Thing.create(:statusable_type => "saiyan")]
    end

    describe ".initialize" do
      context "with an array of elements" do
        it "should store args class" do
          subject.klass.should == Thing.to_s
        end

        it "should store args ids" do
          subject.ids.to_set.should == args.map(&:id).to_set
        end
      end

      context "with an ActiveRecord::Relation" do
        let!(:things) { Thing.create(:statusable_type => "human") }
        let(:args) { Thing.limit(1) }

        it "should store args class" do
          subject.klass.should == Thing.to_s
        end

        it "should store args ids" do
          subject.ids.to_set.should == args.map(&:id).to_set
        end
      end
    end

    describe "#perform" do
      let(:notifier) { double(Notifier) }

      before do
        notifier.stub(:build)
      end

      it "should instantiate a Notifier with args instances" do
        Notifier.should_receive(:new).with(resource, type, args).
            and_return(notifier)
        subject.perform
      end

      it "should invoke Notifier#build without args" do
        Notifier.stub(:new).and_return(notifier)

        notifier.should_receive(:build).with(no_args())
        subject.perform
      end
    end
  end
end
