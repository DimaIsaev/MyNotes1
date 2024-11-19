//
//  ViewController.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 13.08.2024.
//

import UIKit

protocol NotesListControllerProtocol: AnyObject {
    
    func didSelect(noteId: String)
    func didDelete(noteId: String)
    func didTapAddBtn()
    func didUpdate(notes: [Note])
    
}

final class NotesListController: UIViewController {
    
    private lazy var contentView: NotesListViewProtocol = makeContentView()
    
    private let model: NoteListModelProtocol
    
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
        
        contentView.update(for: NotesListView.ViewModel(notes: sortNotes(notes: model.notes)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        removeNoteIfEmpty()
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
    
    func sortNotes(notes: [Note]) -> [Note] {
        let sortedNotes = notes.sorted { $0.date > $1.date }
        return sortedNotes
    }
    
    func removeNoteIfEmpty () {
        let sortedNotes = sortNotes(notes: model.notes)
        guard let firstNote = sortedNotes.first else {
            return
        }
        
        if firstNote.text.isEmpty {
            model.deleteNote(noteId: firstNote.id)
        }
    }
    
    private func makeContentView() -> NotesListViewProtocol {
        let view = NotesListView(controller: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func setupNavigationController() {
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
    
    func didSelect(noteId: String) {
        for note in model.notes {
            if noteId == note.id {
                let model = NoteDetailModel(storedNote: note)
                let detailController = NoteDetailController(model: model)
                model.controller = detailController
                detailController.delegate = self
                navigationController?.pushViewController(detailController, animated: true)
                return
            }
        }
    }
    
    func didDelete(noteId: String) {
        model.deleteNote(noteId: noteId)
    }
    
    func didTapAddBtn() {
        let model = NoteDetailModel(storedNote: nil)
        let detailController = NoteDetailController(model: model)
        model.controller = detailController
        detailController.delegate = self
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func didUpdate(notes: [Note]) {
        let sortedNote = sortNotes(notes: notes)
        contentView.update(for: NotesListView.ViewModel(notes: sortedNote))
    }
    
}

// MARK: - Delegated methods

extension NotesListController: NoteDetailControllerDelegate {
    
    func didSaveNote(note: Note) {
        model.saveNote(note: note)
    }
    
}



