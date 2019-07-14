Given("I send a POST request to {string} with a JSON payload of:") do |path, stringified_json_payload|
  payload = JSON.parse(stringified_json_payload)
  @http_headers ||= {}

  @http_request = post_request(path, payload, @http_headers)
end

When("I set the X-AuthToken header value to {string}") do |value|
  @http_headers ||= {}
  @http_headers['X-AuthToken'] = value
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