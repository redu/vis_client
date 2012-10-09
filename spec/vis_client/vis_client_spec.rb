require "spec_helper"
require "ruby-debug"

class Thing
  include VisClient
end

describe VisClient do
  context "using vis development mode" do
    before do
      @subject = Thing.new
    end

    it "should POST to specific URL" do
      params = {
        :hierarchy_notification => {
          :user_id => 1,
          :type => "help",
          :lecture_id => 1,
          :subject_id => 1,
          :space_id => 1,
          :course_id => 1,
          :status_id => 1,
          :statusable_id => 1,
          :statusable_type => "Lecture",
          :in_response_to_id => nil,
          :in_response_to_type => nil
        }
      }

      url = "http://localhost:3000/hierarchy_notifications.json"
      http = @subject.send_async_info(params, url)
    end
  end
end
