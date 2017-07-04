require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'hirb'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TicketingService
  class Application < Rails::Application
    config.time_zone = 'Asia/Kolkata'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}', '{**/*}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'controllers', '{**}', '{**/*}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'exceptions')]
    config.autoload_paths += Dir[Rails.root.join('app', 'services', '{**}', '{**/*}')]

    config.active_record.raise_in_transactional_callbacks = true

    Hirb.enable

    config.middleware.insert_before ActionDispatch::Static, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options, :put, :delete]
      end
    end
  end
end
