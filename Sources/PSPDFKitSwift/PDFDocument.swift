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

        internal var dictionary: [PSPDFDocumentSaveOption: Any]  {
            switch self {
            case .security(let securityOptions):
                return [.securityOptions: securityOptions]
            case .forceRewrite:
                return [.forceRewrite: NSNumber(value: true)]
            }
        }

        internal static func mapToDictionary(options: [SaveOption]) -> [PSPDFDocumentSaveOption: Any] {
            var optionsDictionary = [PSPDFDocumentSaveOption: Any]()
            for option in options {
                option.dictionary.forEach { optionsDictionary[$0.0] = $0.1 }
            }
            return optionsDictionary
        }
    }

    public func save(options: SaveOption...) throws {
        try super.save(options: SaveOption.mapToDictionary(options: options))
    }

    public func save(options: SaveOption..., completion: @escaping (Result<[PSPDFAnnotation], AnyError>) -> Void)  {
        super.save(options: SaveOption.mapToDictionary(options: options), completionHandler: { (error, annotations) in
            if let error = error {
                completion(Result.failure(AnyError(error)))
                return
            }

            completion(Result.success(annotations))
        })
    }
}


private class testPDFDocument {
    func test() throws {
        let document = PDFDocument()
        let securityOptions = PDFDocument.SecurityOptions(ownerPassword: "foo", userPassword: "bar", keyLength: 16, permissions: [.extract, .fillForms], encryptionAlgorithm: .AES)
        try document.save(options: .security(securityOptions), .forceRewrite)
        document.save(options: .security(securityOptions), .forceRewrite) { (result) in
            do {
                let annotations = try result.dematerialize()
                print(annotations)
            } catch {
                print(error)
            }
        }
    }
}
