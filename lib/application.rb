require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

class Server < Sinatra::Base
  get '/get/:app_name/:sensor_name' do
    'TBC'
  end

  post '/set/:app_name/:sensor_name' do
  end
end