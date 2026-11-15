# swift-issue-reporting

Use this package when code that is not a test (a library, a framework, an app's logic) finds something wrong that a
test of it should fail on, and that should only be printed when no test is running. Build a `Test.Issue` from
swift-test and hand it to `Test.Issue.Reporter.report(_:)`. Link `Issue Reporting Apple Testing` into the test
target and the issue is recorded into the Swift Testing test that is running; the library itself never links a test
framework.

## Laws

- `report(_:)` hands the issue to `Test.Issue.Reporter.record` when it is set, and prints the issue's description to
  standard output when it is not.
- The first report, or the first read of `isTesting`, looks the process up for a function exported under the C name
  `swift_issue_reporting_install` and calls it once. `Issue Reporting Apple Testing` exports it; linking that target
  is the whole of setting it up.
- With `Issue Reporting Apple Testing`, an issue reported while a Swift Testing test runs is recorded by
  swift-test-apple's `Test.Apple.Recorder` into that test, at the issue's own source location and severity. An
  issue reported while no test runs is printed.
- `isTesting` is true when an adapter installed itself, when the process is an XCTest bundle or host
  (`XCTestBundlePath`, `XCTestConfigurationFilePath` or `XCTestSessionIdentifier` is set), when its arguments
  contain `--testing-library`, or when its executable's name ends in `xctest` or `PackageTests`. It is read once.
- Symbol lookup is swift-loader's; where that is not supported (Windows), no adapter is found and issues are printed.
