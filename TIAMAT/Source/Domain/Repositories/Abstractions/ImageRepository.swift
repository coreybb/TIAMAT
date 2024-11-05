import UIKit.UIImage

protocol ImageRepository {
    
/// Asynchronously fetches an image from a given URL.
///
/// - Parameter url: The URL of the image to fetch.
/// - Returns: A UIImage object representing the fetched image.
/// - Throws: An error if the image cannot be fetched or processed.
    func getImage(forURL url: URL) async throws -> UIImage
}
