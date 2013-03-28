require "spec_helper"

module VisClient
  describe NotificationBuilder do
    let(:type) { "ximbica" }
    let(:object) { Thing.new("Saiyan") }
    subject { NotificationBuilder.new(object, type) }

    it "should return the correct object" do
      subject.object.should be_an_instance_of Thing
    end

    it "should return the correct type" do
      subject.type.should == type
    end

    it "should return the correct representer" do
      subject.representer.should == ThingVisRepresenter
    end

    context "after build" do
      it "should return object" do
        subject.build.should be_an_instance_of Thing
      end

      it "should return object serialized by representer" do
        subject.build.to_json.should include("ximbica")
      end
    end
  end
end
