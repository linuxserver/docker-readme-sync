require 'sinatra'
require 'capybara'
require 'capybara/poltergeist'

poltergeist_options = { js_errors: false, phantomjs_options: ['--load-images=false', '--ignore-ssl-errors=yes', '--ssl-protocol=any', '--web-security=false'] }
# poltergeist_options = { js_errors: false, phantomjs_options: ['--load-images=false', '--ignore-ssl-errors=yes', '--ssl-protocol=any', '--web-security=false', '--debug=true'] }

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, poltergeist_options)
end

driver = :poltergeist
# driver = :selenium

Capybara.default_driver = driver
Capybara.current_driver = driver
Capybara.javascript_driver = driver


require './app/github_dockerhub_sync'
require './app/model/dockerhub'
require './app/model/github'
require './app/service/sync_service'
