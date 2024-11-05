protocol ContentItemRepository {
    func fetchContentItems() async throws -> [ContentItem]
}


//  MARK: - Network Servicing Default Implementation

extension ContentItemRepository where Self: NetworkServicing {
    
    func fetchContentItems() async throws -> [ContentItem] {
        let endpoint = ContentEndpoint()
        let response: ContentNetworkResponse = try await networkingService.request(endpoint)
        return response.contentItems
    }
}
