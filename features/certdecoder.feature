Feature: My bootstrapped app kinda works
  In order to get going on coding my awesome app
  I want to have aruba and cucumber setup
  So I don't have to do it myself

  Scenario: App just runs
    When I get help for "certdecoder"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version|
      |--input  |
      |--hostname    |
      |--crt|
      |--txt|
      |--silent|
    And the banner should document that this app takes no arguments

  Scenario: Parse full file
    When I run `certdecoder -i ../../features/google-full.crt --log-level debug`
    Then the output should contain "google-full.crt..."
    And  the output should contain "Found 3 certificates."
    And  the output should contain "Google Internet Authority"

  Scenario: Parse abbreviated file
    When I run `certdecoder -i ../../features/google-short.crt`
    Then the output should contain "google-short.crt..."
    And  the output should contain "Found 3 certificates."
    And  the output should contain "Google Internet Authority"

  Scenario: Parse URL
    When I run `certdecoder -h google.com`
    Then the output should contain "Fetching certificate from google.com..."
    And  the output should contain "Found 3 certificates."
    And  the output should contain "Google Internet Authority"

  Scenario: No cert
    When I run `certdecoder`
    Then the output should contain "You must include a cert file with -i or a hostname with -h."

