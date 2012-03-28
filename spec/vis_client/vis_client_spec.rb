require "spec_helper"
require "ruby-debug"

class Thing
  include VisClient
end

describe VisClient do
  before do
    @subject = Thing.new
    WebMock.reset!
    @example_url = "http://www.example.com"
  end

  context "send_async_info" do
    it "should response to send_async_info method" do
      @subject.should respond_to(:send_async_info)
    end

    it "should POST to a passed url" do
      EM.run {
        stub_request(:post, "http://www.example.com/?test=test").
        with(:headers => {'Content-Type'=>'application/json', 'Authorization'=>['JOjLeRjcK', 'core-team']}).
        to_return(:status => 200, :body => "", :headers => {})

        params = { :test => "test"}
        @subject.send_async_info(params, @example_url).callback {
          WebMock.should have_requested(:post, "http://www.example.com/?test=test")
          EM.stop
        }
      }
    end

    it "should a deferrable which fails whith Bad Request error" do
      stub_request(:post, "http://www.example.com/").
        with(:headers => {'Content-Type'=>'application/json', 'Authorization'=>['JOjLeRjcK', 'core-team']}).
        to_return(:status => 400, :body => "", :headers => {})
      defe = @subject.send_async_info("", @example_url)

      defe.callback {
        fail
      }
      defe.errback { |error|
        WebMock.should have_requested(:post, "http://www.example.com/")
        error.should be_kind_of(VisClient::BadRequest)
        EM.stop
      }
    end
 end

end
