Feature: My bootstrapped app kinda works
  In order to get going on coding my awesome app
  I want to have aruba and cucumber setup
  So I don't have to do it myself

  Scenario: App just runs
    When I get help for "certutil"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version|
      |--output|
      |--split|
      |--silent|
    And the banner should document that this app's arguments are:
      |source|which is required|

  Scenario: Parse full file
    When I run `certutil ../../features/google-full.crt --log-level debug`
    Then the output should contain "google-full"
    And  the output should contain "Found 3 certificates."
    And  the output should contain "Google Internet Authority"

  Scenario: Parse abbreviated file
    When I run `certutil ../../features/google-short.crt`
    Then the output should contain "google-short"
    And  the output should contain "Found 3 certificates."
    And  the output should contain "Google Internet Authority"

  Scenario: Parse URL
    When I run `certutil google.com`
    Then the output should contain "google.com"
    And  the output should contain "Found 3 certificates."
    And  the output should contain "Google Internet Authority"

  Scenario: No cert
    When I run `certutil`
    Then the output should contain "parse error: 'source' is required"

