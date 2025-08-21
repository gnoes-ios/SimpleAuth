import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let diContainer = DIContainer(
            context: CoreDataStack.shared.backgroundContext,
            userDefaults: .standard
        )
        let vm = diContainer.makeStartViewModel()
        let vc = StartViewController(viewModel: vm, diContainer: diContainer)
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
    }
}

