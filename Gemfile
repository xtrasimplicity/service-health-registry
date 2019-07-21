# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'sinatra'
gem 'json'
gem 'puma'
gem 'activerecord'
gem 'sinatra-activerecord'
gem 'mysql2'
gem 'rake'

group :test, :development do
  gem 'cucumber'
  gem 'byebug'
  gem 'rest-client'
  gem 'rspec'
  gem 'simplecov'
  gem 'rake'
  gem 'dotenv', require: false
  gem 'shoulda-matchers'
  gem 'database_cleaner'
end