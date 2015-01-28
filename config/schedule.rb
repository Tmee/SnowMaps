# require File.expand_path(File.dirname(__FILE__) + "/environment")
env :PATH, ENV['PATH']

env :GEM_PATH, ENV['GEM_PATH']
set :bundle_command, "/Users/Tim_Mee/.rvm/gems/ruby-2.1.2@global/bin/bundle"


set :output, { error: 'error.log', standard: 'cron.log' }

every 2.minutes do
  rake "db:drop"
  rake "db:create"
  rake "db:migrate"
  rake "db:seed"
  command "cd /Users/Tim_Mee/Turing/projects/self_directed/snow_maps && RAILS_ENV=production rake db:drop"
  command "cd /Users/Tim_Mee/Turing/projects/self_directed/snow_maps && RAILS_ENV=production rake db:create"
  command "cd /Users/Tim_Mee/Turing/projects/self_directed/snow_maps && RAILS_ENV=production rake db:migrate"
  command "cd /Users/Tim_Mee/Turing/projects/self_directed/snow_maps && RAILS_ENV=production rake db:seed"
end