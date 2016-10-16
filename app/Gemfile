source 'https://rubygems.org'

ruby File.read(File.expand_path('../.ruby-version', __FILE__)).strip.sub(/ruby\-/, '')

def darwin_only(require_as)
  RUBY_PLATFORM.include?('darwin') && require_as
end

def linux_only(require_as)
  RUBY_PLATFORM.include?('linux') && require_as
end

gem 'rake', '~> 11.3'

gem 'rack'
gem 'sinatra'
gem 'mechanize', '~> 2.7', '>= 2.7.5'

# DB
# gem 'rake'
# gem 'sequel'
# gem 'sinatra-sequel'
# gem 'mysql2'

# caching

# gem 'redis'
# gem 'redis-namespace'

gem 'awesome_print'
gem 'capybara'
gem 'poltergeist'
gem "selenium-webdriver"
gem "escape_utils"
gem "puma"

group :test do
  gem 'rspec'
  gem "rack-test"
  gem "simplecov", require: false
  gem "simplecov-rcov", require: false
  gem 'vcr'
end

