Feature: Modify request on the fly

Background: Initialize stuff
    Given url "https://jsonplaceholder.typicode.com"
    And def rqst1 = {userId: '#(userId)', body: '#(body)', title: '#(title)'}
    And def rqst2 = {userId: '#(user.userId)', body: '#(user.body)', title: '#(user.title)'}

Scenario Outline: Embedded expression - 1
    Given path 'posts'
    And header Content-Type = 'application/json; charset=UTF-8'
    And request rqst1
    When method post
    Then status 201 
    And match response == {id:'#number', title: <title>, body: '#(body)', userId: <userId>} 

    # Should validate afterwards with a get method and assert the created values, but this API does not actually create the record, so we will skip that step

Examples:
    | userId! | title    | body    |
    | 1       |  foo     | bar     |
    | 2       |  hello   | world   |
    | 3       |  karate  | rocks   |

Scenario Outline: Embedded expression - 2
    Given path 'posts'
    And header Content-Type = 'application/json; charset=UTF-8'
    And request rqst2
    When method post
    Then status 201 
    And match response == {id:'#number', title: '#(user.title)', body: '#(user.body)', userId: '#(user.userId)'} 

    # Should validate afterwards with a get method and assert the created values, but this API does not actually create the record, so we will skip that step

Examples:
    | user! |
    | {userId: 1, title: 'foo', body: 'bar'}        |
    | {userId: 2, title: 'hello', body: 'world'}    |

Scenario Outline: Add an attribute on the fly
    Given path 'posts'
    And header Content-Type = 'application/json; charset=UTF-8'
    And * def setHashtag = function(k, v) { rqst2[k] = v }
    #And set rqst2.hashtag = 'database'
    And if(rqst2.userId == 1) set Hashtag ('hashtag', 'CEO')
    And request rqst2
    When method post
    Then status 201 
    And match response == {id:'#number', title: '#(user.title)', body: '#(user.body)', userId: '#(user.userId)', hashtag: '##string'}

    # Should validate afterwards with a get method and assert the created values, but this API does not actually create the record, so we will skip that step

Examples:
    | user! |
    | {userId: 1, title: 'foo', body: 'bar'}        |
    | {userId: 2, title: 'hello', body: 'world'}    |

Scenario Outline: Delete an attribute on the fly
    Given path 'posts'
    And header Content-Type = 'application/json; charset=UTF-8'
    And eval delete rqst2.body
    And request rqst2
    When method post
    Then status 201 
    And match response == {id:'#number', title: '#(user.title)', userId: '#(user.userId)', hashtag: '##string'}

    # Should validate afterwards with a get method and assert the created values, but this API does not actually create the record, so we will skip that step
