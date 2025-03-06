//
//  NotesViewController+NoteDetailControllerDelegate.swift
//  NotesApp5
//
//  Created by Evgeniy Fakhretdinov on 23.06.2024.
//

import Foundation

// MARK: - NoteDetailControllerDelegate

extension NotesViewController: NoteDetailControllerDelegate {
    // Обновление данных после редактирования заметки
    func dataUpdated(for note: Note, deleted: Bool) {
        if deleted {
            CoreDataManager.shared.deleteNote(note)
        } else {
            CoreDataManager.shared.saveNote(note) 
        }
        updateDataSourceWithNewSnapshot(animate: true)
        updateFooterLabel()
    }
}
