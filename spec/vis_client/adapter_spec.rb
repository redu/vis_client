require "spec_helper"

module VisClient
  describe Adapter do
    let(:auth) { Base64::encode64("core-team:JOjLeRjcK").chomp }
    let(:headers) { {'Authorization' => auth,
                     'Content-Type'=>'application/json'} }
    let(:params) { {:test => "test"}.to_json }

    context "with default configurations" do
      subject { Adapter.new }

      it "should POST to a default endpoint" do
        stub_request(:post, VisClient.config.endpoint).
          with(:body => params, :headers => headers).
          to_return(:status => 201, :body => "", :headers => {})

        subject.send_request(params, "")

        a_request(:post, VisClient.config.endpoint).
          with(:body => params, :headers => headers).
          should have_been_made
      end
    end

    context "with customized configurations" do
      let(:endpoint) { "http://localhost:4000" }
      let(:resource) { "/hierarchy_notifications.json" }
      let(:url) { endpoint + resource }

      context "like different endpoint" do
        subject { Adapter.new("endpoint" => endpoint) }

        it "should POST to specific endpoint" do

          stub_request(:post, url).
            with(:body => params, :headers => headers).
            to_return(:status => 201, :body => "", :headers => {})

          subject.send_request(params, resource)

          a_request(:post, url).
            with(:body => params, :headers => headers).
            should have_been_made
        end
      end

      context "like deliver notification to false" do
        subject { Adapter.new("deliver_notifications" => false) }

        it "shouldn't POST to specific endpoint" do

          subject.send_request(params, resource)

          a_request(:post, url).
            with(:body => params, :headers => headers).
            should_not have_been_made
        end

        it "should logger a message" do
          Logger.any_instance.should_receive(:info).with(/Notifications are disabled/)

          subject.send_request(params, resource)
        end
      end
    end
  end
end
