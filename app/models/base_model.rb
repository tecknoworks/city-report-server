class BaseModel
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Mongoid::Search

  include ReparaHelper
  include RequestCodes

  def to_api
    self
  end

  def first_error_desc
    self.errors.first.join(' ')
  end

  def first_error_code
    case self.errors.first.first
    when :name
      code = MISSING_NAME
    when :invalid_lat, :invalid_lon
      code = INVALID_COORDINATES
    when :invalid_category
      code = INVALID_CATEGORY
    when :invalid_image_url
      code = INVALID_IMAGE_URL
    when :invalid_image_format
      code = INVALID_IMAGE_FORMAT
    when :minimum_one_image_required
      code = REQUIRES_AT_LEAST_ONE_IMAGE
    when :invalid_image_hash_format
      code = INVALID_IMAGE_HASH_FORMAT
    when :invalid_comment_format
      code = INVALID_COMMENT_FORMAT
    when :string_too_big
      code = STRING_TOO_BIG
    else
      code = UNKNOWN_ERROR
    end
    code
  end
end
