Feature: Get a list of users

  Background:
    # 'baseUrl' and 'bearerToken' are loaded automatically from karate-config.js
    * url baseUrl
    * header Authorization = bearerToken
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'

  Scenario: Verify fetching all users from the API
    Given path 'users'
    When method GET
    Then status 200
    # The response body should be a JSON array
    And match response == '#array'
    # The array should not be empty
    And assert response.length > 0
    # Each object in the array should have the required fields
    And match each response[*] == { id: '#number', name: '#string', email: '#string', gender: '#string', status: '#string' }