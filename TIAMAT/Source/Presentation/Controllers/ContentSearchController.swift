import UIKit

final class ContentSearchController: UISearchController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        obscuresBackgroundDuringPresentation = false
        searchBar.placeholder = "Search"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
