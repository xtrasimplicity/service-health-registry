ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require File.expand_path('../../../lib/server', __FILE__)

Before do
  ServiceHealthRegistry::Service.destroy_all!

  Thread.new do
    ServiceHealthRegistry::Server.run!
  end

  until system("lsof -i:#{ServiceHealthRegistry::Server.port}", out: '/dev/null')
    puts "Waiting for server to start..."
  end
end