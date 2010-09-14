Feature: Authorization
  Scenario: Posting a document without credentials
    Given I am an unauthenticated user
    When I store a document 'data.json' as public to 'bucket/wont_work'
    Then the response code should be 403

  Scenario: Posting a document with valid credentials
    Given I am authenticated to 'TOKEN1'
    When I store a document 'data.json' to 'bucket/data.json'
    Then the request should be successful

  Scenario: Retrieving the document I just published
    Given I am authenticated to 'TOKEN1'
    When I request 'bucket/data.json'
    Then the request should be successful
      And the body should be the same as 'data.json'
