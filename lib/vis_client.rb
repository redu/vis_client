require "vis_client/version"

module VisClient

  class Redirection
  end
  class BadRequest
  end
  class UnauthorizedAccess
  end
  class ResourceNotFound
  end
  class ConnectionError
  end

  def send_async_info(params, url)
    deferrable = EM::DefaultDeferrable.new

    http = EM::HttpRequest.new(url).post({
      :query => params, :timeout => 5,:body => "",
      :head => {'Content-Type' => 'application/json', 'authorization' => ["core-team", "JOjLeRjcK"] }
    })
    http.callback {
      begin
        handle_response(http.response_header.status, http.response.chomp)
        deferrable.succeed
      rescue => e
        deferrable.fail(e)
      end
    }
    http.errback {
      deferrable.fail(Error.new("Network error connecting to pusher"))
    }

    deferrable
  end

  private

  def handle_response(status_code, body)
    case status_code
    when 200
      return true
    when 202
      return true
    when 400
      raise BadRequest, "Bad request: #{body}"
    when 401
      raise UnauthorizedAccess, body
    when 404
      raise ResourceNotFound, "Resource not found: app_id is probably invalid"
    else
      raise ConnectionError, "Unknown error (status code #{status_code}): #{body}"
    end
  end

end
