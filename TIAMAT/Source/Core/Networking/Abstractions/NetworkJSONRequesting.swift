import Foundation

/// Represents an empty response from an API call.
struct EmptyResponse: Decodable {}


// MARK: - Network JSON Requesting

/// A protocol for handling network requests. It includes the necessary encoder and decoder for encoding requests and decoding responses.
protocol NetworkJSONRequesting: NetworkDataRequesting, JSONCoding {
    
    /// Makes a network request to the specified endpoint and decodes the response into the specified response object type.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to which the request will be made..
    /// - Returns: A response object that conforms to `Decodable`.
    /// - Throws: Throws an error if the request fails or if decoding the response fails.
    func request<ResponseObject: Decodable>(_ endpoint: any Endpoint) async throws -> ResponseObject
}


extension NetworkJSONRequesting {
    
    func request<ResponseObject: Decodable>(_ endpoint: any Endpoint) async throws -> ResponseObject {
        try await requestData(endpoint).decode(using: decoder)
    }
}


//  MARK: - Network Data Requesting

protocol NetworkDataRequesting where Self: ClientNetworking {
    
    /// Makes a network request to the specified endpoint and returns the raw data from the from the response.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to which the request will be made..
    /// - Returns: A response object that conforms to `Decodable`.
    /// - Throws: Throws an error if the request fails or if decoding the response fails.
    func requestData(_ endpoint: any Endpoint) async throws -> Data
}


extension NetworkDataRequesting {
    
    func requestData(_ endpoint: any Endpoint) async throws -> Data {
        try await prepareAndSendRequest(endpoint)
    }
}


fileprivate extension NetworkDataRequesting {
    
    func prepareAndSendRequest(_ endpoint: any Endpoint) async throws -> Data {
        let request = try endpoint.urlRequest()
        let (data, response) = try await networkClient.sendRequest(request)
        try response.validate()
        return data
    }
}


//  MARK: - Private Helper Extensions

fileprivate extension Data {
    
    /// Decodes the data into a specified `Decodable` type.
    ///
    /// - Parameter decoder: The `JSONDecoder` to use for decoding.
    /// - Returns: An instance of the specified `Decodable` type.
    /// - Throws: A `NetworkError` if the data is empty and the expected type is not `EmptyResponse`,
    ///           or a decoding error if the data cannot be decoded into the specified type.
    func decode<T: Decodable>(using decoder: JSONDecoder) throws -> T {
        if self.isEmpty {
            if T.self == EmptyResponse.self {
                return EmptyResponse() as! T
            } else {
                throw NetworkError.unexpectedEmptyResponse
            }
        } else {
            return try decoder.decode(T.self, from: self)
        }
    }
}


private extension URLResponse {
    
    /// Checks if the HTTP response status code is in the 200-299 range.
    ///
    /// - Throws: A `NetworkError` if the response is not an HTTP response or if the status code is not in the 200-299 range.
    func validate() throws {
        guard let httpResponse = self as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode.isOK else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
    }
}


private typealias StatusCode = Int


private extension StatusCode {
    var isOK: Bool {
        (200...299).contains(self)
    }
}
