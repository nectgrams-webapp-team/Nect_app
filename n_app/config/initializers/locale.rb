# config/initializers/locale.rb

# Where the I18n library should search for translation files
I18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]

# Permitted locales available for the application
I18n.available_locales = [:en, :ja]

# Set default locale to something other than :en
I18n.default_locale = :ja

require "i18n/backend/fallbacks"

I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)

I18n.fallbacks.map(:ja => :en)

I18n.fallbacks[:ja] # => [:ja, :en]
