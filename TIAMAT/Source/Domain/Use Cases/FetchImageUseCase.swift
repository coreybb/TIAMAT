import UIKit.UIImage


protocol FetchImageUseCase {
    
    /// Retrieves an image from either the local cache or the web, and ensures it's cached for future use.
    func execute(forURL url: URL) async throws -> UIImage
}


final actor DefaultFetchImageUseCase: FetchImageUseCase {
    
    //  MARK: - Private Properties
    
    private let remoteRepository: ImageRemoteRepository
    private let localRepository: ImageLocalRepository
    
    
    //  MARK: - Initialization
    
    init(
        remoteRepository: ImageRemoteRepository,
        localRepository: ImageLocalRepository
    ) {
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
    }
    
    
    //  MARK: - Internal API
    
    func execute(forURL url: URL) async throws -> UIImage {
        do {
            return try await localRepository.getImage(forURL: url)
            
        } catch {
            let image = try await remoteRepository.getImage(forURL: url)
            try await localRepository.saveImage(image, forURL: url)
            return image
        }
    }
}
