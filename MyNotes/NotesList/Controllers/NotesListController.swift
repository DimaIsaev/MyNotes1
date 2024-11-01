//
//  ViewController.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 13.08.2024.
//

import UIKit

protocol NotesListControllerProtocol: AnyObject {

    func didSelect(noteId: String) //ушел от опционала
    func didDelete(noteId: String)
    func didTapAddBtn()
    func didUpdate(notes: [Note])
    
}

final class NotesListController: UIViewController, NotesListControllerProtocol {
    
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
    
    func setupView() {
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func sortNotes(notes: [Note]) -> [Note] { //может sortedNotes// Проверить
        let sortedNotes = notes.sorted { $0.date > $1.date }
        return sortedNotes
    }
    // проверить это новый переход на заметку по ID
    func didSelect(noteId: String) { //ушел от опционала
        for note in model.notes {
            if noteId == note.id {
                let model = NoteDetailModel(storedNote: note)
                let detailController = NoteDetailController(model: model)
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
        detailController.delegate = self
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func didUpdate(notes: [Note]) { // Проверить
        let sortedNote = sortNotes(notes: notes)
        contentView.update(for: NotesListView.ViewModel(notes: sortedNote))
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

extension NotesListController: NoteDetailControllerDelegate {

    func didCreateNote(noteText: String) -> Note {
        let note = model.saveNote(text: noteText)
        return note
    }
    
    func didEditNote(noteText: String, noteId: String) -> Note? { //Возвращаю опционал? Прошлось добавить так как model.editNote возвращает опционал
        let note = model.editNote(text: noteText, noteId: noteId)
        return note
    }

    func didDeleteNote(noteId: String) { //раньше тут получал не noteId,а note(полную заметку)
        model.deleteNote(noteId: noteId)
    }
    
}



