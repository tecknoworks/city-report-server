class BaseModel
  include Mongoid::Document
  include Mongoid::Timestamps

  include ReparaHelper

  def to_api
    self
  end
end
