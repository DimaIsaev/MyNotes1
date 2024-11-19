//
//  MyView.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 14.08.2024.
//

import UIKit

protocol NotesListViewProtocol: UIView {
    
    func update(for viewModel: NotesListView.ViewModel)
    
}

final class NotesListView: UIView {
    
    struct ViewModel {
        let notes: [Note]
    }
    
    private lazy var tableView: UITableView = makeTableView()
    private lazy var addButton: UIButton = makeAddButton()
    
    var viewModel: ViewModel?
    
    weak var controller: NotesListControllerProtocol?
    
    init(controller: NotesListControllerProtocol) {
        self.controller = controller
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - TableView Methods

extension NotesListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.notes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let cell = cell as? NoteCell, let viewModel {
            cell.configureLabels(with: viewModel.notes[indexPath.row])
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = viewModel?.notes[indexPath.row].id else {
            return
        }
        controller?.didSelect(noteId: id)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //            if let note = viewModel?.notes[indexPath.row] {
            //                controller?.didDelete(noteId: note.id)
            //            }
            guard let id = viewModel?.notes[indexPath.row].id else {
                return
            }
            controller?.didDelete(noteId: id)
        }
    }
    
}

// MARK: - Протокол View

extension NotesListView: NotesListViewProtocol {
    
    func update(for viewModel: ViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
    
}

// MARK: - UI Elements

private extension NotesListView {
    
    func setupLayout() {
        addSubview(tableView)
        addSubview(addButton)
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalTo: self.heightAnchor),
            tableView.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            addButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -45)
        ])
    }
    
    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.register(NoteCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    
    @objc func didTapAddButton() {
        controller?.didTapAddBtn()
    }
    
    func makeAddButton() -> UIButton {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        btn.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.tintColor = .systemOrange
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return btn
    }
    
}
