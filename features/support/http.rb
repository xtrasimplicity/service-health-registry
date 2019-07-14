module HTTPHelper
  def post_request(path, payload, headers = {})
    RestClient.post(build_url(path), payload, headers) {|response, request, result| response }
  end

  def get_request(path)
    RestClient.get(build_url(path)) {|response, request, result| response }
  end

  private

  def build_url(path)
    "http://127.0.0.1:#{ServiceHealthRegistry::Server.port}#{path}"
  end
end

World(HTTPHelper)