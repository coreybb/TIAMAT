final actor DefaultImageRemoteRepository: ImageRemoteRepository, NetworkServicing {
    let networkingService: NetworkingService
    
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }
}
