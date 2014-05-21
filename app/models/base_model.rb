class BaseModel
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Mongoid::Search

  include ReparaHelper

  def to_api
    self
  end
end
