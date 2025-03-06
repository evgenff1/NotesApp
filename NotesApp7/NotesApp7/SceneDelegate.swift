//
//  SceneDelegate.swift
//  NotesApp7
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
        
        let notesVC = NotesViewController()
        let navigationController = UINavigationController(rootViewController: notesVC)
        
        let userDefaults = UserDefaults.standard
        if userDefaults.isDetailScreen, let noteId = userDefaults.currentNoteId, let note = RealmManager.shared.fetchNoteById(noteId) {
            let detailVC = NoteDetailViewController(with: note, delegate: nil)
            navigationController.pushViewController(detailVC, animated: false)
        }
        
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
        saveCurrentNoteIfNeeded()
    }

    private func saveCurrentNoteIfNeeded() {
        guard let navController = window?.rootViewController as? UINavigationController else { return }
        let topViewController = navController.topViewController
        
        if let noteDetailVC = topViewController as? NoteDetailViewController {
            noteDetailVC.saveCurrentNote()
            UserDefaults.standard.isDetailScreen = true
            UserDefaults.standard.currentNoteId = noteDetailVC.currentNote.id
        } else {
            UserDefaults.standard.isDetailScreen = false
            UserDefaults.standard.currentNoteId = nil
        }
    }

}

