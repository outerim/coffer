Feature: Public data storage and retrieval
  Scenario: Storing a public document
    Given The data store is empty
    #And I am authenticated as token user 'A'
    When I store a document 'data.json' as public to 'bucket/key'
    Then the request should succeed
