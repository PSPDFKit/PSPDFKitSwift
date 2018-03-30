//
//  Copyright (c) 2018 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from
//  this file.
//

import Foundation
@_exported import PSPDFKit //Clang module

// swiftlint:disable:next identifier_name
func NSUnimplemented(_ fn: String = #function, file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("\(fn) is not yet implemented", file: file, line: line)
}

// swiftlint:disable:next identifier_name
func NSRequiresConcreteImplementation(_ fn: String = #function, file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("\(fn) must be overriden in subclass implementations", file: file, line: line)
}

#if swift(>=4.1)
// TODO: remove this file when Xcode 9.2 is no longer used
#else
extension Sequence {
    public func compactMap<ElementOfResult>(
        _ transform: (Element) throws -> ElementOfResult?
        ) rethrows -> [ElementOfResult] {
        return try flatMap(transform)
    }
}
#endif
