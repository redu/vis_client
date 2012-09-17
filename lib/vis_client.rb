require "vis_client/version"
require 'json'
require 'logger'

module VisClient

  class Redirection < StandardError
  end
  class BadRequest < StandardError
  end
  class UnauthorizedAccess < StandardError
  end
  class ResourceNotFound < StandardError
  end
  class ConnectionError < StandardError
  end
  class Conflict < StandardError
  end

  # send to vis application passed through url a set of params
  def send_async_info(params, url)
    EM.run {

      http = EM::HttpRequest.new(url).post({
        :body => params.to_json,
        :head => {'Authorization' => ["core-team", "JOjLeRjcK"],
                  'Content-Type' => 'application/json' }
      })

      http.callback {
        begin
          handle_response(http.response_header.status)
        rescue
          log = Logger.new("log/error.log")
          log.error "Callback, error with code: #{ http.response_header.status }"
          log.close
        end
        EM.stop
      }

      http.errback {
        begin
          handle_response(http.response_header.status)
        rescue
          log = Logger.new("log/error.log")
          log.error "Errback: Bad DNS or Timeout, code:#{ http.response_header.status }, with body: #{ http.req.body }"
          log.close
        end
        EM.stop
      }
    }
  end

  private

  def handle_response(status_code)
    case status_code
    when 200
      return true
    when 201
      return true
    when 202
      return true
    when 400
      raise BadRequest, "Bad request"
    when 401
      raise UnauthorizedAccess, "Not Authorized access to vis server."
    when 404
      raise ResourceNotFound, "Resource not found: app_id is probably invalid"
    when 409
      raise Conflict, "Resorce already exists"
    else
      raise ConnectionError, "Unknown error (status code #{status_code}): #{body}"
    end
  end

end
