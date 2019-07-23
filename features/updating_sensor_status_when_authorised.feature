@stub-service-registration-auth-token
Feature: Updating a sensor's status when a valid service-specific X-AuthToken header is supplied
  Background:
    Given I have registered a service named 'app_name'
    And I set the X-AuthToken header value to 'MySecretServiceSpecificToken'
    And the server is running

  Scenario: Setting the service's status to `healthy`
  When I send a POST request to '/set/app_name/sensor_name' with a JSON payload of:
  """
  {"status": "healthy" }
  """
  And I visit '/get/app_name/sensor_name'
  Then it should return a HTTP status of 200

  Scenario: Setting the service's status to `unhealthy`
  When I send a POST request to '/set/app_name/sensor_name' with a JSON payload of:
  """
  {"status": "unhealthy" }
  """
  And I visit '/get/app_name/sensor_name'
  Then it should return a HTTP status of 422