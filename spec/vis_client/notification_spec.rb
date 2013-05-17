require "spec_helper"

module VisClient
  describe Notification do
    let(:payload) do
      { "user_id" => 1, "created_at" => Time.now,
        "updated_at" => Time.now, "lecture_id" => 1,
        "subject_id" => 1, "space_id" => 1, "course_id" => 1,
        "grade" => 2.5}
    end
    let(:type) { "type" }

    let(:attr) { {:type => type, :payload => payload} }

    let(:only_keys) do
      new_hash = payload.merge({:type => type})
      new_hash.keys.map { |k| k.to_s }
    end


    subject { Notification.new(attr) }
    context "when initializing" do

      it "should assign value to variable type" do
        subject.type.should == type
      end

      it "should assign value to variable payload" do
        subject.payload.should == payload
      end

      it "should get value through payload keys" do
        subject.user_id.should == payload["user_id"]
      end

      it "should return nil if there isn't a key on payload" do
        subject.ximbica.should be_nil
      end

      it "should return hash based on NotificationRepresenter" do
       only_keys.each do |key|
          subject.to_hash.should have_key(key)
        end
      end
    end
  end
end
