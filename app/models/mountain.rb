class Mountain < ActiveRecord::Base
  has_many :peaks
  has_many :trails, through: :peaks
  has_many :weather_reports

  validates :name, presence: true

  before_save :generate_slug

  def set_closed
    update_attribute(:open, false)
  end

  def set_open
    update_attribute(:open, true)
  end

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
