//
//  NoteListModel.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 21.08.2024.
//

import Foundation

protocol NoteListModelProtocol {
    
    var notes: [Note] { get }
    
    func saveNote(note: Note)
    func deleteNote(noteId: String)
    
}

final class NoteListModel {
    
    weak var controller: NotesListControllerProtocol?
    
    private var storedNotes: [Note] {
        didSet {
            controller?.didUpdate(notes: storedNotes)
        }
    }
    
    init() {
        storedNotes = [
            //            Note(text: "title", id: UUID().uuidString),
            //            Note(text: "titleN\n", id: UUID().uuidString),
            //            Note(text: "\ndetaiText", id: UUID().uuidString),
            //            Note(text: "test1\ndetail", id: UUID().uuidString),
            //            Note(text: "test2\ndetail4", id: UUID().uuidString),
            //            Note(text: "test3\ndetail3", id: UUID().uuidString),
            //            Note(text: "test4\ndetail2", id: UUID().uuidString),
            //            Note(text: "test5\ndetail1", id: UUID().uuidString)
        ]
    }
    
}

//MARK: - Протокол модели

extension NoteListModel: NoteListModelProtocol {
    
    var notes: [Note]  {
        storedNotes
    }
    
    func saveNote(note: Note) {
        for (index, storedNote) in storedNotes.enumerated() {
            if storedNote.id == note.id {
                storedNotes[index] = note
                return
            }
        }
        storedNotes.append(note)
    }
    
    func deleteNote(noteId: String) {
        for (index, note) in storedNotes.enumerated() {
            if noteId == note.id {
                storedNotes.remove(at: index)
                return
            }
        }
    }
    
}
