//
//  NoteDetailView.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 18.08.2024.
//

import UIKit

protocol NoteDetailViewProtocol: UIView {
    
    func setText(text: String?)
    
    func startTextViewListening()
    func stopTextViewListening()
    
}

final class NoteDetailView: UIView {
    
    private lazy var textView: UITextView = makeTextView()
    
    private var controller: NoteDetailControllerProtocol // private?
    
    init(controller: NoteDetailControllerProtocol) {
        self.controller = controller
        super.init(frame: .zero)
        setupLoyaut()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func becomeFirstResponder() -> Bool {
        textView.becomeFirstResponder()
    }
    
}

// MARK: - TextView Methods

extension NoteDetailView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let index = textView.text.firstIndex(of: "\n")
        let attributeForTitle = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28, weight: .bold),
                                  NSAttributedString.Key.foregroundColor: UIColor.white ]
        
        let titleRange = NSRange(
            location: textView.text.distance(from: textView.text.startIndex, to: textView.text.startIndex),
            length: textView.text.distance(from: textView.text.startIndex, to: index ?? textView.text.endIndex)
        )
        
        textView.textStorage.addAttributes(attributeForTitle, range: titleRange)
        
        if let index {
            let startIndex = textView.text.index(after: index)
            let attributeForDetailText = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                                           NSAttributedString.Key.foregroundColor: UIColor.white ]
            let detailTextRange = NSRange(
                location: textView.text.distance(from: textView.text.startIndex, to: startIndex),
                length: textView.text.distance(from: startIndex, to: textView.text.endIndex)
            )
            textView.textStorage.addAttributes(attributeForDetailText, range: detailTextRange)
        }
        
        controller.didChange(text: textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        controller.didBeginEditing()
    }
    
}

// MARK: - Протокол View

extension NoteDetailView: NoteDetailViewProtocol {
    
    func setText(text: String?) {
        let textCombination = NSMutableAttributedString()
        
        if let text = text {
            let title = makeTitle(with: text)
            
            if let detailText = makeDetailText(with: text) {
                textCombination.append(title)
                textCombination.append(NSAttributedString(string: "\n"))
                textCombination.append(detailText)
            } else {
                textCombination.append(title)
            }
        }
        textView.attributedText = textCombination
    }
    
    func startTextViewListening() {
        textView.delegate = self
    }
    
    func stopTextViewListening() {
        textView.delegate = nil
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
        textView.backgroundColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autocorrectionType = .no
        
        return textView
    }
    
    func makeTitle(with text: String) -> NSAttributedString {
        
        let start = text.startIndex
        let end = text.firstIndex(of: "\n") ?? text.endIndex
        let titleSubstring = text[start..<end]
        
        let attributeForTitle = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28, weight: .bold),
                                  NSAttributedString.Key.foregroundColor: UIColor.white ]
        
        return NSAttributedString(string: String(titleSubstring), attributes: attributeForTitle)
    }
    
    func makeDetailText(with text: String) -> NSAttributedString? {
        
        if let index = text.firstIndex(of: "\n") {
            let startIndex = text.index(after: index)
            let endIndex = text.endIndex
            let detailTextSubstring = text[startIndex..<endIndex]
            
            let attributeForDetailText = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                                           NSAttributedString.Key.foregroundColor: UIColor.white ]
            
            return NSAttributedString(string: String(detailTextSubstring), attributes: attributeForDetailText)
        }
        
        return nil
    }
    
}
