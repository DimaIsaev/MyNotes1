//
//  NoteListModelProtocol.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 25.12.2024.
//

import Foundation

protocol NoteListModelProtocol {
    
    var notes: [Note] { get }
    
    func createNote() -> Note
    func updateNote(with id: String, newText: String) -> Note?
    func deleteNote(with id: String)
    
}
