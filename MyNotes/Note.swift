//
//  Note.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 26.09.2024.
//

import Foundation

struct Note {
    var text: String // для изменения текста указал var (для функции edit)
    let id: String
    var date = Date() //добавил дату, var что бы менять при редактировании заметки дату
}
