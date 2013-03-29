module VisClient
  class Job
    attr_accessor :params, :url

    def initialize(params, url)
      @params = params
      @url = url
    end

    def perform
      adapter = Adapter.new
      adapter.send_request(params, url)
    end
  end
end
