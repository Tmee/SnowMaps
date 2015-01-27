class Peak < ActiveRecord::Base
  belongs_to :mountain
  has_many :trails


  validates :name, :presence => true
end
