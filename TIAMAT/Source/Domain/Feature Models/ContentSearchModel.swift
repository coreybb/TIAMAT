final class ContentSearchModel {
    
    //  MARK: - Internal Properties
    
    private(set) var filteredItems = [ContentItem]()
    private(set) var currentQuery = ""
    
    
    //  MARK: - Private Properties
    
    private var items = [ContentItem]()
    
    
    //  MARK: - Initialization
    
    init(items: [ContentItem]) {
        self.items = items
        self.filteredItems = items
    }
    
    
    //  MARK: - Internal API
    
    func search(with query: String) {
        currentQuery = query
        guard !currentQuery.isEmpty else {
            filteredItems = items
            return
        }
        
        filteredItems = items.filter {
            $0.name.lowercased().contains(currentQuery.lowercased())
            ||
            $0.genre.rawValue.lowercased().contains(currentQuery.lowercased())
        }
    }
    
    
    func updateContent(_ newItems: [ContentItem]) {
        items = newItems
        search(with: currentQuery)
    }
}
