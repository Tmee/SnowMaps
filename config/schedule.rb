require File.expand_path(File.dirname(__FILE__) + "/environment")
env :PATH, ENV['PATH']



set :output, { error: 'error.log', standard: 'cron.log' }

# every 2.minutes do
#   command "VailScraper.scrape_for_vail_village_trails"
# end