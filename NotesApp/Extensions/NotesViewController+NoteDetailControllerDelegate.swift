//
//  NotesViewController+NoteDetailControllerDelegate.swift
//  NotesApp
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
            notes.removeAll { $0.id == note.id }
        } else {
            if let index = notes.firstIndex(where: { $0.id == note.id }) {
                // Обновление заметки в массиве
                notes[index] = note
                CoreDataManager.shared.updateNote(notes[index], with: note)
            } else {
                notes.append(note)
                CoreDataManager.shared.saveNote(note)
            }
        }
        sortNotes(&notes)
        updateFooterLabel()
        
        // Обновление конкретной ячейки с учетом удаления
        updateExistingSnapshot(for: note, deleted: deleted)
        updateDataSourceWithNewSnapshot(with: self.notes, animate: true)
    }
}
