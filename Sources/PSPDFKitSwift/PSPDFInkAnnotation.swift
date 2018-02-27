//
//  Copyright (c) 2018 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from
//  this file.
//

import Foundation
@_exported import PSPDFKit //Clang module

public typealias InkAnnotation = PSPDFInkAnnotation

// swiftlint:disable:next identifier_name
private func ConvertToDrawingPointArray(valueArray: [[NSValue]]) -> [PDFLine] {
    return valueArray.map { $0.map({ $0.pspdf_drawingPointValue }) }
}

// swiftlint:disable:next identifier_name
private func ConvertToValueArray(pdfLines: [PDFLine]) -> [[NSValue]] {
    return pdfLines.map { $0.map({ NSValue.pspdf_value(with: $0) }) }
}

extension PSPDFInkAnnotation {

    public convenience init(lines: [PSPDFDrawingPoint]) {
        self.init(__lines: lines.map { value in
            var value = value
            return [NSValue(bytes: &value, objCType: _getObjCTypeEncoding(PSPDFDrawingPoint.self))]
        })
    }

    public var lines: [PDFLine]? {
        get {
            guard let valueLines = __lines else { return nil }
            return ConvertToDrawingPointArray(valueArray: valueLines)
        }
        set {
            __lines = newValue != nil ? ConvertToValueArray(pdfLines: newValue!) : nil
        }
    }
}

public typealias PDFLine = [PSPDFDrawingPoint]
public typealias ViewLine = [CGPoint]

/// Will convert view lines to PDF lines (operates on every point)
/// Get the `cropBox` and rotation from `PSPDFPageInfo`.
/// bounds should be the size of the view.
// swiftlint:disable:next identifier_name
public func ConvertToPDFLines(viewLines: [ViewLine], cropBox: CGRect, rotation: Int, bounds: CGRect) -> [PDFLine] {
    let lines = viewLines.map { $0.map({ NSValue(cgPoint: $0) }) }
    let convertedBoxedLines = __PSPDFConvertViewLinesToPDFLines(lines, cropBox, UInt(rotation), bounds)
    return ConvertToDrawingPointArray(valueArray: convertedBoxedLines)
}

/// Converts a single line of boxed `CGPoint`.
// swiftlint:disable:next identifier_name
public func ConvertToPDFLine(viewLine: ViewLine, cropBox: CGRect, rotation: Int, bounds: CGRect) -> PDFLine {
    let line = viewLine.map { NSValue(cgPoint: $0) }

    return __PSPDFConvertViewLineToPDFLines(line, cropBox, UInt(rotation), bounds).map { $0.pspdf_drawingPointValue }
}

/// Calculates the bounding box from lines.
// swiftlint:disable:next identifier_name
public func BoundingBoxFromLines(_ lines: [PSPDFDrawingPoint], width: Double) {
    __PSPDFBoundingBoxFromLines(lines, CGFloat(width))
}
