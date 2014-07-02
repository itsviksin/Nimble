import Foundation


func _identityAsString(value: NSObject?) -> String {
    if !value {
        return "nil"
    }
    var str: String
    let args = VaListBuilder()
    args.append(value!.description)
    args.append(value!)
    str = NSString(format: "<%@> (0x%p)", arguments: args.va_list())
    return str
}

func _arrayAsString<T>(items: T[], joiner: String = ", ") -> String {
    return items.reduce("") { accum, item in
        let prefix = (accum.isEmpty ? "" : joiner)
        return accum + prefix + "\(item)"
    }
}

@objc protocol KICStringer {
    func KIC_stringify() -> String
}

func stringify<S: Sequence>(value: S) -> String {
    var generator = value.generate()
    var strings = String[]()
    var value: S.GeneratorType.Element?
    do {
        value = generator.next()
        if value {
            strings.append(stringify(value))
        }
    } while value
    let str = ", ".join(strings)
    return "[\(str)]"
}

extension NSArray : KICStringer {
    func KIC_stringify() -> String {
        let str = valueForKey("description").componentsJoinedByString(", ")
        return "[\(str)]"
    }
}

func stringify<T>(value: T?) -> String {
    if value is Double {
        var args = VaListBuilder()
        args.append(value as Double)
        return NSString(format: "%.4f", arguments: args.va_list())
    }
    return toString(value)
}