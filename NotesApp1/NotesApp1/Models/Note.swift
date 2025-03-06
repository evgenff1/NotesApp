//
//  Note.swift
//  NotesApp1
//
//  Created by Evgeniy Fakhretdinov on 24.06.2024.
//

import Foundation

struct Note: Hashable {
    var id: UUID
    var title: String
    var content: String
    var created: Date
    var edited: Date
}
