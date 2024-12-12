//
//  NoteListModel.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 21.08.2024.
//

import Foundation

protocol NoteListModelProtocol {
    
    var notes: [Note] { get }
    
    func createNote() -> Note
    func deleteNote(with id: String)
    func updateNote(with id: String, newText: String) -> Note?
    
}

final class NoteListModel {
    
    weak var controller: NotesListControllerProtocol?
    
    private var storedNotes: [Note] {
        didSet {
            controller?.didUpdate()
        }
    }
    
    init() {
        storedNotes = []
    }
    
}

//MARK: - Протокол модели

extension NoteListModel: NoteListModelProtocol {
    
    var notes: [Note]  {
        storedNotes
    }
    
    func createNote() -> Note {//тест не принимает, сохранение и так совершалось на моменте пустой строки.
        let note = Note(text: "", id: UUID().uuidString, date: Date())// Создает теперь заметку с пустой строкой.
        storedNotes.append(note)
        return note
    }
    
    func deleteNote(with id: String) {
        for (index, note) in storedNotes.enumerated() {
            if id == note.id {
                storedNotes.remove(at: index)
                return
            }
        }
    }
    
    func updateNote(with id: String, newText: String) -> Note? {
        for (index, note) in storedNotes.enumerated() {
            if id == note.id {
                var note = storedNotes[index]
                note.text = newText
                note.date = Date()
                storedNotes[index] = note
                return storedNotes[index]
            }
        }
        return nil
    }
    
}
