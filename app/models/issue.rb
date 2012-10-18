class Issue < ActiveRecord::Base
  attr_accessible :category_id, :latitude, :longitude, :title, :attachment
  belongs_to :category
  has_one :attachment
  after_save :update_url

  def add_attachment(image_base64, image_name)
    File.open(image_name, "wb") do |file|
      file.write(ActiveSupport::Base64.decode64(image_base64))
    end
    image = File.open(image_name)
    @attachment = Attachment.new
    @attachment.image = image
    self.attachment = @attachment
    self.save
    File.delete(image_name)
  end

  private
  def update_url
    if self.attachment.present?
      self.image_url = self.attachment.image.url
    end
  end
end
