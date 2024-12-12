//
//  NoteViewController.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 17.08.2024.
//

import UIKit

protocol NoteDetailControllerProtocol: AnyObject {
    
    func didChange(text: String)
    func didBeginEditing() //eбрал аргумент with text. Текста не будет он в любом случае сохранит пустую строку
    
}

protocol NoteDetailControllerDelegate: AnyObject {
    
    func didCreateNote() -> Note
    func didEditNote(with id: String, text: String) -> Note?
    
}

final class NoteDetailController: UIViewController {
    
    private lazy var contentView: NoteDetailViewProtocol = makeContentView()
    
    weak var delegate: NoteDetailControllerDelegate?
    
    private var model: NoteDetailModelProtocol // private?
    
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
        setupView()
        
        contentView.setText(text: model.note?.text)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if model.isNew {
            contentView.becomeFirstResponder()
        }
    }
    
}

// MARK: - UI Elements

private extension NoteDetailController { //private?
    
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
    
    func setupNavigationBarItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(dismissKeyboard))
        navigationItem.titleView?.tintColor = .systemOrange
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: - Протокол контроллера

extension NoteDetailController: NoteDetailControllerProtocol {
    
    func didChange(text: String) {
        if !model.isNew {
            guard let id = model.note?.id,
                  let note = delegate?.didEditNote(with: id, text: text) else { return }
            model.update(note: note)
        }
    }
    
    func didBeginEditing() { //убрал аргумент with text. Текста не будет он в любом случае сохранит пустую строку
        setupNavigationBarItem()
        
        if model.isNew {
            guard let note = delegate?.didCreateNote() else { return }
            model.update(note: note)
        }
    }
    
}
