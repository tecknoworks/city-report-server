class ApiStatus
  def self.OK
    "Ok"
  end

  def self.OK_CODE
    200
  end

  def self.NOT_MODIFIED
    "Not Modified"
  end
  def self.NOT_MODIFIED_CODE
    304
  end

  def self.BAD_REQUEST
    "Bad Request"
  end
  def self.BAD_REQUEST_CODE
    400
  end

  def self.UNAUTHORIZED
    "Unauthorized"
  end
  def self.UNAUTHORIZED_CODE
    400
  end

  def self.FORBIDDEN
    "Forbidden"
  end
  def self.FORBIDDEN_CODE
    403
  end

  def self.NOT_FOUND
    "Not Found"
  end
  def self.NOT_FOUND_CODE
    404
  end

  def self.ENHANCE_YOUR_CALM
    "Enhance Your Calm"
  end
  def self.ENHANCE_YOUR_CALM_CODE
    420
  end

  def self.INTERNAL_SERVER_ERROR
    "Internal Server Error"
  end
  def self.INTERNAL_SERVER_ERROR_CODE
    500
  end

  def self.CORUPTED_REQUEST_DATA_OR_INTERNAL_SERVER_ERROR
    "Corupted request data or internal server error"
  end
  def self.CORUPTED_REQUEST_DATA_OR_INTERNAL_SERVER_ERROR_CODE
    501
  end

  def self.BAD_GATEWAY
    "Bad Gateway"
  end
  def self.BAD_GATEWAY_CODE
    502
  end

  def self.SERVICE_UNAVAILABLE
    "Service Unavailable"
  end
  def self.SERVICE_UNAVAILABLE_CODE
    503
  end
end
