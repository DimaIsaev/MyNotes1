//
//  NoteDetailView.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 18.08.2024.
//

import UIKit

protocol NoteDetailViewProtocol: UIView {
    func getTitle() -> String
    func getDetailText() -> String
    func setText(title: String?, detailText: String?)
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
    
    func getTitle() -> String {
        return textField.text!   // исправить
    }
    
    func getDetailText() -> String {
        return textView.text
    }
    
    func setText(title: String?,detailText: String?) {
        textField.text = title
        textView.text = detailText
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
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "Заголовок", attributes:  [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return textField
    }
    
    func makeTextView() -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = .white
        textView.backgroundColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }
    
}
