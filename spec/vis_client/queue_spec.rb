require 'spec_helper'

module VisClient
  describe Queue do

    subject { Queue.new }

    let(:params) do
      {:master => "Goku", :son => "Gohan"}.to_json
    end

    let(:url) do
      "/hierarchy_notifications.json"
    end

    let(:job) do
      Job.new(params, url)
    end

    let(:different_queue) do
      Queue.new("general")
    end

    it "should enqueue the job" do
      Delayed::Job.should_receive(:enqueue).
        with(job, :queue => subject.default_queue)
      subject.enqueue(job)
    end

    it "should enqueue the job on the configured queue" do
      Delayed::Job.should_receive(:enqueue).with(job, :queue => "general")
      different_queue.enqueue(job)
    end

    it "should call send_request after all" do
      Adapter.any_instance.should_receive(:send_request).
        once.with(params, url)
      subject.enqueue(job)
    end

    it "should return the job" do
      Adapter.any_instance.stub(:send_request).and_return(true)
      subject.enqueue(job).should be_a Delayed::Job
    end
  end
end
