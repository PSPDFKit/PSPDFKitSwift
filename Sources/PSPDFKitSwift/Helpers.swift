import Foundation

func NSUnimplemented(_ fn: String = #function, file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("\(fn) is not yet implemented", file: file, line: line)
}

func NSRequiresConcreteImplementation(_ fn: String = #function, file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("\(fn) must be overriden in subclass implementations", file: file, line: line)
}
