require File.expand_path('../boot', __FILE__)

require 'rails/all'
config.assets.paths << Rails.root.join("app", "assets", "foundation-icons")


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SnowMaps
  class Application < Rails::Application
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.assets.paths << Rails.root.join("app", "assets", "foundation-icons")
  end
end
