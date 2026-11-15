internal import Environment
internal import Loader
public import Test

extension Test.Issue {

    /// Where code that is not a test sends an issue: to the test that is running, when a test runner's adapter is
    /// linked into the process, and to standard output otherwise.
    public enum Reporter {}
}

extension Test.Issue.Reporter {

    // WHY: set once, by the adapter's install function, which `resolve` calls exactly once before any read.
    /// What an adapter does with an issue. The adapter sets it when the process first reports.
    nonisolated(unsafe) public static var record: (@Sendable (Test.Issue) -> Void)?

    /// The C name of the function an adapter exports to install itself.
    public static let install = "swift_issue_reporting_install"

    /// Sends `issue` to the running test through the adapter, or prints its description when there is none.
    public static func report(_ issue: Test.Issue) {
        _ = resolve
        guard let record = unsafe record else {
            print(issue.description)
            return
        }
        record(issue)
    }

    /// True in a test process: an adapter is linked, or the process is a test runner (an XCTest bundle or host,
    /// or a Swift Testing run), whether or not it links an adapter.
    public static let isTesting: Bool = {
        _ = resolve
        if unsafe record != nil { return true }
        for name in ["XCTestBundlePath", "XCTestConfigurationFilePath", "XCTestSessionIdentifier"]
        where Environment.read.isSet(name) {
            return true
        }
        let arguments = CommandLine.arguments
        if arguments.contains("--testing-library") { return true }
        return arguments.first.map { $0.hasSuffix("xctest") || $0.hasSuffix("PackageTests") } ?? false
    }()

    private static let resolve: Void = {
        guard unsafe record == nil else { return }
        let symbol: UnsafeRawPointer
        do throws(Loader.Error) {
            unsafe symbol = try Loader.Symbol.lookup(name: install, in: .default)
        } catch {
            return
        }
        unsafe unsafeBitCast(symbol, to: (@convention(c) () -> Void).self)()
    }()
}
