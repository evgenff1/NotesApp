//
//  Note+CoreDataProperties.swift
//  NotesApp2
//
//  Created by Evgeniy Fakhretdinov on 24.06.2024.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var created: Date?
    @NSManaged public var edited: Date?

}

extension Note : Identifiable {

}
