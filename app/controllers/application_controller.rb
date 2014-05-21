class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  def render_response body, code=200, status_code=nil
    body = {
      code: code,
      body: body
    }
    status_code ||= code

    render json: body, status: status_code
  end

end
