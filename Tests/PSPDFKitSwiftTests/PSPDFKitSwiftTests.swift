import XCTest
@testable import PSPDFKitSwift

class PSPDFKitSwiftTests: XCTestCase {
    func testDocument() {
        do {
            try PDFDocumentTests.test()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testPSPDFKit() throws {
        try PSPDFKitObjectTests.test()
    }

    static var allTests = [
        ("documentTests", testDocument),
        ("pspdfkitObjectTests", testPSPDFKit),
    ]
}
