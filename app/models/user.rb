class User < ActiveRecord::Base
  validates :name, :presence => true
  validates :uid, :presence => true, uniqueness: true

  def self.find_or_create_by_auth(auth_data)
    user = find_or_create_user(auth_data)
    if user.name != auth_data["info"]["name"]
      user.name = auth_data["info"]["name"]
      user.save
    end
    user
  end

private

  def self.find_or_create_user(auth_data)
    User.where(provider: auth_data['twitter'], uid: auth_data['uid']).first_or_create
  end
end
