import Foundation

protocol JSONCoding: JSONSerializing, JSONDeserializing { }


protocol JSONSerializing {
    var encoder: JSONEncoder { get }
}

protocol JSONDeserializing {
    var decoder: JSONDecoder { get }
}
