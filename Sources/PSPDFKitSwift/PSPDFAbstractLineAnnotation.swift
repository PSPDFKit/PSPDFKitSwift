//
//  Copyright (c) 2018 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from
//  this file.
//

import Foundation
@_exported import PSPDFKit //Clang module

extension PSPDFAbstractLineAnnotation {
    public convenience init(points: [CGPoint]) {
        self.init(__points: points.map { NSValue(cgPoint: $0) })
    }
}
