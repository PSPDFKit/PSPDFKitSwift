import Foundation
import PSPDFKit

extension PSPDFPointArray {
    /// Access internal points. Thread safe accessor.
    public var points: [PSPDFDrawingPoint] {
        return __points.map { $0.pspdf_drawingPointValue }
    }

    /// Init with a boxed array, will unbox on load.
    /// @note `points` will be validated, NaN or Inf values will be filtered out.
    public convenience init(points: [PSPDFDrawingPoint]) {
        self.init(__points: points.map({ NSValue.pspdf_value(with: $0) }))
    }

    /// Subscripting support.
    open subscript(index: Int) -> PSPDFDrawingPoint {
        return self.point(at: UInt(index))
    }
}
