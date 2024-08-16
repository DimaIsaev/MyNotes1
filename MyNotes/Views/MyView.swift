//
//  MyView.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 14.08.2024.
//

import UIKit

class MyView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableView: UITableView = makeTableView()
    
    let testTitleArray = ["test1", "test2", "test3", "test4"]
    let testDateArray = ["01.09.2024", "11.10.2024", "08.11.2024", "24.12.2024"]
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalTo: self.heightAnchor),
            tableView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}

extension MyView {
    
    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.register(NoteCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    
    //MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NoteCell {
            let noteTitle = testTitleArray[indexPath.row]
            let noteDateTitle = testDateArray[indexPath.row]
            cell.setCell(titleText: noteTitle, dateTitle: noteDateTitle)
            return cell
            }
        
        return UITableViewCell()
    }
    
    
}
