class Issue < BaseModel

  field :name, type: String
  field :lat, type: Float
  field :lon, type: Float
  field :address, type: String, default: ''
  field :category, type: String
  field :images, type: Array, default: []
  field :vote_counter, type: Integer, default: 0

  validates :name, presence: true
  validates :category, presence: true
  validates :lat, presence: true
  validates :lon, presence: true

  validate :coordinates
  validate :allowed_category
  validate :minimum_one_image
  validate :image_urls

  before_save :set_thumbnails
  before_validation :downcase_category

  def self.search s
    self.any_of({
      name: /.*#{s}.*/i,
      address: /.*#{s}.*/i,
      category: /.*#{s}.*/i
    })
  end

  def upvote!
    self.vote!(1)
  end

  def downvote!
    self.vote!(-1)
  end

  def vote! i
    self.inc(:vote_counter, i)
  end

  protected

  def downcase_category
    self.category = self.category.downcase unless self.category.nil?
  end

  def set_thumbnails
    self.images.each do |img|
      # accessing a hash with either string or symbol keys
      # because the param keys in the test environment are saved as symbols
      # and on production they are saved as strings
      if img.with_indifferent_access[:url].start_with? Repara.base_url
        img[:thumb_url] = original_url_to_thumbnail_url(img.with_indifferent_access[:url])
      end
    end
  end

  # check that image url is valid
  def minimum_one_image
    self.errors.add(:minimum_one_image_required, 'requires at least one image') unless
    !self.images.empty?
  end

  def image_urls
    self.images.each do |img|
      unless img.class == Hash
        self.errors.add(:invalid_image_hash_format, 'invalid image hash format')
        return
      end
      # accessing a hash with either string or symbol keys
      # because the param keys in the test environment are saved as symbols
      # and on production they are saved as strings
      img = img.with_indifferent_access

      unless img.has_key?(:url)
        self.errors.add(:invalid_image_hash_format, 'invalid image hash format')
        return
      end

      img_url = img[:url]

      self.errors.add(:invalid_image_url, 'invalid image url') unless
      img_url =~ URI::regexp

      self.errors.add(:invalid_image_format, 'invalid image format') unless
      image?(img_url)
    end
  end

  def coordinates
    self.errors.add(:invalid_lat, 'invalid lat') unless
    self.lat.nil? || -90.0 < self.lat && self.lat < 90.0

    self.errors.add(:invalid_lon, 'invalid lon') unless
    self.lon.nil? || -180.0 < self.lon && self.lon < 180
  end

  def allowed_category
    self.errors.add(:invalid_category, 'invalid category') unless
    Repara.categories.include? self.category
  end
end
