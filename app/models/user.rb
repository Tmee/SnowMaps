class User < ActiveRecord::Base

  validates :password, confirmation: true
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false }

end
