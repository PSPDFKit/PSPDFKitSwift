//
//  Copyright © 2018-2019 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from
//  this file.
//

import Foundation
@_exported import PSPDFKit //Clang module

extension PSPDFAbstractLineAnnotation {
    public convenience init(pointsTyped: [CGPoint]) {
        self.init(points: pointsTyped.map { NSValue(point: $0) })
    }
}
