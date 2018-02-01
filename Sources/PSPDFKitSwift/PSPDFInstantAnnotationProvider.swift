import Foundation
import PSPDFKit
import PSPDFKitUI

extension PSPDFInstantAnnotationProvider {
    
    /**
     Replaces the cached annotations for the specified pages, and accumulates the changes using the block in order to
     generate change messages.
     */
    func needsLocking_refreshCachedAnnotationsForPages(atIndices pageIndices: Set<Int>) {
        __needsLocking_refreshCachedAnnotationsForPages(atIndices: Set(pageIndices.map { NSNumber(value: $0) }))
    }
}
