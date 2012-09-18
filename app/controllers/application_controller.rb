class ApplicationController < ActionController::Base
  protect_from_forgery

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
