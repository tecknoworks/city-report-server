class Attachment < ActiveRecord::Base
  attr_accessible :issue_id
  belongs_to :issue
end
