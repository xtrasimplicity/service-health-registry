require 'bundler/setup'
bundle_environments = [:default, ENV['RACK_ENV']].reject(&:nil?)
Bundler.require(*bundle_environments)

class Server < Sinatra::Base
  set :bind, '0.0.0.0'

  get '/get/:app_name/:sensor_name' do
    'TBC'
  end

  post '/set/:app_name/:sensor_name' do
  end
end