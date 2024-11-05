import UIKit.UIImage

protocol ImageLocalRepository: ImageRepository {
    func getImage(forURL url: URL) async throws -> UIImage
    func saveImage(_ image: UIImage, forURL url: URL) async throws
}
