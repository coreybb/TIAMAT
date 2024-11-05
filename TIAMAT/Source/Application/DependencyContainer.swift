import Foundation

final class DependencyContainer {
    
    let networkingService: NetworkingService
    let fetchImageUseCase: FetchImageUseCase
    let contentRepository: ContentItemRepository
    
    init() {
        let noCacheConfig = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: noCacheConfig)
        networkingService = NetworkingService(networkClient: session)
        
        let imageRemoteRepository = DefaultImageRemoteRepository(networkingService: networkingService)
        let imageLocalRepository = DefaultImageLocalRepository()
        fetchImageUseCase = DefaultFetchImageUseCase(
            remoteRepository: imageRemoteRepository,
            localRepository: imageLocalRepository
        )
        
        contentRepository = DefaultContentItemRemoteRepository(networkingService: networkingService)
    }
}
