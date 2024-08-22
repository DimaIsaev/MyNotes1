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

final class NotesListView: UIView, NotesListViewProtocol {
    struct ViewModel {
        let notes: [Note]
    }
    
    private lazy var tableView: UITableView = makeTableView()
    
    var viewModel: ViewModel?
    
    var controller: NotesListControllerProtocol
    
    init(controller: NotesListControllerProtocol) {
        self.controller = controller
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}

extension NotesListView: UITableViewDelegate, UITableViewDataSource {
    
    //    MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.notes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let cell = cell as? NoteCell, let viewModel
        {
            cell.configureLabels(with: viewModel.notes[indexPath.row])
        }
        cell.selectionStyle = .none
        
        return cell

    }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            controller.didSelect(noteIndex: indexPath.row)
        }
}

private extension NotesListView {
    
    func setupLayout() {
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalTo: self.heightAnchor),
            tableView.widthAnchor.constraint(equalTo: self.widthAnchor),
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
}
