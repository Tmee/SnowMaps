class Mountain < ActiveRecord::Base
  has_many :peaks

  validates :name, presence: true

  before_save :generate_slug


  def generate_slug
    self.slug = name.parameterize
  end
end
