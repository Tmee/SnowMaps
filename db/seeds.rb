class Seed

  def initialize
    generate_admin
  end

  def generate_admin
    User.create!(first_name: "Tim",
                  last_name: "Mee",
                  email: "tjeme90@gmail.com",
                  password: "password",
                  password_confirmation: "password",
                  )
  end
end

Seed.new