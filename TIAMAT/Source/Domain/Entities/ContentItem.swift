import Foundation

struct ContentItem: Hashable {
    let genre: Genre
    let name: String
    let photoURLLarge: String
    let photoURLSmall: String
    let sourceURL: String?
    let id: String
    let youtubeURL: String?
}


//  MARK: - Custom Deserialization

extension ContentItem: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case genre = "cuisine"
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case id = "uuid"
        case youtubeURL = "youtube_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // The 'name' field may contain malformed Unicode characters due to encoding issues.
        // See: "mojibake" (https://en.wikipedia.org/wiki/Mojibake).
        // Examples include "CrÃ¨me BrÃ»lÃ©e" instead of "Crème Brûlée" or "NaleÅ›niki" instead of "Naleśniki".

        // Fix:
        // 1. Decode the raw string
        // 2. Attempt to re-encode using ISO-8859-1 (Latin1) and ISO-8859-2 (Latin2), then decode as UTF-8
        // 3. Apply specific character replacements for Polish characters if needed
        // 4. Use the fixed version only if it's different from the original
        let rawName = try container.decode(String.self, forKey: .name)
        let convertedName = [.isoLatin1, .isoLatin2]
            .lazy
            .compactMap { rawName.data(using: $0) }
            .compactMap { String(data: $0, encoding: .utf8) }
            .first ?? rawName

        let fixedName = convertedName.replacingOccurrences(of: "Å›", with: "ś")
        name = (fixedName != rawName) ? fixedName : rawName
        
        // Otherwise decode as normal
        genre = try container.decode(Genre.self, forKey: .genre)
        photoURLLarge = try container.decode(String.self, forKey: .photoURLLarge)
        photoURLSmall = try container.decode(String.self, forKey: .photoURLSmall)
        sourceURL = try container.decodeIfPresent(String.self, forKey: .sourceURL)
        id = try container.decode(String.self, forKey: .id)
        youtubeURL = try container.decodeIfPresent(String.self, forKey: .youtubeURL)
    }
}
