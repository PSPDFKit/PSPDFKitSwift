//
//  Copyright © 2018-2019 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from
//  this file.
//

@_exported import PSPDFKit // Clang module

extension String {
    public init(_ value: AnnotationType) {
        self.init(describing: StringFromAnnotationType(value)!.rawValue)
    }

    public init(_ value: AnnotationString) {
        self.init(describing: value.rawValue)
    }
}
