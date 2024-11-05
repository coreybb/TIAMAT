import Foundation

protocol NetworkDataTransporting: Sendable {
    func sendRequest(_ request: URLRequest) async throws -> (Data, URLResponse)
}


/// A protocol that all client networking components must conform to. It ensures that a network client is available for performing network operations.
protocol ClientNetworking {
    var networkClient: NetworkDataTransporting { get }
}


//  MARK: - URLSession Extension + Default Implementation

///  This extension makes URLSession conform to the NetworkDataTransporting protocol.
///  Its purpose is to abstracts the networking layer as an abstraction for testing and flexible implementation.
extension URLSession: NetworkDataTransporting {
    
    func sendRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request)
    }
}
