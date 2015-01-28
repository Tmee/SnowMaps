namespace :snowmaps  do
  desc "Scrape all sites and gather data"
  task update_database: :environment do
    puts "begin Update"
    "rake db:reset"
  end
end