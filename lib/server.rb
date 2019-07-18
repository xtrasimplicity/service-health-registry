require 'bundler/setup'
bundle_environments = [:default, ENV['RACK_ENV']].reject(&:nil?)

if Bundler.setup(*bundle_environments).gems.map(&:name).include?('dotenv')
  require 'dotenv/load'
end

require 'sinatra/activerecord'
Bundler.require(*bundle_environments)

module ServiceHealthRegistry
  require_relative 'errors'
  require_relative 'service'

  class Server < Sinatra::Base
    configure do
      set :bind, '0.0.0.0'
      set :environment, ENV.fetch('RACK_ENV') { 'production' }
      set :admin_authentication_token, ENV.fetch('ADMIN_AUTH_TOKEN') { abort 'ERROR: The ADMIN_AUTH_TOKEN environment variable must be set!' }
    end

    post '/register_service' do
      verify_auth_token_or_raise_403!(settings.admin_authentication_token)

      service_name = params[:name]
      response_payload = {}
      
      begin
        new_service = ServiceHealthRegistry::Service.new(service_name)
        ServiceHealthRegistry::Service.register(new_service)
        
        status 200
        response_payload[:status] = :ok
        response_payload[:AuthToken] = new_service.authentication_token
      rescue ServiceAlreadyExistsError => e
        status 422
        response_payload[:status] = :error
        response_payload[:message] = e.message
      end

      content_type :json
      response_payload.to_json
    end

    get '/get/:service_name/:sensor_name' do
      sensor = load_sensor
      response_payload = {}

      if sensor.healthy?
        status 200
        response_payload[:status] = :ok
        response_payload[:message] = 'sensor is healthy'
      else
        response_payload[:status] = :error
        status 422

        if sensor.has_received_data?
          response_payload[:message] = 'sensor is unhealthy'
        else
          response_payload[:message] = 'sensor has not received any data'
        end
      end

      content_type :json
      response_payload.to_json
    end

    post '/set/:service_name/:sensor_name' do
      service = load_service
      verify_auth_token_or_raise_403!(service.authentication_token)

      sensor = load_sensor(service)
      is_healthy = params[:status].to_s =~ /\Ahealthy\Z/i

      sensor.set_health_status(is_healthy)

      status 200
    end

    get '*' do
      'Ooops! It looks like you forgot to specify a valid endpoint, or have used the wrong HTTP method?'
    end

    private

    def verify_auth_token_or_raise_403!(desired_token_value)
      supplied_auth_token = request.get_header('HTTP_X_AUTHTOKEN')

      if supplied_auth_token != desired_token_value
        abort_request_and_return(403, { status: :unauthorised }.to_json)
      end
    end

    def load_service
      service_name = params[:service_name]

      begin
        ServiceHealthRegistry::Service.find(service_name)
      rescue ServiceNotFoundError => e
        abort_request_and_return(422, { status: :error, message: e.message}.to_json)
      end
    end

    def load_sensor(service = nil)
      sensor_name = params[:sensor_name]
      service ||= load_service
      service.get_sensor(sensor_name)
    end

    def abort_request_and_return(status_code, response_body, headers = {'Content-Type' => 'application/json'})
      halt status_code, headers, response_body
    end
  end
end