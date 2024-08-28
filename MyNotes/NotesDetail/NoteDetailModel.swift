//
//  NoteDetailModel.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 26.08.2024.
//

import Foundation

protocol NoteDetailModelProtocol {
    var title: String? {get}
    var detailText: String? {get}
}

final class NoteDetailModel {
    private let storedTitle: String?
    private let storedDetailText: String?
    
    init(storedTitle: String?, storedDetailText: String?) {
        self.storedTitle = storedTitle
        self.storedDetailText = storedDetailText
    }
}

extension NoteDetailModel: NoteDetailModelProtocol {
    var title: String? {storedTitle}
    var detailText: String? {storedDetailText}
}
