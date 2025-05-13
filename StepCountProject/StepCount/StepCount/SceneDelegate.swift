// Project Name: StepCount
// Team Member 1: Chirag Dodia (cpdodia@iu.edu)
// Team Member 2: Shreyas Jadhav (shrejadh@iu.edu)
// Date: 05/06/2025

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard (scene as? UIWindowScene) != nil else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Handle scene disconnection
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Restart any tasks that were paused
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Handle scene moving to inactive state
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Undo changes made on entering the background
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save data and release shared resources
    }
}
