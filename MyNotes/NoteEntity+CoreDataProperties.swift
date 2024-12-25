//
//  NoteEntity+CoreDataProperties.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 05.12.2024.
//
//

import Foundation
import CoreData

extension NoteEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        return NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }
    
    @NSManaged public var text: String
    @NSManaged public var date: Date
    @NSManaged public var id: String
    
}

extension NoteEntity : Identifiable {
    
}
