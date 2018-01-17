import CoreFoundation
import Foundation
import PSPDFKit.Private

public class PDFDocument: PSPDFDocument, Codable {
    public typealias FileIndex = UInt

    override init(dataProviders: [PSPDFDataProviding], loadCheckpointIfAvailable loadCheckpoint: Bool) {
        super.init(dataProviders: dataProviders, loadCheckpointIfAvailable: loadCheckpoint)
    }

    convenience init(url: URL) {
        let dataProvider: PSPDFDataProviding
        if PSPDFKit.bool(forKey: PSPDFFileCoordinationEnabledKey) {
            dataProvider = PSPDFCoordinatedFileDataProvider(fileURL: url, progress: nil)
        } else {
            dataProvider = PSPDFFileDataProvider(fileURL: url, progress: nil)
        }

        self.init(dataProviders: [dataProvider], loadCheckpointIfAvailable: false)
    }

    // MARK: - Codable, NSCoding

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
    }

    enum CodingKeys: String, CodingKey {
        case uid
        case title
        case areAnnotationsEnabled
        case dataProviders
        case shouldLoadCheckpoint
        case renderOptionsForAll
        case renderOptionsForPage
        case renderOptionsForProcessor
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let dataProviders = try container.decode(Array<PSPDFDataProviding>.self, forKey: .dataProviders)
        let enableCheckpoints = try container.decode(Bool.self, forKey: .shouldLoadCheckpoint)

        super.init(dataProviders: dataProviders, loadCheckpointIfAvailable: enableCheckpoints)

        title = try container.decode(String.self, forKey: .title)
        areAnnotationsEnabled = try container.decode(Bool.self, forKey: .title)
        uid = try container.decode(String.self, forKey: .uid)

        // TODO: Refine PSPDFRenderOption dictionary
        setRenderOptions(try container.decode([PSPDFRenderOption: Any]?.self, forKey: .renderOptionsForAll), type: .all)
        setRenderOptions(try container.decode([PSPDFRenderOption: Any]?.self, forKey: .renderOptionsForAll), type: .page)
        setRenderOptions(try container.decode([PSPDFRenderOption: Any]?.self, forKey: .renderOptionsForProcessor), type: .processor)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(dataProviders, forKey: .dataProviders)
        try container.encode(title, forKey: .title)
        try container.encode(areAnnotationsEnabled, forKey: .areAnnotationsEnabled)
        try container.encode(uid, forKey: .uid)
        try container.encode(checkpointer.checkpointExists, forKey: .shouldLoadCheckpoint)
        try container.encode(renderOptions(for: .all, context: nil), forKey: .renderOptionsForAll)
        try container.encode(renderOptions(for: .page, context: nil), forKey: .renderOptionsForPage)
        try container.encode(renderOptions(for: .processor, context: nil), forKey: .renderOptionsForProcessor)
    }
}

// MARK: - Saving
extension PDFDocument {
    public typealias SecurityOptions = PSPDFDocumentSecurityOptions

    public enum SaveOption {
        case security(SecurityOptions)
        case forceRewrite

        internal var dictionary: [PSPDFDocumentSaveOption: Any] {
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
                option.dictionary.forEach { entry in
                    optionsDictionary[entry.key] = entry.value
                }
            }
            return optionsDictionary
        }
    }

    ///  Saves the document and all of its linked data, including bookmarks and
    ///  annotations, synchronously.
    ///
    /// - Parameter options: See `SaveOption` documentation for more details.
    /// - Throws: NSInternalInconsistencyException if save options are not valid.
    public func save(options: SaveOption...) throws {
        try __save(options: SaveOption.mapToDictionary(options: options))
    }

    /// Saves the document and all of its linked data, including bookmarks and
    /// annotations, asynchronously. Does not block the calling thread.
    ///
    /// - Parameters:
    ///   - options: See `SaveOption` documentation for more details.
    ///   - completion: Called on the *main thread* after the save operation finishes.
    public func save(options: SaveOption..., completion: @escaping (Result<[PSPDFAnnotation], AnyError>) -> Void) {
        __save(options: SaveOption.mapToDictionary(options: options), completionHandler: { error, annotations in
            if let error = error {
                completion(Result.failure(AnyError(error)))
                return
            }

            completion(Result.success(annotations))
        })
    }
}

internal class PDFDocumentTests {
    static func test() throws {
        let document = PDFDocument()
        let securityOptions = try PDFDocument.SecurityOptions(ownerPassword: "0123456789012345678901234567890123456789", userPassword: "0123456789012345678901234567890123456789", keyLength: 40, permissions: [.extract, .fillForms], encryptionAlgorithm: .AES)
        try document.save(options: .security(securityOptions), .forceRewrite)
        document.save(options: .security(securityOptions), .forceRewrite) { result in
            _ = try! result.dematerialize()
        }
    }
}
