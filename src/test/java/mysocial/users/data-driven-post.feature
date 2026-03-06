Feature: Verify posts API for mysocial

Background: Initialize stuff
    Given url "https://jsonplaceholder.typicode.com"
    * def posts = read('post-data.json')

Scenario Outline: Verify posts/<postId> works
    Given path '/posts', <postId>
    When method get
    Then status 200
    And match response == 
    """
    {
        "userId": '#number',
        "id": '#number',
        "title": '#string',
        "body": '#string'
    }
    """

Examples:
    | postId |
    | 1      |
    | 2      |
    | 3      |

Scenario Outline: Verify new post for userID <userId> can be created
    Given path 'posts'
    And header Content-Type = 'application/json; charset=UTF-8'
    And request
    """
    {
        "title": <title>,
        "body": <body>,
        "userId": <userId>
    }
    """
    When method post
    Then status 201 
    And match response == {id:'#number', title: <title>, body: <body>, userId: <userId>} 

    # Should validate afterwards with a get method and assert the created values, but this API does not actually create the record, so we will skip that step

Examples:
    | posts |