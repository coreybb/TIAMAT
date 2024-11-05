import UIKit
import Combine

final class ContentCollectionViewDelegate: NSObject {

    let onCellSelection = PassthroughSubject<ContentCellViewModel, Never>()
    let onCellWillShow = PassthroughSubject<ContentCellViewModel, Never>()
    let onCellWillDisappear = PassthroughSubject<ContentCellViewModel, Never>()
    let onScroll = PassthroughSubject<UIScrollView, Never>()
}


//  MARK: - UICollectionView Delegation

extension ContentCollectionViewDelegate: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellViewModel = cellViewModel(from: collectionView, indexPath) else { return }
        onCellSelection.send(cellViewModel)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cellViewModel = cellViewModel(from: collectionView, indexPath) else { return }
        onCellWillShow.send(cellViewModel)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cellViewModel = cellViewModel(from: collectionView, indexPath) else { return }
        onCellWillDisappear.send(cellViewModel)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScroll.send(scrollView)
    }
}


//  MARK: - Private API

private extension ContentCollectionViewDelegate {
    
    private func cellViewModel(from collectionView: UICollectionView, _ indexPath: IndexPath) -> ContentCellViewModel? {
        guard let dataSource = collectionView.dataSource as? ContentCollectionDataSource,
              let cellViewModel = dataSource.itemIdentifier(for: indexPath)
        else {
            return nil
        }
        
        return cellViewModel
    }
}
