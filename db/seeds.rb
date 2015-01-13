class Seed

  def initialize
    generate_admin
    generate_mountains
  end

  def generate_admin
    User.create!(first_name: "Tim",
                  last_name: "Mee",
                  email: "tjeme90@gmail.com",
                  password: "password",
                  password_confirmation: "password"
                  )

    puts 'Users have been created'
  end

  def generate_mountains
    Mountains.create!(name: "Vail")

    puts 'Mountains created'
  end

end

Seed.new