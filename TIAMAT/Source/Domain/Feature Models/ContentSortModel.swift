final class ContentSortModel {
    
    //  MARK: - Internal Properties
    private(set) var sortedItems = [ContentItem]()
    private(set) var currentParameter: SortParameter?
    
    
    //  MARK: - Private Properties
    
    private var items = [ContentItem]()
    
    
    //  MARK: - Initialization
    
    init(items: [ContentItem]) {
        self.items = items
        self.sortedItems = items
    }
    
    
    //  MARK: - Internal API
    
    func sort(by parameter: SortParameter) {
        currentParameter = parameter
        sortedItems = items.sorted { first, second in
            switch parameter {
            case .name:
                let space: String = " "
                let emptyString: String = ""
                let nameA = first.name.components(separatedBy: space).first ?? emptyString
                let nameB = second.name.components(separatedBy: space).first ?? emptyString
                return nameA.localizedCaseInsensitiveCompare(nameB) == .orderedAscending
            case .genre:
                return first.genre.rawValue.localizedCaseInsensitiveCompare(second.genre.rawValue) == .orderedAscending
            }
        }
    }
    
    
    func updateContent(_ newItems: [ContentItem]) {
        items = newItems
        if let parameter = currentParameter {
            sort(by: parameter)
        }
    }
}
