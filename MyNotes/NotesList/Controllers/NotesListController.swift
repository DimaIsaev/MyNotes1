//
//  ViewController.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 13.08.2024.
//

import UIKit

protocol NotesListControllerProtocol: AnyObject {
    
    func didSelectNote(with id: String)
    func didDeleteNote(with id: String)
    func didTapAddBtn()
    func didUpdate()
    
}

final class NotesListController: UIViewController {
    
    private lazy var contentView: NotesListViewProtocol = makeContentView()
    
    private let model: NoteListModelProtocol // private?
    
    init(model: NoteListModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupView()
        
        contentView.update(for: NotesListView.ViewModel(notes: sortNotes()))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        removeNoteIfEmpty()
    }
    
    private func sortNotes() -> [Note] { // private?
        let notes = model.notes
        let sortedNotes = notes.sorted { $0.date > $1.date }
        return sortedNotes
    }
    
    private func removeNoteIfEmpty () { // private?
        let sortedNotes = sortNotes()
        guard let firstNote = sortedNotes.first else {
            return
        }
        
        if firstNote.text.isEmpty {
            model.deleteNote(with: firstNote.id)
        }
    }
    
}

// MARK: - UI Elements

private extension NotesListController {// private?
    
    func setupView() {
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func makeContentView() -> NotesListViewProtocol {
        let view = NotesListView(controller: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func setupNavigationController() {
        title = "Заметки"
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .systemOrange
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(didTapAddButton))
    }
    
    @objc func didTapAddButton() {
        
    }
    
}

// MARK: - Протокол контроллера

extension NotesListController: NotesListControllerProtocol {
    
    func didSelectNote(with id: String) {
        guard let note = model.notes.first(where: { $0.id == id }) else { return }
        let model = NoteDetailModel(storedNote: note)
        let detailController = NoteDetailController(model: model)
        model.controller = detailController
        detailController.delegate = self
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func didDeleteNote(with id: String) {
        model.deleteNote(with: id)
    }
    
    func didTapAddBtn() {
        let model = NoteDetailModel(storedNote: nil)
        let detailController = NoteDetailController(model: model)
        model.controller = detailController
        detailController.delegate = self
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func didUpdate() {
        let sortedNote = sortNotes()
        contentView.update(for: NotesListView.ViewModel(notes: sortedNote))
    }
    
}

// MARK: - Delegated methods

extension NotesListController: NoteDetailControllerDelegate {
    
    func didCreateNote() -> Note {
        let note = model.createNote()
        return note
    }
    
    func didEditNote(with id: String, text: String) -> Note? {
        let note = model.updateNote(with: id, newText: text)
        return note
    }
    
}



