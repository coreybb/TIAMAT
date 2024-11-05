import UIKit
import Combine

final class ContentCellViewModel {
    
    //  MARK: - Internal Properties
    
    let item: ContentItem
    var name: String { item.name }
    var genre: String { item.genre.rawValue }
    @Published private(set) var image: UIImage?
    
    
    //  MARK: - Private Properties
    
    private var imageURL: URL? { URL(string: item.photoURLSmall) }
    private let fetchImageUseCase: FetchImageUseCase
    private var imageLoadingTask: Task<Void, Never>?
    private var imageLoadDidFail = false
    private var id: String { item.id }
    
    
    //  MARK: - Initialization
    
    init(item: ContentItem, fetchImageUseCase: FetchImageUseCase) {
        self.item = item
        self.fetchImageUseCase = fetchImageUseCase
    }
    
    
    //  MARK: - Internal API
    
    func loadImageIfNeeded() {
        guard image == nil,
              let imageURL,
              !imageLoadDidFail else {
            return
        }

        imageLoadingTask = Task {
            do {
                let loadedImage = try await fetchImageUseCase.execute(forURL: imageURL)
                await MainActor.run {
                    self.image = loadedImage
                }
            } catch {
                imageLoadDidFail = true
                print("Failed to load image at \(String(describing: imageURL)) with error: \(error.localizedDescription)")
            }
        }
    }
    
    
    func cancelImageLoad() {
        imageLoadingTask?.cancel()
    }
}


//  MARK: - Hashable Conformance

extension ContentCellViewModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ContentCellViewModel, rhs: ContentCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
