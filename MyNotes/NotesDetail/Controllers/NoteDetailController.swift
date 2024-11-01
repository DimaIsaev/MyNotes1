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
    
    func didCreateNote(noteText: String) -> Note
    func didEditNote(noteText: String, noteId: String) -> Note?
    func didDeleteNote(noteId: String)
    
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
        contentView.setText(text: model.note?.text)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if model.isNew {
            contentView.becomeFirstResponder()
        }
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
        
        if let text {
            if model.isNew {
                guard let note = delegate?.didCreateNote(noteText: text) else {
                    return
                }
                //оставить пустую строку? Или загоняюсь?
                self.model.update(note: note)
            } else {
                if text != model.note?.text {
                    guard let id = model.note?.id else {
                        return
                    } // guard норм?
                    guard let note = delegate?.didEditNote(noteText: text, noteId: id) else {
                        return
                    }//guard норм?
                    self.model.update(note: note)
                }
            }
        } else {
            if !model.isNew {//проверить
                guard let note = model.note else {
                    return
                } // guard норм?
                delegate?.didDeleteNote(noteId: note.id)
            }
        }
    }

}
