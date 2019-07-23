ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

ENV['ADMIN_AUTH_TOKEN'] = 'SomeToken'
require File.expand_path('../../../lib/server', __FILE__)

module ServerManager
  @@server_pid = nil

  class << self
    def stop!
      return true unless running?
      
      begin
        Process.kill 'SIGTERM', pid
        Process.wait pid
        true
      rescue Errno::ESRCH
        false
      end
    end

    def start!
      stop!

      @@server_pid = fork do
        ServiceHealthRegistry::Server.run!
      end
    
      begin
        Timeout::timeout(30) do
          puts "Waiting for server to start...\n"

          until system("nc -z localhost #{ServiceHealthRegistry::Server.port}") 
            print "."
          end
        end
      rescue Timeout::Error
        abort "Timed out whilst waiting for server to start!"
      end

      true
    end

    def running?
      !pid.nil?
    end

    private

    def pid
      @@server_pid
    end
  end
end

Before do
  ServiceHealthRegistry::ServiceRepository.destroy_all!
  ServerManager.stop!
end

After do
  ServerManager.stop!
end