import UIKit
import Combine


final class ContentItemListModalView: UIView {
    
    //  MARK: - Internal Properties
    
    let onSortTapped = PassthroughSubject<SortParameter, Never>()
    
    
    //  MARK: - Private Properties
    
    private let titleLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        label.text = "Options"
        return label
    }()
    private let sortByLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = "Sort by"
        return label
    }()
    private lazy var sortByNameButton = sortButton(.name)
    private lazy var sortByGenreButton = sortButton(.genre)
    private let lineView = LineView(orientation: .horizontal)
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
        [sortByNameButton, sortByGenreButton].forEach {
            $0.layer.cornerRadius = $0.frame.height / 2
        }
        didLayoutSubviews = true
    }
}


//  MARK: - Private API

extension ContentItemListModalView {
    
    private func layoutUI() {
        layoutTitleLabel()
        layoutSortByLabel()
        layoutSortButtons()
        layoutLineView()
    }
    
    
    private func layoutTitleLabel() {
        let topPadding: CGFloat = 20
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: topPadding),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    
    private func layoutSortByLabel() {
        let lateralPadding: CGFloat = 20
        let topPadding: CGFloat = 36
        
        addSubview(sortByLabel)
        NSLayoutConstraint.activate([
            sortByLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: lateralPadding),
            sortByLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -lateralPadding),
            sortByLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: topPadding)
        ])
    }
    
    
    private func layoutSortButtons() {
        let topPadding: CGFloat = 20
        let height: CGFloat = 48
        let spacing: CGFloat = 24
        
        addSubview(sortByNameButton)
        addSubview(sortByGenreButton)
        
        NSLayoutConstraint.activate([
            sortByNameButton.topAnchor.constraint(equalTo: sortByLabel.bottomAnchor, constant: topPadding),
            sortByNameButton.leadingAnchor.constraint(equalTo: sortByLabel.leadingAnchor),
            sortByNameButton.heightAnchor.constraint(equalToConstant: height),
            
            sortByGenreButton.topAnchor.constraint(equalTo: sortByNameButton.topAnchor),
            sortByGenreButton.leadingAnchor.constraint(equalTo: sortByNameButton.trailingAnchor, constant: spacing),
            sortByGenreButton.trailingAnchor.constraint(equalTo: sortByLabel.trailingAnchor),
            sortByGenreButton.heightAnchor.constraint(equalToConstant: height),
            sortByGenreButton.widthAnchor.constraint(equalTo: sortByNameButton.widthAnchor)
        ])
    }
    
    
    private func layoutLineView() {
        let topPadding: CGFloat = 32
        
        addSubview(lineView)
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: sortByNameButton.bottomAnchor, constant: topPadding),
            lineView.leadingAnchor.constraint(equalTo: sortByNameButton.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    
    private func sortButton(_ parameter: SortParameter) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(parameter.rawValue.capitalized, for: .normal)
        button.backgroundColor = .tertiarySystemFill
        button.clipsToBounds = false
        let action = UIAction {
            [weak self] _ in
            self?.onSortTapped.send(parameter)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }
}
