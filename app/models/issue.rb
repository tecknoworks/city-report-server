class Issue
  include Mongoid::Document

  field :name, type: String
  field :lat, type: Float, default: 0.0
  field :lon, type: Float, default: 0.0
  field :address, type: String, default: ''
  field :category, type: String, default: ''
  field :images, type: Array, default: []

  validates :name, presence: true
  validates :category, presence: true

  validate :coordinates
  validate :category_item

  protected

  def coordinates
    self.errors.add(:base, 'invalid lat or lon') unless
    -90.0 < self.lat && self.lat < 90.0 && -180.0 < self.lon && self.lon < 180
  end

  def category_item
    self.errors.add(:base, 'invalid category') unless
    Repara.config['meta']['categories'].include? self.category
  end
end
