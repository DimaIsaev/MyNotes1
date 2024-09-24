//
//  NoteDetailView.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 18.08.2024.
//

import UIKit

protocol NoteDetailViewProtocol: UIView {
    func getText() -> String?
    func setText(text: String?)
}

final class NoteDetailView: UIView, NoteDetailViewProtocol {

    private lazy var textView: UITextView = makeTextView()
    
    var controller: NoteDetailControllerProtocol
    
    init(controller: NoteDetailControllerProtocol) {
        self.controller = controller
        super.init(frame: .zero)
        setupLoyaut()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getText() -> String? {
        if textView.text.isEmpty {
            return nil
        }
        return textView.text
        
    }
    
    override func becomeFirstResponder() -> Bool {
        textView.becomeFirstResponder()
    }
    
    func setText(text: String?) {   //УПРОСТИТЬ
        if let text = text {
            if let title = makeTitle(text: text) {
                if let detailText = makeDetailText(text: text) {
                    textView.text = title + "\n" + detailText
                } else {
                    textView.text = title
                }
            } else {
                if let detailText = makeDetailText(text: text) {
                    textView.text = "\n" + detailText
                }
            }
        }
    }
}

// MARK: - UI Elements
private extension NoteDetailView {
    
    func setupLoyaut() {
        addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 45),
            textView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -56),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

    func makeTextView() -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = .white
        textView.backgroundColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }
    
    func makeTitle(text: String?) -> String? {
        var title: String?
        
        if let text = text {
            let start = text.startIndex
            let end = text.firstIndex(of: "\n") ?? text.endIndex
            let titleSubstring = text[start..<end]
        
            title = String(titleSubstring)
        }
        return title
    }
    
    func makeDetailText(text: String?) -> String? {
        var detailText: String?
        
        if let text = text {
            if let index = text.firstIndex(of: "\n") {
                let startIndex = text.index(after: index)
                let endIndex = text.endIndex
                let detailTextSubstring = text[startIndex..<endIndex]
                
                detailText = String(detailTextSubstring)
            }
        }
        return detailText
    }
}
