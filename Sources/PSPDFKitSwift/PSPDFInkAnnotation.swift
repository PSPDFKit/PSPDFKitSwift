import PSPDFKit

extension PSPDFInkAnnotation {
    public convenience init(lines: [PSPDFDrawingPoint]) {
        self.init(__lines: lines.map { value in
            var value = value
            return [NSValue(bytes: &value, objCType: _getObjCTypeEncoding(PSPDFDrawingPoint.self))]
        })
    }
}

public typealias PDFLine = [PSPDFDrawingPoint]
public typealias ViewLine = [PSPDFDrawingPoint]

/// Will convert view lines to PDF lines (operates on every point)
/// Get the `cropBox` and rotation from `PSPDFPageInfo`.
/// bounds should be the size of the view.
public func ConvertToPDFLines(viewLines: [ViewLine], cropBox: CGRect, rotation: Int, bounds: CGRect) -> [PDFLine] {
    let lines = viewLines.map { $0.map({ NSValue.pspdf_value(with: $0) }) }

    return __PSPDFConvertViewLinesToPDFLines(lines, cropBox, UInt(rotation), bounds).map { $0.map({ $0.pspdf_drawingPointValue }) }
}

/// Converts a single line of boxed `PSPDFDrawingPoints`.
public func ConvertToPDFLine(viewLine: ViewLine, cropBox: CGRect, rotation: Int, bounds: CGRect) -> PDFLine {
    let line = viewLine.map { NSValue.pspdf_value(with: $0) }

    return __PSPDFConvertViewLineToPDFLines(line, cropBox, UInt(rotation), bounds).map { $0.pspdf_drawingPointValue }
}

///// Calculates the bounding box from lines.
///// @param lines Either an `NSArray<PSPDFPointArray *>` or `NSArray<NSArray<NSValue *> *>`.
public func BoundingBoxFromLines(_ lines: [PSPDFPointArray], width: Double) {
    __PSPDFBoundingBoxFromLines(lines, CGFloat(width))
}

///// Calculates the bounding box from lines.
public func BoundingBoxFromLines(_ lines: [[PSPDFDrawingPoint]], width: Double) {
    __PSPDFBoundingBoxFromLines(lines.map({ $0.map({ NSValue.pspdf_value(with: $0) }) }), CGFloat(width))
}
