//
//  Copyright © 2018-2019 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from
//  this file.
//

import Foundation
@_exported import PSPDFKit // Clang module

extension NSValue {
    public convenience init(point: CGPoint) {
        self.init(cgPoint: point)
    }

    public convenience init(rect: CGRect) {
        self.init(cgRect: rect)
    }

    public var rectValue: CGRect {
        return self.cgRectValue
    }

    public var pointValue: CGPoint {
        return self.cgPointValue
    }
}
