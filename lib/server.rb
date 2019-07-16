require 'bundler/setup'
bundle_environments = [:default, ENV['RACK_ENV']].reject(&:nil?)
Bundler.require(*bundle_environments)

module ServiceHealthRegistry
  require_relative 'errors'
  require_relative 'service'

  class Server < Sinatra::Base
    configure do
      set :bind, '0.0.0.0'
      set :admin_authentication_token, ENV.fetch('ADMIN_AUTH_TOKEN') { abort 'ERROR: The ADMIN_AUTH_TOKEN environment variable must be set!' }
    end

    post '/register_service' do
      verify_admin_auth_token!

      service_name = params[:name]
      response_payload = {}
      
      begin
        new_service = ServiceHealthRegistry::Service.new(service_name)
        ServiceHealthRegistry::Service.register(new_service)
        
        status 200
        response_payload[:status] = :ok
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

      if sensor.healthy?
        status 200
      else
        status 422
      end
    end

    post '/set/:service_name/:sensor_name' do
      sensor = load_sensor
      is_healthy = params[:status].to_s =~ /\Ahealthy\Z/i

      sensor.set_health_status(is_healthy)

      status 200
    end

    private

    def verify_admin_auth_token!
      supplied_auth_token = request.get_header('HTTP_X_AUTHTOKEN')

      if supplied_auth_token != settings.admin_authentication_token
        halt 403, {'Content-Type' => 'application/json'}, { status: :unauthorised }.to_json
      end
    end

    def load_sensor
      service_name = params[:service_name]
      sensor_name = params[:sensor_name]

      service = ServiceHealthRegistry::Service.find(service_name)
      
      service.get_sensor(sensor_name)
    end
  end
end