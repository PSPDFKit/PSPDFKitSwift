//
//  Copyright © 2018-2019 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from
//  this file.
//

import Foundation
@_exported import PSPDFKit //Clang module

public typealias PolygonAnnotation = PSPDFPolygonAnnotation

extension PSPDFPolygonAnnotation {

    /// Initializer
    ///
    /// - Parameters:
    ///   - points: Polygon points.
    ///   - intentType: Annotation intent.
    public convenience init(pointsTyped: [CGPoint], intentType: PSPDFPolygonAnnotationIntent = .none) {
        self.init(points: pointsTyped.map { NSValue(point: $0) }, intentType: intentType)
    }
}
