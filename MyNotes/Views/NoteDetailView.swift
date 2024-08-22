//
//  NoteDetailView.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 18.08.2024.
//

import UIKit

protocol NoteDetailViewProtocol: UIView {
    
}

final class NoteDetailView: UIView, NoteDetailViewProtocol {
    
    lazy var textField: UITextField = makeTextField()
    lazy var textView: UITextView = makeTextView()
    
    var controller: NoteDetailControllerProtocol
    
    init(controller: NoteDetailControllerProtocol) {
        self.controller = controller
        super.init(frame: .zero)
        setupLoyaut()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension NoteDetailView {
    
    func setupLoyaut() {
        addSubview(textField)
        addSubview(textView)
        
        
        NSLayoutConstraint.activate([
            textView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 70),
            textView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -56),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            textField.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -10),
            textField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textField.heightAnchor.constraint(equalToConstant: 30),
            textField.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -70)
        ])
    }
    
    func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.text = "UITextField"
        textField.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        textField.textColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func makeTextView() -> UITextView {
        let textView = UITextView()
        textView.text = "UITextView"
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = .white
        textView.backgroundColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }
    
}
