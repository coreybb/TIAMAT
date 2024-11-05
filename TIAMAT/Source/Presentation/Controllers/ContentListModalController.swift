import UIKit
import Combine

final class ContentListModalController: UIViewController {
    
    //  MARK: - Internal Properties
    
    let mainView = ContentItemListModalView()
    var onSortTapped: ((SortParameter) -> Void)?
    var cancellables = Set<AnyCancellable>()
    
    
    //  MARK: - View Lifecycle
    override func loadView() {
        view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
}


//  MARK: - Bindable

extension ContentListModalController: Bindable {
    
    private func setupBindings() {
        subscribe(mainView.onSortTapped) { [weak self] parameter in
            self?.onSortTapped?(parameter)
        }
    }
}
