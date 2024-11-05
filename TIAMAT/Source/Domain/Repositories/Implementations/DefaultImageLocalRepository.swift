import UIKit.UIImage

final actor DefaultImageLocalRepository: ImageLocalRepository {
    
    //  MARK: - Private Properties
    private let memoryCache = NSCache<NSString, UIImage>()
    private let diskCache: DiskImageCache?
    
    
    //  MARK: - Initialization
    init() {
        do {
            diskCache = try DiskImageCache()
        } catch {
            diskCache = nil
            print("Warning: Unable to initialize disk cache with error: \(error.localizedDescription)")
        }
    }
}


//  MARK: - Internal API

extension DefaultImageLocalRepository {
    
    func getImage(forURL url: URL) async throws -> UIImage {
        do {
            let image = try memoryCachedImage(forURL: url)
            return image
            
        } catch {
            let image = try await imageFromDiskCache(url: url)
            saveImageToMemoryCache(image, url: url)
            return image
        }
    }
    
    
    func saveImage(_ image: UIImage, forURL url: URL) async throws {
        saveImageToMemoryCache(image, url: url)
        try await saveImageToDisk(image, url: url)
    }
    
    
    func saveImageToMemoryCache(_ image: UIImage, url: URL) {
        memoryCache.setObject(image, forKey: url.absoluteString as NSString)
    }
}


//  MARK: - Private API

extension DefaultImageLocalRepository {
    
    private func saveImageToDisk(_ image: UIImage, url: URL) async throws {
        try await diskCache?.save(image: image, fileName: url.absoluteString)
    }
    
    
    private func imageFromDiskCache(url: URL) async throws -> UIImage {
        guard let diskCache = diskCache else {
            throw ImageError.imageNotFound
        }

        return try await diskCache.getImage(fileName: url.absoluteString)
    }
    
    
    private func memoryCachedImage(forURL url: URL) throws -> UIImage {
        let key = url.absoluteString as NSString
        guard let cachedImage = memoryCache.object(forKey: key) else {
            throw ImageError.imageNotFound
        }
        
        return cachedImage
    }
}
