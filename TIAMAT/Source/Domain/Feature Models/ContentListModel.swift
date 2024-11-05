import Combine

final class ContentListModel {
    
    //  MARK: - Internal Properties
    
    private(set) var onDisplayedContentUpdation = PassthroughSubject<[ContentItem], Never>()
    
    
    //  MARK: - Private Properties
    
    private let searchModel: ContentSearchModel
    private let sortModel: ContentSortModel
    private var items = [ContentItem]()
    private var displayedItems: [ContentItem] = []
    
    
    //  MARK: - Initialization
    
    init() {
        searchModel = ContentSearchModel(items: [])
        sortModel = ContentSortModel(items: [])
    }
}


//  MARK: - Internal API

extension ContentListModel {
    
    func updateContent(_ newItems: [ContentItem]) {
        items = newItems
        searchModel.updateContent(newItems)
        sortModel.updateContent(newItems)
        updateDisplayedContent()
    }
    
    
    func search(query: String) {
        searchModel.search(with: query)
        updateDisplayedContent()
    }
    
    
    func sort(by parameter: SortParameter) {
        sortModel.sort(by: parameter)
        updateDisplayedContent()
    }
}


//  MARK: - Private API

private extension ContentListModel {
    
    private func updateDisplayedContent() {
        var currentItems = items
        
        if !searchModel.currentQuery.isEmpty {
            currentItems = searchModel.filteredItems
        }
        
        if sortModel.currentParameter != nil {
            sortModel.updateContent(currentItems)
            currentItems = sortModel.sortedItems
        }
        
        displayedItems = currentItems
        onDisplayedContentUpdation.send(displayedItems)
    }
}
