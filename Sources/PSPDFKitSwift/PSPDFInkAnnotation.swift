//
//  Copyright © 2018-2019 PSPDFKit GmbH. All rights reserved.
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

    public convenience init(lines: [PDFLine]) {
        self.init(lines: ConvertToValueArray(pdfLines: lines))
    }

    public var linesTyped: [PDFLine]? {
        get {
            guard let valueLines = lines else { return nil }
            return ConvertToDrawingPointArray(valueArray: valueLines)
        }
        set {
            lines = newValue != nil ? ConvertToValueArray(pdfLines: newValue!) : nil
        }
    }
}

public typealias PDFLine = [PSPDFDrawingPoint]
public typealias ViewLine = [CGPoint]

/// Convert view lines to PDF lines.
// swiftlint:disable:next identifier_name
public func ConvertToPDFLines(viewLines: [ViewLine], pageInfo: PSPDFPageInfo, viewBounds: CGRect) -> [PDFLine] {
    let lines = viewLines.map { $0.map({ NSValue(point: $0) }) }
    let convertedBoxedLines = PSPDFConvertViewLinesToPDFLines(lines, pageInfo, viewBounds)
    return ConvertToDrawingPointArray(valueArray: convertedBoxedLines)
}

/// Converts a single line of boxed `CGPoint`.
// swiftlint:disable:next identifier_name
public func ConvertToPDFLine(viewLine: ViewLine, pageInfo: PSPDFPageInfo, viewBounds: CGRect) -> PDFLine {
    let line = viewLine.map { NSValue(point: $0) }

    return PSPDFConvertViewLineToPDFLines(line, pageInfo, viewBounds).map { $0.pspdf_drawingPointValue }
}

/// Calculates the bounding box from lines.
// swiftlint:disable:next identifier_name
public func BoundingBoxFromLines(_ lines: [PSPDFDrawingPoint], width: Double) {
    PSPDFBoundingBoxFromLines(lines, CGFloat(width))
}
