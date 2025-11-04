Feature: Delete an existing user using a dynamic ID

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * header Authorization = bearerToken

  Scenario: Create a user and then delete it
    
    # STEP 1: CREATE A NEW USER (POST)
    # Llamamos al feature de creación para obtener un usuario nuevo
    * def createdUser = call read('create_user.feature')
    
    # Extraemos el ID del usuario creado
    * def userId = createdUser.userId
    * print 'Called create_user.feature, got ID: ' + userId

    # STEP 2: DELETE THE USER
    Given path 'users/' + userId
    When method delete
    Then status 204
    And match response == ''

    # STEP 3: VERIFY THE DELETION 
    Given path 'users/' + userId
    When method get
    Then status 404
    And match response.message == 'Resource not found'