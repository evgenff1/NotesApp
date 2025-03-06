//
//  CoreDataManager.swift
//  NotesApp4
//
//  Created by Evgeniy Fakhretdinov on 24.06.2024.
//

import CoreData
import UIKit

// Менеджер для работы с Core Data
class CoreDataManager {
    // Singleton экземпляр менеджера
    static let shared = CoreDataManager()

    // Приватный инициализатор для предотвращения создания других экземпляров
    private init() {}

    // Персистентный контейнер
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NotesApp")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // Контекст для взаимодействия с Core Data
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Сохранение контекста
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // Получение заметок из Core Data
    func fetchNotes() -> [Note] {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            let notes = try context.fetch(fetchRequest)
            return notes
        } catch {
            print("Failed to fetch notes: \(error)")
            return []
        }
    }

    // Создание новой заметки
    func createNote(title: String, content: String, created: Date = Date(), edited: Date = Date()) -> Note {
        let newNote = Note(context: context)
        newNote.id = UUID()
        newNote.title = title
        newNote.content = content
        newNote.created = created
        newNote.edited = edited
        return newNote
    }
    
    // Сохранение заметки
    func saveNote(_ note: Note) {
        saveContext()
    }
    
    // Обновление существующей заметки
    func updateNote(_ existingNote: Note, with updatedNote: Note) {
        existingNote.title = updatedNote.title
        existingNote.content = updatedNote.content
        existingNote.edited = updatedNote.edited
        saveContext()
    }
    
    // Удаление заметки
    func deleteNote(_ note: Note) {
        context.delete(note)
        saveContext()
    }

    // Удаление всех заметок
    func deleteAllNotes() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Note.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Failed to delete all notes: \(error)")
        }
    }
}

