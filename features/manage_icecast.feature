Feature: Manage Icecast
  In order to make a local broadcast
  An user
  wants to manage icecast

  Scenario: Disable without a source password
    When I am on /icecast
    Then I should see "undefined"        
    And Icecast should not respond on "http://streambox.local:8000"

  Scenario: Define a source password
    Given I am on /icecast/edit
    And I fill in "Source password" with "dummy"
    And I press "Modify"
    And I am on /streams/new
    And I fill in the following:
    | Name        | Ogg/Vorbis test |
    | Server      | localhost       |
    | Port        | 8000            |
    | Mount point | test.ogg        |
    | Password    | dummy           |
    And I press "Add"
    Then an ogg stream should respond on "http://streambox.local:8000/test.ogg"

    
