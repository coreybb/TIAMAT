import UIKit
import Combine

final class ContentListController: UIViewController {
    
    //  MARK: - Internal Properties
    
    weak var coordinator: ContentListCoordinating?
    var cancellables = Set<AnyCancellable>()
    
    
    //  MARK: - Private Properties
    
    private lazy var searchController = ContentSearchController()
    private let mainView = ContentListView()
    private let viewModel: ContentListViewModel
    private lazy var collectionDataSource = ContentCollectionDataSource(
        collectionView: mainView.collectionView
    )
    private let collectionDelegate = ContentCollectionViewDelegate()
    
    
    //  MARK: - View Lifecycle
    
    init(container: DependencyContainer) {
        self.viewModel = ContentListViewModel(
            repository: container.contentRepository,
            fetchImageUseCase: container.fetchImageUseCase
        )
        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        view = mainView
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupView()
        viewModel.streamContent()
    }
}


//  MARK: - Private API

private extension ContentListController {
    
    private func setupBindings() {
        setupViewModelStateBinding()
        setupCollectionViewBindings()
        setupInteractionBindings()
    }
    
    
    private func setupView() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        mainView.collectionView.delegate = collectionDelegate
        mainView.collectionView.dataSource = collectionDataSource
        mainView.collectionView.prefetchDataSource = collectionDataSource
    }
    
    
    private func updateLoadingState(_ isLoading: Bool) {
        if isLoading {
            mainView.activityIndicator.startAnimating()
        } else {
            mainView.activityIndicator.stopAnimating()
            mainView.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    
    private func updateCollectionView(with content: [ContentCellViewModel]?) {
        guard let content else { return }
        collectionDataSource.updateSnapshot(with: content)
        mainView.collectionView.backgroundView = content.isEmpty ? NoContentView() : nil
    }
}


//  MARK: - Bindable

extension ContentListController: Bindable, ErrorAlertPresenting {
    
    private func setupViewModelStateBinding() {
        subscribe(viewModel.$state) { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .idle:
                updateLoadingState(false)
            case .loading:
                updateLoadingState(true)
            case .error:
                updateLoadingState(false)
                presentErrorAlert()
            }
            
            updateCollectionView(with: viewModel.currentContent)
        }
    }

    
    private func setupCollectionViewBindings() {
        subscribe(collectionDelegate.onCellSelection) { [weak self] cellViewModel in
            self?.coordinator?.showContentItemDetail(for: cellViewModel.item)
        }

        subscribe(collectionDelegate.onCellWillShow) { cellViewModel in
            cellViewModel.loadImageIfNeeded()
        }

        subscribe(collectionDelegate.onCellWillDisappear) { cellViewModel in
            cellViewModel.cancelImageLoad()
        }
        
        subscribe(collectionDelegate.onScroll) { [weak self] scrollView in
            guard let self else { return }
            guard scrollView.contentOffset.y > 100,
                  searchController.searchBar.isFirstResponder
            else { return }
            
            searchController.searchBar.resignFirstResponder()
        }
    }

    
    private func setupInteractionBindings() {
        subscribe(mainView.onOptionsButtonTap) { [weak self] in
            guard let self else { return }
            coordinator?.showOptionsModal(from: self) { parameter in
                self.viewModel.sortContent(by: parameter)
            }
        }

        subscribe(mainView.collectionView.didPullToRefresh) { [weak self] in
            self?.viewModel.refreshContent()
        }
    }
}


//  MARK: - UISearchController Delegate

extension ContentListController: UISearchControllerDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.searchContent(for: searchText)
    }
}
