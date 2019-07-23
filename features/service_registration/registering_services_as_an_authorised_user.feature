Feature: Registering services as an authorised user
    In order to be able to be able to set/retrieve information regarding an application/service's sensors, we first need to make sure that it is registered. We can do this by sending a POST request to the service registration endpoint.

  Background:
    Given the admin authentication token is 'SomeSecretToken'
    And I set the X-AuthToken header value to 'SomeSecretToken'
    And the server is running

  @stub-service-registration-auth-token
  Scenario: The service does not exist
    Given there isn't a registered service named 'MyService'
    When I send a POST request to '/register_service' with a JSON payload of:
    """
    {"name": "MyService"}
    """
    Then it should return a HTTP status of 200
    And it should return a JSON payload of:
    """
    {"status": "ok", "AuthToken": "MySecretServiceSpecificToken"}
    """

  Scenario: The service already exists
    Given I have registered a service named 'MyService'
    When I send a POST request to '/register_service' with a JSON payload of:
    """
    {"name": "MyService"}
    """
    Then it should return a HTTP status of 422
    And it should return a JSON payload of:
    """
    {"status": "error","message": "MyService already exists"}
    """