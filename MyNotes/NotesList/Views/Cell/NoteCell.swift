//
//  NoteCell.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 15.08.2024.
//

import UIKit

final class NoteCell: UITableViewCell {
    
    private lazy var cellTitle = makeCellLabel()
    private lazy var cellDetailText = makeDetailText()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .black
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabels(with note: Note?) {
        
        func getTitle(text: String?) -> String {
            guard let text else {
                return ""
            }
            let startTitle = text.startIndex
            let endTitle = text.firstIndex(of: "\n") ?? text.endIndex
            let titleSubstring = text[startTitle..<endTitle]
            
            return String(titleSubstring)
        }
        
        func getDetailText(text: String?) -> String {
            guard let text, let index = text.firstIndex(of: "\n") else {
                return ""
            }
            let startDetailText = text.index(after: index)
            let endDetailText = text.endIndex
            let detailTextSubstring = text[startDetailText..<endDetailText]
            
            return String(detailTextSubstring)
        }

        var title: String = getTitle(text: note?.text)
        var detailText: String = getDetailText(text: note?.text)
        // проверить на пробелы в строке
        if title.isEmpty || title.allSatisfy({ $0 == " " }) {
            if detailText.isEmpty || detailText.allSatisfy({ $0 == " " }) {
                title = "Новая заметка"
                detailText = "Нет дополнительного текста"
            } else {
                title = detailText
                detailText = "Нет дополнительного текста"
            }
        } else {
            if detailText.isEmpty || detailText.allSatisfy({ $0 == " " }) {
                detailText = "Нет дополнительного текста"
            }
        }

        cellTitle.text = title
        cellDetailText.text = detailText
    }
    
}

private extension NoteCell {
    
    func setupLayout() {
        contentView.addSubview(cellTitle)
        contentView.addSubview(cellDetailText)
        
        NSLayoutConstraint.activate([
            cellTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cellTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cellTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            cellDetailText.topAnchor.constraint(equalTo: cellTitle.bottomAnchor, constant: 2),
            cellDetailText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cellDetailText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func makeCellLabel() -> UILabel {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }
    
    func makeDetailText() -> UILabel {
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        text.textColor = .systemGray
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }

}
