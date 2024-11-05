import Foundation


/// An actor that provides basic networking capabilities.
actor NetworkingService: NetworkJSONRequesting {

    /// The network client responsible for sending requests (e.g., `URLSession`).
    let networkClient: any NetworkDataTransporting
    
    /// The JSON encoder used for encoding request bodies.
    let encoder: JSONEncoder
    
    /// The JSON decoder used for decoding response bodies.
    let decoder: JSONDecoder
    
    
    /// Initializes a new instance of `NetworkingService`.
    ///
    /// - Parameters:
    ///   - networkClient: The network client used to send requests.
    ///   - encoder: A JSON encoder for encoding request bodies. Defaults to a new `JSONEncoder`.
    ///   - decoder: A JSON decoder for decoding response bodies. Defaults to a new `JSONDecoder`.
    init(
        networkClient: any NetworkDataTransporting,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.networkClient = networkClient
        self.encoder = encoder
        self.decoder = decoder
    }
}
