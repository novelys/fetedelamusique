source 'https://rubygems.org'

ruby '2.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.0.0.rc1', '< 5.1'
gem 'rails-i18n', '~> 5.0.0.beta4'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'haml'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'

gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
gem 'puma'
gem 'asset_sync'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'momentjs-rails'
gem 'bootstrap3-datetimepicker-rails'
gem 'simple_form'

gem 'mongoid', github: 'mongodb/mongoid'
gem 'fog-aws'
gem 'fog', require: 'fog/aws/storage'
gem 'paperclip', '~> 5.0.0.beta2'
gem 'mongoid-paperclip', require: "mongoid_paperclip"
gem 'geocoder'

gem 'devise'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  gem 'pry-rails'
  gem 'pry-nav'
  gem 'dotenv-rails'
  gem 'scalingo_databases_rake_tasks'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'rails_12factor', :groups => [:staging, :production]

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
