//
//  Copyright (c) 2018 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from
//  this file.
//

import Foundation
@_exported import PSPDFKit // Clang module

/// Protocol common for all provided PSPDFDocument subclasses.
public protocol PDFDocumentType: class {
    var isValid: Bool { get }
    var dataProviders: [PSPDFDataProviding] { get }
    var documentId: Data? { get }
    var documentIdString: String? { get }
    var uid: String! { get }
    var pageCount: PageCount { get }
    var fileURL: URL? { get }
}

extension PSPDFDocument: PDFDocumentType {}

open class PDFDocument: PSPDFDocument {

    public override init(dataProviders: [PSPDFDataProviding], loadCheckpointIfAvailable loadCheckpoint: Bool = false) {
        super.init(dataProviders: dataProviders, loadCheckpointIfAvailable: loadCheckpoint)
    }

    public convenience init(url: URL, loadCheckpointIfAvailable loadCheckpoint: Bool = false) {
        let dataProvider: PSPDFDataProviding
        if PSPDFKit.sharedInstance.bool(forKey: .fileCoordinationEnabledKey) {
            dataProvider = PSPDFCoordinatedFileDataProvider(fileURL: url, progress: nil)
        } else {
            dataProvider = PSPDFFileDataProvider(fileURL: url, progress: nil)
        }

        self.init(dataProviders: [dataProvider], loadCheckpointIfAvailable: loadCheckpoint)
    }

    // MARK: - Codable, NSCoding

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
    }
}

// MARK: - Annotations
extension PSPDFDocument {

    /// Annotation option.
    public enum AnnotationOption: RawRepresentable {
        /// Controls if overlay annotations should be animated. Only applies to overlay.
        case animateViewKey(Bool)
        /// Prevents the insertion or removal notifications from being sent.
        case suppressNotificationsKey(Bool)

        public typealias RawValue = [PSPDFAnnotationOption: Any]

        public init?(rawValue: RawValue) {
            for (key, value) in rawValue {
                switch key {
                case PSPDFAnnotationOption.animateViewKey:
                    self = .animateViewKey((value as? NSNumber)?.boolValue ?? false)
                case PSPDFAnnotationOption.suppressNotificationsKey:
                    self = .suppressNotificationsKey((value as? NSNumber)?.boolValue ?? false)
                default:
                    return nil
                }
            }
            return nil
        }

        public var rawValue: RawValue {
            switch self {
            case .animateViewKey(let value):
                return [PSPDFAnnotationOption.animateViewKey: NSNumber(value: value)]
            case .suppressNotificationsKey(let value):
                return [PSPDFAnnotationOption.suppressNotificationsKey: NSNumber(value: value)]
            }
        }
    }

    /**
     Allows control over what annotation should get an AP stream.
     AP (Appearance Stream) generation takes more time but will maximize compatibility with PDF Viewers that don't implement the complete spec for annotations.
     The default value for this dict is `[.generateAppearanceStreamForTypeKey: [.freeText, .ink, .polygon, .polyLine, .line, .square, .circle, .stamp, .widget]]`
     */
    public var annotationWritingOptions: [PSPDFAnnotationWriteOptions: AnnotationType]? {
        get {
            return __annotationWritingOptions?.mapValues { AnnotationType(rawValue: UInt(truncating: $0)) }
        }
        set {
            __annotationWritingOptions = newValue?.mapValues { $0.rawValue as NSNumber }
        }
    }

    /**
     Add `annotations` to the current document (and the backing store `PSPDFAnnotationProvider`)
     @param annotations An array of PSPDFAnnotation objects to be inserted.
     @param options Insertion options (see the `PSPDFAnnotationOption...` constants in `PSPDFAnnotationManager.h`).
     @note For each, the `absolutePage` property of the annotation is used.
     @warning Might change the `page` property if multiple documentProviders are set.
     */
    @discardableResult
    public func add(_ annotations: [PSPDFAnnotation], options: [AnnotationOption] = []) -> Bool {
        var internalOptions = [PSPDFAnnotationOption: Any]()
        options.forEach { option in
            let rawOptions = option.rawValue
            rawOptions.keys.forEach({ key in
                internalOptions[key] = rawOptions[key]
            })
        }

        return __add(annotations, options: internalOptions)
    }

    /**
     Remove `annotations` from the backing `PSPDFAnnotationProvider` object(s).
     @param annotations An array of PSPDFAnnotation objects to be removed.
     @param options Deletion options (see the `PSPDFAnnotationOption...` constants in `PSPDFAnnotationManager.h`).
     @note Might return NO if one or multiple annotations couldn't be deleted.
     This might be the case for form annotations or other objects that return NO for `isDeletable`.
     */
    @discardableResult
    public func remove(_ annotations: [PSPDFAnnotation], options: [AnnotationOption] = []) -> Bool {
        var internalOptions = [PSPDFAnnotationOption: Any]()
        options.forEach { option in
            let rawOptions = option.rawValue
            rawOptions.keys.forEach({ key in
                internalOptions[key] = rawOptions[key]
            })
        }

        return __remove(annotations, options: internalOptions)
    }
}

// MARK: - Saving
extension PSPDFDocument {

    /// See `PSPDFDocumentSecurityOptions`
    public typealias SecurityOptions = PSPDFDocumentSecurityOptions

    /// When saving a document, you can provide various save options.
    public enum SaveOption {
        /// Forces a full rewrite of the document.
        /// By default, a document is saved incrementally if possible. This means
        /// that only the changed parts of a document are appended while their previously
        /// persisted state is kept (but ignored). This is faster but uses increasingly more
        /// space over time. Forcing a rewrite means the whole document file is rewritten
        /// from scratch leaving out all the outdated and unused parts.
        case security(SecurityOptions)
        /// A `SecurityOptions` instance, specifies the security options to
        /// use when saving the document.
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
    public func save(options: [SaveOption]) throws {
        try __save(options: SaveOption.mapToDictionary(options: options))
    }

    /// Saves the document and all of its linked data, including bookmarks and
    /// annotations, asynchronously. Does not block the calling thread.
    ///
    /// - Parameters:
    ///   - options: See `SaveOption` documentation for more details.
    ///   - completion: Called on the *main thread* after the save operation finishes.
    public func save(options: [SaveOption], completion: @escaping (Result<[PSPDFAnnotation], AnyError>) -> Void) {
        __save(options: SaveOption.mapToDictionary(options: options), completionHandler: { error, annotations in
            if let error = error {
                completion(Result.failure(AnyError(error)))
                return
            }

            completion(Result.success(annotations))
        })
    }
}

extension PSPDFDocument {

    /**
     *  Set custom render options. See  PSPDFRenderManager.h for a list of available keys.
     *
     *  @param options The render options to set. Will reset to defaults if set to nil.
     *  @param type    The type you want to change. There are different render operation types.
     *
     *  @note There are certain default render options set, such as `PSPDFRenderInteractiveFormFillColorKey` which you most likely want to preserve.
     *
     *  The typical access pattern is:
     *    1) get existing render options
     *    2) customize the dictionary,
     *    3) and set the new merged render options.
     *
     *  If you are working with primarily dark documents, consider setting
     *  `PSPDFRenderBackgroundFillColorKey` to `UIColor.blackColor` to work around
     *  white/gray hairlines at document borders.
     */
    public func setRenderOptions(_ options: [RenderOption] = [], type: RenderType) {
        let optionsDict = options.map({ $0.rawValue }).reduce([:]) { $0.merging($1) { _, new in new } }
        self.__setRenderOptions(optionsDict, type: type)
    }

    /**
     *  Updates render options. Overrides new settings but does not destroy existing settings.
     *
     *  @param options Settings to add/replace in the renderOptions dictionary.
     *  @param type    The type you want to change.
     */
    public func updateRenderOptions(_ options: [RenderOption] = [], type: RenderType) {
        let optionsDict = options.map({ $0.rawValue }).reduce([:]) { $0.merging($1) { _, new in new } }
        self.__updateRenderOptions(optionsDict, type: type)
    }

    /**
     *  Returns the render options for a specific type of operation.
     *
     *  @param type    The specific operation type.
     *  @param context An optional context matching the operation type.
     *                 For `PSPDFRenderTypePage` this is an `NSNumber` of the page.
     *
     *  @return The render dictionary. Guaranteed to always return a dictionary.
     */
    public func renderOptions(for type: RenderType, context: Any?) -> [RenderOption] {
        return self.__renderOptions(for: type, context: context).flatMap({ (entry) -> RenderOption? in
            RenderOption(rawValue: [entry.key: entry.value])
        })
    }

}

internal class PDFDocumentTests {
    static func test() throws {
        let document = PDFDocument()
        let securityOptions = try PDFDocument.SecurityOptions(ownerPassword: "0123456789012345678901234567890123456789", userPassword: "0123456789012345678901234567890123456789", keyLength: 40, permissions: [.extract, .fillForms], encryptionAlgorithm: .AES)
        document.add([ /* TODO: */ ], options: [.animateViewKey(true), .suppressNotificationsKey(false)])
        try document.save(options: [.security(securityOptions), .forceRewrite])
        document.save(options: [.security(securityOptions), .forceRewrite]) { result in
            _ = try! result.dematerialize()
        }
    }
}
