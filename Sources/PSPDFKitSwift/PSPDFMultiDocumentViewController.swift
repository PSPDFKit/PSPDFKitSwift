//
//  Copyright (c) 2018 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from
//  this file.
//

import Foundation
@_exported import PSPDFKitUI

extension PSPDFMultiDocumentViewController {

    /// Documents that are currently loaded.
    @objc
    public var documents: [PDFDocument] {
        // Workaround to still use the #keyPath
        @objc(__pspdfkit_swift_documents)
        get {
            guard let arr = self.__documents as? [PDFDocument] else {
                return []
            }
            return arr
        }
        @objc(__pspdfkit_swift_setDocuments:)
        set {
            self.__documents = newValue
        }
    }

    /// Currently visible document.
    @objc
    public var visibleDocument: PDFDocument? {
        // Workaround to still use the #keyPath
        @objc(__pspdfkit_swift_visibleDocument)
        get {
            guard let visibleDocument = self.__visibleDocument as? PDFDocument else {
                return nil
            }
            return visibleDocument
        }
        @objc(__pspdfkit_swift_setVisibleDocument:)
        set {
            self.__visibleDocument = newValue
        }
    }
}

