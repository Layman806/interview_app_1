require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # rubocop-rails config for running after `rails g`
    config.generators.after_generate do |files|
      parsable_files = files.filter { |file| file.end_with?('.rb') }
      unless parsable_files.empty?
        system("bundle exec rubocop -A --fail-level=E #{parsable_files.shelljoin}  --require rubocop-rails", exception: true)
      end
    end

    # Adding Logger
    config.logger = Logger.new(STDOUT)
    config.active_record.query_log_tags_enabled = true
  end
end