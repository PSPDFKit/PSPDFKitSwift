//
//  Copyright (c) 2018 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from
//  this file.
//

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
