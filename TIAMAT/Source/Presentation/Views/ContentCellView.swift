import UIKit

final class ContentCellView: UIView {
    
    let nameLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let genreLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var imageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = defaultImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let defaultImage = UIImage(systemName: "photo")!
        .withRenderingMode(.alwaysOriginal)
        .withTintColor(.gray)
    
    
    //  MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 16
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //  MARK: - Private API

    private func layoutUI() {
        layoutImageView()
        layoutNameLabel()
        layoutGenreLabel()
    }
    
    
    private func layoutImageView() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6)
        ])
    }
    
    
    private func layoutNameLabel() {
        addSubview(nameLabel)
        
        let topPadding: CGFloat = 12
        let lateralPadding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: topPadding),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: lateralPadding),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -lateralPadding)
        ])
    }
    
    
    private func layoutGenreLabel() {
        addSubview(genreLabel)
        
        let topPadding: CGFloat = 8
        let lateralPadding: CGFloat = 8
        let minimumBottomPadding: CGFloat = 24
        
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: topPadding),
            genreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: lateralPadding),
            genreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -lateralPadding),
            genreLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -minimumBottomPadding)
        ])
    }
}
