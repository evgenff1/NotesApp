//
//  NoteDetailControllerDelegate.swift
//  NotesApp3
//
//  Created by Evgeniy Fakhretdinov on 23.06.2024.
//

import Foundation

protocol NoteDetailControllerDelegate: AnyObject {
    // Метод для обновления данных заметки
    func dataUpdated(for note: Note, deleted: Bool)
}
