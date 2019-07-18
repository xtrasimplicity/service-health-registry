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

task :default => [:spec, :features]