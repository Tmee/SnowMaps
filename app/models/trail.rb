class Trail < ActiveRecord::Base
  belongs_to :peak


  validates :peak_id, :presence => true
end
