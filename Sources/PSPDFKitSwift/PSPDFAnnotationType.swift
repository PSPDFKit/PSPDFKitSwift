//
//  Copyright © 2018-2019 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from
//  this file.
//

@_exported import PSPDFKit // Clang module

extension AnnotationType: CustomStringConvertible, ExpressibleByStringLiteral {

    public init(stringLiteral value: StringLiteralType) {
        self = AnnotationTypeFromString(AnnotationString(rawValue: value))
    }

    public var description: String {
        return String(describing: self)
    }

    init(_ value: String) {
        self = AnnotationTypeFromString(AnnotationString(rawValue: value))
    }

    init(_ value: AnnotationString) {
        self = AnnotationTypeFromString(value)
    }
}
