Feature: Manage streams
  In order to broadcast its contents
  An user
  wants to manage streams

  Background:
    Given I am on /icecast/edit
    And I fill in "Source password" with "dummy"
    And I press "Modify"

  Scenario: Create a local Ogg/Vorbis stream
    Given I am on /streams/new
    When I fill in the following:
    | Name        | Ogg/Vorbis test |
    | Server      | localhost       |
    | Port        | 8000            |
    | Mount point | test.ogg        |
    | Password    | dummy           |
    And I choose "Ogg/Vorbis"
    And I press "Add"
    Then an ogg stream should respond on "http://streambox.local:8000/test.ogg"

  Scenario: Create a local MP3 stream
    Given I am on /streams/new
    When I fill in the following:
    | Name        | MP3 test  |
    | Server      | localhost |
    | Port        | 8000      |
    | Mount point | test.mp3  |
    | Password    | dummy     |
    And I choose "MP3"
    And I press "Add"
    Then a mp3 stream should respond on "http://streambox.local:8000/test.mp3"

  Scenario: Create a local AAC stream
    Given I am on /streams/new
    When I fill in the following:
    | Name        | AAC test  |
    | Server      | localhost |
    | Port        | 8000      |
    | Mount point | test.aac  |
    | Password    | dummy     |
    And I choose "AAC"
    And I press "Add"
    Then a aac stream should respond on "http://streambox.local:8000/test.aac"

  Scenario: Create a local HE-AAC v2 stream
    Given I am on /streams/new
    When I fill in the following:
    | Name        | HE-AAC v2 test |
    | Server      | localhost |
    | Port        | 8000      |
    | Mount point | test.aac  |
    | Password    | dummy     |
    And I choose "HE-AAC v2"
    And I press "Add"
    Then a aacp stream should respond on "http://streambox.local:8000/test.aac"

  Scenario Outline: Select MP3 VBR quality
    Given I am on /streams/new
    When I fill in the following:
    | Name           | MP3 test  |
    | Server         | localhost |
    | Port           | 8000      |
    | Mount point    | test.mp3  |
    | Password       | dummy     |
    | Format (radio) | MP3       |
    | Mode (radio)   | VBR       |
    And I select "<Quality>" from "Quality"
    And I press "Add"
    Then a mp3 stream should respond on "http://streambox.local:8000/test.mp3"

    Examples:
    | Quality |
    |       1 |
    |       5 |
    |      10 |

  Scenario Outline: Select Ogg/Vorbis VBR quality
    Given I am on /streams/new
    When I fill in the following:
    | Name           | Ogg test   |
    | Server         | localhost  |
    | Port           | 8000       |
    | Mount point    | test.ogg   |
    | Password       | dummy      |
    | Format (radio) | Ogg/Vorbis |
    | Mode (radio)   | VBR        |
    And I select "<Quality>" from "Quality"
    And I press "Add"
    Then a ogg stream should respond on "http://streambox.local:8000/test.ogg"

    Examples:
    | Quality |
    |       1 |
    |       5 |
    |      10 |

  Scenario Outline: Select MP3 CBR bitrate
    Given I am on /streams/new
    When I fill in the following:
    | Name           | MP3 test  |
    | Server         | localhost |
    | Port           | 8000      |
    | Mount point    | test.mp3  |
    | Password       | dummy     |
    | Format (radio) | MP3       |
    | Mode (radio)   | CBR        |
    And I select "<Bitrate>" from "Bitrate"
    And I press "Add"
    Then a mp3 stream should respond on "http://streambox.local:8000/test.mp3"

    Examples:
    | Bitrate |
    |      32 |
    |      48 |
    |      64 |
    |      80 |
    |      96 |
    |     112 |
    |     128 |
    |     160 |
    |     192 |
    |     224 |
    |     256 |
    |     320 |

  Scenario: Migration streams to GoBroadcast
    Given the box configuration contains:
    | stream_1_id          | 1         |
    | stream_1_server_type | icecast2  |
    | stream_1_server      | localhost |
    | stream_1_port        | 8000      |
    | stream_1_password    | dummy     |
    | stream_1_mount_point | test.ogg  |
    | stream_1_format      | vorbis    |
    | stream_1_mode        | vbr       |
    | stream_1_quality     | 4         |
    | stream_2_id          | 1         |
    | stream_2_server_type | icecast2  |
    | stream_2_server      | localhost |
    | stream_2_port        | 8000      |
    | stream_2_password    | dummy     |
    | stream_2_mount_point | test.mp3  |
    | stream_2_format      | mp3       |
    | stream_2_bitrate     | 128       |
    | stream_2_mode        | cbr       |
    And the box configuration is saved
    When the box reboots
    Then a ogg stream should respond on "http://streambox.local:8000/test.ogg"
    And a mp3 stream should respond on "http://streambox.local:8000/test.mp3"
