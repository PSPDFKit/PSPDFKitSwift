import PSPDFKit

extension PSPDFPolygonAnnotation {
    public convenience init(points: [CGPoint], intentType: PSPDFPolygonAnnotationIntent = .none) { [unowned self] in
        self.init(__points: points.map { NSValue(cgPoint: $0) }, intentType: intentType)
    }
}
