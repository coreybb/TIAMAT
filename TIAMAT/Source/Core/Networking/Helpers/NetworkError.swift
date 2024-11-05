import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError
    case noInternetConnection
    case unauthorized
    case unexpectedEmptyResponse
    case unknown
}
