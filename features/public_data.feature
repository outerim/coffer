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
