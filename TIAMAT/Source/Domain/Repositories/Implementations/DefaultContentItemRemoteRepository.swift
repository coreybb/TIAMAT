final actor DefaultContentItemRemoteRepository: ContentItemRepository, NetworkServicing {
    let networkingService: NetworkingService
    
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }
}
