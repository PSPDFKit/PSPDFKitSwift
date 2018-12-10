//
//  Copyright © 2018-2019 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from
//  this file.
//

@_exported import PSPDFKit // Clang module

extension AnnotationString: CustomStringConvertible, ExpressibleByStringLiteral {
    public var description: String {
        return self.rawValue
    }

    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}
