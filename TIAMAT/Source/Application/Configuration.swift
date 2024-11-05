import Foundation

/// Represents configuration constants used throughout the application.
/// These constants can be configured either through User-Defined build settings or xcconfig files,
/// keeping sensitive values and environment-specific URLs out of the codebase.
///
/// Configuration Priority:
/// 1. User-Defined build settings (highest priority, overrides everything)
/// 2. xcconfig files (if no User-Defined value is set)
///
/// For Interview Projects:
/// You'll typically need different API endpoints for various test scenarios.
/// Here are two approaches:
///
/// Option 1 - Using User-Defined Build Settings (Quick Testing):
/// 1. In Build Settings, add under "User-Defined":
///    API_BASE_URL = https://api.example.com/test-data.json
///    This value will override any xcconfig values.
///
/// Option 2 - Using xcconfig Files (Multiple Test Scenarios):
/// 1. Create xcconfig files:
///    ```
///    // GoodData.xcconfig
///    API_BASE_URL = https://api.example.com/good-data.json
///
///    // MalformedData.xcconfig
///    API_BASE_URL = https://api.example.com/malformed-data.json
///
///    // EmptyData.xcconfig
///    API_BASE_URL = https://api.example.com/empty-data.json
///    ```
///
/// 2. In Build Settings:
///    - Leave API_BASE_URL empty to use xcconfig values, OR
///    - Set API_BASE_URL = $(API_BASE_URL) to use xcconfig values
///
/// 3. Create different schemes in Xcode, each using a different xcconfig file
///
/// In both cases, reference the value in Info.plist:
/// ```xml
/// <key>API_BASE_URL</key>
/// <string>${API_BASE_URL}</string>
/// ```
///
/// Example Usage:
/// ```
/// // Access configuration values directly:
/// let baseURLString = ConfigurationConstant.apiBaseURL.value()
///
/// // Use in URL construction:
/// let baseURL = URL(string: ConfigurationConstant.apiBaseURL.value())!
///
/// // Use with specific bundle (e.g., for testing):
/// let testURLString = ConfigurationConstant.apiBaseURL.value(in: testBundle)
/// ```
enum ConfigurationConstant {
    
    /// The base URL for API requests.
    case apiBaseURL
    
    /// The endpoint path for a content response from the API.
    case contentPath
    
    /// The endpoint path for an empty content response from the API.
    case emptyContentPath
    
    /// The endpoint path for a malformed content response from the API.
    case malformedContentPath
}


extension ConfigurationConstant {
    
    /// The Info.plist key for this configuration constant.
    /// Must match the key name used in:
    /// - User-Defined build settings, OR
    /// - xcconfig files
    var key: String {
        switch self {
        case .apiBaseURL:
            "API_BASE_URL"
        case .contentPath:
            "CONTENT_PATH"
        case .emptyContentPath:
            "EMPTY_CONTENT_PATH"
        case .malformedContentPath:
            "MALFORMED_CONTENT_PATH"
        }
    }

    /// Retrieves the configuration value from the specified bundle.
    /// - Parameter bundle: The bundle containing Info.plist. Defaults to main bundle.
    /// - Returns: The configured value for this constant.
    /// - Note: In DEBUG builds, missing values trigger a fatal error.
    ///         In RELEASE builds, missing values return an empty string.
    func value(in bundle: Bundle = .main) -> String {
        guard let value: String = try? Configuration.value(for: key, in: bundle) else {
            #if DEBUG
            fatalError("\(key) is not set in the project's info.plist.")
            #else
            return ""
            #endif
        }
        return value
    }
}

/// Protocol for retrieving typed configuration values from a bundle.
protocol ConfigurationValueProviding {
    /// Retrieves a typed value from the bundle's Info.plist.
    /// - Parameters:
    ///   - key: The key to look up
    ///   - bundle: The bundle containing Info.plist
    /// - Returns: The value converted to the specified type
    /// - Throws: Configuration.Error if the key is missing or value can't be converted
    static func value<T>(for key: String, in bundle: BundleProtocol) throws -> T where T: LosslessStringConvertible
}

/// Handles the retrieval and conversion of configuration values.
/// See configuration priority and setup instructions in ConfigurationConstant documentation.
enum Configuration {
    /// Errors that can occur when retrieving configuration values
    enum Error: Swift.Error {
        /// The specified key wasn't found in Info.plist
        case missingKey
        /// The value couldn't be converted to the requested type
        case invalidValue
    }
}

extension Configuration: ConfigurationValueProviding {
    /// Implements ConfigurationValueProviding to retrieve and convert values.
    /// - Parameters:
    ///   - key: The key to look up in Info.plist
    ///   - bundle: The bundle containing Info.plist
    /// - Returns: The value converted to the specified type
    /// - Throws:
    ///   - Error.missingKey if the key isn't found
    ///   - Error.invalidValue if type conversion fails
    static func value<T>(for key: String, in bundle: BundleProtocol) throws -> T where T: LosslessStringConvertible {
        guard let object: Any = bundle.object(forInfoDictionaryKey: key) else {
            throw Error.missingKey
        }
        
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

/// Protocol allowing Bundle functionality to be mocked for testing.
protocol BundleProtocol {
    /// Retrieves a value from the bundle's Info.plist.
    /// - Parameter key: The key to look up
    /// - Returns: The value if found, nil otherwise
    func object(forInfoDictionaryKey key: String) -> Any?
}

extension Bundle: BundleProtocol { }
