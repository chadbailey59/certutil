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
      |--mute|
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

  Scenario: Silent mode (mute)
    When I run `certutil ../../features/google-short.crt -m`
    Then the output should contain "google-short"
    And  the output should contain "Found 3 certificates."
    And  the output should not contain "Google Internet Authority"

  Scenario: Parse URL
    When I run `certutil google.com`
    Then the output should contain "google.com"
    And  the output should contain "Found 3 certificates."
    And  the output should contain "Google Internet Authority"

  Scenario: No cert
    When I run `certutil`
    Then the output should contain "parse error: 'source' is required"


  Scenario: Write split CRT files
    When I run `certutil ../../features/google-full.crt -s -o crt`
    Then the output should contain "google-full"
    And a file named "google-full-0.crt" should exist in my current directory
    And a file named "google-full-1.crt" should exist in my current directory
    And a file named "google-full-2.crt" should exist in my current directory
    And the file named "google-full-0.crt" should contain "MIIHPzCCBiegAwIBAgII"


  Scenario: Write split TXT files
    When I run `certutil ../../features/google-full.crt -s -o txt`
    Then the output should contain "google-full"
    And a file named "google-full-0-decoded.txt" should exist in my current directory
    And a file named "google-full-1-decoded.txt" should exist in my current directory
    And a file named "google-full-2-decoded.txt" should exist in my current directory
    And the file named "google-full-0-decoded.txt" should contain "Google Internet Authority"

  Scenario: Write a single CRT file
    When I run `certutil google.com --log-level debug -o crt`
    Then the output should contain "google.com"
    And a file named "google.com.crt" should exist in my current directory
    And the file named "google.com.crt" should contain "MIIHPzCCBiegAwIBAgII"

  Scenario: Write a single TXT file
    When I run `certutil google.com -o txt`
    Then the output should contain "google.com"
    And a file named "google.com-decoded.txt" should exist in my current directory
    And the file named "google.com-decoded.txt" should contain "Google Internet Authority"
