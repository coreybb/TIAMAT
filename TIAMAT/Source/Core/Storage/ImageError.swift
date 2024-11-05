enum ImageError: Error {
    
    /// Indicates that the data received is not valid image data
    case invalidData
    
    /// Indicates that the requested image could not be found
    case imageNotFound
    
    /// Indicates an error occurred during the serialization process
    case serialization
    
    /// Indicates an error occurred while reading an image file
    case fileReadError
    
    /// Indicates an error occurred during the deserialization process
    case deserialization
}
