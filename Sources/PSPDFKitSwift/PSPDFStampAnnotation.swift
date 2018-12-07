//
//  Copyright © 2018-2019 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from
//  this file.
//

import Foundation
@_exported import PSPDFKit // Clang module

public typealias StampAnnotation = PSPDFStampAnnotation

extension PSPDFStampAnnotation {
    /// Parses the AP stream, searches for an image and loads it.
    /// This can return nil if the `image` has been set manually.
    /// @note This will not update `image` or `imageTransform` - do that manually if required.
    public func loadImage(with transform: inout CGAffineTransform) throws -> UIImage {
        return try withUnsafeMutablePointer(to: &transform) { [unowned self] (pointer) -> UIImage in
            try self.loadImage(with: pointer)
        }
    }
}
