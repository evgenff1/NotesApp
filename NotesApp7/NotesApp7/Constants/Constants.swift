//
//  Constants.swift
//  NotesApp7
//
//  Created by Evgeniy Fakhretdinov on 28.06.2024.
//

import Foundation

enum UserDefaultsKeys {
    static let hasLaunchedBefore = "hasLaunchedBefore"
    static let isDetailScreen = "isDetailScreen"
    static let currentNoteId = "currentNoteId"
}

enum DatabaseKeys {
    static let edited = "edited"
}

enum UIElements {
    static let squareAndPencil = "square.and.pencil"
    static let checkmarkCircle = "checkmark.circle"
    static let ellipsisCircle = "ellipsis.circle"
    static let trash = "trash"
    static let done = "done"
    static let deleteAll = "Delete All"
    static let delete = "Delete"
    static let cancel = "Cancel"
    static let selectNotes = "Select Notes"
    static let cancelButton = "cancelButton"
}

enum FontSizes {
    static let header: CGFloat = 32
    static let subheader: CGFloat = 20
    static let body: CGFloat = 16
    static let footnote: CGFloat = 14
}

enum Margins {
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 32
}

enum Heights {
    static let footer: CGFloat = 60
    static let minimumCell: CGFloat = 44
}
