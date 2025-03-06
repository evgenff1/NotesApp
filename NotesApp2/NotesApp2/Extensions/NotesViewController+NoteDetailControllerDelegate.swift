//
//  NotesViewController+NoteDetailControllerDelegate.swift
//  NotesApp2
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
                self.deleteNote(note)
            } else if let _ = self.notes.firstIndex(where: { $0.id == note.id }) {
                self.updateExistingNote(note)
            } else {
                self.addNewNote(note)
            }
            self.updateFooterLabel()
        }
    }

    // Функция удаления заметки
    func deleteNote(_ note: Note) {
        CoreDataManager.shared.deleteNote(note)
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes.remove(at: index)
            let indexPath = IndexPath(row: index, section: 0)
            if isSearchActive {
                if let searchIndex = filteredNotes.firstIndex(where: { $0.id == note.id }) {
                    filteredNotes.remove(at: searchIndex)
                    let searchIndexPath = IndexPath(row: searchIndex, section: 0)
                    notesView.tableView.deleteRows(at: [searchIndexPath], with: .automatic)
                }
            } else {
                notesView.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }

    // Функция обновления существующей заметки
    func updateExistingNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            CoreDataManager.shared.updateNote(notes[index], with: note)
            sortNotes(&notes)
            
            guard let newIndex = notes.firstIndex(where: { $0.id == note.id }) else {
                return
            }
            
            let indexPath = IndexPath(row: index, section: 0)
            let newIndexPath = IndexPath(row: newIndex, section: 0)
            if indexPath != newIndexPath {
                if isSearchActive {
                    searchBar(notesView.searchBar, textDidChange: notesView.searchBar.text ?? "")
                } else {
                    notesView.tableView.moveRow(at: indexPath, to: newIndexPath)
                    notesView.tableView.reloadRows(at: [newIndexPath], with: .automatic)
                }
            } else {
                notesView.tableView.reloadRows(at: [newIndexPath], with: .automatic)
            }
        }
    }

    // Функция добавления новой заметки
    func addNewNote(_ note: Note) {
        notes.append(note)
        CoreDataManager.shared.saveNote(note)
        sortNotes(&notes)
        
        guard let newIndex = notes.firstIndex(where: { $0.id == note.id }) else {
            return
        }
        
        let newIndexPath = IndexPath(row: newIndex, section: 0)
        
        if isSearchActive {
            searchBar(notesView.searchBar, textDidChange: notesView.searchBar.text ?? "")
        } else {
            notesView.tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
}









