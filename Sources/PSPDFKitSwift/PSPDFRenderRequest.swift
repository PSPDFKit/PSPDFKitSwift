import PSPDFKit

public typealias RenderRequest = PSPDFRenderRequest
public typealias RenderType = PSPDFRenderType
public typealias RenderFilter = PSPDFRenderFilter

// Replaces original Objective-C `PSPDFRenderDrawBlock`. See https://bugs.swift.org/browse/SR-6873
public typealias PSPDFRenderDrawBlock = @convention(block) (_ context: CGContext, _ page: UInt, _ cropBox: CGRect, _ rotation: UInt, _ options: [String: Any]?) -> Void
public typealias RenderDrawHandler = PSPDFRenderDrawBlock

/// Rendering options. Parameters of how an image should be rendered.
public enum RenderOption: RawRepresentable, Codable {
    public typealias RawValue = [PSPDFRenderOption: Any]

    case none
    case preserveAspectRatio(Bool)
    case ignoreDisplaySettings(Bool)
    case pageColor(UIColor)
    case inverted(Bool)
    case filters(RenderFilter)
    case interpolationQuality(CGInterpolationQuality)
    case skipPageContent(Bool)
    case overlayAnnotations(Bool)
    case skipAnnotations([PDFAnnotation])
    case ignorePageClip(Bool)
    case allowAntiAliasing(Bool)
    case backgroundFillColor(UIColor)
    case textRenderingUseCoreGraphics(Bool)
    case textRenderingClearTypeEnabled(Bool)
    case interactiveFormFillColor(UIColor)
    case draw(RenderDrawHandler)
    case drawSignHereOverlay(Bool)
    case ciFilters([CIFilter])

    public init?(rawValue: RawValue) {
        for (key, value) in rawValue {
            switch key {
            case .preserveAspectRatioKey:
                self = .preserveAspectRatio((value as? NSNumber)?.boolValue ?? false)
            case .ignoreDisplaySettingsKey:
                self = .ignoreDisplaySettings((value as? NSNumber)?.boolValue ?? false)
            case .pageColorKey:
                self = .pageColor(value as? UIColor ?? .white)
            case .invertedKey:
                self = .inverted((value as? NSNumber)?.boolValue ?? false)
            case .filtersKey:
                let rawValue = (value as? NSNumber)?.uintValue ?? .init(bitPattern: 0)
                self = .filters(RenderFilter(rawValue: rawValue))
            case .interpolationQualityKey:
                let qualityValue = CGInterpolationQuality(rawValue: (value as? NSNumber)?.int32Value ?? CGInterpolationQuality.default.rawValue)
                self = .interpolationQuality(qualityValue ?? CGInterpolationQuality.default)
            case .skipPageContentKey:
                self = .skipPageContent((value as? NSNumber)?.boolValue ?? false)
            case .overlayAnnotationsKey:
                self = .overlayAnnotations((value as? NSNumber)?.boolValue ?? false)
            case .skipAnnotationArrayKey:
                self = .skipAnnotations(value as? [PDFAnnotation] ?? [])
            case .ignorePageClipKey:
                self = .ignorePageClip((value as? NSNumber)?.boolValue ?? false)
            case .allowAntiAliasingKey:
                self = .allowAntiAliasing((value as? NSNumber)?.boolValue ?? false)
            case .backgroundFillColorKey:
                self = .backgroundFillColor(value as? UIColor ?? .black)
            case .textRenderingUseCoreGraphicsKey:
                self = .textRenderingUseCoreGraphics((value as? NSNumber)?.boolValue ?? false)
            case .textRenderingClearTypeEnabledKey:
                self = .textRenderingClearTypeEnabled((value as? NSNumber)?.boolValue ?? false)
            case .interactiveFormFillColorKey:
                self = .interactiveFormFillColor(value as? UIColor ?? .black)
            case .drawBlockKey:
                let closure: PSPDFRenderDrawBlock = unsafeBitCast(value, to: PSPDFRenderDrawBlock.self)
                self = .draw(closure)
            case .drawSignHereOverlay:
                self = .drawSignHereOverlay((value as? NSNumber)?.boolValue ?? false)
            case .ciFilterKey:
                self = .ciFilters(value as? [CIFilter] ?? [])
            default:
                fatalError("Unknown option")
            }
        }
        self = .none
    }

    public var rawValue: RawValue {
        switch self {
        case .none:
            return [:]
        case .preserveAspectRatio(let value):
            return [.preserveAspectRatioKey: NSNumber(value: value)]
        case .ignoreDisplaySettings(let value):
            return [.ignoreDisplaySettingsKey: NSNumber(value: value)]
        case .pageColor(let value):
            return [.pageColorKey: value]
        case .inverted(let value):
            return [.invertedKey: NSNumber(value: value)]
        case .filters(let filters):
            return [.filtersKey: filters]
        case .interpolationQuality(let value):
            return [.interpolationQualityKey: value.rawValue]
        case .skipPageContent(let value):
            return [.skipPageContentKey: NSNumber(value: value)]
        case .overlayAnnotations(let value):
            return [.overlayAnnotationsKey: NSNumber(value: value)]
        case .skipAnnotations(let annotations):
            return [.skipAnnotationArrayKey: annotations]
        case .ignorePageClip(let value):
            return [.ignorePageClipKey: NSNumber(value: value)]
        case .allowAntiAliasing(let value):
            return [.skipPageContentKey: NSNumber(value: value)]
        case .backgroundFillColor(let color):
            return [.backgroundFillColorKey: color]
        case .textRenderingUseCoreGraphics(let value):
            return [.skipPageContentKey: NSNumber(value: value)]
        case .textRenderingClearTypeEnabled(let value):
            return [.textRenderingClearTypeEnabledKey: NSNumber(value: value)]
        case .interactiveFormFillColor(let color):
            return [.interactiveFormFillColorKey: color]
        case .draw(let closure):
            return [.drawBlockKey: unsafeBitCast(closure, to: AnyObject.self)]
        case .drawSignHereOverlay(let value):
            return [.drawSignHereOverlay: NSNumber(value: value)]
        case .ciFilters(let filters):
            return [.ciFilterKey: filters]
        }
    }

    public init(from decoder: Decoder) throws {
        var unkeyedContainer = try decoder.unkeyedContainer()
        self.init(rawValue: try unkeyedContainer.decode(RawValue.self))!
    }

    public func encode(to encoder: Encoder) throws {
        var unkeyedContainer = encoder.unkeyedContainer()
        try unkeyedContainer.encode(self.rawValue)
    }
}

internal class RenderRequestTests {
    static func test() throws {
        let document = PDFDocument()

        let drawClosure = { (_: CGContext, page: UInt, cropBox: CGRect, _: UInt, _: [String: Any]?) -> Void in
            let text = "PSPDF Live Watermark On Page \(page + 1)"
            let stringDrawingContext = NSStringDrawingContext()

            text.draw(with: cropBox, context: stringDrawingContext)
        }

        document.updateRenderOptions([.draw(drawClosure), .drawSignHereOverlay(true)], type: .all)
    }
}
