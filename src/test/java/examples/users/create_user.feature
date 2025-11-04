Feature: Crear un usuario usando datos dinámicos de Java

  Background:
    * url baseUrl
    * header Authorization = bearerToken
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * def dataGenerator = Java.type('utils.DataGenerator')

  Scenario: Crear un usuario con nombre y email aleatorios
    * def randomName = dataGenerator.generateRandomFullName()
    * def randomEmail = dataGenerator.generateRandomEmail(randomName)
    * print 'Generated Name: ' + randomName
    * print 'Generated Email: ' + randomEmail

    Given path 'users'
    And request { "name": "#(randomName)", "gender": "male", "email": "#(randomEmail)", "status": "active" }
    When method post
    Then status 201

    * def userId = response.id
    * print 'Created user ID: ' + userId

    And match response.name == randomName
    And match response.email == randomEmail