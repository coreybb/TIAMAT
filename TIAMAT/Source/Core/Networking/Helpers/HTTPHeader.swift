import Foundation

/// A struct that represents an HTTP header, which consists of a name and a value.
/// This is used to add headers to `URLRequest` objects for configuring network requests.
struct HTTPHeader: Sendable {
    let name: Name
    let value: String

    
    //  MARK: - Initialization
    
    /// Initializes a new `HTTPHeader` with a custom name and value.
    /// - Parameters:
    ///   - name: The name of the header.
    ///   - value: The value associated with the header.
    init(name: Name, value: String) {
        self.name = name
        self.value = value
    }
    
    /// Initializes a new `HTTPHeader` with a `Content-Type` value.
    /// - Parameters:
    ///   - name: The name of the header (should be `.contentType`).
    ///   - contentType: A specific `ContentType` value (e.g., `.applicationJSON`).
    init(name: Name, contentType: Value.ContentType) {
        self.name = name
        self.value = contentType.rawValue
    }
    
    /// Initializes a new `HTTPHeader` with an `Accept` value.
    /// - Parameters:
    ///   - name: The name of the header (should be `.accept`).
    ///   - accept: A specific `Accept` value (e.g., `.applicationJSON`).
    init(name: Name, accept: Value.Accept) {
        self.name = name
        self.value = accept.rawValue
    }
}


extension HTTPHeader {
    
    /// Represents the name of an HTTP header.
    /// This includes common header names like `Content-Type`, `Accept`, and `Authorization`.
    enum Name: String, Sendable {
        case contentType = "Content-Type"
        case accept = "Accept"
        case authorization = "Authorization"
        case userAgent = "User-Agent"
    }
    
    /// Contains nested types representing predefined header values, such as content types.
    enum Value {
        enum ContentType: String {
            case applicationJSON = "application/json"
            case applicationXWWWFormURLEncoded = "application/x-www-form-urlencoded"
            case textPlain = "text/plain"
        }
        
        enum Accept: String {
            case applicationJSON = "application/json"
            case textHTML = "text/html"
            
        }
    }
 }



extension URLRequest {
    
    mutating func addHeader(_ header: HTTPHeader) {
        addValue(header.value, forHTTPHeaderField: header.name.rawValue)
    }
}
