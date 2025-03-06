//
//  SceneDelegate.swift
//  NotesApp5
//
//  Created by Evgeniy Fakhretdinov on 22.06.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // MARK: - Scene Lifecycle
    
    // Этот метод вызывается при подключении сцены.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let viewController = NotesViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
    
    // Этот метод вызывается при отключении сцены.
    func sceneDidDisconnect(_ scene: UIScene) {
        // Освобождение ресурсов сцены.
    }

    // Этот метод вызывается при активации сцены.
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Перезапуск задач, приостановленных при деактивации сцены.
    }

    // Этот метод вызывается при деактивации сцены.
    func sceneWillResignActive(_ scene: UIScene) {
        // Приостановка задач при временных прерываниях.
    }

    // Этот метод вызывается при переходе сцены в передний план.
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Восстановление изменений, сделанных при переходе сцены в фон.
    }

    // Этот метод вызывается при переходе сцены в фон.
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Сохранение данных при переходе приложения в фон.
        CoreDataManager.shared.saveContext()
    }


}

