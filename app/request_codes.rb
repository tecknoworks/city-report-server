module RequestCodes
  SUCCESS = 200

  BAD_REQUEST        = 400
  NOT_FOUND          = 404
  METHOD_NOT_ALLOWED = 405

  UNKNOWN_ERROR = 400000

  MISSING_NAME                = 400001
  INVALID_COORDINATES         = 400002
  INVALID_CATEGORY            = 400003
  REQUIRES_AT_LEAST_ONE_IMAGE = 400004
  MISSING_IMAGE               = 400005
  INVALID_IMAGE_HASH_FORMAT   = 400006

  INVALID_IMAGE_URL    = 400100
  INVALID_IMAGE_FORMAT = 400101
end
