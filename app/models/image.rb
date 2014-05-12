class Image < BaseModel

  field :original_filename, type: String
  field :storage_filename, type: String
  field :storage_path, type: String
  field :storage_thumb_path, type: String
  field :url, type: String
  field :thumb_url, type: String

  validate :image_format

  before_save :set_data_from_original_filename

  def to_api
    {
      url: self.url,
      thumb_url: self.thumb_url
    }
  end

  protected

  def set_data_from_original_filename
    self.storage_filename = serialize_filename(self.original_filename)

    self.storage_path = File.join('public/images/uploads/original/', self.storage_filename)
    self.storage_thumb_path = File.join('public/images/uploads/thumb/', self.storage_filename)

    self.url = Repara.base_url + 'images/uploads/original/' + self.storage_filename
    self.thumb_url = Repara.base_url + 'images/uploads/thumb/' + self.storage_filename
  end

  def image_format
    self.errors.add(:invalid_image_format, 'only png images are allowed') unless
    image?(self.original_filename)
  end
end
