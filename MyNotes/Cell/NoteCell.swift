//
//  NoteCell.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 15.08.2024.
//

import UIKit

class NoteCell: UITableViewCell {
    
    private lazy var cellTitle = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var cellDateLabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    func setCell(titleText: String, dateTitle: String) {
        cellTitle.text = titleText
        cellDateLabel.text  = dateTitle
        
        self.backgroundColor = .black
        
        self.addSubview(cellTitle)
        self.addSubview(cellDateLabel)
        
        NSLayoutConstraint.activate([
            cellTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            cellTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            cellTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            cellDateLabel.topAnchor.constraint(equalTo: cellTitle.bottomAnchor, constant: 2),
            cellDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            cellDateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
}
