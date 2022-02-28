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
        static let sortName = "date"
    }
    
    // MARK: - UI Elements
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
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
    
    // MARK: - NSFetchedResultsController
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
        
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setup()
        setupFetchResultController()
        setInitialObject()
    }
}

// MARK: - Setup Views
extension NoteListViewController {
    private func setup() {
        navigationItem.title = "Notes"
        
        tableView.backgroundColor = UIColor(named: "TableViewBackgroundColor")
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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
    private func setInitialObject() {
        if fetchResultController.fetchedObjects?.count == 0 {
            let object = Note()
            
            object.noteName = "New note"
            object.noteText = "Create new note"
            
            CoreDataManager.shared.saveContext()
        }
    }
    
    // MARK: - Actions
    @objc private func addNoteTapped() {
        navigationController?.pushViewController(
            AddNoteViewController(),
            animated: false
        )
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
            tableView.reloadData()
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
