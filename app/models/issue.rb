class Issue < ActiveRecord::Base
  attr_accessible :category_id, :latitude, :longitude, :title
  belongs_to :category
end
