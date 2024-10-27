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
    
    func update(note: Note)
    
}

final class NoteDetailModel {
    
    private var storedNote: Note?
    
    init(storedNote: Note?) {
        self.storedNote = storedNote
    }
    
}

extension NoteDetailModel: NoteDetailModelProtocol {
    
    var note: Note? { storedNote }
    
    var isNew: Bool {
        return note == nil
    }
    
    func update(note: Note) {
        storedNote = note
    }
    
}
