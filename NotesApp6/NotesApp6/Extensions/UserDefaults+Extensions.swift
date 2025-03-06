//
//  UserDefaults+Extensions.swift
//  NotesApp6
//
//  Created by Evgeniy Fakhretdinov on 24.06.2024.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let hasLaunchedBefore = "hasLaunchedBefore"
    }
    
    var isFirstLaunch: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: Keys.hasLaunchedBefore)
        }
        set {
            UserDefaults.standard.set(!newValue, forKey: Keys.hasLaunchedBefore)
        }
    }
}

