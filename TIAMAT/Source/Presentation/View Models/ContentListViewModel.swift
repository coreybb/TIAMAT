import Foundation
import Combine

final class ContentListViewModel: ViewStatePresenting {
    
    //  MARK: - Internal Properties
    
    @Published var state = ViewState<[ContentCellViewModel]>.idle([])
    let title = "Home"
    
    
    //  MARK: - Private Properties
    
    private let repository: ContentItemRepository
    private let fetchImageUseCase: FetchImageUseCase
    private let model: ContentListModel
    private var fetchTask: Task<Void, Never>?
    var cellViewModels = [ContentCellViewModel]()
    var cancellables = Set<AnyCancellable>()
    
    
    //  MARK: - Initialization
    
    init(repository: ContentItemRepository,
         fetchImageUseCase: FetchImageUseCase,
         featureModel: ContentListModel = ContentListModel()
    ) {
        self.repository = repository
        self.fetchImageUseCase = fetchImageUseCase
        self.model = featureModel
        setupBindings()
    }
}


//  MARK: - Bindable

extension ContentListViewModel: Bindable {
    
    private func setupBindings() {
        subscribe(model.onDisplayedContentUpdation) { [weak self] items in
            self?.updateDisplayedContent(items)
        }
    }
}


//  MARK: - Internal API

extension ContentListViewModel {
    
    func streamContent() {
        cancelFetch()
        fetchTask = Task { await fetchAndUpdateContent() }
    }
    
    
    func refreshContent() {
        model.updateContent([])
        streamContent()
    }
    
    
    func cancelFetch() {
        fetchTask?.cancel()
        fetchTask = nil
    }
    
    
    func searchContent(for query: String) {
        model.search(query: query)
    }
    
    
    func sortContent(by parameter: SortParameter) {
        model.sort(by: parameter)
    }
}


//  MARK: - Private API

private extension ContentListViewModel {

    private func updateDisplayedContent(_ items: [ContentItem]) {
        let viewModels = items.map {
            ContentCellViewModel(
                item: $0,
                fetchImageUseCase: fetchImageUseCase
            )
        }
        
        state = .idle(viewModels)
    }
    
    
    private func fetchAndUpdateContent() async {
        let previousViewModels = currentContent ?? []
        
        await updateState(to: .loading(previous: previousViewModels))
        
        do {
            let contentItems = try await repository.fetchContentItems()
            
            if !Task.isCancelled {
                updateContentIfNotCancelled(contentItems)
            }
        } catch {
            if !Task.isCancelled {
                print("Content data fetch operation failed with error: \(error)")
                await updateState(to: .error(error, previous: previousViewModels))
            }
        }
    }

    
    private func updateContentIfNotCancelled(_ items: [ContentItem]) {
        model.updateContent(items)
    }
}
