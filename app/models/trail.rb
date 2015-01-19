class Trail < ActiveRecord::Base
  belongs_to :peak
  belongs_to :mountain

  validates :peak_id, :presence => true
end
