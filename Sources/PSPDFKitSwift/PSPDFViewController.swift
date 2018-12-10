//
//  Copyright © 2018-2019 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from
//  this file.
//

import Foundation
@_exported import PSPDFKit // Clang module
@_exported import PSPDFKitUI // Clang module

extension PSPDFViewController {

    /// Convenience initializer that takes a document and a generated configuration.
    public convenience init(_ document: PSPDFDocument?, _ builder: ((PSPDFConfigurationBuilder) -> Void)? = nil) {
        let configuration = PSPDFConfiguration { innerBuilder in
            guard let builder = builder else { return }
            builder(innerBuilder)
        }
        self.init(document: document, configuration: configuration)
    }
}
