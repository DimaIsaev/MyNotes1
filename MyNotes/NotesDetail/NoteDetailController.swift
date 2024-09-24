//
//  NoteViewController.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 17.08.2024.
//

import UIKit

protocol NoteDetailControllerProtocol: AnyObject {

}

protocol NoteDetailControllerDelegate: AnyObject {
    func didCreateNote(note: Note)
    func didEditNote(note: Note)
    func didDeleteNote(note: Note)
}

final class NoteDetailController: UIViewController, NoteDetailControllerProtocol {

    private lazy var contentView: NoteDetailViewProtocol = makeContentView()
    
    weak var delegate: NoteDetailControllerDelegate?
    
    var model: NoteDetailModelProtocol
    
    init(model: NoteDetailModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never

        setupNavigationBarItem()
        setupView()
        contentView.setText(text: model.text)
    }
    
    func setupView() {
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func makeContentView() -> NoteDetailViewProtocol {
        let view = NoteDetailView(controller: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func setupNavigationBarItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(dismissKeyboard))
        navigationItem.titleView?.tintColor = .systemOrange
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
        
        let text = contentView.getText()
        
        if text != nil {
            if model.text == nil {
                delegate?.didCreateNote(note: Note(text: text))
            } else if model.text != nil {
                delegate?.didEditNote(note: Note(text: text))
            }
        } else {
            if model.text == nil {
                delegate?.didCreateNote(note: Note(text: text))
                delegate?.didDeleteNote(note: Note(text: text))
            } else if model.text != nil {
                delegate?.didEditNote(note: Note(text: text))
                delegate?.didDeleteNote(note: Note(text: text))
            }
        }
    }
    
    @objc func dismissKeyboard1() { //пробная
        view.endEditing(true)
        
        let text = contentView.getText()
        
        if model.text != model.text && model.text != text {
            if text != nil && text != model.text {
                if model.text == nil {
                    delegate?.didCreateNote(note: Note(text: text))
                } else if model.text != nil {
                    delegate?.didEditNote(note: Note(text: text))
                }
            } else if text == nil && text != model.text {
                if model.text == nil {
                    delegate?.didCreateNote(note: Note(text: text))
                    delegate?.didDeleteNote(note: Note(text: text))
                } else if model.text != nil {
                    delegate?.didEditNote(note: Note(text: text))
                    delegate?.didDeleteNote(note: Note(text: text))
                }
            }
        }
    }
}
