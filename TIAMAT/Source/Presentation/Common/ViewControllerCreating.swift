import UIKit

protocol ViewControllerCreating {
    func makeContentListController(container: DependencyContainer, coordinator: ContentListCoordinating) -> ContentListController
    func makeContentListModalController(onSortTapped: @escaping (SortParameter) -> Void) -> ContentListModalController
}


extension ViewControllerCreating {
    
    func makeContentListController(
        container: DependencyContainer,
        coordinator: ContentListCoordinating
    ) -> ContentListController {
        let controller = ContentListController(container: container)
        controller.coordinator = coordinator
        return controller
    }
    
    
    func makeContentListModalController(onSortTapped: @escaping (SortParameter) -> Void) -> ContentListModalController {
        let controller = ContentListModalController()
        if let presentationController = controller.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        controller.onSortTapped = onSortTapped
        controller.view.layer.cornerRadius = 24
        return controller
    }
}
