import UIKit
import Combine

final class ContentCollectionView: UICollectionView {
    
    //  MARK: - Internal Properties
    
    let didPullToRefresh = PassthroughSubject<Void, Never>()
    
    
    //  MARK: - Private Properties
    
    private let impactGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

    
    //  MARK: - Initialization
    
    init() {
        super.init(
            frame: .zero,
            collectionViewLayout: ContentCollectionViewLayout()
        )
        
        register(
            ContentCollectionCell.self,
            forCellWithReuseIdentifier: ContentCollectionCell.reuseID
        )
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(
            self,
            action: #selector(beginRefreshing(_:)),
            for: .valueChanged
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //  MARK: - Private API
    
    @objc
    private func beginRefreshing(_ sender: Any) {
        impactGenerator.impactOccurred()
        didPullToRefresh.send()
    }
}
