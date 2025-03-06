//
//  UserDefaults+Extensions.swift
//  NotesApp7
//
//  Created by Evgeniy Fakhretdinov on 24.06.2024.
//

import Foundation

extension UserDefaults {
    var isFirstLaunch: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasLaunchedBefore)
        }
        set {
            UserDefaults.standard.set(!newValue, forKey: UserDefaultsKeys.hasLaunchedBefore)
        }
    }
    
    var isDetailScreen: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKeys.isDetailScreen)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.isDetailScreen)
        }
    }
    
    var currentNoteId: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.currentNoteId)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.currentNoteId)
        }
    }
}


