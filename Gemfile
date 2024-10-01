# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.0'

gem 'bcrypt', '~> 3.1', '>= 3.1.12'
gem 'bootsnap', require: false
gem 'brakeman', '~> 6.1'
gem 'bundler-audit', '~> 0.9.1'
gem 'jsonapi-serializer'
gem 'jwt'
gem 'mysql2', '~> 0.5.5'
gem 'overcommit', '~> 0.60.0'
gem 'puma', '>= 6.3.1'
gem 'rack-cors', '~> 2.0'
gem 'rails', '~> 7.0.6'
gem 'redis', '~> 4.0'
gem 'rswag-api'
gem 'rswag-ui'
gem 'rubocop_runner', '~> 2.1', require: false
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'whenever', '~> 1.0.0', require: false

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'dotenv-rails', '~> 2.8.1'
  gem 'factory_bot_rails'
  gem 'faker', '~> 3.2.1'
  gem 'rswag-specs'
  gem 'rubocop-performance', '~> 1.20.2', require: false
  gem 'rubocop-rails', '~> 2.23.1', require: false
  gem 'rubocop-rspec', '~> 2.26.1', require: false
end

group :development do
  gem 'letter_opener'
  gem 'web-console'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec-rails', '~> 6.0'
  gem 'shoulda-matchers', '~> 5.3'
  gem 'simplecov', '~> 0.21.2'
  gem 'simplecov-json', require: false
  gem 'super_diff', '~> 0.9.0'
end
