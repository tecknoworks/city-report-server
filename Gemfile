source 'https://rubygems.org'

gem 'rails', '4.1.1'

gem 'mongoid', github: 'mongoid/mongoid'
gem 'mongoid_search'
gem 'bson_ext'

gem 'devise'
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'activeadmin-mongoid', github: 'elia/activeadmin-mongoid', branch: 'rails4'
gem 'chartkick'

gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', :require => nil # required for sidekiq web

gem 'httparty'
gem 'micro_magick'

gem 'haml-rails'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'

gem 'apipie-rails'

gem 'bootstrap-sass'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'sendgrid_toolkit'

gem 'spring', group: :development

group :test do
  gem 'shoulda-matchers', '~> 3.1'
  gem 'mongoid-rspec'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'foreman'
  gem 'factory_girl_rails'
  gem 'brakeman', :require => false
  gem 'rails_best_practices', :require => false
  gem 'guard-rspec'
  gem 'rubocop', require: false
end

gem 'capistrano-rails', group: :development
gem 'capistrano-rvm'
gem 'passenger', '4.0.42'
gem 'therubyracer'
