Feature: Registering services when not authorised
  Background:
    Given the admin authentication token is '296F9d39X14349zeb10'
    And the server is running

  Scenario: Without providing an X-AuthToken header
    Given there isn't a registered service named 'MyService'
    When I set the X-AuthToken header value to ''
    When I send a POST request to '/register_service' with a JSON payload of:
    """
    {"name": "MyService"}
    """
    Then it should return a HTTP status of 403
    And it should return a JSON payload of:
    """
    {"status": "unauthorised"}
    """

  Scenario: With an invalid X-AuthToken header
    Given there isn't a registered service named 'MyService'
    When I set the X-AuthToken header value to '123456'
    And I send a POST request to '/register_service' with a JSON payload of:
    """
    {"name": "MyService"}
    """
    Then it should return a HTTP status of 403
    And it should return a JSON payload of:
    """
    {"status": "unauthorised"}
    """