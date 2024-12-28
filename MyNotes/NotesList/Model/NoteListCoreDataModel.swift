//
//  NoteListCoreDataModel.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 05.12.2024.


import Foundation
import CoreData

class NoteListCoreDataModel {
    
    weak var controller: NotesListControllerProtocol?
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyNotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                controller?.didUpdate()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchNotes() -> [NoteEntity] {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
}

//MARK: - Протокол модели

extension NoteListCoreDataModel: NoteListModelProtocol {
    
    var notes: [Note] {
        let notesEntities = fetchNotes()
        var notes = [Note]()
        for note in notesEntities {
            notes.append(Note(text: note.text, id: note.id, date: note.date))
        }
        return notes
    }
    
    func createNote() -> Note {
        let note = NoteEntity(context: viewContext)
        note.text = ""
        note.id = UUID().uuidString
        note.date = Date()
        
        saveContext()
        return Note(text: note.text, id: note.id, date: note.date)
    }
    
    func updateNote(with id: String, newText: String) -> Note? {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        guard let notes = try? viewContext.fetch(request),
              let note = notes.first(where: {$0.id == id}) else { return nil }
        note.text = newText
        note.date = Date()
        
        saveContext()
        return Note(text: newText, id: note.id, date: note.date)
    }
    
    func deleteNote(with id: String) {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        guard let notes = try? viewContext.fetch(request),
              let note = notes.first(where: {$0.id == id}) else { return }
        viewContext.delete(note)
        
        saveContext()
    }
    
}
