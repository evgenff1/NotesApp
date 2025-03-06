//
//  RealmManager.swift
//  NotesApp7
//
//  Created by Evgeniy Fakhretdinov on 27.06.2024.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    
    private init() {}
    
    let realm = try! Realm()
    
    func add(_ note: Note) {
        try! realm.write {
            realm.add(note)
        }
    }
    
    func createNote(title: String, content: String) -> Note {
        let newNote = Note()
        newNote.title = title
        newNote.content = content
        return newNote
    }
    
    func delete(_ note: Note) {
        try! realm.write {
            realm.delete(note)
        }
    }
    
    func update(_ note: Note, withTitle title: String, andContent content: String) {
        try! realm.write {
            note.title = title
            note.content = content
            note.edited = Date()
        }
    }
    
    func fetchNotes() -> Results<Note> {
        return realm.objects(Note.self).sorted(byKeyPath: DatabaseKeys.edited, ascending: false)
    }
    
    func fetchNoteById(_ id: String) -> Note? {
        return realm.object(ofType: Note.self, forPrimaryKey: id)
    }
}

