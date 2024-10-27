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

    override func becomeFirstResponder() -> Bool {
        textView.becomeFirstResponder()
    }
    
    func getText() -> String? {
        if textView.text.isEmpty {
            return nil
        }
        return textView.text
    }
    
    func setText(text: String?) {
        let textCombination = NSMutableAttributedString()  //var? let? lazy var?
        let newString = NSAttributedString(string: "\n") //lazy var? убрал NSMutableAttributedString. Может без let, сразу в append добавить?
        
        if let text = text {
            let title = makeTitleWithAttribute(text: text) //убрал if let так как title или текст или ""
            
            if let detailText = makeDetailTextWithAttribute(text: text) {
                textCombination.append(title) // if title.string.isEmpty убрал так как при newString title будет пустой строкой
                textCombination.append(newString)
                textCombination.append(detailText)
            } else {
                textCombination.append(title)
            }
        }
        textView.attributedText = textCombination
    }
    
}
extension NoteDetailView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        //Вариант 1. Выглядит страшно, но описан подробно. Если нет перехода но новую строку атрибут будет только для title, а если есть переход, то для title и detail. Но очень много повторяющегося текста. Возможно вариант 2 лучше. Так же указал lazy var это норм? Вынес за пределы условий, что бы не обрабатывать каждый раз. Убрать шрифт в makeTextView если используем этот вариант
        lazy var attributeForTitle = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28, weight: .bold),
                                  NSAttributedString.Key.foregroundColor: UIColor.white ]
        lazy var attributeForDetailText = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                                       NSAttributedString.Key.foregroundColor: UIColor.white ]
        
        if let index = textView.text.firstIndex(of: "\n") {
            let titleRange = NSRange(
                location: textView.text.distance(from: textView.text.startIndex, to: textView.text.startIndex),
                length: textView.text.distance(from: textView.text.startIndex, to: index)
            )
            
            let detailStartIndex = textView.text.index(after: index)
            
            let detailTextRange = NSRange(
                location: textView.text.distance(from: textView.text.startIndex, to: detailStartIndex),
                length: textView.text.distance(from: detailStartIndex, to: textView.text.endIndex)
            )
            
            textView.textStorage.addAttributes(attributeForTitle, range: titleRange)
            textView.textStorage.addAttributes(attributeForDetailText, range: detailTextRange)
        } else {
            let titleRange = NSRange(
                location: textView.text.distance(from: textView.text.startIndex, to: textView.text.startIndex),
                length: textView.text.distance(from: textView.text.startIndex, to: textView.text.endIndex)
            )
            
            textView.textStorage.addAttributes(attributeForTitle, range: titleRange)
        }
        
        
        //Вариант 2. Тут отрабатывает шрифт для title, а после перехода на новую строку шрифт для detilText. Может убрать первый let index и добавить его сразу в range? Index вроде одинаковый, но прописан отдельно для title и detail. Так как не отработает аттрибут для title. Смущало два раза прописанный индекс, после этого написал вариант 1. Убрать шрифт в makeTextView если используем этот вариант
//        let index = textView.text.firstIndex(of: "\n")
//        let attributeForTitle = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28, weight: .bold),
//                                  NSAttributedString.Key.foregroundColor: UIColor.white ]
//        
//        let titleRange = NSRange(
//            location: textView.text.distance(from: textView.text.startIndex, to: textView.text.startIndex),
//            length: textView.text.distance(from: textView.text.startIndex, to: index ?? textView.text.endIndex)
//        )
//        
//        textView.textStorage.addAttributes(attributeForTitle, range: titleRange)
//        
//        if let index = textView.text.firstIndex(of: "\n") {
//            let startIndex = textView.text.index(after: index)
//            let attributeForDetailText = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
//                                           NSAttributedString.Key.foregroundColor: UIColor.white ]
//            let detailTextRange = NSRange(
//                location: textView.text.distance(from: textView.text.startIndex, to: startIndex),
//                length: textView.text.distance(from: startIndex, to: textView.text.endIndex)
//            )
//            textView.textStorage.addAttributes(attributeForDetailText, range: detailTextRange)
//        }

        
        // Вариант 3. Выглядит самым приятным. Но шрифт Title отрабатывает в MakeTextView. Тут аттрибут для title нужен только, когда редактируешь старую заметку без title. Если не указать тут атрибут для title, то текст будет маленьким и не подтянется из MakeTextView. Минус что прописываем шрифт MakeTextView, а для варианта заметки без title шрифт регулируется тут. Думаю вариант не верный.
//        if let index = textView.text.firstIndex(of: "\n") {
//            let attributeForTitle = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28, weight: .bold),
//                                      NSAttributedString.Key.foregroundColor: UIColor.white ]
//            let attributeForDetailText = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
//                                           NSAttributedString.Key.foregroundColor: UIColor.white ]
//            
//            let startIndex = textView.text.index(after: index)
//            
//            let titleRange = NSRange(
//                location: textView.text.distance(from: textView.text.startIndex, to: textView.text.startIndex),
//                length: textView.text.distance(from: textView.text.startIndex, to: index)
//            )
//            
//            let detailTextRange = NSRange(
//                location: textView.text.distance(from: textView.text.startIndex, to: startIndex),
//                length: textView.text.distance(from: startIndex, to: textView.text.endIndex)
//            )
//            
//            textView.textStorage.addAttributes(attributeForTitle, range: titleRange)
//            textView.textStorage.addAttributes(attributeForDetailText, range: detailTextRange)
//        }
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
        textView.font = UIFont.systemFont(ofSize: 13, weight: .bold) // убрать если 1 или 2 вариант
        textView.textColor = .white // убрать если 1 или 2 вариант
        textView.backgroundColor = .black
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }
    
    func makeTitleWithAttribute(text: String) -> NSAttributedString { //меняю на makeTitle название функции? Убрал опционал в аргументе и let text = text. Так как проверка на текст в функции setText. убрал NSMutableAttributedString. Убрал опционал в возвращаемом элементе функции(title всегда вернется либо текстом либо пустой стройкой)
//        var title: NSAttributedString? //убираю? ниже указал let title
        
        let start = text.startIndex
        let end = text.firstIndex(of: "\n") ?? text.endIndex
        let titleSubstring = text[start..<end]
        
        let attributeForTitle = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28, weight: .bold),
                                  NSAttributedString.Key.foregroundColor: UIColor.white ]
        
        let title = NSAttributedString(string: String(titleSubstring), attributes: attributeForTitle) //убрал NSMutableAttributedString

        return title
    }
    
    func makeDetailTextWithAttribute(text: String) -> NSAttributedString? { //меняю на makeDetailText название функции? Убрал опционал в аргументе и let text = text. Так как проверка на текст в функции setText. убрал NSMutableAttributedString
        var detailText: NSAttributedString? //убрал NSMutableAttributedString
        
        if let index = text.firstIndex(of: "\n") {
            let startIndex = text.index(after: index)
            let endIndex = text.endIndex
            let detailTextSubstring = text[startIndex..<endIndex]
            
            let attributeForDetailText = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                                           NSAttributedString.Key.foregroundColor: UIColor.white ]
            
            detailText = NSAttributedString(string: String(detailTextSubstring), attributes: attributeForDetailText) //убрал NSMutableAttributedString
        }

        return detailText
    }
}
