import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let firebaseAuth = FirebaseAuthRepository()
        let currentUser = firebaseAuth.getUserStatus()
        
        // Check if the user is logged in
        if currentUser != nil {
            // UITabBarController 로직 분리 필요
            let tabBarController = UITabBarController()

            let channelListViewController = ChannelListViewController()
            channelListViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))

            let settingsViewController = SettingsViewController()
            settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), selectedImage: UIImage(systemName: "gear.fill"))
            
            tabBarController.viewControllers = [
                UINavigationController(rootViewController: channelListViewController),
                UINavigationController(rootViewController: settingsViewController),
            ]
            window.rootViewController = tabBarController
        } else {
            // No user is signed in, show SignInViewController
            let signInViewController = SignInViewController()
            let navigationController = UINavigationController(rootViewController: signInViewController)
            window.rootViewController = navigationController
        }
        
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
    
}


