import PSPDFKit

extension PSPDFAbstractLineAnnotation {
    public convenience init(points: [CGPoint]) {
        self.init(__points: points.map { NSValue(cgPoint: $0) })
    }
}
