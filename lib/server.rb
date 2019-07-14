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

    get '/get/:app_name/:sensor_name' do
      'TBC'
    end

    post '/set/:app_name/:sensor_name' do
    end

    private

    def verify_admin_auth_token!
      supplied_auth_token = request.get_header('HTTP_X_AUTHTOKEN')

      if supplied_auth_token != settings.admin_authentication_token
        halt 403, {'Content-Type' => 'application/json'}, { status: :unauthorised }.to_json
      end
    end
  end
end