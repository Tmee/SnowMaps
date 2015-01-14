class Trail < ActiveRecord::Base
  belongs_to :peak

  validates :name, :presence => true
  validates :peak_id, :presence => true
end
