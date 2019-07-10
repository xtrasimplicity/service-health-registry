ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require File.expand_path('../../../lib/server', __FILE__)

require 'capybara/cucumber'
Capybara.app = ServiceHealthRegistry::Server

Before do
  Thread.new do
    ServiceHealthRegistry::Server.run!
  end

  until system("lsof -i:#{ServiceHealthRegistry::Server.port}", out: '/dev/null')
    puts "Waiting for server to start..."
  end
end