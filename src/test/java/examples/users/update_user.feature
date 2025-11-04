Feature: Update an existing user using a dynamic ID

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * header Authorization = bearerToken
    * def dataGenerator = Java.type('utils.DataGenerator')

  Scenario: Create a user and then update their information
    
    # STEP 1: CREATE A NEW USER (POST)
    * def createdUser = call read('create_user.feature')
    * def userId = createdUser.userId
    * def originalEmail = createdUser.randomEmail
    * print 'Called create_user.feature, got ID: ' + userId

    # STEP 2: UPDATE THE USER (PATCH)
    * def updatedName = dataGenerator.generateRandomFullName()
    * def updatedUserPayload = { "name": "#(updatedName)" }

    Given path 'users/' + userId
    And request updatedUserPayload
    When method patch
    Then status 200

    # Optional: Validate the updated user data in the response
    # ESTA ES LA VERIFICACIÓN IMPORTANTE
    * match response.id == userId
    * match response.name == updatedName
    * match response.email == originalEmail

    # STEP 3: ELIMINADO
    # (Ya no es necesario verificar con un GET)