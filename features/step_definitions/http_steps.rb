Given("I send a POST request to {string} with a JSON payload of:") do |path, stringified_json_payload|
  payload = JSON.parse(stringified_json_payload)

  RestClient.post("http://127.0.0.1:#{Server.port}#{path}", payload, {})
end

When("I visit {string}") do |url|
  visit url
end

Then("it should return a HTTP status of {int}") do |expected_status_code|
  expect(page.status_code).to eq(expected_status_code)
end