source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.3.6'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# gems from current radon gemfile
gem 'therubyracer'
gem 'less-rails'
gem 'twitter-bootstrap-rails', branch: 'bootstrap3', git: 'git://github.com/seyhunak/twitter-bootstrap-rails.git'

gem 'activerecord-session_store', '~>0.1.2'

gem 'acts_as_list', '~> 0.8.2'

gem 'formtastic', '~> 3.0'
#gem 'formtastic-bootstrap', '~> 3.0.0'

gem 'authlogic', '~> 3.4.0'
gem 'scrypt'
#gem 'declarative_authorization'
gem 'declarative_authorization', github: "stffn/declarative_authorization"

gem 'kaminari'
gem 'geonames'
gem 'pg', '~> 0.18'
gem 'rmagick', '>=4.1.0'
gem 'ruby_parser'
gem 'activerecord-import'

gem 'wice_grid'
gem 'font-awesome-sass',  '~> 4.3'

gem 'unicorn' 

gem 'openlayers-rails'

gem 'dotenv-rails', :require => 'dotenv/rails-now'
gem 'recaptcha', '~> 3.2.0', :require => 'recaptcha/rails'

gem 'bibtex-ruby', '~> 5.1.4'
gem 'twitter', '~> 5.0'

gem 'redcarpet', '~> 3.1.1'

# added gems to obtain original functionality
gem 'jquery-ui-rails'
gem "iconv", "~> 1.0.4"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 9.1.0'

  # gems from current radon gemfile
  gem 'rspec-rails'#, '~> 3.4.2'
  gem 'capybara'#, '~> 2.3'
  gem 'capybara-webkit'#, '~> 1.4.1'
  gem 'guard-rspec', '~> 4.7.2'
  gem 'launchy'
  gem "factory_bot_rails"#, '~> 4.4.1', :require => false
  gem 'database_cleaner'
  gem 'spork', '~> 1.0rc'
  gem 'guard-spork'
#  gem 'selenium-webdriver'#, '~> 2.52.0'
  gem 'webdrivers'
  gem 'transpec'
  gem 'travis'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 1.7.2'

  # gems from current radon gemfile
  gem 'capistrano', '~> 2.13.5'
  gem 'net-ssh', '~> 2.6.2'
end

# add these gems to help with the transition:
  gem 'protected_attributes'
#  gem 'rails-observers'
#  gem 'actionpack-page_caching'
#  gem 'actionpack-action_caching'

# CI and Code Coverage
gem 'simplecov-html', '~> 0.10.0', :require => false
gem 'codecov', :require => false, :group => :test
