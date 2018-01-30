import Foundation
import PSPDFKit

public typealias PolygonAnnotation = PSPDFPolygonAnnotation

extension PSPDFPolygonAnnotation {
    public convenience init(points: [CGPoint], intentType: PSPDFPolygonAnnotationIntent = .none) {
        self.init(__points: points.map { NSValue(cgPoint: $0) }, intentType: intentType)
    }
}
