class Issue < ActiveRecord::Base
  attr_accessible :category_id, :latitude, :longitude, :title, :attachment
  belongs_to :category
  has_one :attachment
end
