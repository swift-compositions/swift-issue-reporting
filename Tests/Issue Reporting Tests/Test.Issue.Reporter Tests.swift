import Issue_Reporting
import Issue_Reporting_Apple_Testing
import Test
import Testing

enum `Test.Issue.Reporter Tests` {}

extension `Test.Issue.Reporter Tests` {
    @Suite
    struct Test {
        #if AppleTesting
            @Test
            func `a reported issue reaches the running test through the adapter it finds by itself`() {
                withKnownIssue {
                    Test::Test.Issue.Reporter.report(
                        Test::Test.Issue(kind: .unconditional(Test::Test.Text("reported from library code")))
                    )
                } matching: { issue in
                    issue.description.contains("reported from library code")
                }
            }
        #endif

        @Test
        func `a test process knows it is one`() {
            #expect(Test::Test.Issue.Reporter.isTesting)
        }
    }
}
