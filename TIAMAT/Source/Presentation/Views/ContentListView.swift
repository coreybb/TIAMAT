import UIKit
import Combine

final class ContentListView: UIView {
    
    //  MARK: - Internal Properties
    
    var collectionView = ContentCollectionView()
    let onOptionsButtonTap = PassthroughSubject<Void, Never>()
    
    
    //  MARK: - Private Properties
    
    private lazy var optionsButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(
            UIImage(systemName: "slider.horizontal.3")!
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.white),
            for: .normal
        )
        button.imageView?.contentMode = .scaleToFill
        button.backgroundColor = .black
        let action: UIAction = UIAction {
            [weak self] _ in
            guard let self else { return }
            guard !(self.collectionView.visibleCells.count == 0) else { return }
            self.onOptionsButtonTap.send()
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    private var didLayoutSubviews = false
    
    
    //  MARK: - View Lifecycle
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if didLayoutSubviews { return }
        optionsButton.layer.cornerRadius = optionsButton.frame.height / 2
        didLayoutSubviews = true
    }
}



//  MARK: - Private API

extension ContentListView {
    
    private func layoutUI() {
        layoutCollectionView()
        layoutOptionsButton()
        layoutActivityIndicator()
    }
    
    
    private func layoutCollectionView() {
        addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    
    private func layoutOptionsButton() {
        let trailingPadding: CGFloat = 16
        let bottomPadding: CGFloat = 72
        let dimension: CGFloat = 64
        
        addSubview(optionsButton)
        optionsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailingPadding).isActive = true
        optionsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding).isActive = true
        optionsButton.heightAnchor.constraint(equalToConstant: dimension).isActive = true
        optionsButton.widthAnchor.constraint(equalTo: optionsButton.heightAnchor).isActive = true
    }
    
    
    private func layoutActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
    }
}
