//
//  ViewController.swift
//  Notes
//
//  Created by Олег Федоров on 25.02.2022.
//

import UIKit

class NoteListViewController: UIViewController {
    
    struct Constans {
        static let entity = "Note"
        static let sortName = "noteName"
    }
    
    let tableView = UITableView()
    let numbers = ["test1", "test2", "test3", "test4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

// MARK: - Setup Table View
extension NoteListViewController {
    private func setup() {
        navigationItem.title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            NoteListCell.self,
            forCellReuseIdentifier: NoteListCell.cellID
        )
        tableView.rowHeight = NoteListCell.rowHeight
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
}

// MARK: - UITableViewDataSource
extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        numbers.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NoteListCell.cellID,
            for: indexPath
        ) as! NoteListCell
        
        cell.noteNameLabel.text = numbers[indexPath.row]
        cell.noteTextLabel.text = numbers[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

