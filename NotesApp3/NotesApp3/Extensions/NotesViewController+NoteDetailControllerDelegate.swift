//
//  NotesViewController+NoteDetailControllerDelegate.swift
//  NotesApp3
//
//  Created by Evgeniy Fakhretdinov on 23.06.2024.
//

import Foundation

// MARK: - NoteDetailControllerDelegate

extension NotesViewController: NoteDetailControllerDelegate {
    // Обновление данных после редактирования заметки
    func dataUpdated(for note: Note, deleted: Bool) {
        DispatchQueue.main.async {
            if deleted {
                CoreDataManager.shared.deleteNote(note)
            } else {
                CoreDataManager.shared.saveNote(note)
                CoreDataManager.shared.context.refresh(note, mergeChanges: true)
            }
            self.updateFooterLabel()
        }
    }
}









