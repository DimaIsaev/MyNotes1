//
//  NoteListModel.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 21.08.2024.
//

import Foundation

struct Note {
    let title: String
    let date: String
}

protocol NoteListModelProtocol {
    var notes: [Note] {get}
}

final class NoteListModel {
    
    private let storedNotes: [Note]
    
    init() {
        storedNotes = [
            Note(title: "test1", date: "1.01.2024"),
            Note(title: "test2", date: "2.01.2024"),
            Note(title: "test3", date: "3.01.2024"),
            Note(title: "test4", date: "4.01.2024"),
        ]
    }
}

extension NoteListModel: NoteListModelProtocol {
    var notes: [Note] {
        storedNotes 
    }
}
