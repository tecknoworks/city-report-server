class Attachment < ActiveRecord::Base
  attr_accessible :issue_id, :image
  belongs_to :issue
  has_attached_file :image, :styles => { :original => "500x500>" }
end
