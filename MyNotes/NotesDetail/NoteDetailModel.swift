//
//  NoteDetailModel.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 26.08.2024.
//

import Foundation

protocol NoteDetailModelProtocol {
    var text: String? {get}
}

final class NoteDetailModel {
    private var storedText: String?
    
    init(storedText: String?) {
        self.storedText = storedText
    }
}

extension NoteDetailModel: NoteDetailModelProtocol {
    var text: String? {storedText}
}
