import Foundation

// CFRuntimeBase is 16 bits. bits 15-8 in the CFRuntimeBase _info are type. bits 7-0 in the CFRuntimeBase are reserved for CF's use https://opensource.apple.com/source/CF/CF-299/Base.subproj/CFRuntime.c
//typealias CFRuntimeBase = UInt16
//struct CFKeyedArchiverUID: Decodable {
//    let _base: CFRuntimeBase
//    let _value: UInt32
//}
//
//@objc class FakeObject: NSObject, Decodable {
//    var _base: CFRuntimeBase = 0
//    var _value: UInt32 = 0
//
//    required init(from decoder: Decoder) throws {
//        print("aqq")
//    }
//}

// The missing link between `NSKeyedArchiver` and `Encodable`
struct KeyedArchive: Decodable {

    enum Error: Swift.Error {
        case invalid
    }

    class KeyedArchiverUID: NSObject, Decodable {
        required init(from decoder: Decoder) throws {
        }
    }

    struct Object: Decodable {
        var key: Dictionary<String, KeyedArchiverUID>?

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            guard !container.decodeNil() else { return }

            do {
                let str = try container.decode(String.self)
                print(str)
            } catch {
                key = try container.decode(Dictionary<String, KeyedArchiverUID>.self)
            } catch {
                // just ignore
            }
        }
    }

    struct Top: Decodable {
        let root: String?
    }

    let version: Int
    let top: Top
    let archiver: String
    let objects: Array<Object>

    enum CodingKeys: String, CodingKey {
        case version = "$version"
        case top = "$top"
        case archiver = "$archiver"
        case objects = "$objects"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.version = try container.decode(Int.self, forKey: .version)
        self.top = try container.decode(Top.self, forKey: .top)
        self.archiver = try container.decode(String.self, forKey: .archiver)
        self.objects = try container.decode(Array<Object>.self, forKey: .objects)
        // let topContainer = try container.nestedContainer(keyedBy: Top.CodingKeys.self, forKey: CodingKeys.top)
        // try topContainer.decode(Top.self, forKey: Top.CodingKeys.root)
        throw Error.invalid
    }
}

internal class KeyedArchiveTests {
    static func test() throws {
        let document = PDFDocument()
        document.title = "salamandra"
        let archiver = NSKeyedArchiver(forWritingWith: NSMutableData())
        archiver.encodeRootObject(document)
        let archivedData = archiver.encodedData

//        NSKeyedArchiver.archiveRootObject(document, toFile: "/Users/marcinkrzyzanowski/Downloads/archive.plist")
//        let archivedData = NSKeyedArchiver.archivedData(withRootObject: document)
        try archivedData.write(to: URL.init(fileURLWithPath: "/Users/marcinkrzyzanowski/Downloads/archive.plist"))
        let decoded = try KeyedArchiveDecoder().decode(data: archivedData)
        print(decoded)
    }
}

class KeyedArchiveDecoder {

    enum Error: Swift.Error {
        case invalid
    }

    private static let NSKeyedArchivePlistVersion = 100000
    private var plist : Any? = nil

    func decode(data: Data) throws -> KeyedArchive {
        var format = PropertyListSerialization.PropertyListFormat.binary
        return try PropertyListDecoder().decode(KeyedArchive.self, from: data, format: &format)

        /*
        try plist = PropertyListSerialization.propertyList(from: data, options: [], format: &format)

        guard let unwrappedPlist = plist as? Dictionary<String, Any> else {
            throw Error.invalid
        }

        let archiver = unwrappedPlist["$archiver"] as? String
        if archiver != NSStringFromClass(NSKeyedArchiver.self) {
            throw Error.invalid
        }

        guard let version = unwrappedPlist["$version"] as? NSNumber, version.int32Value != Int32(KeyedArchiveDecoder.NSKeyedArchivePlistVersion) else {
            throw Error.invalid
        }


        guard let top = unwrappedPlist["$top"] as? Dictionary<String, Any>,
              let objects = unwrappedPlist["$objects"] as? Array<Any>
        else {
            throw Error.invalid
        }

        return KeyedArchive(version: version.intValue, top: top, objects: objects)
         */
    }
}
