#!/usr/bin/env rake
require 'rake'
require File.expand_path('../lib/server', __FILE__)
require 'sinatra/activerecord/rake'

begin
  require 'rspec/core/rake_task'
  require 'cucumber/rake/task'

  RSpec::Core::RakeTask.new(:spec)
  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "--format pretty"
  end
rescue LoadError
end

task :wait_for_db do
  host = ENV['DATABASE_HOST']
  host = 'localhost' if host.nil? or host.empty?
  timeout_duration = 30

  begin
    Timeout::timeout(timeout_duration) do
      puts "Waiting #{timeout_duration} seconds for database..."

      until system("nc -z #{host} 3306") do
        print "."
      end
    end
  rescue Timeout::Error
    abort "\nTimed out waiting for database server"
  end
end

task :default => [:wait_for_db, :spec, :features]

task :ci => [:wait_for_db, 'db:drop', 'db:setup', :default]