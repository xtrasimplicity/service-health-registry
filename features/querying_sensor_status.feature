Feature: Querying sensor statuses
  Background:
    Given the server is running

  Scenario: The service does not exist
  When I visit '/get/app_name/sensor_name'
  Then it should return a HTTP status of 422
  And it should return a JSON payload of:
  """
  {"status": "error","message": "app_name does not exist"}
  """

  Scenario: The sensor has not received any data
    Given I have registered a service named 'app_name'
    When I visit '/get/app_name/sensor_name'
    Then it should return a HTTP status of 422
    And it should return a JSON payload of:
    """
    {"status": "error","message": "sensor has not received any data"}
    """

  Scenario: The sensor is healthy
    Given I have registered a service named 'app_name'
    And I have a sensor named 'sensor_name' which is healthy
    When I visit '/get/app_name/sensor_name'
    Then it should return a HTTP status of 200
    And it should return a JSON payload of:
    """
    {"status": "ok","message": "sensor is healthy"}
    """

  Scenario: The sensor is unhealthy
    Given I have registered a service named 'app_name'
    And I have a sensor named 'sensor_name' which is unhealthy
    When I visit '/get/app_name/sensor_name'
    Then it should return a HTTP status of 422
    And it should return a JSON payload of:
    """
    {"status": "error","message": "sensor is unhealthy"}
    """