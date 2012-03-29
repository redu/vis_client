require "vis_client/version"
require 'json'

module VisClient

  class Redirection < Exception
  end
  class BadRequest < Exception
  end
  class UnauthorizedAccess < Exception
  end
  class ResourceNotFound < Exception
  end
  class ConnectionError < Exception
  end

  def send_async_info(params, url)
    EM.run {
      http = EM::HttpRequest.new(url).post({
        :body => params.to_json,
        :head => {'Authorization' => ["core-team", "JOjLeRjcK"],
                  'Content-Type' => 'application/json' }
      })

      http.callback {
        handle_response(http.response_header.status, http.response.chomp)
        EM.stop
      }

      http.errback {
        raise ConnectionError, "Unknown error (status code #{http.response_header.status}): #{http.response.chomp}"
        EM.stop
      }

   }
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
