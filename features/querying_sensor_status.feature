Feature: Querying sensor statuses
  Scenario: The service does not exist
  When I visit '/get/app_name/sensor_name'
  Then it should return a HTTP status of 422
  And the page should include:
  """
  app_name does not exist
  """

  Scenario: The sensor does not exist