ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require File.expand_path('../../../lib/application', __FILE__)

require 'capybara/cucumber'
Capybara.app = Server

Before do
  Thread.new do
    Server.run!
  end

  until system("lsof -i:#{Server.port}", out: '/dev/null')
    puts "Waiting for server to start..."
  end
end