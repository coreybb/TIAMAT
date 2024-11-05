import Foundation

/// Defines the group of endpoints related to content.
struct ContentEndpointGroup: EndpointGroup {
    static let baseURL = URL(string: ConfigurationConstant.apiBaseURL.value())!
}


/// Represents the main endpoint for fetching content.
struct ContentEndpoint: GroupedEndpoint {
    typealias Group = ContentEndpointGroup
    let path: String? = ContentEndpointPath.data
}


/// Represents an endpoint that returns malformed content data.
/// This endpoint is intended for testing purposes only.
struct MalformedContentEndpoint: GroupedEndpoint {
    typealias Group = ContentEndpointGroup
    let path: String? = ContentEndpointPath.malformed
}


/// Represents an endpoint that returns an empty content dataset.
/// This endpoint is intended for testing purposes only.
struct EmptyContentEndpoint: GroupedEndpoint {
    typealias Group = ContentEndpointGroup
    let path: String? = ContentEndpointPath.empty
}


/// Defines the specific paths for different content endpoints.
private struct ContentEndpointPath {
    
    /// Path for fetching valid data
    static var data: String {
        return ConfigurationConstant.contentPath.value()
    }
    
    /// Path for fetching malformed data (for testing purposes)
    static var malformed: String {
        return ConfigurationConstant.malformedContentPath.value()
    }
    
    /// Path for fetching an empty dataset (for testing purposes)
    static var empty: String {
        return ConfigurationConstant.emptyContentPath.value()
    }
}

