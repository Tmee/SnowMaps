class User < ActiveRecord::Base
  validates :name, :presence => true
  validates :uid, :presence => true, uniqueness: true
end
