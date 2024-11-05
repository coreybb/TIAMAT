import UIKit.UIImage
import CommonCrypto


actor DiskImageCache {
    
    private let fileManager: FileManager
    private let cacheDirectoryURL: URL
    
    
    //  MARK: - Initialization
    
    init() throws {
        self.fileManager = FileManager.default
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        self.cacheDirectoryURL = cachesDirectory[0].appendingPathComponent("IMAGE_CACHE")
        
        try fileManager.createDirectory(
            at: cacheDirectoryURL,
            withIntermediateDirectories: true
        )
    }
    
    
    // MARK: - Internal API
    
    func save(image: UIImage, fileName: String) async throws {
        guard let data = image.pngData() else {
            throw ImageError.serialization
        }
        
        try data.write(to: url(forFileName: fileName))
    }
    
    
    func getImage(fileName: String) async throws -> UIImage {
        let fileURL = url(forFileName: fileName)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            throw ImageError.imageNotFound
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            
            guard let image = UIImage(data: data) else {
                throw ImageError.deserialization
            }
            
            return image
            
        } catch {
            throw ImageError.fileReadError
        }
    }
}
    
    
//  MARK: - Private API

extension DiskImageCache {
    
    /// Generates a filesystem-safe URL for storing cached images.
    ///
    /// We use SHA256 hashing for filenames because:
    /// - It produces a fixed-length output (64 hex chars) regardless of input length
    /// - It's filesystem-safe (only contains hexadecimal chars)
    /// - It has extremely low collision probability (2^256 possible values)
    /// - It's deterministic (same input always produces same output)
    /// - It's fast to compute with hardware acceleration on modern devices
    ///
    /// - Parameter fileName: The original filename or URL to be hashed
    /// - Returns: A URL with the SHA256 hash as the filename within the cache directory
    private func url(forFileName fileName: String) -> URL {
        cacheDirectoryURL.appendingPathComponent(fileName.asSHA256)
    }
}


//  MARK: - SHA256 Extension

fileprivate extension String {
    
    /// Computes the SHA256 hash of the string and returns it as a hexadecimal string.
    /// Used to generate filesystem-safe, fixed-length filenames for caching.
    var asSHA256: String {
        let data = Data(utf8)
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return hash.map {
            String(format: "%02x", $0)
        }
        .joined()
    }
}
