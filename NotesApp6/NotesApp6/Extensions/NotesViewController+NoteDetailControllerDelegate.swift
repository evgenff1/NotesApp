//
//  NotesViewController+NoteDetailControllerDelegate.swift
//  NotesApp6
//
//  Created by Evgeniy Fakhretdinov on 23.06.2024.
//

import Foundation

// MARK: - NoteDetailControllerDelegate

extension NotesViewController: NoteDetailControllerDelegate {
    func dataUpdated(for note: Note, deleted: Bool, newTitle: String?, newContent: String?) {
        DispatchQueue.main.async {
            if deleted {
                self.deleteNoteFromRealm(note)
            } else if let newTitle = newTitle, let newContent = newContent {
                self.updateNoteInRealm(note, withTitle: newTitle, andContent: newContent)
            }

            if self.isSearchActive {
                self.filteredNotes = self.notes.filter("title CONTAINS[c] %@ OR content CONTAINS[c] %@", self.notesView.searchBar.text ?? "", self.notesView.searchBar.text ?? "")
                self.loadNotes()
            }

        }
    }

    func deleteNoteFromRealm(_ note: Note) {
        try! RealmManager.shared.realm.write {
            RealmManager.shared.realm.delete(note)
        }
    }

    func updateNoteInRealm(_ note: Note, withTitle title: String, andContent content: String) {
        try! RealmManager.shared.realm.write {
            note.title = title
            note.content = content
            note.edited = Date()
        }
    }
}










