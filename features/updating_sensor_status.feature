Feature: Updating a sensor's status
  Background:
    Given I have registered a service named 'app_name'

  Scenario: Setting the service's status to `healthy`
  Given I send a POST request to '/set/app_name/sensor_name' with a JSON payload of:
  """
  {"status": "healthy" }
  """
  When I visit '/get/app_name/sensor_name'
  Then it should return a HTTP status of 200

  Scenario: Setting the service's status to `unhealthy`
  Given I send a POST request to '/set/app_name/sensor_name' with a JSON payload of:
  """
  {"status": "unhealthy" }
  """
  When I visit '/get/app_name/sensor_name'
  Then it should return a HTTP status of 422