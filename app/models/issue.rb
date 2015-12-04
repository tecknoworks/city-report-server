class Issue < BaseModel

  VALID_STATUSES = %w(unresolved acknowledged resolved)

  self.primary_key = 'id'
  field :name, type: String
  field :status, type: String, default: VALID_STATUSES.first
  field :category, type: String
  field :lat, type: Float
  field :lon, type: Float
  field :address, type: String, default: ''
  field :neighborhood, type: String, default: ''
  field :device_id, type: String
  field :vote_counter, type: Integer, default: 0
  field :images, type: Array, default: []
  field :comments, type: Array, default: []
  field :coordinates, type: Array, default: []

  attr_accessor :images_raw
  attr_accessor :comments_raw
  def images_raw
    self.images.collect do |img|
      img.with_indifferent_access['url'].try(:strip)
    end.join("\n") unless self.images.nil?
  end

  def images_raw=(values)
    self.images = []
    values.split("\n").each do |val|
      self.images << { url: val.try(:strip) }
    end
  end

  def comments_raw
    self.comments.join("\n") unless self.comments.nil?
  end

  def comments_raw=(values)
    self.comments = []
    self.comments = values.split("\n")
  end

  before_validation :downcase_category

  validates :name, presence: true
  validates :device_id, presence: true
  validates :category, presence: true
  validates :lat, presence: true
  validates :lon, presence: true
  validates :status, presence: true

  validates :status, inclusion: VALID_STATUSES

  validate :limit_coordinates
  validate :allowed_category
  validate :minimum_one_image
  validate :image_urls
  validate :comments_format
  validate :string_size_limit

  before_save :set_thumbnails
  before_save :complete_coordinates

  after_create :complete_address

  SEARCHABLE_FIELDS = [:name, :address, :comments, :neighborhood]
  search_in SEARCHABLE_FIELDS

  def complete_address
    GeocodeWorker.perform_async id.to_s
  end

  def complete_coordinates
    self.coordinates = []
    self.coordinates.push(self.lat)
    self.coordinates.push(self.lon)
  end

  def add_params_to_set params
    # params = params.clone.with_indifferent_access
    ['images', 'comments'].each do |key|
      if params.has_key?(key)
        params[key].each do |s|
          self.add_to_set({key => s})
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
    self.inc(vote_counter: i)
  end

  def distance_to_map_center
    map_center = Repara.map_center
    lat = self.lat != nil ? self.lat : 100000
    lon = self.lon != nil ? self.lon : 100000
    delta_lat = map_center['lat'] - lat
    delta_lon = map_center['lon'] - lon
    Math.sqrt(delta_lat * delta_lat + delta_lon * delta_lon)
  end

  def ip_v4?
    address =~ Resolv::IPv4::Regex ? true : false
  end

  def ip_v6?
    address =~ Resolv::IPv6::Regex ? true : false
  end

  protected

  def string_size_limit
    ['name', 'address'].each do |key|
      max_length = Repara.send("#{key}_max_length")
      self.errors.add(:string_too_big, "#{key} can not be longer than #{max_length} characters") if
      (!self.send(key).nil? && self.send(key.to_sym).length > max_length)
    end

    ['comments'].each do |key|
      max_length = Repara.send("#{key}_max_length")
      self.send(key).each do |comment|
        self.errors.add(:string_too_big, "#{key} can not be longer than #{max_length} characters") if
        comment.length > max_length
      end
    end
  end

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
      img_hash = img.with_indifferent_access
      if img_hash[:url].start_with? Repara.base_url
        img[:thumb_url] = original_url_to_thumbnail_url(img_hash[:url])
      end
    end
  end

  # check that image url is valid
  def minimum_one_image
    self.errors.add(:minimum_one_image_required, '!') unless
    !self.images.empty?
  end

  def image_urls
    self.images.each do |img|
      # TODO clean this up
      # we are no longer using sinatra
      unless img.class == Hash || img.class == ActiveSupport::HashWithIndifferentAccess || img.class == ActionController::Parameters
        self.errors.add(:invalid_image_hash_format, 'Not a hash. check /doc for the required format!!')
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

  def limit_coordinates
    self.errors.add(:invalid_lat, 'is it between -90 and 90?') unless
    self.lat.nil? || -90.0 < self.lat && self.lat < 90.0

    self.errors.add(:invalid_lon, 'is it between -180 and 180?') unless
    self.lon.nil? || -180.0 < self.lon && self.lon < 180

    if Repara.max_distance_validator
      self.errors.add(:invalid_coordinates_too_far_from_map_center, "allowed to place issues only around #{Repara.map_center_lat}:#{Repara.map_center_lon}") if
      self.distance_to_map_center > Repara.max_distance_to_map_center
    end
  end

  def allowed_category
    self.errors.add(:invalid_category, 'check /meta for allowed categories') unless
    Category.to_api.include? self.category
  end

end
