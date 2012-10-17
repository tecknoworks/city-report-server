class AddAttachmentImageToAttachments < ActiveRecord::Migration
  def self.up
    change_table :attachments do |t|
      t.has_attached_file :image
    end
  end

  def self.down
    drop_attached_file :attachments, :image
  end
end
