//
//  NoteListModel.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 21.08.2024.
//

import Foundation

protocol NoteListModelProtocol {
    var notes: [Note] { get }
    
    func saveNote(text: String) -> Note
    func deleteNote(noteId: String)
    func editNote(text: String, noteId: String) -> Note? //нужно возвращать?

}

final class NoteListModel {
    
    private var storedNotes: [Note]
    
    init() {
        storedNotes = [
            Note(text: "title", id: UUID().uuidString),
            Note(text: "titleN\n", id: UUID().uuidString),
            Note(text: "\ndetaiText", id: UUID().uuidString),
            Note(text: "test1\ndetail", id: UUID().uuidString),
            Note(text: "test2\ndetail4", id: UUID().uuidString),
            Note(text: "test3\ndetail3", id: UUID().uuidString),
            Note(text: "test4\ndetail2", id: UUID().uuidString),
            Note(text: "test5\ndetail1", id: UUID().uuidString)
        ]
    }
}

extension NoteListModel: NoteListModelProtocol {
    
    var notes: [Note]  {
        storedNotes
    }
    
    func saveNote(text: String) -> Note {
        let note = Note(text: text, id: UUID().uuidString)
        storedNotes.append(note)
        return note
    }
    
    func deleteNote(noteId: String) {
        for (index, note) in storedNotes.enumerated() {
            if noteId == note.id {
                storedNotes.remove(at: index)
                return
            }
        }
    }

    func editNote(text: String, noteId: String) -> Note? { //Возвращаю опционал? Проверить функцию еще раз
        for (index, note) in storedNotes.enumerated() {
            if noteId == note.id {
                storedNotes[index].text = text //поменял на var в структуре
                storedNotes[index].date = Date() // дату тут новую устанавливаю?
                return storedNotes[index]
            }
        }
        return nil
    }

}
