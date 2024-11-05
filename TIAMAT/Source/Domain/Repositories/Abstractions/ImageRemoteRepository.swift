import UIKit

protocol ImageRemoteRepository: ImageRepository {
    func getImage(forURL url: URL) async throws -> UIImage
}


extension ImageRemoteRepository where Self: NetworkServicing {
    
    func getImage(forURL url: URL) async throws -> UIImage {
        let data = try await networkingService.requestData(DynamicEndpoint(url))
        guard let image = UIImage(data: data) else {
            throw ImageError.invalidData
        }
        return image
    }
}
