require File.expand_path(File.dirname(__FILE__) + "/environment")
env :PATH, ENV['PATH']
env :GEM_PATH, ENV['GEM_PATH']
# set :bundle_command, "/Users/Tim_Mee/.rvm/wrappers/snow_maps/bundle"

set :output, { error: 'error.log', standard: 'cron.log' }

every 2.minutes do
  rake "db:drop"
  rake "db:create"
  rake "db:migrate"
  rake "db:seed"
end