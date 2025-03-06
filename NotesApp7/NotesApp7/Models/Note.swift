//
//  Note.swift
//  NotesApp7
//
//  Created by Evgeniy Fakhretdinov on 24.06.2024.
//

import Foundation
import RealmSwift

class Note: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var created: Date = Date()
    @objc dynamic var edited: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
