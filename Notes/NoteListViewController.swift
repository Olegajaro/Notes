//
//  ViewController.swift
//  Notes
//
//  Created by Олег Федоров on 25.02.2022.
//

import UIKit
import CoreData

class NoteListViewController: UIViewController {
    
    struct Constans {
        static let entity = "Note"
        static let sortName = "noteName"
    }
    
    let tableView = UITableView()
    lazy var addNoteBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            title: "Add note",
            style: .plain,
            target: self,
            action: #selector(addNoteTapped)
        )
        
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constans.entity)
        let sortDescriptor = NSSortDescriptor(key: Constans.sortName, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager.shared.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        return fetchedResultController
    }()
    
    let numbers = ["test1", "test2", "test3", "test4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setup()
        setupFetchResultController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - Setup Table View
extension NoteListViewController {
    private func setup() {
        navigationItem.title = "Notes"
        
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            NoteListCell.self,
            forCellReuseIdentifier: NoteListCell.cellID
        )
        tableView.rowHeight = NoteListCell.rowHeight
        
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = addNoteBarButtonItem
    }
    
    private func setupFetchResultController() {
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc private func addNoteTapped() {
        navigationController?.pushViewController(AddNoteViewController(),
                                                 animated: false)
    }
}

// MARK: - UITableViewDataSource
extension NoteListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        fetchResultController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NoteListCell.cellID,
            for: indexPath
        ) as! NoteListCell
        
        let note = fetchResultController.object(at: indexPath) as! Note
        cell.noteNameLabel.text = note.noteName
        cell.noteTextLabel.text = note.noteText
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let note = fetchResultController.object(at: indexPath) as! Note
        let controller = AddNoteViewController()
        controller.note = note
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let note = fetchResultController.object(at: indexPath) as! Note
            CoreDataManager.shared.context.delete(note)
            CoreDataManager.shared.saveContext()
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension NoteListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        if tableView.isOnWindow {
            tableView.beginUpdates()
        }
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                //                if tableView.isOnWindow {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                //                }
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let note = fetchResultController.object(at: indexPath) as! Note
                let cell = tableView.cellForRow(at: indexPath) as! NoteListCell
                
                cell.noteNameLabel.text = note.noteName
                cell.noteTextLabel.text = note.noteText
            }
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        tableView.endUpdates()
    }
}
