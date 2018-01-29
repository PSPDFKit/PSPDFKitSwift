import XCTest
@testable import PSPDFKitSwift

class PSPDFKitSwiftTests: XCTestCase {

    func testDocument() throws {
        do {
            try PDFDocumentTests.test()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testPSPDFKit() throws {
        try PSPDFKitObjectTests.test()
    }

    func testPSPDFRenderRequest() throws {
        try RenderRequestTests.test()
    }

    static var allTests = [
        ("documentTests", testDocument),
        ("pspdfkitObjectTests", testPSPDFKit),
        ("testPSPDFRenderRequest", testPSPDFRenderRequest)
    ]
}
