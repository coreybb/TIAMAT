import Foundation

/// Represents a group of endpoints that share the same base URL.
/// This is useful for organizing endpoints that belong to the same API or service.
/// Conforming types should provide a `baseURL` for all related endpoints.
protocol EndpointGroup {
    
    /// The base URL used by all endpoints in this group.
    static var baseURL: URL { get }
}


/// A protocol that defines an endpoint associated with an `EndpointGroup`.
/// This is used to reduce redundancy when multiple endpoints share the same `baseURL`.
/// Conforming types only need to specify the `Group` they belong to.
protocol GroupedEndpoint: Endpoint {
    
    /// The type of `EndpointGroup` associated with this endpoint.
    associatedtype Group: EndpointGroup
}

/// Default implementation for `GroupedEndpoint`, automatically providing the `baseURL`
/// from the associated `EndpointGroup`.
extension GroupedEndpoint {
    
    /// Uses the `baseURL` defined in the `EndpointGroup`.
    var baseURL: URL { Group.baseURL }
}


/// A protocol that defines the structure of an API endpoint, including the details
/// needed to construct a network request.
///
/// NOTE: - When overriding optional properties in conforming types, they must be declared as
///        optionals to match the protocol definition. Failure to do so will result
///        in the default implementation (which likely returns `nil`) being used instead of the
///        overridden value.
protocol Endpoint: Sendable {
    
    /// The type of the request body. Defaults to `Never` if no body is used.
    associatedtype Body: Encodable = Never
    
    /// The base URL for the endpoint. This should be combined with `path` to form the full URL.
    var baseURL: URL { get }
    
    /// The path component to be appended to the `baseURL`.
    /// Example: For `https://api.example.com/v1/users`, the `path` would be "v1/users".
    var path: String? { get }
    
    /// The enumerated HTTP method to use for the request (e.g.,` GET`, `POST`).
    var method: HTTPMethod { get set }
    
    /// Optional enumerated headers to include in the request.
    var headers: [HTTPHeader]? { get set }
    
    /// Optional query parameters to include in the request.
    var queryItems: [URLQueryItem]? { get set }
    
    /// The body data as an Encodable model object to include in the request, if any.
    var body: Body? { get set }
    
    /// The full URL for the endpoint, including the `baseURL`, `path`, and `queryItems`.
    var url: URL { get }
    
    /// Creates a `URLRequest` object based on the properties of the endpoint.
    /// - Parameter encoder: A `JSONEncoder` used to encode the request body if provided.
    /// - Returns: A configured `URLRequest` object.
    func urlRequest(using encoder: JSONEncoder?) throws -> URLRequest
}


// MARK: - Default Implementation

/// Provides default implementations for the `Endpoint` protocol to simplify the
/// creation of conforming types.
extension Endpoint {
    
    /// Default implementation for `path`, returning `nil` if not overridden.
    var path: String? { nil }
    
    /// Default HTTP method is `GET`. Conforming types can override this if needed.
    var method: HTTPMethod {
        get { .get }
        set { /* no-op, override if needed */ }
    }
    
    /// Default headers are `nil`, meaning no headers will be included by default.
    var headers: [HTTPHeader]? {
        get { nil }
        set { /* no-op, override if needed */ }
    }
    
    /// Default query items are `nil`, meaning no query parameters will be included by default.
    var queryItems: [URLQueryItem]? {
        get { nil }
        set { /* no-op, override if needed */ }
    }
    
    /// Default body is `nil`, meaning no body data will be included by default.
    var body: Body? {
        get { nil }
        set { /* no-op, override if needed */ }
    }
    
    /// Constructs the full URL for the request, combining the `baseURL`, `path`, and `queryItems`.
    /// - Returns: A complete `URL` object for the request.
    var url: URL {
        var fullURL = baseURL

        if let path = path {
            fullURL = fullURL.appendingPathComponent(path)
        }
        
        guard let queryItems, !queryItems.isEmpty else {
            return fullURL
        }
        
        var components = URLComponents(url: fullURL, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        guard let urlWithQuery = components?.url else {
            preconditionFailure("Invalid URL components: \(String(describing: components))")
        }
        return urlWithQuery
    }
    

    /// Creates a `URLRequest` object configured with the endpoint's details.
    /// - Parameter encoder: A `JSONEncoder` for encoding the request body if one is present.
    /// - Returns: A configured `URLRequest` object.
    func urlRequest(using encoder: JSONEncoder? = nil) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers?.toDictionary()
        
        if let body = body,
            let encoder = encoder {
            request.httpBody = try encoder.encode(body)
        }
        
        return request
    }
}


//  MARK: - Private API

private extension Endpoint {
    
    private var baseComponents: URLComponents? {
        path.map {
            URLComponents(
                url: baseURL.appendingPathComponent($0),
                resolvingAgainstBaseURL: true
            )
        } ?? URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
    }
}



//  MARK: - Array Extension Helper

private extension Array where Element == HTTPHeader {

    func toDictionary() -> [String: String] {
        Dictionary(
            uniqueKeysWithValues: self.map {
                ($0.name.rawValue, $0.value)
            }
        )
    }
}
