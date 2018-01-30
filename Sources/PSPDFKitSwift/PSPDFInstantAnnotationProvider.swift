import Foundation
import PSPDFKit
import PSPDFKitUI

extension PSPDFInstantAnnotationProvider {
    func needsLocking_refreshCachedAnnotationsForPages(atIndices pageIndices: Set<Int>) {
        __needsLocking_refreshCachedAnnotationsForPages(atIndices: Set(pageIndices.map { NSNumber(value: $0) }))
    }
}
