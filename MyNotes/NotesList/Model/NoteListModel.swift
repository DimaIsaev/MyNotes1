//
//  NoteListModel.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 21.08.2024.
//

import Foundation

struct Note {
    let text: String?
}

protocol NoteListModelProtocol {
    var notes: [Note] {get}
    
    func saveNote(note: Note)
    func deleteNote(noteIndex: Int)
}

final class NoteListModel {
    
    private var storedNotes: [Note]
    
    init() {
        storedNotes = [
            Note(text: "test1\n01.01.2024"),
            Note(text: "test2\n02.01.2024"),
            Note(text: "test3\n03.01.2024"),
            Note(text: "test4\n04.01.2024"),
            Note(text: "test5\n05.01.2024")
        ]
    }
}

extension NoteListModel: NoteListModelProtocol {
    
    var notes: [Note] {
        storedNotes
    }
    
    func saveNote(note: Note) {
        storedNotes.insert(note, at: 0)
    }
    
    func deleteNote(noteIndex: Int) {
        storedNotes.remove(at: noteIndex)
    }
}
