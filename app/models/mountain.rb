class Mountain < ActiveRecord::Base
  has_many :peaks
  has_many :trails, through: :peaks

  validates :name, presence: true

  before_save :generate_slug


  def generate_slug
    self.slug = name.parameterize
  end
end
