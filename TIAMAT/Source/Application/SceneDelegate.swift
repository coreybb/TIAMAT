import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let dependencyContainer = DependencyContainer()
    private let controllerFactory = ViewControllerFactory()
    private var coordinator: Coordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        setupWindow(windowScene: windowScene)
    }

    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}


//  MARK: - Private API

private extension SceneDelegate {
    
    private func setupWindow(windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        window!.rootViewController = rootController()
        window!.makeKeyAndVisible()
    }
    
    
    private func rootController() -> UIViewController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        
        coordinator = AppCoordinator(
            navigationController: navigationController,
            dependencyContainer: dependencyContainer,
            controllerFactory: controllerFactory
        )
        coordinator?.start()
        
        return navigationController
    }
}
