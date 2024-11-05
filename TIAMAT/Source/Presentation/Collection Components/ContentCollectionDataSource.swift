import UIKit

@MainActor
final class ContentCollectionDataSource: UICollectionViewDiffableDataSource<ContentCollectionDataSource.Section, ContentCellViewModel> {
    
    enum Section { case main }
    
    
    //  MARK: - Lifecycle
    
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { collectionView, indexPath, cellViewModel in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ContentCollectionCell.reuseID,
                for: indexPath
            ) as? ContentCollectionCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: cellViewModel)
            return cell
        }
    }

    
    //  MARK: - Internal API
    
    func updateSnapshot(with cellViewModels: [ContentCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ContentCellViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cellViewModels)
        apply(snapshot, animatingDifferences: true)
    }
}



//  MARK: - Collection View Data Source Prefetching

extension ContentCollectionDataSource: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            itemIdentifier(for: $0)?.loadImageIfNeeded()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            itemIdentifier(for: $0)?.cancelImageLoad()
        }
    }
}
