class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_uri


  def current_uri
    request.env["PATH_INFO"]
  end

  def render_response code, message, response_hash
    {
      "status" =>
      {
        "code" => code,
        "message" => message
      },
        "response" => response_hash
    }
  end
end
