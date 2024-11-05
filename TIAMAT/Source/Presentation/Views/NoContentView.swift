import UIKit

final class NoContentView: UIView {
    
    private let imageView = {
        let image = UIImage(systemName: "exclamationmark.triangle")!
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.systemRed)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    private let messageLabel = {
        let label = UILabel()
        label.text = "There's nothing to show right now."
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //  MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //  MARK: - Private API
    
    private func layoutUI() {
        layoutImageView()
        layoutLabel()
    }
    
    
    private func layoutImageView() {
        let dimension: CGFloat = 50
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: dimension),
            imageView.widthAnchor.constraint(equalToConstant: dimension),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    
    private func layoutLabel() {
        let topPadding: CGFloat = 24
        let lateralPadding: CGFloat = 20
        
        addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: topPadding),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: lateralPadding),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -lateralPadding)
        ])
    }
}
