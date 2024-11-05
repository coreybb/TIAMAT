struct ContentNetworkResponse {
    let contentItems: [ContentItem]
}


extension ContentNetworkResponse: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case contentItems = "recipes"
    }
}
