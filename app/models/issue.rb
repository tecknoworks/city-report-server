class Issue
  include Mongoid::Document
  include Mongoid::Timestamps

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

  protected

  def coordinates
    self.errors.add(:lat, 'invalid lat') unless
    self.lat.nil? || -90.0 < self.lat && self.lat < 90.0

    self.errors.add(:lon, 'invalid lon') unless
    self.lon.nil? || -180.0 < self.lon && self.lon < 180
  end

  def allowed_category
    self.errors.add(:category, 'invalid category') unless
    Repara.config['meta']['categories'].include? self.category
  end
end
