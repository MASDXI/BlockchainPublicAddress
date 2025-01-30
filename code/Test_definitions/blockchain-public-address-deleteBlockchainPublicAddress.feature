Feature: CAMARA Blockchain Public Address API, v0.2 - Operation deleteBlockchainPublicAddress
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  #
  #
  # Testing assets:
  # * A phone number with several existing bindings to be able to perform unbindings
  #
  #
  # References to OAS spec schemas refer to schemas specifies in blockchain-public-address.yaml, version 0.2.0-rc.1

  Background: Common deleteBlockchainPublicAddress setup
    Given the resource "/blockchain-public-address/v0.2rc1/blockchain-public-addresses/{id}"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value
    And the path parameter "id" is set to a valid value

  ##############################
  # Happy path scenarios
  ##############################

  @delete_blockchain_public_address_01_generic_success_scenario
  Scenario: Common validations for any success scenario
    Given an existing binding created by operation bindBlockchainPublicAddress
    And the path parameter "id" is set to the value for this binding
    When the HTTP "DELETE" request is sent
    Then the response status code is 204
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And there is no response body

  ##############################
  # Error scenarios
  ##############################

  # Error 401 scenarios

  @retrieve_refund_401.01_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    And the path parameter "id" is set to a valid value
    When the HTTP "DELETE" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @retrieve_refund_401.02_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    And the path parameter "id" is set to a valid value
    When the HTTP "DELETE" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @retrieve_refund_401.03_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    And the path parameter "id" is set to a valid value
    When the HTTP "DELETE" request is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # Error 403 scenarios

  @retrieve_refund_403.01_invalid_token_permissions
  Scenario: Inconsistent access token permissions
    # To test this, an access token has to be obtained without blockchain-public-address:delete scope
    Given header "Authorization" is set to a valid access token emitted without blockchain-public-address:delete scope
    And the path parameter "id" is set to a valid value
    When the HTTP "DELETE" request is sent
    Then the response status code is 403
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  # Error 404 scenarios

  @retrieve_refund_404.01_binding_not_found
  Scenario: Binding not found
    Given the path parameter "id" is set to a non-existing value in the environment
    And the header "Authorization" is set to a valid access token
    When the HTTP "DELETE" request is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  ##############################
  ##END
  ##############################