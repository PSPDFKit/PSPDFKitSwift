import PSPDFKit

class PDFDocument: PSPDFDocument {
    @available(*, unavailable)
    override func save(options: [PSPDFDocumentSaveOption : Any]? = nil, completionHandler: ((Error?, [PSPDFAnnotation]) -> Void)? = nil) {}

    @available(*, unavailable)
    override func save(options: [PSPDFDocumentSaveOption : Any]? = nil) throws {}
}

extension PDFDocument {
    public typealias DocumentPermissions = PSPDFDocumentPermissions

    public struct SecurityOptions {
        var ownerPassword: String?
        var userPassword: String?
        var keyLength: Int
        var permissions: DocumentPermissions
        var encryptionAlgorithm: PSPDFDocumentEncryptionAlgorithm
    }

    public enum SaveOption {
        case security(SecurityOptions)
        case forceRewrite
    }

    public func save(options: SaveOption...) throws {
        var translatedOptions:[PSPDFDocumentSaveOption: Any]? = [PSPDFDocumentSaveOption: Any]()
        for option in options {
            switch option {
            case .security(let securityOptions):
                translatedOptions?[.securityOptions] = securityOptions
                break
            case .forceRewrite:
                translatedOptions?[.forceRewrite] = NSNumber(value: true)
                break
            }
        }

        try super.save(options: translatedOptions)
    }
}


private class testPDFDocument {
    func test() throws {
        let document = PDFDocument()
        let securityOptions = PDFDocument.SecurityOptions(ownerPassword: "foo", userPassword: "bar", keyLength: 16, permissions: [.extract, .fillForms], encryptionAlgorithm: .AES)
        try document.save(options: .security(securityOptions), .forceRewrite)
    }
}
