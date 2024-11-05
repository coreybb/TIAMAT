import Foundation

/// An endpoint that can be constructed dynamically at runtime.
struct DynamicEndpoint: Endpoint {
    
    let baseURL: URL

    init(_ url: URL) {
        self.baseURL = url
    }
}

