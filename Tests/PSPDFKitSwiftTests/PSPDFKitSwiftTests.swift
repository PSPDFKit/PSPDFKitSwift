import XCTest
@testable import PSPDFKitSwift

class PSPDFKitSwiftTests: XCTestCase {
    func test() {
        do {
            // try PDFDocumentTests.test()
            try KeyedArchiveTests.test()
        } catch {
            XCTFail(error.localizedDescription)
        }

    }


    static var allTests = [
        ("test", test),
    ]
}
