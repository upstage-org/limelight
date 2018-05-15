source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem "jquery-slick-rails"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# More robust email validator
gem 'email_validator', '~> 1.6.0'

# For pretty URLs
gem 'friendly_id', '~> 5.2.1'

# Design library
gem 'bootstrap-sass', '~> 3.3.7'

# For soft deletion
gem 'paranoia', '~> 2.3.1'

# Protection from Spam Bots
gem 'invisible_captcha', '~> 0.9.1'

# To automatically identify links
gem 'rails_autolink', '~> 1.1.6'

# Handles uploads
gem 'paperclip', '~> 5.2.0'

# Rich editor
gem 'bootstrap-wysihtml5-rails', '~> 0.3.3.8'

# Uses Bootstrap modal in place of built-in confirm()
gem 'data-confirm-modal'

# Enables ActiveRecord query based on time
gem 'by_star', git: "https://github.com/radar/by_star.git"

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.6'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'rails-controller-testing'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :production do
  # Use MySQL2 as the database for Active Record
  gem 'mysql2'
  # Use Redis adapter to run Action Cable
  gem 'redis', '~> 3.0'
end
