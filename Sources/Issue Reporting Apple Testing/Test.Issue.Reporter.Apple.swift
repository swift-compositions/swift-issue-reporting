public import Issue_Reporting
public import Test

#if AppleTesting
    internal import Test_Apple
    internal import Testing
#endif

extension Test::Test.Issue.Reporter {

    /// The adapter that records each reported issue into the Swift Testing test that is running, through
    /// swift-test-apple's recorder, and prints it when no test is running. It installs itself when the process
    /// first reports, provided the `AppleTesting` trait is on.
    public enum Apple {}
}

#if AppleTesting
    extension Test::Test.Issue.Reporter.Apple {

        public static func install() {
            unsafe Test::Test.Issue.Reporter.record = { issue in
                guard Testing.Test.current != nil else {
                    print(issue.description)
                    return
                }
                Test::Test.Apple.Recorder().record(issue)
            }
        }
    }

    @c(swift_issue_reporting_install)
    func _install() {
        Test::Test.Issue.Reporter.Apple.install()
    }
#endif
