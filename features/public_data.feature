Feature: Public data storage and retrieval
  Scenario: Storing a public document
    Given the data store is empty
      #And I am authenticated as token user 'A'
    When I store a document 'data.json' as public to 'bucket/key'
    Then the request should be successful

  Scenario: Retrieving a document stored publically
    Given the data store is empty
      And a public document 'data.json' has been stored at 'bucket/key'
      And I am an unauthenticated user
    When I request 'bucket/key'
    Then the request should be successful
      And the 'Content-type' header should be 'application/json'
      And the body should be the same as 'data.json'
      And it should have an 'Etag' header
      And it should have a 'Last-modified' header

  Scenario: Updating a previously stored document
    Given the data store is empty
      And a public document 'data.json' has been stored at 'bucket/key'
    When I update 'bucket/key' with 'other_data.json'
    Then the request should be successful
    When I request 'bucket/key'
    Then the body should be the same as 'other_data.json'

  Scenario: Retrieving a nonexistent key
    Given the data store is empty
    When I request 'bucket/key'
    Then the response code should be 404
      And the response should be empty
