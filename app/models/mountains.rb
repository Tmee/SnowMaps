class Mountains < ActiveRecord::Base
  validates :name, presence: true
end
