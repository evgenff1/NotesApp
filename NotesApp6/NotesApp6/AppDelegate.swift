//
//  AppDelegate.swift
//  NotesApp6
//
//  Created by Evgeniy Fakhretdinov on 22.06.2024.
//

import UIKit
import CoreData
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Application Lifecycle
    
    // Этот метод вызывается после запуска приложения.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions lau7nchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Точка для настройки после запуска приложения.
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    // Этот метод вызывается при создании нового сеанса сцены.
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Используйте этот метод для выбора конфигурации для создания новой сцены.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // Этот метод вызывается при удалении пользователем сеанса сцены.
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Освободите ресурсы, специфичные для удалённых сцен.
    }

}

