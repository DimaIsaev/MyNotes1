//
//  NoteListCoreDataModel.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 05.12.2024.
//
//
//import Foundation
//import CoreData
//
//protocol NoteListModelProtocol {
//    
//    var notes: [Note] { get }
//    
//    func createNote() -> Note
//    func updateNote(with id: String, newText: String) -> Note? //update или edit?
//    func deleteNote(with id: String)
//    
//}
//
//class NoteListCoreDataModel {
//    
//    weak var controller: NotesListControllerProtocol?
//    
//    var viewContext: NSManagedObjectContext {
//        persistentContainer.viewContext
//    }
//    
//    // MARK: - Core Data stack
//    
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "MyNotes")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//    
//    // MARK: - Core Data Saving support
//    
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//                controller?.didUpdate() //обновляю view
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//    
//    func fetchNotes() -> [NoteEntity] { //может опционал вернуть?
//        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
//        do {
//            return try viewContext.fetch(request)
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//        return [] // вернуть пустой или опционал?
//    }
//    
//}
//
//extension NoteListCoreDataModel: NoteListModelProtocol {
//    
//    var notes: [Note] {
//        let notesEntitys = fetchNotes() //название константы норм?
//        var notes = [Note]()
//        for note in notesEntitys {
//            notes.append(Note(text: note.text, id: note.id, date: note.date))
//        }
//        return notes
//    }
//    
//    func createNote() -> Note { //может опционал сделать?
//        let note = NoteEntity(context: viewContext)
//        note.text = ""
//        note.id = UUID().uuidString
//        note.date = Date()
//        
//        saveContext()// .self?
//        return Note(text: note.text, id: note.id, date: note.date)
//    }
//    
//    func updateNote(with id: String, newText: String) -> Note? {
//        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
//        guard let notes = try? viewContext.fetch(request),
//              let note = notes.first(where: {$0.id == id}) else { return nil }
//        note.text = newText
//        note.date = Date()
//        
//        saveContext()// .self?
//        return Note(text: newText, id: note.id, date: note.date)
//    }
//    
//    func deleteNote(with id: String) {
//        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
//        guard let notes = try? viewContext.fetch(request),
//              let note = notes.first(where: {$0.id == id}) else { return }
//        viewContext.delete(note)
//        
//        saveContext()
//    }
//    
//}
