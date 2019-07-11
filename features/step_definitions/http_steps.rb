module HTTPHelper
  def post_request(path, payload, headers = {})
    RestClient.post(build_url(path), payload, {}) {|response, request, result| response }
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

Given("I send a POST request to {string} with a JSON payload of:") do |path, stringified_json_payload|
  payload = JSON.parse(stringified_json_payload)

  @http_request = post_request(path, payload)
end

When("I visit {string}") do |path|
  @http_request = get_request(path)
end

Then("it should return a HTTP status of {int}") do |expected_status_code|
  expect(@http_request.code).to eq(expected_status_code)
end

Then("it should return a JSON payload of:") do |stringified_json_payload|
  expected_payload = JSON.parse(stringified_json_payload)
  actual_payload = JSON.parse(@http_request.body)
  
  expect(actual_payload).to eq(expected_payload)
end