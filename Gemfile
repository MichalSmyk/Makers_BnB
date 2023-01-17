source 'https://rubygems.org'

ruby '3.1.0'

group :development, :test do
  gem 'rubocop', '1.20'
  gem 'rubocop-rake'
end

gem "sinatra-reloader"
gem "sinatra"
gem "rack-contrib"
gem "rack-cors"
gem "activerecord"
gem "sinatra-activerecord"
gem "rake"
gem "pg"
gem "require_all"
gem "faker"
gem "bcrypt"
gem "webrick"
gem "database_cleaner"


group :development do
  gem "pry"
  gem "rerun"
end

# These gems will only be used when we are running tests
group :test do

  gem "rack-test"
  gem "rspec"
  gem "rspec-json_expectations"
  gem 'simplecov', require: false
  gem 'simplecov-console', require: false
end
