//
//  NotesViewController+NoteDetailControllerDelegate.swift
//  NotesApp7
//
//  Created by Evgeniy Fakhretdinov on 23.06.2024.
//

import Foundation

// MARK: - NoteDetailControllerDelegate

extension NotesViewController: NoteDetailControllerDelegate {
    func dataUpdated(for note: Note, deleted: Bool, newTitle: String?, newContent: String?) {
        DispatchQueue.main.async {
            if deleted {
                self.deleteNoteAndUpdateSnapshot(note)
            } else if let newTitle = newTitle, let newContent = newContent {
                self.updateNoteInRealm(note, withTitle: newTitle, andContent: newContent)
            }
        }
    }
    
    func deleteNoteAndUpdateSnapshot(_ note: Note) {
        var snapshot = self.dataSource.snapshot()
        snapshot.deleteItems([note])
        self.dataSource.apply(snapshot, animatingDifferences: false) {
            try! RealmManager.shared.realm.write {
                RealmManager.shared.realm.delete(note)
            }
            self.updateFooterLabel()
        }
    }
    
    func updateNoteInRealm(_ note: Note, withTitle title: String, andContent content: String) {
        try! RealmManager.shared.realm.write {
            note.title = title
            note.content = content
            note.edited = Date()
        }
        updateExistingSnapshot(for: note, deleted: false)
        updateFooterLabel()
    }
}








