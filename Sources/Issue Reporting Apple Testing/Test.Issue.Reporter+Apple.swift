public import Issue_Reporting
internal import Test_Apple
public import Test
internal import Testing

extension Test::Test.Issue.Reporter {

    /// Records each reported issue into the Swift Testing test that is running, through swift-test-apple's
    /// recorder, and prints it when no test is running. Installed by itself when the process first reports.
    public static func installAppleTesting() {
        unsafe record = { issue in
            guard Testing.Test.current != nil else {
                print(issue.description)
                return
            }
            Test::Test.Apple.Recorder().record(issue)
        }
    }
}

@c(swift_issue_reporting_install)
func _installAppleTesting() {
    Test::Test.Issue.Reporter.installAppleTesting()
}
