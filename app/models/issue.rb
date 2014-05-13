class Issue < BaseModel

  field :name, type: String
  field :lat, type: Float
  field :lon, type: Float
  field :address, type: String, default: ''
  field :category, type: String
  field :vote_counter, type: Integer, default: 0
  field :images, type: Array, default: []
  field :comments, type: Array, default: []

  validates :name, presence: true
  validates :category, presence: true
  validates :lat, presence: true
  validates :lon, presence: true

  validate :coordinates
  validate :allowed_category
  validate :minimum_one_image
  validate :image_urls
  validate :comments_format

  before_save :set_thumbnails
  before_validation :downcase_category

  search_in :name, :address, :category, :comments

  def add_params_to_set params
    # params = params.clone.with_indifferent_access
    ['images', 'comments'].each do |key|
      if params.has_key?(key)
        params[key].each do |s|
          self.add_to_set(key, s)
        end
      end
    end
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

  def comments_format
    self.comments.each do |comment|
      self.errors.add(:invalid_comment_format, 'string only') unless
      comment.class == String
    end
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
    self.errors.add(:minimum_one_image_required, '') unless
    !self.images.empty?
  end

  def image_urls
    self.images.each do |img|
      unless img.class == Hash
        self.errors.add(:invalid_image_hash_format, 'check /doc for the required format')
        return
      end
      # accessing a hash with either string or symbol keys
      # because the param keys in the test environment are saved as symbols
      # and on production they are saved as strings
      img = img.with_indifferent_access

      unless img.has_key?(:url)
        self.errors.add(:invalid_image_hash_format, 'check /doc for the required format')
        return
      end

      img_url = img[:url]

      self.errors.add(:invalid_image_url, 'it needs to be a valid URL') unless
      img_url =~ URI::regexp

      self.errors.add(:invalid_image_format, 'only png images supported') unless
      image?(img_url)
    end
  end

  def coordinates
    self.errors.add(:invalid_lat, 'is it between -90 and 90?') unless
    self.lat.nil? || -90.0 < self.lat && self.lat < 90.0

    self.errors.add(:invalid_lon, 'is it between -180 and 180?') unless
    self.lon.nil? || -180.0 < self.lon && self.lon < 180
  end

  def allowed_category
    self.errors.add(:invalid_category, 'check /meta for allowed categories') unless
    Repara.categories.include? self.category
  end
end
