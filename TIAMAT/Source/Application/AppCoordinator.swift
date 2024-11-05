import UIKit

protocol ContentListCoordinating: AnyObject {
    func showContentItemDetail(for contentItem: ContentItem)
    func showOptionsModal(from viewController: UIViewController, onSortTapped: @escaping (SortParameter) -> Void)
}


final class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let dependencyContainer: DependencyContainer
    private let controllerFactory: ViewControllerFactory
    
    
    //  MARK: - Initialization
    
    init(
        navigationController: UINavigationController,
        dependencyContainer: DependencyContainer,
        controllerFactory: ViewControllerFactory
    ) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
        self.controllerFactory = controllerFactory
    }
    
    
    //  MARK: - Internal API
    
    func start() {
        showContentList()
    }
    
    
    func showContentList() {
        push(
            controllerFactory.makeContentListController(
                container: dependencyContainer,
                coordinator: self
            )
        )
    }
    
    
    private func push(_ controller: UIViewController) {
        navigationController.pushViewController(controller, animated: false)
    }
}



//  MARK: - Content List Coordinating

extension AppCoordinator: ContentListCoordinating {
    
    func showContentItemDetail(for contentItem: ContentItem) {
        
    }
    
    
    func showOptionsModal(from viewController: UIViewController, onSortTapped: @escaping (SortParameter) -> Void) {
        let controller = controllerFactory.makeContentListModalController(onSortTapped: onSortTapped)
        viewController.present(controller, animated: true)
    }
}
