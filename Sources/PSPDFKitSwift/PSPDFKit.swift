import PSPDFKit

extension PSPDFKitObject {

    /// Allow direct dictionary-like access.
    public subscript(key: String) -> Any? {
        get {
            return __objectForKeyedSubscript(key as NSString) // self[key as NSString]
        }
        set {
            guard let newValue = newValue else { return }
            __setObject(newValue, forKeyedSubscript: key as NSString)
        }
    }
}

internal class PSPDFKitObjectTests {
    static func test() throws {

        // let any = PSPDFKitOrigin.shared["foo" as NSCopying] // Any?
        // PSPDFKitOrigin.shared.setObject(1 as NSNumber, forKeyedSubscript: "foo" as NSCopying)
        PSPDFKit.sharedInstance["abc"] = 1
        let value = PSPDFKit.sharedInstance["abc"] as? Int
        guard value == 1 else {
            throw NSError.pspdf_error(withCode: 0, description: "Invalid value from")
        }
    }
}
