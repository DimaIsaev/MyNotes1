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
    
    enum ToolButtons: CaseIterable { //Добавлено перечисление кнопок (посмотреть нейминги)
        case checklist
        case addFile
        case drawing
        case addNewNote
    }
    
    private lazy var textView: UITextView = makeTextView()
    private lazy var toolButtonsStack: UIStackView = makeToolButtonsStack() //Добавлен стек кнопок (посмотреть нейминги)
    
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
    
    func setupLoyaut() { // добавление на view и NSLayoutConstraint для стека
        addSubview(textView)
        addSubview(toolButtonsStack)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            textView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -35),
            textView.bottomAnchor.constraint(equalTo: toolButtonsStack.topAnchor, constant: -10),
            
            toolButtonsStack.heightAnchor.constraint(equalToConstant: 30),
            toolButtonsStack.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -10),
            toolButtonsStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            toolButtonsStack.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
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
    
    func makeTool(button: ToolButtons) -> UIButton { // добавлена функция создания кнопки
        let toolButton = UIButton(type: .system)
        toolButton.tintColor = .systemOrange
        toolButton.translatesAutoresizingMaskIntoConstraints = false
        toolButton.widthAnchor.constraint(equalToConstant: 50).isActive = true// сделал чуть больше норм?
        toolButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        switch button {// посмотреть может есть варианты лучше?
        case .checklist:
            toolButton.setImage(UIImage(systemName: "checklist"), for: .normal)
        case .addFile:
            toolButton.setImage(UIImage(systemName: "paperclip"), for: .normal)
            toolButton.addTarget(self, action: #selector(didTapAddFileBtn), for: .touchUpInside) //действия добавлять тут норм?
        case .drawing:
            toolButton.setImage(UIImage(systemName: "pencil.tip.crop.circle"), for: .normal)
        case .addNewNote:
            toolButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        }
        
        return toolButton
    }
    
    @objc func didTapAddFileBtn() { //Добавлено действие кнопки

    }
    
    func makeToolButtonsStack() -> UIStackView { //Создание стека кнопок норм?  (нейминг норм?)
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .equalSpacing
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        ToolButtons.allCases.forEach { button in // норм добавление?
            hStack.addArrangedSubview(makeTool(button: button))
        }
    
        return hStack
    }
    
}
