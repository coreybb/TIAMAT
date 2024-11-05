import UIKit
import Combine


final class ContentCollectionCell: UICollectionViewCell {

    //  MARK: - Internal Properties
    
    static let reuseID: String = "CONTENT_COLLECTION_VIEW_CELL"
    
    
    //  MARK: - Private Properties
    
    private let shadowView = ShadowView()
    private let cellView = ContentCellView()
    private var imageSubscription: AnyCancellable?
    private var viewModel: ContentCellViewModel?

    
    //  MARK: - Cell Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelImageLoading()
        resetUI()
    }
    
    
    //  MARK: - Internal API
    
    func configure(with viewModel: ContentCellViewModel) {
        self.viewModel = viewModel
        cellView.nameLabel.text = viewModel.name
        cellView.genreLabel.text = viewModel.genre
        subscribeToImageUpdates(viewModel)
        loadImageIfNeeded()
    }
    
    
    func loadImageIfNeeded() {
        viewModel?.loadImageIfNeeded()
    }
    
    
    func cancelImageLoading() {
        viewModel?.cancelImageLoad()
        imageSubscription?.cancel()
        imageSubscription = nil
    }
    
    
    //  MARK: - Private API
    
    private func subscribeToImageUpdates(_ viewModel: ContentCellViewModel) {
        imageSubscription = viewModel.$image
            .receive(on: DispatchQueue.main)
            .sink
        { [weak self] image in
            self?.handle(image)
        }
    }
    
    
    private func handle(_ image: UIImage?) {
        cellView.imageView.image = image ?? cellView.defaultImage
    }
    
    
    private func resetUI() {
        cellView.nameLabel.text = nil
        cellView.genreLabel.text = nil
        cellView.imageView.image = cellView.defaultImage
    }
    

    private func layoutUI() {
        layoutShadowView()
        layoutContentView()
    }
    
    
    private func layoutShadowView() {
        contentView.addSubview(shadowView)
        shadowView.fillSuperview()
    }
    
    
    private func layoutContentView() {
        shadowView.addSubview(cellView)
        cellView.fillSuperview()
    }
}


//  MARK: - Shadow View

private final class ShadowView: UIView, ShadowCasting {
    
    var didLayoutSubviews = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if didLayoutSubviews { return }
        addDropShadow()
        didLayoutSubviews = true
    }
}
