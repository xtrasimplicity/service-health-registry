Feature: Updating a sensor's status when a valid service-specific X-AuthToken header is not supplied
  Background:
    Given I have registered a service named 'app_name'
    And the server is running

  Scenario: When the X-AuthToken header is not supplied
  When I send a POST request to '/set/app_name/sensor_name' with a JSON payload of:
  """
  {"status": "healthy" }
  """
  Then it should return a HTTP status of 403
  And it should return a JSON payload of:
  """
  {"status": "unauthorised"}
  """

  Scenario: When the X-AuthToken header is invalid
  Given I set the X-AuthToken header value to 'SomeInvalidToken'
  When I send a POST request to '/set/app_name/sensor_name' with a JSON payload of:
  """
  {"status": "healthy" }
  """
  Then it should return a HTTP status of 403
  And it should return a JSON payload of:
  """
  {"status": "unauthorised"}
  """