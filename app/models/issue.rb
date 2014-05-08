class Issue
  include Mongoid::Document
  include Mongoid::Timestamps

  include ReparaHelper

  field :name, type: String
  field :lat, type: Float
  field :lon, type: Float
  field :address, type: String, default: ''
  field :category, type: String
  field :images, type: Array, default: []

  validates :name, presence: true
  validates :category, presence: true
  validates :lat, presence: true
  validates :lon, presence: true

  validate :coordinates
  validate :allowed_category
  validate :minimum_one_image
  validate :image_urls

  protected

  # check that image url is valid
  def minimum_one_image
    self.errors.add(:minimum_one_image_required, 'requires at least one image') unless
    !self.images.empty?
  end

  def image_urls
    self.images.each do |img_url|
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
