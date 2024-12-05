//
//  NoteDetailModel.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 26.08.2024.
//

import Foundation

protocol NoteDetailModelProtocol {
    
    var note: Note? { get }
    var isNew: Bool { get }
    
    func createNote(text: String)
    func editNote(text: String)
    
}

final class NoteDetailModel {
    
    weak var controller: NoteDetailControllerProtocol?
    
    public var storedNote: Note? {
        didSet {
            controller?.didUpdate(note: storedNote!)//тут
        }
    }
    
    init(storedNote: Note?) {
        self.storedNote = storedNote
    }
    
}

//MARK: - Протокол модели

extension NoteDetailModel: NoteDetailModelProtocol {
    
    var note: Note? { storedNote }
    
    var isNew: Bool {
        return note == nil
    }
    
    func createNote(text: String) {
        let note = Note(text: text, id: UUID().uuidString, date: Date())
        storedNote = note
    }
    
    func editNote(text: String) {
        var editedNote = storedNote
        editedNote?.text = text
        editedNote?.date = Date()
        storedNote = editedNote
    }
    
}
